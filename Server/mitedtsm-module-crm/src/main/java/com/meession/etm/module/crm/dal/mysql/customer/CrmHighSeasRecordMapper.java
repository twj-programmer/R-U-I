package com.meession.etm.module.crm.dal.mysql.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.mybatis.core.mapper.BaseMapperX;
import com.meession.etm.framework.mybatis.core.query.LambdaQueryWrapperX;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmHighSeasRecordPageReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmHighSeasRecordDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface CrmHighSeasRecordMapper extends BaseMapperX<CrmHighSeasRecordDO> {

    default PageResult<CrmHighSeasRecordDO> selectPage(CrmHighSeasRecordPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<CrmHighSeasRecordDO>()
                .eqIfPresent(CrmHighSeasRecordDO::getCustomerId, reqVO.getCustomerId())
                .eqIfPresent(CrmHighSeasRecordDO::getActionType, reqVO.getActionType())
                .betweenIfPresent(CrmHighSeasRecordDO::getActionTime, reqVO.getBeginTime(), reqVO.getEndTime())
                .orderByDesc(CrmHighSeasRecordDO::getActionTime));
    }

    default List<CrmHighSeasRecordDO> selectListByCustomerId(Long customerId) {
        return selectList(new LambdaQueryWrapperX<CrmHighSeasRecordDO>()
                .eq(CrmHighSeasRecordDO::getCustomerId, customerId)
                .orderByDesc(CrmHighSeasRecordDO::getActionTime));
    }

    default List<CrmHighSeasRecordDO> selectListByCustomerIdAndTimeRange(Long customerId, LocalDateTime beginTime, LocalDateTime endTime) {
        return selectList(new LambdaQueryWrapperX<CrmHighSeasRecordDO>()
                .eq(CrmHighSeasRecordDO::getCustomerId, customerId)
                .betweenIfPresent(CrmHighSeasRecordDO::getActionTime, beginTime, endTime)
                .orderByDesc(CrmHighSeasRecordDO::getActionTime));
    }

    default List<CrmHighSeasRecordDO> selectListByOperatorUserId(Long operatorUserId) {
        return selectList(new LambdaQueryWrapperX<CrmHighSeasRecordDO>()
                .eq(CrmHighSeasRecordDO::getOperatorUserId, operatorUserId)
                .orderByDesc(CrmHighSeasRecordDO::getActionTime));
    }

    default List<CrmHighSeasRecordDO> selectListByActionType(String actionType) {
        return selectList(new LambdaQueryWrapperX<CrmHighSeasRecordDO>()
                .eq(CrmHighSeasRecordDO::getActionType, actionType)
                .orderByDesc(CrmHighSeasRecordDO::getActionTime));
    }

    @Select("SELECT COUNT(*) FROM crm_high_seas_record WHERE tenant_id = #{tenantId} AND operator_user_id = #{userId} AND action_type = 'RECEIVE' AND action_time >= #{beginTime} AND action_time < #{endTime}")
    Long selectReceiveCountByUserIdAndDateRange(@Param("tenantId") Long tenantId, @Param("userId") Long userId,
                                                 @Param("beginTime") LocalDateTime beginTime, @Param("endTime") LocalDateTime endTime);

    @Select("SELECT COUNT(*) FROM crm_high_seas_record WHERE tenant_id = #{tenantId} AND customer_id = #{customerId} AND operator_user_id = #{userId} AND action_type = 'RECEIVE' AND action_time >= #{beginTime} AND action_time <= #{endTime}")
    Long selectReceiveCountByCustomerIdAndTimeRange(@Param("tenantId") Long tenantId, @Param("customerId") Long customerId,
                                                     @Param("userId") Long userId, @Param("beginTime") LocalDateTime beginTime,
                                                     @Param("endTime") LocalDateTime endTime);

}
