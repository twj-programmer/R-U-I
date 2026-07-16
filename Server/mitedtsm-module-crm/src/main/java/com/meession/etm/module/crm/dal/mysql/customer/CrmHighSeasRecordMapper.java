package com.meession.etm.module.crm.dal.mysql.customer;

import com.meession.etm.framework.mybatis.core.mapper.BaseMapperX;
import com.meession.etm.module.crm.controller.admin.customer.vo.pool.CrmHighSeasRecordPageReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmHighSeasRecordDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface CrmHighSeasRecordMapper extends BaseMapperX<CrmHighSeasRecordDO> {

    List<CrmHighSeasRecordDO> selectPageByCondition(CrmHighSeasRecordPageReqVO reqVO);

    int selectCountByCondition(CrmHighSeasRecordPageReqVO reqVO);

    CrmHighSeasRecordDO selectById(Long id);

    List<CrmHighSeasRecordDO> selectByCustomerId(@Param("customerId") Long customerId, @Param("tenantId") Long tenantId);

    Long countTodayReceivedByUserId(@Param("userId") Long userId, @Param("actionTime") LocalDateTime actionTime, @Param("tenantId") Long tenantId);

    Long countReceivedInDaysByUserIdAndCustomerId(@Param("userId") Long userId, @Param("customerId") Long customerId, @Param("actionTime") LocalDateTime actionTime, @Param("tenantId") Long tenantId);

}