package com.meession.etm.module.crm.service.customer.exception;

import static com.meession.etm.module.crm.service.customer.exception.CrmCustomerErrorCode.CUSTOMER_RECEIVE_EXCEED_DAILY_LIMIT;

public class CrmCustomerReceiveLimitException extends CrmCustomerExtensionException {

    public CrmCustomerReceiveLimitException() {
        super(CUSTOMER_RECEIVE_EXCEED_DAILY_LIMIT);
    }

}