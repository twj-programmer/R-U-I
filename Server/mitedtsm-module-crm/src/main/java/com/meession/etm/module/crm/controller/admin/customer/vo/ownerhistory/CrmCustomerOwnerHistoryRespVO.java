package com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - CRM 客户归属历史 Response VO")
@Data
public class CrmCustomerOwnerHistoryRespVO {

    @Schema(description = "编号")
    private Long id;

    @Schema(description = "客户编号")
    private Long customerId;

    @Schema(description = "变更类型")
    private String changeType;

    @Schema(description = "变更类型描述")
    private String changeTypeDesc;

    @Schema(description = "变更前负责人用户编号")
    private Long oldOwnerUserId;

    @Schema(description = "变更前负责人用户名")
    private String oldOwnerUserName;

    @Schema(description = "变更后负责人用户编号")
    private Long newOwnerUserId;

    @Schema(description = "变更后负责人用户名")
    private String newOwnerUserName;

    @Schema(description = "原因")
    private String reason;

    @Schema(description = "操作人用户编号")
    private Long operatorUserId;

    @Schema(description = "操作人用户名")
    private String operatorUserName;

    @Schema(description = "变更时间")
    private LocalDateTime changeTime;

}