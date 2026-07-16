package com.meession.etm.module.crm.service.customer;

public interface CrmCustomerPoolReceiveRuleService {

    boolean checkDailyLimit(Long userId);

    boolean checkCooldown(Long userId, Long customerId);

    boolean checkActiveBusiness(Long customerId);

}