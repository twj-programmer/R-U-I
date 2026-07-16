package com.meession.etm.module.crm.service.customer.bo;

import lombok.Data;

@Data
public class CrmCustomerDuplicateCheckBO {

    private String name;

    private String mobile;

    private Long excludeId;

}