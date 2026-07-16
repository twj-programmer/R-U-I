package com.meession.etm.module.crm.controller.admin.customer.vo.pool;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CrmHighSeasRecordRespVO {

    private Long id;

    private Long customerId;

    private String actionType;

    private String actionTypeDesc;

    private Long beforeOwnerUserId;

    private String beforeOwnerUserName;

    private Long afterOwnerUserId;

    private String afterOwnerUserName;

    private String reason;

    private Long operatorUserId;

    private String operatorUserName;

    private LocalDateTime actionTime;

}