ALTER TABLE `crm_customer_pool_config`
    DROP INDEX `uk_tenant_id`;

ALTER TABLE `crm_customer_pool_config`
    DROP COLUMN `receive_limit_per_day`,
    DROP COLUMN `receive_cooldown_days`;