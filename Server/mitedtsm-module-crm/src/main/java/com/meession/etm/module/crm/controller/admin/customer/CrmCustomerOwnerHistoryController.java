package com.meession.etm.module.crm.controller.admin.customer;

import com.meession.etm.framework.common.pojo.CommonResult;
import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryPageReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.ownerhistory.CrmCustomerOwnerHistoryRespVO;
import com.meession.etm.module.crm.service.customer.CrmCustomerOwnerHistoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.meession.etm.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - CRM 客户归属历史")
@RestController
@RequestMapping("/crm/customer/owner-history")
public class CrmCustomerOwnerHistoryController {

    @Resource
    private CrmCustomerOwnerHistoryService ownerHistoryService;

    @GetMapping("/page")
    @Operation(summary = "获得客户归属历史分页")
    @PreAuthorize("@ss.hasPermission('crm:customer:query')")
    public CommonResult<PageResult<CrmCustomerOwnerHistoryRespVO>> getPage(@Valid CrmCustomerOwnerHistoryPageReqVO reqVO) {
        return success(ownerHistoryService.getPage(reqVO));
    }

    @GetMapping("/list")
    @Operation(summary = "获得客户归属历史列表")
    @Parameter(name = "customerId", description = "客户编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('crm:customer:query')")
    public CommonResult<List<CrmCustomerOwnerHistoryRespVO>> getByCustomerId(@RequestParam("customerId") Long customerId) {
        return success(ownerHistoryService.getByCustomerId(customerId));
    }

}