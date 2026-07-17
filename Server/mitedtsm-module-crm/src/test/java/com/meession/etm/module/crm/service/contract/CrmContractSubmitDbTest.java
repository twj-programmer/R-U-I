package com.meession.etm.module.crm.service.contract;

import com.meession.etm.framework.common.exception.ServiceException;
import com.meession.etm.framework.tenant.core.context.TenantContextHolder;
import com.meession.etm.framework.test.core.ut.BaseDbUnitTest;
import com.meession.etm.module.bpm.api.task.BpmProcessInstanceApi;
import com.meession.etm.module.crm.dal.dataobject.contract.CrmContractDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.dataobject.permission.CrmPermissionDO;
import com.meession.etm.module.crm.dal.mysql.contract.CrmContractMapper;
import com.meession.etm.module.crm.dal.mysql.contract.CrmContractProductMapper;
import com.meession.etm.module.crm.dal.redis.no.CrmNoRedisDAO;
import com.meession.etm.module.crm.enums.permission.CrmPermissionLevelEnum;
import com.meession.etm.module.crm.support.CrmTestDataFactory;
import com.meession.etm.module.crm.support.TenantTestConfiguration;
import com.meession.etm.module.crm.service.business.CrmBusinessService;
import com.meession.etm.module.crm.service.contact.CrmContactService;
import com.meession.etm.module.crm.service.customer.CrmCustomerService;
import com.meession.etm.module.crm.service.permission.CrmPermissionService;
import com.meession.etm.module.crm.service.product.CrmProductService;
import com.meession.etm.module.crm.service.receivable.CrmReceivableService;
import com.meession.etm.module.system.api.user.AdminUserApi;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.context.jdbc.Sql;

import java.util.Collection;
import java.util.Collections;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicInteger;

import static com.meession.etm.module.crm.enums.ErrorCodeConstants.CONTRACT_NOT_EXISTS;
import static com.meession.etm.module.crm.enums.ErrorCodeConstants.CONTRACT_SUBMIT_FAIL_NOT_DRAFT;
import static com.meession.etm.module.crm.enums.common.CrmAuditStatusEnum.DRAFT;
import static com.meession.etm.module.crm.enums.common.CrmAuditStatusEnum.PROCESS;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@Import({CrmTestDataFactory.class, TenantTestConfiguration.class, CrmContractServiceImpl.class,
        CrmContractConfigServiceImpl.class})
@Sql(scripts = "classpath:sql/create_tables.sql", executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
public class CrmContractSubmitDbTest extends BaseDbUnitTest {

    private static final Long TENANT_ID = 1L;
    private static final Long USER_ID = 100L;

    @Resource
    private CrmContractService contractService;

    @Resource
    private CrmContractMapper contractMapper;

    @Resource
    private CrmTestDataFactory testDataFactory;

    @MockBean
    private BpmProcessInstanceApi bpmProcessInstanceApi;

    @MockBean
    private CrmPermissionService permissionService;

    @MockBean
    private CrmNoRedisDAO noRedisDAO;

    @MockBean
    private CrmContractProductMapper contractProductMapper;

    @MockBean
    private CrmProductService productService;

    @MockBean
    private CrmCustomerService customerService;

    @MockBean
    private CrmBusinessService businessService;

    @MockBean
    private CrmContactService contactService;

    @MockBean
    private CrmReceivableService receivableService;

    @MockBean
    private AdminUserApi adminUserApi;

    @BeforeEach
    void setUpTenant() {
        TenantContextHolder.setTenantId(TENANT_ID);
    }

    @AfterEach
    void clearTenant() {
        TenantContextHolder.clear();
    }

    private void mockWritePermission(Long bizId) {
        CrmPermissionDO permission = new CrmPermissionDO();
        permission.setUserId(USER_ID);
        permission.setLevel(CrmPermissionLevelEnum.WRITE.getLevel());
        when(permissionService.getPermissionListByBiz(any(Integer.class), any(Collection.class))).thenReturn(Collections.singletonList(permission));
    }

    @Test
    public void testSubmitContract_success() {
        when(bpmProcessInstanceApi.createProcessInstance(anyLong(), any())).thenReturn("test-process-id-001");

        CrmCustomerDO customer = testDataFactory.createCustomer(TENANT_ID);
        CrmContractDO contract = testDataFactory.createContract(TENANT_ID, customer.getId(), null, DRAFT.getStatus());
        mockWritePermission(contract.getId());

        contractService.submitContract(contract.getId(), USER_ID);

        CrmContractDO updatedContract = contractMapper.selectById(contract.getId());
        assertEquals(PROCESS.getStatus(), updatedContract.getAuditStatus());
        assertNotNull(updatedContract.getProcessInstanceId());
        assertEquals("test-process-id-001", updatedContract.getProcessInstanceId());
        verify(bpmProcessInstanceApi, times(1)).createProcessInstance(anyLong(), any());
    }

    @Test
    public void testSubmitContract_duplicate_submit_fail() {
        when(bpmProcessInstanceApi.createProcessInstance(anyLong(), any())).thenReturn("test-process-id-002");

        CrmCustomerDO customer = testDataFactory.createCustomer(TENANT_ID);
        CrmContractDO contract = testDataFactory.createContract(TENANT_ID, customer.getId(), null, DRAFT.getStatus());
        mockWritePermission(contract.getId());

        contractService.submitContract(contract.getId(), USER_ID);

        ServiceException exception = assertThrows(ServiceException.class, () -> {
            contractService.submitContract(contract.getId(), USER_ID);
        });
        assertEquals(CONTRACT_SUBMIT_FAIL_NOT_DRAFT.getCode(), exception.getCode());
        verify(bpmProcessInstanceApi, times(1)).createProcessInstance(anyLong(), any());
    }

    @Test
    public void testSubmitContract_concurrent_only_one_success() throws InterruptedException {
        String processInstanceId = "test-process-id-concurrent";
        when(bpmProcessInstanceApi.createProcessInstance(anyLong(), any())).thenReturn(processInstanceId);

        CrmCustomerDO customer = testDataFactory.createCustomer(TENANT_ID);
        CrmContractDO contract = testDataFactory.createContract(TENANT_ID, customer.getId(), null, DRAFT.getStatus());
        mockWritePermission(contract.getId());

        int threadCount = 2;
        ExecutorService executor = Executors.newFixedThreadPool(threadCount);
        CountDownLatch latch = new CountDownLatch(threadCount);
        AtomicInteger successCount = new AtomicInteger(0);
        AtomicInteger failCount = new AtomicInteger(0);

        for (int i = 0; i < threadCount; i++) {
            executor.submit(() -> {
                try {
                    contractService.submitContract(contract.getId(), USER_ID);
                    successCount.incrementAndGet();
                } catch (ServiceException e) {
                    if (CONTRACT_SUBMIT_FAIL_NOT_DRAFT.getCode().equals(e.getCode())) {
                        failCount.incrementAndGet();
                    }
                } finally {
                    latch.countDown();
                }
            });
        }

        latch.await();
        executor.shutdown();

        assertEquals(1, successCount.get());
        assertEquals(1, failCount.get());
        verify(bpmProcessInstanceApi, times(1)).createProcessInstance(anyLong(), any());

        CrmContractDO updatedContract = contractMapper.selectById(contract.getId());
        assertEquals(PROCESS.getStatus(), updatedContract.getAuditStatus());
        assertEquals(processInstanceId, updatedContract.getProcessInstanceId());
    }

    @Test
    public void testSubmitContract_bpm_exception_rollback() {
        when(bpmProcessInstanceApi.createProcessInstance(anyLong(), any()))
                .thenThrow(new RuntimeException("BPM service unavailable"));

        CrmCustomerDO customer = testDataFactory.createCustomer(TENANT_ID);
        CrmContractDO contract = testDataFactory.createContract(TENANT_ID, customer.getId(), null, DRAFT.getStatus());
        mockWritePermission(contract.getId());

        assertThrows(RuntimeException.class, () -> {
            contractService.submitContract(contract.getId(), USER_ID);
        });

        CrmContractDO updatedContract = contractMapper.selectById(contract.getId());
        assertEquals(DRAFT.getStatus(), updatedContract.getAuditStatus());
        assertNull(updatedContract.getProcessInstanceId());
    }

    @Test
    public void testSubmitContract_cross_tenant_fail() {
        when(bpmProcessInstanceApi.createProcessInstance(anyLong(), any())).thenReturn("test-process-id-cross");
        mockWritePermission(9999L);

        CrmCustomerDO customer = testDataFactory.createCustomer(999L);
        CrmContractDO contract = testDataFactory.createContract(999L, customer.getId(), null, DRAFT.getStatus());

        ServiceException exception = assertThrows(ServiceException.class, () -> {
            contractService.submitContract(contract.getId(), USER_ID);
        });
        assertEquals(CONTRACT_NOT_EXISTS.getCode(), exception.getCode());

        verify(bpmProcessInstanceApi, never()).createProcessInstance(anyLong(), any());
    }

}