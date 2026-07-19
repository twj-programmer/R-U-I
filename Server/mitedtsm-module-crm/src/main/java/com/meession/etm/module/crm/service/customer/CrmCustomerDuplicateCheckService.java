package com.meession.etm.module.crm.service.customer;

import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateCheckRespVO;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerDuplicateCheckBO;

public interface CrmCustomerDuplicateCheckService {

    CrmCustomerDuplicateCheckRespVO checkDuplicate(CrmCustomerDuplicateCheckBO checkBO);

}