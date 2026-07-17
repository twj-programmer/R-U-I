package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.exception.ServiceException;
import com.meession.etm.framework.tenant.core.util.TenantUtils;
import com.meession.etm.framework.tenant.core.context.TenantContextHolder;
import com.meession.etm.framework.test.core.ut.BaseDbUnitTest;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerOwnerHistoryDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerPoolConfigDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmHighSeasRecordDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerOwnerHistoryMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmHighSeasRecordMapper;
import com.meession.etm.module.crm.support.CrmTestDataFactory;
import com.meession.etm.module.crm.support.TenantTestConfiguration;
import com.meession.etm.module.crm.service.business.CrmBusinessService;
import com.meession.etm.module.crm.service.contact.CrmContactService;
import com.meession.etm.module.crm.service.contract.CrmContractService;
import com.meession.etm.module.crm.service.permission.CrmPermissionService;
import com.meession.etm.module.system.api.user.AdminUserApi;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.jdbc.Sql;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

import static com.meession.etm.module.crm.enums.ErrorCodeConstants.*;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

@Import({CrmTestDataFactory.class, TenantTestConfiguration.class, CrmCustomerServiceImpl.class,
        CrmCustomerPoolConfigServiceImpl.class, CrmHighSeasRecordServiceImpl.class,
        CrmCustomerOwnerHistoryServiceImpl.class})
@Sql(scripts = "classpath:sql/d2-cus-02-test.sql", executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
public class CrmCustomerPoolHistoryDbTest extends BaseDbUnitTest {

    private static final Long TENANT_ID = 1L;

    @Resource
    private CrmCustomerService customerService;

    @Resource
    private CrmHighSeasRecordService highSeasRecordService;

    @Resource
    private CrmCustomerOwnerHistoryService ownerHistoryService;

    @Resource
    private CrmCustomerPoolConfigService customerPoolConfigService;

    @Resource
    private CrmTestDataFactory testDataFactory;

    @Resource
    private CrmCustomerMapper customerMapper;

    @Resource
    private CrmHighSeasRecordMapper highSeasRecordMapper;

    @Resource
    private CrmCustomerOwnerHistoryMapper ownerHistoryMapper;

    @MockBean
    private AdminUserApi adminUserApi;
    @MockBean
    private CrmPermissionService permissionService;
    @MockBean
    private CrmCustomerLimitConfigService customerLimitConfigService;
    @MockBean
    private CrmContactService contactService;
    @MockBean
    private CrmBusinessService businessService;
    @MockBean
    private CrmContractService contractService;

    @BeforeEach
    void setUpTenant() {
        TenantContextHolder.setTenantId(TENANT_ID);
    }

    @AfterEach
    void clearTenant() {
        TenantContextHolder.clear();
    }

    @Test
    public void testReceiveCustomer_success() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);

        CrmCustomerDO customer = testDataFactory.createCustomerInPool(TENANT_ID);

        customerService.receiveCustomer(Arrays.asList(customer.getId()), 100L, true);

        CrmCustomerDO updatedCustomer = customerMapper.selectById(customer.getId());
        assertEquals(100L, updatedCustomer.getOwnerUserId());

        List<CrmHighSeasRecordDO> records = highSeasRecordService.getRecordListByCustomerId(customer.getId());
        assertEquals(1, records.size());
        assertEquals("RECEIVE", records.get(0).getActionType());

        List<CrmCustomerOwnerHistoryDO> histories = ownerHistoryService.getHistoryListByCustomerId(customer.getId());
        assertEquals(1, histories.size());
        assertEquals("RECEIVE", histories.get(0).getChangeType());
        assertEquals(100L, histories.get(0).getNewOwnerUserId());
    }

    @Test
    public void testReceiveCustomer_assign_notWriteHighSeasRecord() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);

        CrmCustomerDO customer = testDataFactory.createCustomerInPool(TENANT_ID);

        customerService.receiveCustomer(Arrays.asList(customer.getId()), 200L, false);

        List<CrmHighSeasRecordDO> records = highSeasRecordService.getRecordListByCustomerId(customer.getId());
        assertEquals(0, records.size());

        List<CrmCustomerOwnerHistoryDO> histories = ownerHistoryService.getHistoryListByCustomerId(customer.getId());
        assertEquals(1, histories.size());
        assertEquals("ASSIGN", histories.get(0).getChangeType());
    }

    @Test
    public void testHighSeasRecord_queryByCustomerId() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);

        CrmCustomerDO customer = testDataFactory.createCustomerInPool(TENANT_ID);
        customerService.receiveCustomer(Arrays.asList(customer.getId()), 100L, true);

        List<CrmHighSeasRecordDO> records = highSeasRecordService.getRecordListByCustomerId(customer.getId());
        assertFalse(records.isEmpty());
        assertEquals(customer.getId(), records.get(0).getCustomerId());
    }

    @Test
    public void testOwnerHistory_queryByCustomerId() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);

        CrmCustomerDO customer = testDataFactory.createCustomerInPool(TENANT_ID);
        customerService.receiveCustomer(Arrays.asList(customer.getId()), 100L, true);

        List<CrmCustomerOwnerHistoryDO> histories = ownerHistoryService.getHistoryListByCustomerId(customer.getId());
        assertFalse(histories.isEmpty());
        assertEquals(customer.getId(), histories.get(0).getCustomerId());
    }

    @Test
    public void testHighSeasRecord_queryByOperatorUserId() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);

        CrmCustomerDO customer = testDataFactory.createCustomerInPool(TENANT_ID);
        customerService.receiveCustomer(Arrays.asList(customer.getId()), 100L, true);

        List<CrmHighSeasRecordDO> records = highSeasRecordService.getRecordListByOperatorUserId(100L);
        assertFalse(records.isEmpty());
        assertEquals(100L, records.get(0).getOperatorUserId());
    }

    @Test
    public void testHighSeasRecord_queryByActionType() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);

        CrmCustomerDO customer = testDataFactory.createCustomerInPool(TENANT_ID);
        customerService.receiveCustomer(Arrays.asList(customer.getId()), 100L, true);

        List<CrmHighSeasRecordDO> records = highSeasRecordService.getRecordListByActionType("RECEIVE");
        assertFalse(records.isEmpty());
        assertEquals("RECEIVE", records.get(0).getActionType());
    }

    @Test
    public void testReceiveCountByUserIdAndDateRange() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);

        CrmCustomerDO customer1 = testDataFactory.createCustomerInPool(TENANT_ID);
        CrmCustomerDO customer2 = testDataFactory.createCustomerInPool(TENANT_ID);

        // 使用独立用户，避免共享 H2 数据库中其他测试的领取记录干扰本断言。
        customerService.receiveCustomer(Arrays.asList(customer1.getId()), 101L, true);
        customerService.receiveCustomer(Arrays.asList(customer2.getId()), 101L, true);

        LocalDateTime todayStart = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
        LocalDateTime todayEnd = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);

        Long count = highSeasRecordService.getReceiveCountByUserIdAndDateRange(TENANT_ID, 101L, todayStart, todayEnd);
        assertEquals(2L, count);
    }

    @Test
    public void testReceiveCustomer_concurrentConflict() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);
        CrmCustomerDO customer = testDataFactory.createCustomerInPool(TENANT_ID);
        customerMapper.updateOwnerUserIdById(customer.getId(), 999L);

        ServiceException exception = assertThrows(ServiceException.class,
                () -> customerService.receiveCustomer(Arrays.asList(customer.getId()), 100L, true));
        assertEquals(CUSTOMER_RECEIVE_CONCURRENT_CONFLICT.getCode(), exception.getCode());
    }

    @Test
    public void testPutCustomerPool_rejectsActiveBusiness() {
        CrmCustomerDO customer = testDataFactory.createCustomer(TENANT_ID);
        when(businessService.getActiveBusinessCountByCustomerId(customer.getId())).thenReturn(1L);

        ServiceException exception = assertThrows(ServiceException.class,
                () -> customerService.putCustomerPool(customer.getId()));
        assertEquals(CUSTOMER_PUT_POOL_FAIL_ACTIVE_BUSINESS.getCode(), exception.getCode());
    }

    @Test
    public void testReceiveCustomer_rejectsEleventhDailyReceive() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);
        for (int i = 0; i < 10; i++) {
            CrmCustomerDO customer = testDataFactory.createCustomerInPool(TENANT_ID);
            customerService.receiveCustomer(Arrays.asList(customer.getId()), 300L, true);
        }
        CrmCustomerDO eleventh = testDataFactory.createCustomerInPool(TENANT_ID);
        ServiceException exception = assertThrows(ServiceException.class,
                () -> customerService.receiveCustomer(Arrays.asList(eleventh.getId()), 300L, true));
        assertEquals(CUSTOMER_RECEIVE_EXCEED_DAILY_LIMIT.getCode(), exception.getCode());
    }

    @Test
    public void testReceiveCustomer_rejectsCooldown() {
        doNothing().when(adminUserApi).validateUserList(anyList());
        when(adminUserApi.getUser(any())).thenReturn(null);
        CrmCustomerDO customer = testDataFactory.createCustomerInPool(TENANT_ID);
        customerService.receiveCustomer(Arrays.asList(customer.getId()), 400L, true);
        customerMapper.updateOwnerUserIdById(customer.getId(), null);

        ServiceException exception = assertThrows(ServiceException.class,
                () -> customerService.receiveCustomer(Arrays.asList(customer.getId()), 400L, true));
        assertEquals(CUSTOMER_RECEIVE_COOLDOWN.getCode(), exception.getCode());
    }

}
