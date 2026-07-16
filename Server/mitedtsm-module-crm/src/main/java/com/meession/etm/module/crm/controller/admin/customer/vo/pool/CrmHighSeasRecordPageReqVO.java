package com.meession.etm.module.crm.controller.admin.customer.vo.pool;

import com.meession.etm.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - CRM 公海记录分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class CrmHighSeasRecordPageReqVO extends PageParam {

    @Schema(description = "客户编号", example = "1024")
    private Long customerId;

    @Schema(description = "操作类型", example = "RECEIVE")
    private String actionType;

    @Schema(description = "开始时间")
    private LocalDateTime beginTime;

    @Schema(description = "结束时间")
    private LocalDateTime endTime;

}