package com.meession.etm.module.crm.controller.admin.customer.vo.customer;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class CrmCustomerDuplicateCheckRespVO {

    private Boolean hasDuplicate = false;

    private List<CrmCustomerDuplicateItemVO> candidates = new ArrayList<>();

}