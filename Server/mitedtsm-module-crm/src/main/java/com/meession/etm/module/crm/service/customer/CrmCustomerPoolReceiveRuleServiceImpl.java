package com.meession.etm.module.crm.service.customer;

import com.meession.etm.framework.mybatis.core.query.LambdaQueryWrapperX;
import com.meession.etm.framework.tenant.core.context.TenantContextHolder;
import com.meession.etm.module.crm.dal.dataobject.business.CrmBusinessDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerPoolConfigDO;
import com.meession.etm.module.crm.dal.mysql.business.CrmBusinessMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerPoolConfigMapper;
import com.meession.etm.module.crm.service.customer.exception.CrmCustomerActiveBusinessException;
import com.meession.etm.module.crm.service.customer.exception.CrmCustomerReceiveCoolDownException;
import com.meession.etm.module.crm.service.customer.exception.CrmCustomerReceiveLimitException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class CrmCustomerPoolReceiveRuleServiceImpl implements CrmCustomerPoolReceiveRuleService {

    private final CrmCustomerPoolConfigMapper poolConfigMapper;
    private final CrmHighSeasRecordService highSeasRecordService;
    private final CrmBusinessMapper businessMapper;

    private static final int DEFAULT_DAILY_LIMIT = 10;
    private static final int DEFAULT_COOLDOWN_DAYS = 30;

    @Override
    @Transactional(readOnly = true)
    public boolean checkDailyLimit(Long userId) {
        CrmCustomerPoolConfigDO config = getPoolConfig();
        int dailyLimit = config != null && config.getReceiveLimitPerDay() != null 
                ? config.getReceiveLimitPerDay() : DEFAULT_DAILY_LIMIT;

        Long todayReceived = highSeasRecordService.countTodayReceived(userId);
        if (todayReceived >= dailyLimit) {
            log.warn("[checkDailyLimit] 用户{}今日已领取{}个客户，超过每日上限{}", userId, todayReceived, dailyLimit);
            throw new CrmCustomerReceiveLimitException();
        }
        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean checkCooldown(Long userId, Long customerId) {
        CrmCustomerPoolConfigDO config = getPoolConfig();
        int cooldownDays = config != null && config.getReceiveCooldownDays() != null 
                ? config.getReceiveCooldownDays() : DEFAULT_COOLDOWN_DAYS;

        boolean inCooldown = !highSeasRecordService.checkCooldown(userId, customerId, cooldownDays);
        if (inCooldown) {
            log.warn("[checkCooldown] 用户{}在{}天冷却期内已领取过客户{}", userId, cooldownDays, customerId);
            throw new CrmCustomerReceiveCoolDownException();
        }
        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public boolean checkActiveBusiness(Long customerId) {
        Long activeBusinessCount = businessMapper.selectCount(new LambdaQueryWrapperX<CrmBusinessDO>()
                .eq(CrmBusinessDO::getCustomerId, customerId)
                .isNull(CrmBusinessDO::getEndStatus)
                .eq(CrmBusinessDO::getDeleted, 0));

        if (activeBusinessCount != null && activeBusinessCount > 0) {
            log.warn("[checkActiveBusiness] 客户{}存在{}个进行中商机，无法移入公海", customerId, activeBusinessCount);
            throw new CrmCustomerActiveBusinessException();
        }
        return true;
    }

    private CrmCustomerPoolConfigDO getPoolConfig() {
        return poolConfigMapper.selectOne(new LambdaQueryWrapperX<CrmCustomerPoolConfigDO>()
                .eq(CrmCustomerPoolConfigDO::getTenantId, TenantContextHolder.getTenantId())
                .eq(CrmCustomerPoolConfigDO::getDeleted, 0));
    }

}