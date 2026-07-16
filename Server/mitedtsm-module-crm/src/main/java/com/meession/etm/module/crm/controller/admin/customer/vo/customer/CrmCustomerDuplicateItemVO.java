package com.meession.etm.module.crm.controller.admin.customer.vo.customer;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CrmCustomerDuplicateItemVO {

    private Long id;

    private String name;

    private String mobileMasked;

    private String matchType;

    private BigDecimal similarity;

}