package com.meession.etm.module.crm.service.customer.event.listener;

import com.meession.etm.module.crm.service.customer.event.CrmCustomerDroppedToPoolEvent;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class CrmCustomerDropPoolNotifyListener {

    @EventListener
    public void onCustomerDroppedToPool(CrmCustomerDroppedToPoolEvent event) {
        log.info("[onCustomerDroppedToPool] customerId={}, beforeOwner={}, operator={}, reason={}",
                event.getCustomerId(), event.getBeforeOwnerUserId(), event.getOperatorUserId(), event.getReason());
    }

}