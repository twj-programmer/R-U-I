package com.meession.etm.module.crm.service.customer.exception;

import com.meession.etm.framework.common.exception.ErrorCode;
import lombok.Data;

@Data
public class CrmCustomerExtensionException extends RuntimeException {

    private Integer code;

    private String message;

    public CrmCustomerExtensionException(ErrorCode errorCode) {
        this.code = errorCode.getCode();
        this.message = errorCode.getMsg();
    }

    public CrmCustomerExtensionException(Integer code, String message) {
        this.code = code;
        this.message = message;
    }

}