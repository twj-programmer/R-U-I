package com.meession.etm.module.crm.service.customer.exception;

import static com.meession.etm.module.crm.service.customer.exception.CrmCustomerErrorCode.CUSTOMER_PERMISSION_DENIED;

public class CrmCustomerPermissionDeniedException extends CrmCustomerExtensionException {

    public CrmCustomerPermissionDeniedException() {
        super(CUSTOMER_PERMISSION_DENIED);
    }

}