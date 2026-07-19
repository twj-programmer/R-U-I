package com.meession.etm.module.crm.controller.admin.customer.vo.customer;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - CRM 客户查重候选项 VO")
@Data
public class CrmCustomerDuplicateItemVO {

    @Schema(description = "客户编号", example = "1024")
    private Long id;

    @Schema(description = "客户名称", example = "张三")
    private String name;

    @Schema(description = "脱敏手机号", example = "138****8000")
    private String mobileMasked;

    @Schema(description = "匹配类型：STRONG-强匹配，SUSPECT-疑似匹配")
    private String matchType;

    @Schema(description = "名称相似度", example = "0.85")
    private BigDecimal similarity;

}