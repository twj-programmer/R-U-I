package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryPageReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryRespVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerOwnerHistoryDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerOwnerHistoryMapper;
import com.meession.etm.module.system.api.user.AdminUserApi;
import com.meession.etm.module.system.api.user.dto.AdminUserRespDTO;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class CrmCustomerOwnerHistoryServiceImplTest {

    private CrmCustomerOwnerHistoryServiceImpl service;
    private CrmCustomerOwnerHistoryMapper ownerHistoryMapper;
    private AdminUserApi adminUserApi;

    @BeforeEach
    void setUp() {
        ownerHistoryMapper = mock(CrmCustomerOwnerHistoryMapper.class);
        adminUserApi = mock(AdminUserApi.class);
        service = new CrmCustomerOwnerHistoryServiceImpl(ownerHistoryMapper, adminUserApi);
    }

    @Test
    void getPage_shouldReturnEmptyPageWhenNoHistory() {
        when(ownerHistoryMapper.selectPageByCondition(any(), anyInt())).thenReturn(new ArrayList<>());
        when(ownerHistoryMapper.selectCountByCondition(any())).thenReturn(0L);

        CrmCustomerOwnerHistoryPageReqVO reqVO = new CrmCustomerOwnerHistoryPageReqVO();
        reqVO.setPageNo(1);
        reqVO.setPageSize(10);

        PageResult<CrmCustomerOwnerHistoryRespVO> result = service.getPage(reqVO);

        assertEquals(0, result.getTotal());
        assertTrue(result.getList().isEmpty());
    }

    @Test
    void getPage_shouldReturnHistoryWithUserNames() {
        CrmCustomerOwnerHistoryDO historyDO = new CrmCustomerOwnerHistoryDO();
        historyDO.setId(1L);
        historyDO.setCustomerId(100L);
        historyDO.setChangeType("TRANSFER");
        historyDO.setOldOwnerUserId(10L);
        historyDO.setNewOwnerUserId(20L);
        historyDO.setOperatorUserId(30L);
        historyDO.setChangeTime(LocalDateTime.now());

        when(ownerHistoryMapper.selectPageByCondition(any(), anyInt())).thenReturn(List.of(historyDO));
        when(ownerHistoryMapper.selectCountByCondition(any())).thenReturn(1L);
        when(adminUserApi.getUser(10L)).thenReturn(new AdminUserRespDTO().setNickname("旧负责人"));
        when(adminUserApi.getUser(20L)).thenReturn(new AdminUserRespDTO().setNickname("新负责人"));
        when(adminUserApi.getUser(30L)).thenReturn(new AdminUserRespDTO().setNickname("操作人"));

        CrmCustomerOwnerHistoryPageReqVO reqVO = new CrmCustomerOwnerHistoryPageReqVO();
        reqVO.setPageNo(1);
        reqVO.setPageSize(10);

        PageResult<CrmCustomerOwnerHistoryRespVO> result = service.getPage(reqVO);

        assertEquals(1, result.getTotal());
        assertEquals(1, result.getList().size());
        assertEquals("旧负责人", result.getList().get(0).getOldOwnerUserName());
        assertEquals("新负责人", result.getList().get(0).getNewOwnerUserName());
        assertEquals("操作人", result.getList().get(0).getOperatorUserName());
    }

    @Test
    void getByCustomerId_shouldReturnHistoryList() {
        CrmCustomerOwnerHistoryDO historyDO = new CrmCustomerOwnerHistoryDO();
        historyDO.setId(1L);
        historyDO.setCustomerId(100L);

        when(ownerHistoryMapper.selectByCustomerId(eq(100L), any())).thenReturn(List.of(historyDO));

        List<CrmCustomerOwnerHistoryRespVO> result = service.getByCustomerId(100L);

        assertEquals(1, result.size());
        assertEquals(100L, result.get(0).getCustomerId());
    }

    @Test
    void getPage_shouldFilterByCustomerId() {
        when(ownerHistoryMapper.selectPageByCondition(any(), anyInt())).thenReturn(new ArrayList<>());
        when(ownerHistoryMapper.selectCountByCondition(any())).thenReturn(0L);

        CrmCustomerOwnerHistoryPageReqVO reqVO = new CrmCustomerOwnerHistoryPageReqVO();
        reqVO.setPageNo(1);
        reqVO.setPageSize(10);
        reqVO.setCustomerId(100L);

        PageResult<CrmCustomerOwnerHistoryRespVO> result = service.getPage(reqVO);

        assertEquals(0, result.getTotal());
    }

}