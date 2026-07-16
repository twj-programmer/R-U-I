package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.module.crm.controller.admin.customer.vo.pool.CrmHighSeasRecordPageReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.pool.CrmHighSeasRecordRespVO;
import com.meession.etm.module.crm.service.customer.bo.CrmHighSeasRecordCreateBO;

import java.util.List;

public interface CrmHighSeasRecordService {

    void createRecord(CrmHighSeasRecordCreateBO createBO);

    PageResult<CrmHighSeasRecordRespVO> getPage(CrmHighSeasRecordPageReqVO reqVO);

    CrmHighSeasRecordRespVO getById(Long id);

    List<CrmHighSeasRecordRespVO> getByCustomerId(Long customerId);

}