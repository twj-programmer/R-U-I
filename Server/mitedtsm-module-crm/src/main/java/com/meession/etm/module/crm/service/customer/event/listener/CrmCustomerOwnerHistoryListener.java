package com.meession.etm.module.crm.service.customer.event.listener;

import com.meession.etm.module.crm.service.customer.CrmCustomerOwnerHistoryService;
import com.meession.etm.module.crm.service.customer.bo.CrmCustomerOwnerHistoryCreateBO;
import com.meession.etm.module.crm.service.customer.event.CrmCustomerOwnerChangedEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class CrmCustomerOwnerHistoryListener {

    private final CrmCustomerOwnerHistoryService ownerHistoryService;

    @EventListener
    public void onCustomerOwnerChanged(CrmCustomerOwnerChangedEvent event) {
        log.info("[onCustomerOwnerChanged] customerId={}, beforeOwner={}, afterOwner={}, changeType={}",
                event.getCustomerId(), event.getBeforeOwnerUserId(), event.getAfterOwnerUserId(), event.getChangeType());

        CrmCustomerOwnerHistoryCreateBO createBO = new CrmCustomerOwnerHistoryCreateBO();
        createBO.setCustomerId(event.getCustomerId());
        createBO.setBeforeOwnerUserId(event.getBeforeOwnerUserId());
        createBO.setAfterOwnerUserId(event.getAfterOwnerUserId());
        createBO.setChangeType(event.getChangeType());
        createBO.setReason(event.getReason());
        createBO.setOperatorUserId(event.getOperatorUserId());

        ownerHistoryService.createHistory(createBO);
    }

}