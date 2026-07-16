// 23计科4班 黄金戈
package com.meession.etm.module.crm.controller.admin.business.vo.business;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

import static com.meession.etm.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND;

@Schema(description = "管理后台 - CRM 商机基础资料更新 Request VO")
@Data
public class CrmBusinessUpdateReqVO {

    @Schema(description = "商机编号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "商机编号不能为空")
    private Long id;

    @Schema(description = "乐观锁版本", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "版本号不能为空")
    @Min(value = 0, message = "版本号不能小于 0")
    private Integer version;

    @Schema(description = "商机名称", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "商机名称不能为空")
    private String name;

    @Schema(description = "客户编号", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotNull(message = "客户不能为空")
    private Long customerId;

    @Schema(description = "下次联系时间")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime contactNextTime;

    @Schema(description = "预计成交日期")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime dealTime;

    @Schema(description = "备注")
    private String remark;

    @Schema(description = "联系人编号")
    private Long contactId;

}
