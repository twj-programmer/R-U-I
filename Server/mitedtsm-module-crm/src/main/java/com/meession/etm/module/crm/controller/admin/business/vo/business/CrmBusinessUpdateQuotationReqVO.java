// 23计科4班 黄金戈
package com.meession.etm.module.crm.controller.admin.business.vo.business;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Schema(description = "管理后台 - CRM 商机报价更新 Request VO")
@Data
public class CrmBusinessUpdateQuotationReqVO {

    @NotNull(message = "商机编号不能为空")
    private Long id;

    @NotNull(message = "版本号不能为空")
    @Min(value = 0, message = "版本号不能小于 0")
    private Integer version;

    @NotNull(message = "减免比例不能为空")
    @DecimalMin(value = "0", message = "减免比例不能小于 0")
    @DecimalMax(value = "100", message = "减免比例不能大于 100")
    @Digits(integer = 3, fraction = 2, message = "减免比例最多 2 位小数")
    private BigDecimal discountPercent;

    @NotNull(message = "产品列表不能为空")
    @Valid
    private List<CrmBusinessProductReqVO> products;

}
