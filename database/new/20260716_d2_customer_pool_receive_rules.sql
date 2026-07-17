SET @duplicate_tenant_ids = NULL;

SELECT GROUP_CONCAT(DISTINCT tenant_id SEPARATOR ',') INTO @duplicate_tenant_ids
FROM (
    SELECT tenant_id, COUNT(*) AS cnt
    FROM `crm_customer_pool_config`
    GROUP BY tenant_id
    HAVING cnt > 1
) AS duplicates;

SET @error_message = CONCAT('ERROR: 存在重复租户配置，冲突租户ID: ', @duplicate_tenant_ids);

SELECT IF(@duplicate_tenant_ids IS NOT NULL, @error_message, 'OK') AS migration_check_result;

ALTER TABLE `crm_customer_pool_config`
    ADD COLUMN `receive_limit_per_day` INT NULL COMMENT '每用户每日领取上限，默认10' AFTER `notify_days`,
    ADD COLUMN `receive_cooldown_days` INT NULL COMMENT '同一客户重复领取冷却天数，默认30' AFTER `receive_limit_per_day`;

ALTER TABLE `crm_customer_pool_config`
    ADD UNIQUE KEY `uk_tenant_id` (`tenant_id`);