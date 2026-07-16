package com.meession.etm.module.crm.controller.admin.customer.vo.pool;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class CrmHighSeasRecordPageReqVO {

    private Long customerId;

    private String actionType;

    private LocalDateTime beginTime;

    private LocalDateTime endTime;

    private Integer pageNo;

    private Integer pageSize;

    private Integer offset;

    private Integer size;

}