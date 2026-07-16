package com.meession.etm.module.crm.service.customer.exception;

import static com.meession.etm.module.crm.service.customer.exception.CrmCustomerErrorCode.CUSTOMER_RECEIVE_CONCURRENT_CONFLICT;

public class CrmCustomerAlreadyReceivedException extends CrmCustomerExtensionException {

    public CrmCustomerAlreadyReceivedException() {
        super(CUSTOMER_RECEIVE_CONCURRENT_CONFLICT);
    }

}