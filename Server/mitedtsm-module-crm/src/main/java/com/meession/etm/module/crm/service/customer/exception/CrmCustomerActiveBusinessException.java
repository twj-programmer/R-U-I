package com.meession.etm.module.crm.service.customer.exception;

import static com.meession.etm.module.crm.service.customer.exception.CrmCustomerErrorCode.CUSTOMER_PUT_POOL_FAIL_ACTIVE_BUSINESS;

public class CrmCustomerActiveBusinessException extends CrmCustomerExtensionException {

    public CrmCustomerActiveBusinessException() {
        super(CUSTOMER_PUT_POOL_FAIL_ACTIVE_BUSINESS);
    }

}