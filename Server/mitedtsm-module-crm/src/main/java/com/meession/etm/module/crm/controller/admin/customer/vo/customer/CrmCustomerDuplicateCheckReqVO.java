package com.meession.etm.module.crm.controller.admin.customer.vo.customer;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CrmCustomerDuplicateCheckReqVO {

    @NotBlank(message = "客户名称不能为空")
    private String name;

    private String mobile;

    private Long excludeId;

}