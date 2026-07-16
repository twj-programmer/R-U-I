// 23计科4班 黄金戈
package com.meession.etm.module.crm.controller.admin.business.vo.business;

import com.meession.etm.module.crm.framework.operatelog.core.CrmCustomerParseFunction;
import com.meession.etm.module.crm.framework.operatelog.core.SysAdminUserParseFunction;
import com.mzt.logapi.starter.annotation.DiffLogField;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import static com.meession.etm.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND;

@Schema(description = "管理后台 - CRM 商机创建 Request VO")
@Data
public class CrmBusinessCreateReqVO {

    @Schema(description = "商机名称", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "商机名称不能为空")
    @DiffLogField(name = "商机名称")
    private String name;

    @Schema(description = "客户编号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "客户不能为空")
    @DiffLogField(name = "客户", function = CrmCustomerParseFunction.NAME)
    private Long customerId;

    @Schema(description = "下次联系时间")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime contactNextTime;

    @Schema(description = "负责人编号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "负责人不能为空")
    @DiffLogField(name = "负责人", function = SysAdminUserParseFunction.NAME)
    private Long ownerUserId;

    @Schema(description = "商机状态组编号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "商机状态组不能为空")
    private Long statusTypeId;

    @Schema(description = "预计成交日期")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime dealTime;

    @Schema(description = "减免比例", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "减免比例不能为空")
    @DecimalMin(value = "0", message = "减免比例不能小于 0")
    @DecimalMax(value = "100", message = "减免比例不能大于 100")
    @Digits(integer = 3, fraction = 2, message = "减免比例最多 2 位小数")
    private BigDecimal discountPercent;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "联系人编号")
    private Long contactId;

    @Schema(description = "产品列表", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "产品列表不能为空")
    @Valid
    private List<CrmBusinessProductReqVO> products;

}
