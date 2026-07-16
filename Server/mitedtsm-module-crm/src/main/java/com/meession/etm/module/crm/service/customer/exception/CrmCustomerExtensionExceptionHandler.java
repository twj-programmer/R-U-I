package com.meession.etm.module.crm.service.customer.exception;

import com.meession.etm.framework.common.pojo.CommonResult;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@Slf4j
@RestControllerAdvice
public class CrmCustomerExtensionExceptionHandler {

    @ExceptionHandler(CrmCustomerReceiveLimitException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public CommonResult<Void> handleReceiveLimitException(CrmCustomerReceiveLimitException e) {
        log.warn("[handleReceiveLimitException] 客户领取超过每日上限", e);
        return CommonResult.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(CrmCustomerReceiveCoolDownException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public CommonResult<Void> handleReceiveCoolDownException(CrmCustomerReceiveCoolDownException e) {
        log.warn("[handleReceiveCoolDownException] 客户领取冷却期内", e);
        return CommonResult.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(CrmCustomerActiveBusinessException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public CommonResult<Void> handleActiveBusinessException(CrmCustomerActiveBusinessException e) {
        log.warn("[handleActiveBusinessException] 存在进行中商机，无法移入公海", e);
        return CommonResult.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(CrmCustomerAlreadyReceivedException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public CommonResult<Void> handleAlreadyReceivedException(CrmCustomerAlreadyReceivedException e) {
        log.warn("[handleAlreadyReceivedException] 客户领取并发冲突", e);
        return CommonResult.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(CrmCustomerPermissionDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public CommonResult<Void> handlePermissionDeniedException(CrmCustomerPermissionDeniedException e) {
        log.warn("[handlePermissionDeniedException] 无权限操作该客户", e);
        return CommonResult.error(e.getCode(), e.getMessage());
    }

}