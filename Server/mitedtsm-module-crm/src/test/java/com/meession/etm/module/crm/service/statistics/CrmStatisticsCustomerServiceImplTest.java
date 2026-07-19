package com.meession.etm.module.crm.service.statistics;

import com.meession.etm.framework.test.core.ut.BaseMockitoUnitTest;
import com.meession.etm.module.crm.controller.admin.statistics.vo.customer.CrmStatisticsCustomerReqVO;
import com.meession.etm.module.crm.dal.mysql.statistics.CrmStatisticsCustomerMapper;
import com.meession.etm.module.system.api.dept.DeptApi;
import com.meession.etm.module.system.api.dept.dto.DeptRespDTO;
import com.meession.etm.module.system.api.user.AdminUserApi;
import com.meession.etm.module.system.api.user.dto.AdminUserRespDTO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class CrmStatisticsCustomerServiceImplTest extends BaseMockitoUnitTest {

    @InjectMocks
    private CrmStatisticsCustomerServiceImpl customerService;
    @Mock
    private CrmStatisticsCustomerMapper customerMapper;
    @Mock
    private AdminUserApi adminUserApi;
    @Mock
    private DeptApi deptApi;

    @BeforeEach
    void setUp() {
        when(customerMapper.selectContractSummary(any())).thenReturn(Collections.emptyList());
        when(adminUserApi.getUserMap(any())).thenReturn(Collections.emptyMap());
    }

    @Test
    void getContractSummaryShouldLimitQueryToExplicitOwner() {
        CrmStatisticsCustomerReqVO reqVO = new CrmStatisticsCustomerReqVO();
        reqVO.setDeptId(10L);
        reqVO.setUserId(21L);

        customerService.getContractSummary(reqVO);

        assertEquals(List.of(21L), reqVO.getUserIds());
        verify(customerMapper).selectContractSummary(reqVO);
        verify(deptApi, never()).getChildDeptList(any());
    }

    @Test
    void getContractSummaryShouldExpandDepartmentToItsExistingUsers() {
        DeptRespDTO childDept = new DeptRespDTO();
        childDept.setId(11L);
        AdminUserRespDTO firstUser = new AdminUserRespDTO();
        firstUser.setId(21L);
        AdminUserRespDTO secondUser = new AdminUserRespDTO();
        secondUser.setId(22L);
        when(deptApi.getChildDeptList(10L)).thenReturn(List.of(childDept));
        when(adminUserApi.getUserListByDeptIds(List.of(11L, 10L)))
                .thenReturn(List.of(firstUser, secondUser));
        CrmStatisticsCustomerReqVO reqVO = new CrmStatisticsCustomerReqVO();
        reqVO.setDeptId(10L);

        customerService.getContractSummary(reqVO);

        assertEquals(List.of(21L, 22L), reqVO.getUserIds());
        verify(customerMapper).selectContractSummary(reqVO);
    }
}
