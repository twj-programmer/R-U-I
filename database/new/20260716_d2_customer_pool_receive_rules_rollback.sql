-- D2-CUS-03 rollback. Execute only after application code no longer reads these columns.
DROP PROCEDURE IF EXISTS `rollback_d2_customer_pool_receive_rules`;
DELIMITER $$
CREATE PROCEDURE `rollback_d2_customer_pool_receive_rules`()
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.statistics
               WHERE table_schema = DATABASE() AND table_name = 'crm_customer_pool_config'
                 AND index_name = 'uk_tenant_id') THEN
        ALTER TABLE `crm_customer_pool_config` DROP INDEX `uk_tenant_id`;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema = DATABASE() AND table_name = 'crm_customer_pool_config'
                 AND column_name = 'receive_cooldown_days') THEN
        ALTER TABLE `crm_customer_pool_config` DROP COLUMN `receive_cooldown_days`;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns
               WHERE table_schema = DATABASE() AND table_name = 'crm_customer_pool_config'
                 AND column_name = 'receive_limit_per_day') THEN
        ALTER TABLE `crm_customer_pool_config` DROP COLUMN `receive_limit_per_day`;
    END IF;
END$$
DELIMITER ;
CALL `rollback_d2_customer_pool_receive_rules`();
DROP PROCEDURE IF EXISTS `rollback_d2_customer_pool_receive_rules`;
