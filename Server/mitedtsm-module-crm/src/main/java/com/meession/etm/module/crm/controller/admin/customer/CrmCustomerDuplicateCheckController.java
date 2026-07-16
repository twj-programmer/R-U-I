package com.meession.etm.module.crm.controller.admin.customer;

import com.meession.etm.framework.common.pojo.CommonResult;
import com.meession.etm.framework.common.util.object.BeanUtils;
import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateCheckReqVO;
import com.meession.etm.module.crm.controller.admin.customer.vo.customer.CrmCustomerDuplicateCheckRespVO;
import com.meession.etm.module.crm.service.customer.CrmCustomerDuplicateCheckService;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerDuplicateCheckBO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import static com.meession.etm.framework.common.pojo.CommonResult.success;

@Tag(name = "管理后台 - CRM 客户查重")
@RestController
@RequestMapping("/crm/customer")
public class CrmCustomerDuplicateCheckController {

    @Resource
    private CrmCustomerDuplicateCheckService duplicateCheckService;

    @PostMapping("/check-duplicate")
    @Operation(summary = "客户查重")
    @PreAuthorize("@ss.hasPermission('crm:customer:query')")
    public CommonResult<CrmCustomerDuplicateCheckRespVO> checkDuplicate(@Valid @RequestBody CrmCustomerDuplicateCheckReqVO reqVO) {
        CrmCustomerDuplicateCheckBO checkBO = BeanUtils.toBean(reqVO, CrmCustomerDuplicateCheckBO.class);
        return success(duplicateCheckService.checkDuplicate(checkBO));
    }

}