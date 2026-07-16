-- D2-STAT-01：客户转化明细导出权限
-- 前置条件：crm:statistics-customer:query 必须且只能对应一个未删除菜单。

DROP PROCEDURE IF EXISTS `migrate_d2_statistics_customer_export_permission`;

DELIMITER $$

CREATE PROCEDURE `migrate_d2_statistics_customer_export_permission`()
BEGIN
    DECLARE parent_count INT DEFAULT 0;
    DECLARE parent_menu_id BIGINT DEFAULT NULL;
    DECLARE permission_count INT DEFAULT 0;
    DECLARE permission_parent_id BIGINT DEFAULT NULL;

    SELECT COUNT(*), MIN(`id`)
      INTO parent_count, parent_menu_id
      FROM `system_menu`
     WHERE `permission` = 'crm:statistics-customer:query'
       AND `deleted` = b'0';

    IF parent_count <> 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'D2-STAT-01 migration failed: crm:statistics-customer:query parent must exist exactly once';
    END IF;

    SELECT COUNT(*), MIN(`parent_id`)
      INTO permission_count, permission_parent_id
      FROM `system_menu`
     WHERE `permission` = 'crm:statistics-customer:export'
       AND `deleted` = b'0';

    IF permission_count = 0 THEN
        INSERT INTO `system_menu`
            (`name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
             `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
             `create_time`, `updater`, `update_time`, `deleted`)
        VALUES
            ('客户转化明细导出', 'crm:statistics-customer:export', 3, 1, parent_menu_id, '', '', '',
             '', 0, b'1', b'1', b'1', '1', NOW(), '1', NOW(), b'0');
    ELSEIF permission_count <> 1 OR permission_parent_id <> parent_menu_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'D2-STAT-01 migration failed: existing export permission is duplicated or under a wrong parent';
    END IF;
END$$

DELIMITER ;

CALL `migrate_d2_statistics_customer_export_permission`();
DROP PROCEDURE IF EXISTS `migrate_d2_statistics_customer_export_permission`;
