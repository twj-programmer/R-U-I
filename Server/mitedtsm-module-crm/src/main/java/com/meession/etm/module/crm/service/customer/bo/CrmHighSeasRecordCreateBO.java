package com.meession.etm.module.crm.service.customer.bo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CrmHighSeasRecordCreateBO {

    private Long customerId;

    private String actionType;

    private Long beforeOwnerUserId;

    private Long afterOwnerUserId;

    private String reason;

    private Long operatorUserId;

    private LocalDateTime actionTime;

}