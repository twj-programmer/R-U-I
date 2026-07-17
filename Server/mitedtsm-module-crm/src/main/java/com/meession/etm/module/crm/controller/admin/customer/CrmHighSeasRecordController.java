package com.meession.etm.module.crm.controller.admin.customer;

import com.meession.etm.framework.common.pojo.CommonResult;
import com.meession.etm.framework.common.pojo.PageResult;
import com.meession.etm.framework.common.util.object.BeanUtils;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmHighSeasRecordPageReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.record.CrmHighSeasRecordRespVO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmHighSeasRecordDO;
import com.meession.etm.module.crm.service.customer.CrmHighSeasRecordService;
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

@Tag(name = "管理后台 - CRM 公海记录")
@RestController
@RequestMapping("/crm/high-seas-record")
@Validated
public class CrmHighSeasRecordController {

    @Resource
    private CrmHighSeasRecordService highSeasRecordService;
    @Resource
    private AdminUserApi adminUserApi;

    @GetMapping("/page")
    @Operation(summary = "获取公海记录分页")
    @PreAuthorize("@ss.hasPermission('crm:high-seas-record:query')")
    public CommonResult<PageResult<CrmHighSeasRecordRespVO>> getHighSeasRecordPage(@Valid CrmHighSeasRecordPageReqVO reqVO) {
        PageResult<CrmHighSeasRecordDO> pageResult = highSeasRecordService.getRecordPage(reqVO);
        return success(new PageResult<>(fillUserNames(pageResult.getList()), pageResult.getTotal()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "获取公海记录")
    @Parameter(name = "id", description = "编号", required = true)
    @PreAuthorize("@ss.hasPermission('crm:high-seas-record:query')")
    public CommonResult<CrmHighSeasRecordRespVO> getHighSeasRecord(@PathVariable("id") Long id) {
        CrmHighSeasRecordDO record = highSeasRecordService.getRecord(id);
        return success(fillUserNames(Collections.singletonList(record)).stream().findFirst().orElse(null));
    }

    @GetMapping("/list-by-customer")
    @Operation(summary = "获取客户公海记录列表")
    @Parameter(name = "customerId", description = "客户编号", required = true)
    @PreAuthorize("@ss.hasPermission('crm:high-seas-record:query')")
    public CommonResult<List<CrmHighSeasRecordRespVO>> getHighSeasRecordListByCustomer(@RequestParam("customerId") Long customerId) {
        List<CrmHighSeasRecordDO> records = highSeasRecordService.getRecordListByCustomerId(customerId);
        return success(fillUserNames(records));
    }

    private List<CrmHighSeasRecordRespVO> fillUserNames(List<CrmHighSeasRecordDO> records) {
        List<CrmHighSeasRecordRespVO> result = BeanUtils.toBean(records, CrmHighSeasRecordRespVO.class);
        Set<Long> ids = new HashSet<>();
        records.forEach(item -> { if (item.getOperatorUserId() != null && item.getOperatorUserId() != 0) ids.add(item.getOperatorUserId()); if (item.getBeforeOwnerUserId() != null) ids.add(item.getBeforeOwnerUserId()); if (item.getAfterOwnerUserId() != null) ids.add(item.getAfterOwnerUserId()); });
        Map<Long, AdminUserRespDTO> users = ids.isEmpty() ? Collections.emptyMap() : adminUserApi.getUserMap(ids);
        result.forEach(item -> { item.setOperatorUserName(item.getOperatorUserId() != null && item.getOperatorUserId() == 0 ? "系统" : Optional.ofNullable(users.get(item.getOperatorUserId())).map(AdminUserRespDTO::getNickname).orElse(null)); item.setBeforeOwnerUserName(Optional.ofNullable(users.get(item.getBeforeOwnerUserId())).map(AdminUserRespDTO::getNickname).orElse(null)); item.setAfterOwnerUserName(Optional.ofNullable(users.get(item.getAfterOwnerUserId())).map(AdminUserRespDTO::getNickname).orElse(null)); });
        return result;
    }

}
