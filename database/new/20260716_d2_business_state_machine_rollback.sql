-- 23计科4班 黄金戈
-- D2-BIZ-01 商机状态机回滚脚本
-- 执行前必须停止使用 version/lose_reason_code 的应用实例并完成数据备份。
-- 安全规则：只删除 COLUMN_COMMENT 带有 [D2-BIZ-01] 标记、可确认由本迁移创建的字段。
-- 迁移前已存在或来源不明的同名字段一律保留，并输出提示信息。

SET @schema_name = DATABASE();

SET @ddl = IF(
    EXISTS(
        SELECT 1
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = 'crm_business'
          AND COLUMN_NAME = 'version'
          AND LOCATE('[D2-BIZ-01]', COLUMN_COMMENT) > 0
    ),
    'ALTER TABLE `crm_business` DROP COLUMN `version`',
    'SELECT ''crm_business.version was not created by D2-BIZ-01; preserved'' AS rollback_message'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @ddl = IF(
    EXISTS(
        SELECT 1
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = 'crm_business'
          AND COLUMN_NAME = 'lose_reason_code'
          AND LOCATE('[D2-BIZ-01]', COLUMN_COMMENT) > 0
    ),
    'ALTER TABLE `crm_business` DROP COLUMN `lose_reason_code`',
    'SELECT ''crm_business.lose_reason_code was not created by D2-BIZ-01; preserved'' AS rollback_message'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
