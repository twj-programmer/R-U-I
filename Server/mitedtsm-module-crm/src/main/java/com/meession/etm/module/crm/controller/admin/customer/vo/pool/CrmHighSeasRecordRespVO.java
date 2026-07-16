package com.meession.etm.module.crm.controller.admin.customer.vo.pool;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - CRM 公海记录 Response VO")
@Data
public class CrmHighSeasRecordRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "客户编号")
    private Long customerId;

    @Schema(description = "操作类型")
    private String actionType;

    @Schema(description = "操作类型描述")
    private String actionTypeDesc;

    @Schema(description = "操作前负责人用户编号")
    private Long beforeOwnerUserId;

    @Schema(description = "操作前负责人用户名")
    private String beforeOwnerUserName;

    @Schema(description = "操作后负责人用户编号")
    private Long afterOwnerUserId;

    @Schema(description = "操作后负责人用户名")
    private String afterOwnerUserName;

    @Schema(description = "原因")
    private String reason;

    @Schema(description = "操作人用户编号")
    private Long operatorUserId;

    @Schema(description = "操作人用户名")
    private String operatorUserName;

    @Schema(description = "操作时间")
    private LocalDateTime actionTime;

}