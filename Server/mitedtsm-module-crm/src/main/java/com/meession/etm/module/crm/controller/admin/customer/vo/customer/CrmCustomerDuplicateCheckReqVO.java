package com.meession.etm.module.crm.controller.admin.customer.vo.customer;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

@Schema(description = "管理后台 - CRM 客户查重 Request VO")
@Data
public class CrmCustomerDuplicateCheckReqVO {

    @Schema(description = "客户名称", example = "张三")
    private String name;

    @Schema(description = "手机号码", example = "13800138000")
    private String mobile;

    @Schema(description = "排除的客户编号", example = "1024")
    private Long excludeId;

}