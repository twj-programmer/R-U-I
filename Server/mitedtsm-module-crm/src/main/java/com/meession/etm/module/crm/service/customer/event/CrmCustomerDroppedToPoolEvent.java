package com.meession.etm.module.crm.service.customer.event;

import lombok.Getter;
import org.springframework.context.ApplicationEvent;

@Getter
public class CrmCustomerDroppedToPoolEvent extends ApplicationEvent {

    private final Long customerId;

    private final Long beforeOwnerUserId;

    private final Long operatorUserId;

    private final String reason;

    public CrmCustomerDroppedToPoolEvent(Object source, Long customerId, Long beforeOwnerUserId,
                                         Long operatorUserId, String reason) {
        super(source);
        this.customerId = customerId;
        this.beforeOwnerUserId = beforeOwnerUserId;
        this.operatorUserId = operatorUserId;
        this.reason = reason;
    }

}