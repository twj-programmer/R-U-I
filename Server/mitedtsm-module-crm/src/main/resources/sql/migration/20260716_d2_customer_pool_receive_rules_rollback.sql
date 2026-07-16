ALTER TABLE `crm_customer_pool_config`
    DROP COLUMN `receive_limit_per_day`,
    DROP COLUMN `receive_cooldown_days`,
    DROP INDEX `uk_crm_customer_pool_config_tenant_id`;