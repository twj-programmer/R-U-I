// 23计科4班 黄金戈
package com.meession.etm.module.crm.controller.admin.business.vo.business;

import lombok.Data;

@Data
public class CrmBusinessStatusUpdateRespVO {
    private Long id;
    private Integer version;
    private Long statusId;
    private Integer endStatus;
    private String loseReasonCode;
    private String endRemark;
}
