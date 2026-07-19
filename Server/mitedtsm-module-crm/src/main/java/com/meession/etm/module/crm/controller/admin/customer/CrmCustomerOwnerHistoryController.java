package com.meession.etm.module.crm.controller.admin.customer;

import com.meession.etm.framework.common.pojo.CommonResult;
import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.common.util.object.BeanUtils;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmCustomerOwnerHistoryPageReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmCustomerOwnerHistoryRespVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerOwnerHistoryDO;
import com.meession.etm.module.crm.service.customer.CrmCustomerOwnerHistoryService;
import com.meession.etm.module.system.api.user.AdminUserApi;
import com.meession.etm.module.system.api.user.dto.AdminUserRespDTO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.*;

import static com.meession.etm.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - CRM 客户负责人历史")
@RestController
@RequestMapping("/crm/customer-owner-history")
@Validated
public class CrmCustomerOwnerHistoryController {

    @Resource
    private CrmCustomerOwnerHistoryService ownerHistoryService;
    @Resource
    private AdminUserApi adminUserApi;

    @GetMapping("/page")
    @Operation(summary = "获取负责人历史分页")
    @PreAuthorize("@ss.hasPermission('crm:customer-owner-history:query')")
    public CommonResult<PageResult<CrmCustomerOwnerHistoryRespVO>> getOwnerHistoryPage(@Valid CrmCustomerOwnerHistoryPageReqVO reqVO) {
        PageResult<CrmCustomerOwnerHistoryDO> pageResult = ownerHistoryService.getHistoryPage(reqVO);
        return success(new PageResult<>(fillUserNames(pageResult.getList()), pageResult.getTotal()));
    }

    @GetMapping("/list")
    @Operation(summary = "获取客户负责人历史列表")
    @Parameter(name = "customerId", description = "客户编号", required = true)
    @PreAuthorize("@ss.hasPermission('crm:customer-owner-history:query')")
    public CommonResult<List<CrmCustomerOwnerHistoryRespVO>> getOwnerHistoryList(@RequestParam("customerId") Long customerId) {
        List<CrmCustomerOwnerHistoryDO> histories = ownerHistoryService.getHistoryListByCustomerId(customerId);
        return success(fillUserNames(histories));
    }

    private List<CrmCustomerOwnerHistoryRespVO> fillUserNames(List<CrmCustomerOwnerHistoryDO> histories) {
        List<CrmCustomerOwnerHistoryRespVO> result = BeanUtils.toBean(histories, CrmCustomerOwnerHistoryRespVO.class);
        Set<Long> ids = new HashSet<>();
        histories.forEach(item -> { if (item.getOperatorUserId() != null && item.getOperatorUserId() != 0) ids.add(item.getOperatorUserId()); if (item.getOldOwnerUserId() != null) ids.add(item.getOldOwnerUserId()); if (item.getNewOwnerUserId() != null) ids.add(item.getNewOwnerUserId()); });
        Map<Long, AdminUserRespDTO> users = ids.isEmpty() ? Collections.emptyMap() : adminUserApi.getUserMap(ids);
        result.forEach(item -> { item.setOperatorUserName(item.getOperatorUserId() != null && item.getOperatorUserId() == 0 ? "系统" : Optional.ofNullable(users.get(item.getOperatorUserId())).map(AdminUserRespDTO::getNickname).orElse(null)); item.setOldOwnerUserName(Optional.ofNullable(users.get(item.getOldOwnerUserId())).map(AdminUserRespDTO::getNickname).orElse(null)); item.setNewOwnerUserName(Optional.ofNullable(users.get(item.getNewOwnerUserId())).map(AdminUserRespDTO::getNickname).orElse(null)); });
        return result;
    }

}
