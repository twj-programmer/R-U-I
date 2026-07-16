// 23计科4班 黄金戈
package com.meession.etm.module.crm.controller.admin.business.vo.business;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Schema(description = "管理后台 - CRM 商机报价产品 Request VO")
@Data
public class CrmBusinessProductReqVO {

    @Schema(description = "产品编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "20529")
    @NotNull(message = "产品编号不能为空")
    private Long productId;

    @Schema(description = "业务单价", requiredMode = Schema.RequiredMode.REQUIRED, example = "123.00")
    @NotNull(message = "业务单价不能为空")
    @DecimalMin(value = "0.01", message = "业务单价必须大于 0")
    @Digits(integer = 18, fraction = 2, message = "业务单价整数最多 18 位且最多 2 位小数")
    private BigDecimal businessPrice;

    @Schema(description = "产品数量", requiredMode = Schema.RequiredMode.REQUIRED, example = "3.000")
    @NotNull(message = "产品数量不能为空")
    @DecimalMin(value = "0.001", message = "产品数量必须大于 0")
    @Digits(integer = 18, fraction = 3, message = "产品数量整数最多 18 位且最多 3 位小数")
    private BigDecimal count;

}
