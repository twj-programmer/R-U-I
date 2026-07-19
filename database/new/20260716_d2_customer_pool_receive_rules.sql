-- D2-CUS-03: per-tenant customer-pool receive limits. MySQL 8.0 migration.

DROP PROCEDURE IF EXISTS `migrate_d2_customer_pool_receive_rules`;
DELIMITER $$
CREATE PROCEDURE `migrate_d2_customer_pool_receive_rules`()
BEGIN
    DECLARE duplicate_count INT DEFAULT 0;
    SELECT COUNT(*) INTO duplicate_count
      FROM (SELECT `tenant_id` FROM `crm_customer_pool_config`
             GROUP BY `tenant_id` HAVING COUNT(*) > 1) AS duplicates;
    IF duplicate_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'D2-CUS-03 migration failed: duplicate tenant pool configuration exists';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = DATABASE() AND table_name = 'crm_customer_pool_config'
                     AND column_name = 'receive_limit_per_day') THEN
        ALTER TABLE `crm_customer_pool_config`
            ADD COLUMN `receive_limit_per_day` INT NULL COMMENT 'per-user daily receive limit, default 10' AFTER `notify_days`;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = DATABASE() AND table_name = 'crm_customer_pool_config'
                     AND column_name = 'receive_cooldown_days') THEN
        ALTER TABLE `crm_customer_pool_config`
            ADD COLUMN `receive_cooldown_days` INT NULL COMMENT 'same customer cooldown days, default 30' AFTER `receive_limit_per_day`;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics
                   WHERE table_schema = DATABASE() AND table_name = 'crm_customer_pool_config'
                     AND index_name = 'uk_tenant_id') THEN
        ALTER TABLE `crm_customer_pool_config` ADD UNIQUE KEY `uk_tenant_id` (`tenant_id`);
    END IF;
END$$
DELIMITER ;
CALL `migrate_d2_customer_pool_receive_rules`();
DROP PROCEDURE IF EXISTS `migrate_d2_customer_pool_receive_rules`;
