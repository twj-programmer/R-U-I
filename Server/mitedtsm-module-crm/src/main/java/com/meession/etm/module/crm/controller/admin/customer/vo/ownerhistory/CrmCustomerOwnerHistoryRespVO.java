package com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CrmCustomerOwnerHistoryRespVO {

    private Long id;

    private Long customerId;

    private String changeType;

    private String changeTypeDesc;

    private Long beforeOwnerUserId;

    private String beforeOwnerUserName;

    private Long afterOwnerUserId;

    private String afterOwnerUserName;

    private String reason;

    private Long operatorUserId;

    private String operatorUserName;

    private LocalDateTime changeTime;

}