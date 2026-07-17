package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmCustomerOwnerHistoryPageReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerOwnerHistoryDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerOwnerHistoryMapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class CrmCustomerOwnerHistoryServiceImpl implements CrmCustomerOwnerHistoryService {

    @Resource
    private CrmCustomerOwnerHistoryMapper ownerHistoryMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void insertHistory(Long customerId, String changeType, Long oldOwnerUserId, Long newOwnerUserId,
                              String reason, Long operatorUserId, LocalDateTime changeTime) {
        CrmCustomerOwnerHistoryDO history = CrmCustomerOwnerHistoryDO.builder()
                .customerId(customerId)
                .changeType(changeType)
                .oldOwnerUserId(oldOwnerUserId)
                .newOwnerUserId(newOwnerUserId)
                .reason(reason)
                .operatorUserId(operatorUserId)
                .changeTime(changeTime)
                .build();
        ownerHistoryMapper.insert(history);
    }

    @Override
    public List<CrmCustomerOwnerHistoryDO> getHistoryListByCustomerId(Long customerId) {
        return ownerHistoryMapper.selectListByCustomerId(customerId);
    }

    @Override
    public PageResult<CrmCustomerOwnerHistoryDO> getHistoryPage(CrmCustomerOwnerHistoryPageReqVO reqVO) {
        return ownerHistoryMapper.selectPage(reqVO);
    }

    @Override
    public List<CrmCustomerOwnerHistoryDO> getHistoryListByOperatorUserId(Long operatorUserId) {
        return ownerHistoryMapper.selectListByOperatorUserId(operatorUserId);
    }

    @Override
    public List<CrmCustomerOwnerHistoryDO> getHistoryListByNewOwnerUserId(Long newOwnerUserId) {
        return ownerHistoryMapper.selectListByNewOwnerUserId(newOwnerUserId);
    }

}
