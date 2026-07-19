package com.meession.etm.module.crm.controller.admin.statistics;

import cn.idev.excel.FastExcelFactory;
import com.meession.etm.framework.common.biz.system.dict.DictDataCommonApi;
import com.meession.etm.framework.dict.core.DictFrameworkUtils;
import com.meession.etm.framework.tenant.core.util.TenantUtils;
import com.meession.etm.framework.test.core.ut.BaseDbUnitTest;
import com.meession.etm.module.crm.dal.dataobject.contract.CrmContractDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.dal.mysql.statistics.CrmStatisticsCustomerMapper;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerContractSummaryRespVO;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerReqVO;
import com.meession.etm.module.crm.service.statistics.CrmStatisticsCustomerService;
import com.meession.etm.module.crm.service.statistics.CrmStatisticsCustomerServiceImpl;
import com.meession.etm.module.crm.support.CrmTestDataFactory;
import com.meession.etm.module.crm.support.TenantTestConfiguration;
import com.meession.etm.module.system.api.dept.DeptApi;
import com.meession.etm.module.system.api.dept.dto.DeptRespDTO;
import com.meession.etm.module.system.api.user.AdminUserApi;
import com.meession.etm.module.system.api.user.dto.AdminUserRespDTO;
import jakarta.annotation.Resource;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.parallel.ResourceLock;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;

import java.io.ByteArrayInputStream;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.setup.MockMvcBuilders.standaloneSetup;

@Import({CrmTestDataFactory.class, TenantTestConfiguration.class})
@ResourceLock("DictFrameworkUtils")
class CrmStatisticsCustomerExportHttpIntegrationTest extends BaseDbUnitTest {

    private static final String EXPORT_PATH = "/crm/statistics-customer/export-contract-summary";
    private static final DateTimeFormatter REQUEST_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Resource
    private CrmTestDataFactory testDataFactory;
    @Resource
    private CrmStatisticsCustomerMapper statisticsCustomerMapper;
    @Resource
    private CrmCustomerMapper customerMapper;

    private MockMvc mockMvc;
    private DictDataCommonApi originalDictDataApi;
    private AdminUserApi userApi;
    private DeptApi deptApi;
    private CrmStatisticsCustomerService customerService;

    @BeforeEach
    void setUp() {
        originalDictDataApi = (DictDataCommonApi) ReflectionTestUtils.getField(DictFrameworkUtils.class, "dictDataApi");
        DictDataCommonApi dictDataApi = mock(DictDataCommonApi.class);
        when(dictDataApi.getDictDataList(anyString())).thenReturn(Collections.emptyList());
        DictFrameworkUtils.init(dictDataApi);
        DictFrameworkUtils.clearCache();

        userApi = mock(AdminUserApi.class);
        AdminUserRespDTO user = new AdminUserRespDTO();
        user.setId(1L);
        user.setNickname("D2-STAT Owner");
        AdminUserRespDTO secondUser = new AdminUserRespDTO();
        secondUser.setId(2L);
        secondUser.setNickname("D2-STAT Child Owner");
        when(userApi.getUserMap(any())).thenReturn(Map.of(1L, user, 2L, secondUser));

        deptApi = mock(DeptApi.class);
        CrmStatisticsCustomerServiceImpl service = new CrmStatisticsCustomerServiceImpl();
        ReflectionTestUtils.setField(service, "customerMapper", statisticsCustomerMapper);
        ReflectionTestUtils.setField(service, "adminUserApi", userApi);
        ReflectionTestUtils.setField(service, "deptApi", deptApi);
        customerService = service;
        CrmStatisticsCustomerController controller = new CrmStatisticsCustomerController();
        ReflectionTestUtils.setField(controller, "customerService", service);
        mockMvc = standaloneSetup(controller).build();
    }

    @AfterEach
    void tearDown() {
        DictFrameworkUtils.clearCache();
        ReflectionTestUtils.setField(DictFrameworkUtils.class, "dictDataApi", originalDictDataApi);
        testDataFactory.clearAll();
    }

    @Test
    void exportHttpBoundaryShouldApplyOwnerDateAndTenantScopeWithoutWritingData() throws Exception {
        LocalDateTime start = LocalDateTime.now().minusDays(1);
        LocalDateTime end = LocalDateTime.now().plusDays(1);
        CrmCustomerDO tenantOneCustomer = createCustomer(1L, "D2-STAT HTTP included", 1L,
                LocalDateTime.now(), 101, 201);
        CrmContractDO includedContract = testDataFactory.createContract(1L, tenantOneCustomer.getId(), null, 20);
        testDataFactory.createReceivable(1L, includedContract.getId(), tenantOneCustomer.getId(), 20);
        CrmCustomerDO otherOwnerCustomer = createCustomer(1L, "D2-STAT HTTP excluded owner", 2L,
                LocalDateTime.now(), 102, 202);
        testDataFactory.createContract(1L, otherOwnerCustomer.getId(), null, 20);
        CrmCustomerDO outOfRangeCustomer = createCustomer(1L, "D2-STAT HTTP excluded date", 1L,
                LocalDateTime.now().minusDays(2), 103, 203);
        testDataFactory.createContract(1L, outOfRangeCustomer.getId(), null, 20);
        CrmCustomerDO tenantTwoCustomer = createCustomer(2L, "D2-STAT HTTP excluded tenant", 1L,
                LocalDateTime.now(), 104, 204);
        testDataFactory.createContract(2L, tenantTwoCustomer.getId(), null, 20);
        long customersBefore = testDataFactory.getCustomerCount(1L);
        long contractsBefore = testDataFactory.getContractCount(1L);
        long receivablesBefore = testDataFactory.getReceivableCount(1L);

        MvcResult result = export(1L, start, end);
        List<CrmStatisticsCustomerContractSummaryRespVO> expected = summary(1L, start, end, 1L);
        List<Map<Integer, String>> rows = readRows(result);

        assertEquals(1, expected.size());
        assertEquals(2, rows.size());
        assertExportRowEquals(expected.get(0), rows.get(1));
        assertFalse(rows.stream().flatMap(row -> row.values().stream()).filter(java.util.Objects::nonNull)
                .anyMatch(value -> value.contains("excluded owner") || value.contains("excluded date")
                        || value.contains("excluded tenant")));
        assertEquals(customersBefore, testDataFactory.getCustomerCount(1L));
        assertEquals(contractsBefore, testDataFactory.getContractCount(1L));
        assertEquals(receivablesBefore, testDataFactory.getReceivableCount(1L));
    }

    @Test
    void exportHttpBoundaryShouldReturnOnlyHeadersOutsideDateRange() throws Exception {
        CrmCustomerDO customer = testDataFactory.createCustomer(1L, "D2-STAT HTTP date boundary");
        testDataFactory.createContract(1L, customer.getId(), null, 20);

        MvcResult result = export(1L, LocalDateTime.now().minusYears(2), LocalDateTime.now().minusYears(1));

        assertEquals(1, readRows(result).size());
        assertEquals(10, readRows(result).get(0).size());
    }

    @Test
    void exportHttpBoundaryShouldExpandDepartmentWhenOwnerIsNotSpecified() throws Exception {
        CrmCustomerDO parentCustomer = createCustomer(1L, "D2-STAT HTTP parent department", 1L,
                LocalDateTime.now(), 101, 201);
        testDataFactory.createContract(1L, parentCustomer.getId(), null, 20);
        CrmCustomerDO childCustomer = createCustomer(1L, "D2-STAT HTTP child department", 2L,
                LocalDateTime.now(), 102, 202);
        testDataFactory.createContract(1L, childCustomer.getId(), null, 20);
        CrmCustomerDO excludedCustomer = createCustomer(1L, "D2-STAT HTTP excluded department", 3L,
                LocalDateTime.now(), 103, 203);
        testDataFactory.createContract(1L, excludedCustomer.getId(), null, 20);
        DeptRespDTO childDept = new DeptRespDTO();
        childDept.setId(2L);
        AdminUserRespDTO owner = new AdminUserRespDTO();
        owner.setId(1L);
        AdminUserRespDTO childOwner = new AdminUserRespDTO();
        childOwner.setId(2L);
        when(deptApi.getChildDeptList(1L)).thenReturn(List.of(childDept));
        when(userApi.getUserListByDeptIds(List.of(2L, 1L))).thenReturn(List.of(owner, childOwner));

        MvcResult result = export(1L, LocalDateTime.now().minusDays(1), LocalDateTime.now().plusDays(1), null);
        List<String> customerNames = readRows(result).stream().skip(1).map(row -> row.get(0)).toList();

        assertEquals(2, customerNames.size());
        assertTrue(customerNames.contains("D2-STAT HTTP parent department"));
        assertTrue(customerNames.contains("D2-STAT HTTP child department"));
        assertFalse(customerNames.contains("D2-STAT HTTP excluded department"));
    }

    private MvcResult export(Long tenantId, LocalDateTime start, LocalDateTime end) {
        return export(tenantId, start, end, 1L);
    }

    private MvcResult export(Long tenantId, LocalDateTime start, LocalDateTime end, Long userId) {
        return TenantUtils.execute(tenantId, (Callable<MvcResult>) () -> {
            MockHttpServletRequestBuilder request = get(EXPORT_PATH)
                        .param("deptId", "1")
                        .param("interval", "1")
                        .param("times[0]", REQUEST_TIME.format(start))
                        .param("times[1]", REQUEST_TIME.format(end));
            if (userId != null) {
                request.param("userId", userId.toString());
            }
            return mockMvc.perform(request)
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Type", "application/vnd.ms-excel;charset=UTF-8"))
                .andReturn();
        });
    }

    private static List<Map<Integer, String>> readRows(MvcResult result) throws Exception {
        MockHttpServletResponse response = result.getResponse();
        return FastExcelFactory.read(new ByteArrayInputStream(response.getContentAsByteArray()))
                .headRowNumber(0)
                .doReadAllSync();
    }

    private CrmCustomerDO createCustomer(Long tenantId, String name, Long ownerUserId, LocalDateTime createTime,
                                         Integer industryId, Integer source) {
        CrmCustomerDO customer = testDataFactory.createCustomer(tenantId, name);
        return TenantUtils.execute(tenantId, () -> {
            customer.setOwnerUserId(ownerUserId);
            customer.setCreateTime(createTime);
            customer.setIndustryId(industryId);
            customer.setSource(source);
            customerMapper.updateById(customer);
            return customerMapper.selectById(customer.getId());
        });
    }

    private List<CrmStatisticsCustomerContractSummaryRespVO> summary(Long tenantId, LocalDateTime start,
                                                                       LocalDateTime end, Long userId) {
        CrmStatisticsCustomerReqVO reqVO = new CrmStatisticsCustomerReqVO();
        reqVO.setDeptId(1L);
        reqVO.setUserId(userId);
        reqVO.setInterval(1);
        reqVO.setTimes(new LocalDateTime[]{start, end});
        return TenantUtils.execute(tenantId, () -> customerService.getContractSummary(reqVO));
    }

    private static void assertExportRowEquals(CrmStatisticsCustomerContractSummaryRespVO expected,
                                              Map<Integer, String> actual) {
        assertEquals(expected.getCustomerName(), actual.get(0));
        assertEquals(expected.getContractName(), actual.get(1));
        assertEquals(0, expected.getTotalPrice().compareTo(new BigDecimal(actual.get(2))));
        assertEquals(0, expected.getReceivablePrice().compareTo(new BigDecimal(actual.get(3))));
        assertEquals(String.valueOf(expected.getIndustryId()), actual.get(4));
        assertEquals(String.valueOf(expected.getSource()), actual.get(5));
        assertEquals(expected.getOwnerUserName(), actual.get(6));
        assertEquals(expected.getCreatorUserName(), actual.get(7));
    }

}
