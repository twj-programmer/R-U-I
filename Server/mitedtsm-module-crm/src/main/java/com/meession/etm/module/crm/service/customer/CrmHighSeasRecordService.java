package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmHighSeasRecordPageReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmHighSeasRecordDO;

import java.time.LocalDateTime;
import java.util.List;

public interface CrmHighSeasRecordService {

    void insertRecord(Long customerId, String actionType, Long beforeOwnerUserId, Long afterOwnerUserId,
                      String reason, Long operatorUserId, LocalDateTime actionTime);

    List<CrmHighSeasRecordDO> getRecordListByCustomerId(Long customerId);

    CrmHighSeasRecordDO getRecord(Long id);

    PageResult<CrmHighSeasRecordDO> getRecordPage(CrmHighSeasRecordPageReqVO reqVO);

    List<CrmHighSeasRecordDO> getRecordListByCustomerIdAndTimeRange(Long customerId, LocalDateTime beginTime, LocalDateTime endTime);

    List<CrmHighSeasRecordDO> getRecordListByOperatorUserId(Long operatorUserId);

    List<CrmHighSeasRecordDO> getRecordListByActionType(String actionType);

    Long getReceiveCountByUserIdAndDateRange(Long tenantId, Long userId, LocalDateTime beginTime, LocalDateTime endTime);

    Long getReceiveCountByCustomerIdAndTimeRange(Long tenantId, Long customerId, Long userId, LocalDateTime beginTime, LocalDateTime endTime);

}
