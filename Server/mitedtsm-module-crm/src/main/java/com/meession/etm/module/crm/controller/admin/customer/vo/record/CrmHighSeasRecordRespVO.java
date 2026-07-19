package com.meession.etm.module.crm.controller.admin.customer.vo.record;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - 公海记录响应 VO")
@Data
public class CrmHighSeasRecordRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "客户编号")
    private Long customerId;

    @Schema(description = "动作类型")
    private String actionType;

    @Schema(description = "移入前负责人编号")
    private Long beforeOwnerUserId;

    @Schema(description = "移入前负责人名称")
    private String beforeOwnerUserName;

    @Schema(description = "移入后负责人编号")
    private Long afterOwnerUserId;

    @Schema(description = "移入后负责人名称")
    private String afterOwnerUserName;

    @Schema(description = "备注")
    private String reason;

    @Schema(description = "操作人编号")
    private Long operatorUserId;

    @Schema(description = "操作人名称")
    private String operatorUserName;

    @Schema(description = "动作时间")
    private LocalDateTime actionTime;

}