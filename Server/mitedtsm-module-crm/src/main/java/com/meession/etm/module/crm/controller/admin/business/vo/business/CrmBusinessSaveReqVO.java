// 23计科4班 黄金戈
package com.meession.etm.module.crm.controller.admin.business.vo.business;

import com.meession.etm.module.crm.framework.operatelog.core.CrmCustomerParseFunction;
import com.meession.etm.module.crm.framework.operatelog.core.SysAdminUserParseFunction;
import com.mzt.logapi.starter.annotation.DiffLogField;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static com.meession.etm.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND;

@Schema(description = "管理后台 - CRM 商机创建/更新 Request VO")
@Data
public class CrmBusinessSaveReqVO {

    @Schema(description = "主键", requiredMode = Schema.RequiredMode.REQUIRED, example = "32129")
    private Long id;

    @Schema(description = "乐观锁版本；更新时必填", example = "0")
    @Min(value = 0, message = "版本号不能小于 0")
    private Integer version;

    @Schema(description = "商机名称", requiredMode = Schema.RequiredMode.REQUIRED, example = "李四")
    @DiffLogField(name = "商机名称")
    @NotNull(message = "商机名称不能为空")
    private String name;

    @Schema(description = "客户编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "10299")
    @DiffLogField(name = "客户", function = CrmCustomerParseFunction.NAME)
    @NotNull(message = "客户不能为空")
    private Long customerId;

    @Schema(description = "下次联系时间")
    @DiffLogField(name = "下次联系时间")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime contactNextTime;

    @Schema(description = "负责人用户编号", example = "14334")
    @NotNull(message = "负责人不能为空")
    @DiffLogField(name = "负责人", function = SysAdminUserParseFunction.NAME)
    private Long ownerUserId;

    @Schema(description = "商机状态组编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "25714")
    @DiffLogField(name = "商机状态组")
    @NotNull(message = "商机状态组不能为空")
    private Long statusTypeId;

    @Schema(description = "预计成交日期")
    @DiffLogField(name = "预计成交日期")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime dealTime;

    @Schema(description = "整单折扣", requiredMode = Schema.RequiredMode.REQUIRED, example = "55.00")
    @DiffLogField(name = "整单折扣")
    @NotNull(message = "整单折扣不能为空")
    @DecimalMin(value = "0.00", message = "整单折扣不能小于 0")
    @DecimalMax(value = "100.00", message = "整单折扣不能大于 100")
    @Digits(integer = 3, fraction = 2, message = "整单折扣最多 2 位小数")
    private BigDecimal discountPercent;

    @Schema(description = "备注", example = "随便")
    @DiffLogField(name = "备注")
    private String remark;

    @Schema(description = "联系人编号", example = "110")
    private Long contactId; // 使用场景，在【联系人详情】添加商机时，如果需要关联两者，需要传递 contactId 字段

    @Schema(description = "产品列表")
    private List<BusinessProduct> products;

    @Schema(description = "产品列表")
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class BusinessProduct {

        @Schema(description = "商机产品行编号；更新已有产品行时传入")
        private Long id;

        @Schema(description = "产品编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "20529")
        @NotNull(message = "产品编号不能为空")
        private Long productId;

        @Schema(description = "产品单价", requiredMode = Schema.RequiredMode.REQUIRED, example = "123.00")
        @NotNull(message = "产品单价不能为空")
        private BigDecimal productPrice;

        @Schema(description = "商机价格", requiredMode = Schema.RequiredMode.REQUIRED, example = "123.00")
        @NotNull(message = "商机价格不能为空")
        @DecimalMin(value = "0.01", message = "商机价格必须大于 0")
        @Digits(integer = 18, fraction = 2, message = "商机价格整数最多 18 位且最多 2 位小数")
        private BigDecimal businessPrice;

        @Schema(description = "产品数量", requiredMode = Schema.RequiredMode.REQUIRED, example = "8911")
        @NotNull(message = "产品数量不能为空")
        @DecimalMin(value = "0.001", message = "产品数量必须大于 0")
        @Digits(integer = 18, fraction = 3, message = "产品数量整数最多 18 位且最多 3 位小数")
        private BigDecimal count;

    }

}
