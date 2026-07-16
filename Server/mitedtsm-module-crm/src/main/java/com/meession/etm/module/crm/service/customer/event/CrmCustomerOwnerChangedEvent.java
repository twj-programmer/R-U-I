package com.meession.etm.module.crm.service.customer.event;

import lombok.Getter;
import org.springframework.context.ApplicationEvent;

@Getter
public class CrmCustomerOwnerChangedEvent extends ApplicationEvent {

    private final Long customerId;

    private final Long beforeOwnerUserId;

    private final Long afterOwnerUserId;

    private final String changeType;

    private final String reason;

    private final Long operatorUserId;

    public CrmCustomerOwnerChangedEvent(Object source, Long customerId, Long beforeOwnerUserId,
                                        Long afterOwnerUserId, String changeType, String reason, Long operatorUserId) {
        super(source);
        this.customerId = customerId;
        this.beforeOwnerUserId = beforeOwnerUserId;
        this.afterOwnerUserId = afterOwnerUserId;
        this.changeType = changeType;
        this.reason = reason;
        this.operatorUserId = operatorUserId;
    }

}