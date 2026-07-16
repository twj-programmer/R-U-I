package com.meession.etm.module.crm.service.customer.migration;

import com.meession.etm.framework.tenant.core.context.TenantContextHolder;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerDO;
import com.meession.etm.module.crm.dal.dataobject.customer.CrmCustomerPoolConfigDO;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerMapper;
import com.meession.etm.module.crm.dal.mysql.customer.CrmCustomerPoolConfigMapper;
import com.meession.etm.module.crm.enums.customer.HighSeasActionTypeEnum;
import com.meession.etm.module.crm.service.customer.CrmHighSeasRecordService;
import com.meession.etm.module.crm.service.customer.bo.CrmHighSeasRecordCreateBO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Component
@Order(100)
@RequiredArgsConstructor
public class CrmCustomerExtensionDataMigration implements CommandLineRunner {

    private final CrmCustomerPoolConfigMapper poolConfigMapper;
    private final CrmCustomerMapper customerMapper;
    private final CrmHighSeasRecordService highSeasRecordService;

    private static final int DEFAULT_DAILY_LIMIT = 10;
    private static final int DEFAULT_COOLDOWN_DAYS = 30;

    @Override
    public void run(String... args) {
        log.info("[CrmCustomerExtensionDataMigration] 开始执行客户扩展数据迁移");
        try {
            migratePoolConfig();
            log.info("[CrmCustomerExtensionDataMigration] 客户扩展数据迁移完成");
        } catch (Exception e) {
            log.error("[CrmCustomerExtensionDataMigration] 客户扩展数据迁移失败", e);
        }
    }

    @Transactional
    public void migratePoolConfig() {
        List<CrmCustomerPoolConfigDO> configs = poolConfigMapper.selectList(null);

        for (CrmCustomerPoolConfigDO config : configs) {
            if (config.getReceiveLimitPerDay() == null) {
                config.setReceiveLimitPerDay(DEFAULT_DAILY_LIMIT);
            }
            if (config.getReceiveCooldownDays() == null) {
                config.setReceiveCooldownDays(DEFAULT_COOLDOWN_DAYS);
            }
            poolConfigMapper.updateById(config);
        }

        if (configs.isEmpty()) {
            log.warn("[migratePoolConfig] 未找到公海配置，跳过迁移");
        }
    }

}