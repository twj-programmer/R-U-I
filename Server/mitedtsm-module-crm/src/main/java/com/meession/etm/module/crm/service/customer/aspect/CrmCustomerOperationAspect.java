package com.meession.etm.module.crm.service.customer.aspect;

import com.meession.etm.framework.security.core.util.SecurityFrameworkUtils;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.enums.customer.HighSeasActionTypeEnum;
import com.meession.etm.module.crm.enums.customer.OwnerChangeTypeEnum;
import com.meession.etm.module.crm.service.customer.CrmCustomerPoolReceiveRuleService;
import com.meession.etm.module.crm.service.customer.CrmHighSeasRecordService;
import com.meession.etm.module.crm.service.customer.bo.CrmHighSeasRecordCreateBO;
import com.meession.etm.module.crm.service.customer.event.CrmCustomerOwnerChangedEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
public class CrmCustomerOperationAspect {

    private final CrmCustomerMapper customerMapper;
    private final CrmCustomerPoolReceiveRuleService poolReceiveRuleService;
    private final CrmHighSeasRecordService highSeasRecordService;
    private final ApplicationEventPublisher eventPublisher;

    @Before("execution(* com.meession.etm.module.crm.service.customer.CrmCustomerService.receiveCustomer(..))")
    public void beforeReceiveCustomer(JoinPoint joinPoint) {
        Object[] args = joinPoint.getArgs();
        if (args.length >= 2) {
            @SuppressWarnings("unchecked")
            List<Long> customerIds = (List<Long>) args[0];
            Long ownerUserId = (Long) args[1];

            for (Long customerId : customerIds) {
                CrmCustomerDO customer = customerMapper.selectById(customerId);
                if (customer != null) {
                    poolReceiveRuleService.checkDailyLimit(ownerUserId);
                    poolReceiveRuleService.checkCooldown(ownerUserId, customerId);
                }
            }
        }
    }

    @Before("execution(* com.meession.etm.module.crm.service.customer.CrmCustomerService.putCustomerPool(Long))")
    public void beforePutCustomerPool(JoinPoint joinPoint) {
        Object[] args = joinPoint.getArgs();
        if (args.length > 0) {
            Long customerId = (Long) args[0];
            poolReceiveRuleService.checkActiveBusiness(customerId);
        }
    }

    @AfterReturning(pointcut = "execution(* com.meession.etm.module.crm.service.customer.CrmCustomerService.receiveCustomer(..))", returning = "result")
    public void afterReceiveCustomer(JoinPoint joinPoint, Object result) {
        Object[] args = joinPoint.getArgs();
        if (args.length >= 3) {
            @SuppressWarnings("unchecked")
            List<Long> customerIds = (List<Long>) args[0];
            Long ownerUserId = (Long) args[1];
            Boolean isReceive = (Boolean) args[2];

            Long operatorUserId = getCurrentUserId();

            for (Long customerId : customerIds) {
                CrmCustomerDO customer = customerMapper.selectById(customerId);
                if (customer != null) {
                    createHighSeasRecord(customerId, HighSeasActionTypeEnum.RECEIVE.getType(),
                            null, ownerUserId, null, operatorUserId);

                    String changeType = isReceive ? OwnerChangeTypeEnum.RECEIVE.getType() 
                            : OwnerChangeTypeEnum.ASSIGN.getType();
                    publishOwnerChangedEvent(customerId, null, ownerUserId, changeType, null, operatorUserId);
                }
            }
        }
    }

    @AfterReturning(pointcut = "execution(* com.meession.etm.module.crm.service.customer.CrmCustomerService.putCustomerPool(Long))", returning = "result")
    public void afterPutCustomerPool(JoinPoint joinPoint, Object result) {
        Object[] args = joinPoint.getArgs();
        if (args.length > 0) {
            Long customerId = (Long) args[0];
            CrmCustomerDO customer = customerMapper.selectById(customerId);
            if (customer != null) {
                Long operatorUserId = getCurrentUserId();

                createHighSeasRecord(customerId, HighSeasActionTypeEnum.MANUAL_PUT.getType(),
                        customer.getOwnerUserId(), null, null, operatorUserId);

                publishOwnerChangedEvent(customerId, customer.getOwnerUserId(), null,
                        OwnerChangeTypeEnum.PUT_POOL.getType(), null, operatorUserId);
            }
        }
    }

    private void createHighSeasRecord(Long customerId, String actionType,
                                       Long beforeOwnerUserId, Long afterOwnerUserId,
                                       String reason, Long operatorUserId) {
        CrmHighSeasRecordCreateBO createBO = new CrmHighSeasRecordCreateBO();
        createBO.setCustomerId(customerId);
        createBO.setActionType(actionType);
        createBO.setBeforeOwnerUserId(beforeOwnerUserId);
        createBO.setAfterOwnerUserId(afterOwnerUserId);
        createBO.setReason(reason);
        createBO.setOperatorUserId(operatorUserId != null ? operatorUserId : 0L);

        highSeasRecordService.createRecord(createBO);
    }

    private void publishOwnerChangedEvent(Long customerId, Long beforeOwnerUserId, Long afterOwnerUserId,
                                          String changeType, String reason, Long operatorUserId) {
        eventPublisher.publishEvent(new CrmCustomerOwnerChangedEvent(this, customerId, beforeOwnerUserId,
                afterOwnerUserId, changeType, reason, operatorUserId != null ? operatorUserId : 0L));
    }

    private Long getCurrentUserId() {
        try {
            return SecurityFrameworkUtils.getLoginUserId();
        } catch (Exception e) {
            log.warn("[getCurrentUserId] 获取当前用户ID失败", e);
            return null;
        }
    }

}