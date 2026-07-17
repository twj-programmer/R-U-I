package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmCustomerOwnerHistoryPageReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerOwnerHistoryDO;

import java.time.LocalDateTime;
import java.util.List;

public interface CrmCustomerOwnerHistoryService {

    void insertHistory(Long customerId, String changeType, Long oldOwnerUserId, Long newOwnerUserId,
                       String reason, Long operatorUserId, LocalDateTime changeTime);

    List<CrmCustomerOwnerHistoryDO> getHistoryListByCustomerId(Long customerId);

    PageResult<CrmCustomerOwnerHistoryDO> getHistoryPage(CrmCustomerOwnerHistoryPageReqVO reqVO);

    List<CrmCustomerOwnerHistoryDO> getHistoryListByOperatorUserId(Long operatorUserId);

    List<CrmCustomerOwnerHistoryDO> getHistoryListByNewOwnerUserId(Long newOwnerUserId);

}
