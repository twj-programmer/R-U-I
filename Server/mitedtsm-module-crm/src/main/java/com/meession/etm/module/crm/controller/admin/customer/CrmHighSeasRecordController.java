package com.meession.etm.module.crm.controller.admin.customer;

import com.meession.etm.framework.common.pojo.CommonResult;
import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.module.crm.controller.admin.customer.vo.pool.CrmHighSeasRecordPageReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.pool.CrmHighSeasRecordRespVO;
import com.meession.etm.module.crm.service.customer.CrmHighSeasRecordService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static com.meession.etm.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - 公海记录")
@RestController
@RequestMapping("/crm/high-seas-record")
public class CrmHighSeasRecordController {

    @Resource
    private CrmHighSeasRecordService highSeasRecordService;

    @GetMapping("/page")
    @Operation(summary = "获取公海记录分页")
    @PreAuthorize("@ss.hasPermission('crm:high-seas-record:query')")
    public CommonResult<PageResult<CrmHighSeasRecordRespVO>> getPage(CrmHighSeasRecordPageReqVO reqVO) {
        return success(highSeasRecordService.getPage(reqVO));
    }

    @GetMapping("/{id}")
    @Operation(summary = "获取公海记录详情")
    @PreAuthorize("@ss.hasPermission('crm:high-seas-record:query')")
    public CommonResult<CrmHighSeasRecordRespVO> getById(@PathVariable("id") Long id) {
        return success(highSeasRecordService.getById(id));
    }

    @GetMapping("/list-by-customer")
    @Operation(summary = "获取客户公海记录列表")
    @PreAuthorize("@ss.hasPermission('crm:high-seas-record:query')")
    public CommonResult<List<CrmHighSeasRecordRespVO>> getByCustomerId(@RequestParam("customerId") Long customerId) {
        return success(highSeasRecordService.getByCustomerId(customerId));
    }

}