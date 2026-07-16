package com.meession.etm.module.crm.service.customer.exception;

import static com.meession.etm.module.crm.service.customer.exception.CrmCustomerErrorCode.CUSTOMER_RECEIVE_COOLDOWN;

public class CrmCustomerReceiveCoolDownException extends CrmCustomerExtensionException {

    public CrmCustomerReceiveCoolDownException() {
        super(CUSTOMER_RECEIVE_COOLDOWN);
    }

}