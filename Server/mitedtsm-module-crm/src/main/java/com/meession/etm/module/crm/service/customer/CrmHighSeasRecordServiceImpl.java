package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmHighSeasRecordPageReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmHighSeasRecordDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmHighSeasRecordMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class CrmHighSeasRecordServiceImpl implements CrmHighSeasRecordService {

    @Resource
    private CrmHighSeasRecordMapper highSeasRecordMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void insertRecord(Long customerId, String actionType, Long beforeOwnerUserId, Long afterOwnerUserId,
                             String reason, Long operatorUserId, LocalDateTime actionTime) {
        CrmHighSeasRecordDO record = CrmHighSeasRecordDO.builder()
                .customerId(customerId)
                .actionType(actionType)
                .beforeOwnerUserId(beforeOwnerUserId)
                .afterOwnerUserId(afterOwnerUserId)
                .reason(reason)
                .operatorUserId(operatorUserId)
                .actionTime(actionTime)
                .build();
        highSeasRecordMapper.insert(record);
    }

    @Override
    public List<CrmHighSeasRecordDO> getRecordListByCustomerId(Long customerId) {
        return highSeasRecordMapper.selectListByCustomerId(customerId);
    }

    @Override
    public CrmHighSeasRecordDO getRecord(Long id) {
        return highSeasRecordMapper.selectById(id);
    }

    @Override
    public PageResult<CrmHighSeasRecordDO> getRecordPage(CrmHighSeasRecordPageReqVO reqVO) {
        return highSeasRecordMapper.selectPage(reqVO);
    }

    @Override
    public List<CrmHighSeasRecordDO> getRecordListByCustomerIdAndTimeRange(Long customerId, LocalDateTime beginTime, LocalDateTime endTime) {
        return highSeasRecordMapper.selectListByCustomerIdAndTimeRange(customerId, beginTime, endTime);
    }

    @Override
    public List<CrmHighSeasRecordDO> getRecordListByOperatorUserId(Long operatorUserId) {
        return highSeasRecordMapper.selectListByOperatorUserId(operatorUserId);
    }

    @Override
    public List<CrmHighSeasRecordDO> getRecordListByActionType(String actionType) {
        return highSeasRecordMapper.selectListByActionType(actionType);
    }

    @Override
    public Long getReceiveCountByUserIdAndDateRange(Long tenantId, Long userId, LocalDateTime beginTime, LocalDateTime endTime) {
        return highSeasRecordMapper.selectReceiveCountByUserIdAndDateRange(tenantId, userId, beginTime, endTime);
    }

    @Override
    public Long getReceiveCountByCustomerIdAndTimeRange(Long tenantId, Long customerId, Long userId, LocalDateTime beginTime, LocalDateTime endTime) {
        return highSeasRecordMapper.selectReceiveCountByCustomerIdAndTimeRange(tenantId, customerId, userId, beginTime, endTime);
    }

}
