package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryPageReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryRespVO;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerOwnerHistoryCreateBO;

import java.util.List;

public interface CrmCustomerOwnerHistoryService {

    void createHistory(CrmCustomerOwnerHistoryCreateBO createBO);

    PageResult<CrmCustomerOwnerHistoryRespVO> getPage(CrmCustomerOwnerHistoryPageReqVO reqVO);

    List<CrmCustomerOwnerHistoryRespVO> getByCustomerId(Long customerId);

}