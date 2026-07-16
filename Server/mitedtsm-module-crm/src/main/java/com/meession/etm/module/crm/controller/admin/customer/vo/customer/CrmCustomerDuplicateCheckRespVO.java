package com.meession.etm.module.crm.controller.admin.customer.vo.customer;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Schema(description = "管理后台 - CRM 客户查重 Response VO")
@Data
public class CrmCustomerDuplicateCheckRespVO {

    @Schema(description = "是否存在重复", example = "true")
    private Boolean hasDuplicate = false;

    @Schema(description = "重复候选列表")
    private List<CrmCustomerDuplicateItemVO> candidates = new ArrayList<>();

}