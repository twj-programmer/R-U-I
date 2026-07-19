-- D2-CUS-01：客户查重隐藏按钮权限。
-- 前置条件：crm:customer:query 必须且只能对应一个未删除菜单。

DROP PROCEDURE IF EXISTS `migrate_d2_customer_duplicate_permission`;

DELIMITER $$

CREATE PROCEDURE `migrate_d2_customer_duplicate_permission`()
BEGIN
    DECLARE parent_count INT DEFAULT 0;
    DECLARE parent_menu_id BIGINT DEFAULT NULL;

    SELECT COUNT(*), MIN(`id`)
      INTO parent_count, parent_menu_id
      FROM `system_menu`
     WHERE `permission` = 'crm:customer:query'
       AND `deleted` = b'0';

    IF parent_count <> 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'D2-CUS-01 migration failed: crm:customer:query parent must exist exactly once';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM `system_menu`
                   WHERE `permission` = 'crm:customer:check-duplicate' AND `deleted` = b'0') THEN
        INSERT INTO `system_menu`
            (`name`, `permission`, `type`, `sort`, `parent_id`, `path`, `icon`, `component`,
             `component_name`, `status`, `visible`, `keep_alive`, `always_show`, `creator`,
             `create_time`, `updater`, `update_time`, `deleted`)
        VALUES
            ('客户查重', 'crm:customer:check-duplicate', 3, 10, parent_menu_id, '', '', '',
             '', 0, b'0', b'1', b'1', 'D2-CUS-01', NOW(), 'D2-CUS-01', NOW(), b'0');
    END IF;
END$$

DELIMITER ;

CALL `migrate_d2_customer_duplicate_permission`();
DROP PROCEDURE IF EXISTS `migrate_d2_customer_duplicate_permission`;
