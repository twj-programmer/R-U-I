package com.meession.etm.module.crm.dal.mysql.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.mybatis.core.mapper.BaseMapperX;
import com.meession.etm.framework.mybatis.core.query.LambdaQueryWrapperX;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmCustomerOwnerHistoryPageReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerOwnerHistoryDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CrmCustomerOwnerHistoryMapper extends BaseMapperX<CrmCustomerOwnerHistoryDO> {

    default PageResult<CrmCustomerOwnerHistoryDO> selectPage(CrmCustomerOwnerHistoryPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<CrmCustomerOwnerHistoryDO>()
                .eqIfPresent(CrmCustomerOwnerHistoryDO::getCustomerId, reqVO.getCustomerId())
                .eqIfPresent(CrmCustomerOwnerHistoryDO::getChangeType, reqVO.getChangeType())
                .betweenIfPresent(CrmCustomerOwnerHistoryDO::getChangeTime, reqVO.getBeginTime(), reqVO.getEndTime())
                .orderByDesc(CrmCustomerOwnerHistoryDO::getChangeTime));
    }

    default List<CrmCustomerOwnerHistoryDO> selectListByCustomerId(Long customerId) {
        return selectList(new LambdaQueryWrapperX<CrmCustomerOwnerHistoryDO>()
                .eq(CrmCustomerOwnerHistoryDO::getCustomerId, customerId)
                .orderByDesc(CrmCustomerOwnerHistoryDO::getChangeTime));
    }

    default List<CrmCustomerOwnerHistoryDO> selectListByOperatorUserId(Long operatorUserId) {
        return selectList(new LambdaQueryWrapperX<CrmCustomerOwnerHistoryDO>()
                .eq(CrmCustomerOwnerHistoryDO::getOperatorUserId, operatorUserId)
                .orderByDesc(CrmCustomerOwnerHistoryDO::getChangeTime));
    }

    default List<CrmCustomerOwnerHistoryDO> selectListByNewOwnerUserId(Long newOwnerUserId) {
        return selectList(new LambdaQueryWrapperX<CrmCustomerOwnerHistoryDO>()
                .eq(CrmCustomerOwnerHistoryDO::getNewOwnerUserId, newOwnerUserId)
                .orderByDesc(CrmCustomerOwnerHistoryDO::getChangeTime));
    }

}
