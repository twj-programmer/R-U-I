package com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CrmCustomerOwnerHistoryPageReqVO {

    private Long customerId;

    private String changeType;

    private LocalDateTime beginTime;

    private LocalDateTime endTime;

    private Integer pageNo;

    private Integer pageSize;

    private Integer offset;

    private Integer size;

}