package com.meession.etm.module.crm.dal.mysql.customer;

import com.meession.etm.framework.mybatis.core.mapper.BaseMapperX;
import com.meession.etm.module.crm.controller.admin.customer.vo.pool.CrmHighSeasRecordPageReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmHighSeasRecordDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CrmHighSeasRecordMapper extends BaseMapperX<CrmHighSeasRecordDO> {

    List<CrmHighSeasRecordDO> selectPageByCondition(@Param("reqVO") CrmHighSeasRecordPageReqVO reqVO, @Param("offset") int offset);

    long selectCountByCondition(CrmHighSeasRecordPageReqVO reqVO);

    CrmHighSeasRecordDO selectById(Long id);

    List<CrmHighSeasRecordDO> selectByCustomerId(@Param("customerId") Long customerId, @Param("tenantId") Long tenantId);

}