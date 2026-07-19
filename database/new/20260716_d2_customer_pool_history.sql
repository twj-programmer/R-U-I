-- D2-CUS-02: customer pool and owner history. MySQL 8.0 migration.

CREATE TABLE IF NOT EXISTS `crm_high_seas_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `tenant_id` BIGINT NOT NULL COMMENT 'tenant ID',
    `customer_id` BIGINT NOT NULL COMMENT 'customer ID',
    `action_type` VARCHAR(32) NOT NULL COMMENT 'MANUAL_PUT, AUTO_PUT or RECEIVE',
    `before_owner_user_id` BIGINT NULL,
    `after_owner_user_id` BIGINT NULL,
    `reason` VARCHAR(500) NULL,
    `operator_user_id` BIGINT NOT NULL COMMENT '0 means system',
    `action_time` DATETIME NOT NULL,
    `creator` VARCHAR(64) NOT NULL DEFAULT '',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` VARCHAR(64) NOT NULL DEFAULT '',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted` BIT NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CRM customer pool history';

CREATE TABLE IF NOT EXISTS `crm_customer_owner_history` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `tenant_id` BIGINT NOT NULL COMMENT 'tenant ID',
    `customer_id` BIGINT NOT NULL COMMENT 'customer ID',
    `change_type` VARCHAR(32) NOT NULL COMMENT 'ASSIGN, TRANSFER, RECEIVE, MANUAL_PUT or AUTO_PUT',
    `old_owner_user_id` BIGINT NULL,
    `new_owner_user_id` BIGINT NULL,
    `reason` VARCHAR(500) NULL,
    `operator_user_id` BIGINT NOT NULL COMMENT '0 means system',
    `change_time` DATETIME NOT NULL,
    `creator` VARCHAR(64) NOT NULL DEFAULT '',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` VARCHAR(64) NOT NULL DEFAULT '',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `deleted` BIT NOT NULL DEFAULT b'0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CRM customer owner history';

DROP PROCEDURE IF EXISTS `migrate_d2_customer_pool_history`;
DELIMITER $$
CREATE PROCEDURE `migrate_d2_customer_pool_history`()
BEGIN
    DECLARE parent_count INT DEFAULT 0;
    DECLARE parent_menu_id BIGINT DEFAULT NULL;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = DATABASE() AND table_name = 'crm_high_seas_record'
                     AND column_name = 'id' AND extra LIKE '%auto_increment%') THEN
        ALTER TABLE `crm_high_seas_record`
            MODIFY COLUMN `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns
                   WHERE table_schema = DATABASE() AND table_name = 'crm_customer_owner_history'
                     AND column_name = 'id' AND extra LIKE '%auto_increment%') THEN
        ALTER TABLE `crm_customer_owner_history`
            MODIFY COLUMN `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics
                   WHERE table_schema = DATABASE() AND table_name = 'crm_high_seas_record'
                     AND index_name = 'idx_tenant_customer_time') THEN
        CREATE INDEX `idx_tenant_customer_time`
            ON `crm_high_seas_record` (`tenant_id`, `customer_id`, `action_time`);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics
                   WHERE table_schema = DATABASE() AND table_name = 'crm_high_seas_record'
                     AND index_name = 'idx_tenant_operator_time') THEN
        CREATE INDEX `idx_tenant_operator_time`
            ON `crm_high_seas_record` (`tenant_id`, `operator_user_id`, `action_time`);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics
                   WHERE table_schema = DATABASE() AND table_name = 'crm_customer_owner_history'
                     AND index_name = 'idx_owner_history_tenant_customer_time') THEN
        CREATE INDEX `idx_owner_history_tenant_customer_time`
            ON `crm_customer_owner_history` (`tenant_id`, `customer_id`, `change_time`);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.statistics
                   WHERE table_schema = DATABASE() AND table_name = 'crm_customer_owner_history'
                     AND index_name = 'idx_owner_history_tenant_new_owner_time') THEN
        CREATE INDEX `idx_owner_history_tenant_new_owner_time`
            ON `crm_customer_owner_history` (`tenant_id`, `new_owner_user_id`, `change_time`);
    END IF;

    SELECT COUNT(*), MIN(`id`) INTO parent_count, parent_menu_id
      FROM `system_menu`
     WHERE `permission` = 'crm:customer:query' AND `deleted` = b'0';
    IF parent_count <> 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'D2-CUS-02 migration failed: crm:customer:query parent must exist exactly once';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM `system_menu`
                   WHERE `permission` = 'crm:high-seas-record:query' AND `deleted` = b'0') THEN
        INSERT INTO `system_menu` (`name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
            `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
        VALUES ('公海记录查询', 'crm:high-seas-record:query', 3, 50, parent_menu_id, '', '', '', '',
            0, b'0', b'1', b'1', 'D2-CUS-02', NOW(), 'D2-CUS-02', NOW(), b'0');
    END IF;
    IF NOT EXISTS (SELECT 1 FROM `system_menu`
                   WHERE `permission` = 'crm:customer-owner-history:query' AND `deleted` = b'0') THEN
        INSERT INTO `system_menu` (`name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
            `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
        VALUES ('负责人历史查询', 'crm:customer-owner-history:query', 3, 51, parent_menu_id, '', '', '', '',
            0, b'0', b'1', b'1', 'D2-CUS-02', NOW(), 'D2-CUS-02', NOW(), b'0');
    END IF;
END$$
DELIMITER ;
CALL `migrate_d2_customer_pool_history`();
DROP PROCEDURE IF EXISTS `migrate_d2_customer_pool_history`;
