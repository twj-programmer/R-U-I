ALTER TABLE `crm_customer_pool_config`
    ADD COLUMN `receive_limit_per_day` INT NULL COMMENT '每日领取上限' AFTER `notify_days`,
    ADD COLUMN `receive_cooldown_days` INT NULL COMMENT '领取冷却期天数' AFTER `receive_limit_per_day`;

ALTER TABLE `crm_customer_pool_config`
    ADD CONSTRAINT `uk_crm_customer_pool_config_tenant_id` UNIQUE (`tenant_id`);

SET @default_limit = 10;
SET @default_cooldown = 30;

UPDATE `crm_customer_pool_config`
SET `receive_limit_per_day` = IFNULL(`receive_limit_per_day`, @default_limit),
    `receive_cooldown_days` = IFNULL(`receive_cooldown_days`, @default_cooldown);

SELECT COUNT(*) INTO @duplicate_count
FROM (
    SELECT tenant_id, COUNT(*) as cnt
    FROM crm_customer_pool_config
    WHERE deleted = 0
    GROUP BY tenant_id
    HAVING cnt > 1
) as duplicates;

IF @duplicate_count > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '存在重复租户配置记录，无法继续迁移';
END IF;