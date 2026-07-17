package com.meession.etm.module.crm.controller.admin.customer.vo.record;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 负责人历史响应 VO")
@Data
public class CrmCustomerOwnerHistoryRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "客户编号")
    private Long customerId;

    @Schema(description = "变更类型")
    private String changeType;

    @Schema(description = "旧负责人编号")
    private Long oldOwnerUserId;

    @Schema(description = "旧负责人名称")
    private String oldOwnerUserName;

    @Schema(description = "新负责人编号")
    private Long newOwnerUserId;

    @Schema(description = "新负责人名称")
    private String newOwnerUserName;

    @Schema(description = "备注")
    private String reason;

    @Schema(description = "操作人编号")
    private Long operatorUserId;

    @Schema(description = "操作人名称")
    private String operatorUserName;

    @Schema(description = "变更时间")
    private LocalDateTime changeTime;

}