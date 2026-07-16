package com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory;

import com.meession.etm.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.time.LocalDateTime;

@Schema(description = "管理后台 - CRM 客户归属历史分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class CrmCustomerOwnerHistoryPageReqVO extends PageParam {

    @Schema(description = "客户编号", example = "1024")
    private Long customerId;

    @Schema(description = "变更类型", example = "TRANSFER")
    private String changeType;

    @Schema(description = "开始时间")
    private LocalDateTime beginTime;

    @Schema(description = "结束时间")
    private LocalDateTime endTime;

}