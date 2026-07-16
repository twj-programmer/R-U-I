package com.meession.etm.module.crm.service.customer.exception;

import com.meession.etm.framework.common.exception.ErrorCode;
import com.meession.etm.framework.common.exception.ServiceException;

public class CrmCustomerExtensionException extends ServiceException {

    public CrmCustomerExtensionException(ErrorCode errorCode) {
        super(errorCode);
    }

    public CrmCustomerExtensionException(ErrorCode errorCode, String message) {
        super(errorCode.getCode(), message);
    }

}