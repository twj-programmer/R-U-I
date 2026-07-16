package com.meession.etm.module.crm.dal.mysql.customer;

import com.meession.etm.framework.mybatis.core.mapper.BaseMapperX;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryPageReqVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerOwnerHistoryDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CrmCustomerOwnerHistoryMapper extends BaseMapperX<CrmCustomerOwnerHistoryDO> {

    List<CrmCustomerOwnerHistoryDO> selectPageByCondition(@Param("reqVO") CrmCustomerOwnerHistoryPageReqVO reqVO, @Param("offset") int offset);

    long selectCountByCondition(CrmCustomerOwnerHistoryPageReqVO reqVO);

    List<CrmCustomerOwnerHistoryDO> selectByCustomerId(@Param("customerId") Long customerId, @Param("tenantId") Long tenantId);

}