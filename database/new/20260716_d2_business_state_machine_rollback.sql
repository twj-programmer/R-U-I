-- 23计科4班 黄金戈
-- D2-BIZ-01 商机状态机回滚脚本
-- 执行前必须停止使用 version/lose_reason_code 的应用实例并完成数据备份。

SET @schema_name = DATABASE();

SET @ddl = IF(
    EXISTS(
        SELECT 1
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = 'crm_business'
          AND COLUMN_NAME = 'version'
    ),
    'ALTER TABLE `crm_business` DROP COLUMN `version`',
    'SELECT ''crm_business.version does not exist'' AS rollback_message'
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
    ),
    'ALTER TABLE `crm_business` DROP COLUMN `lose_reason_code`',
    'SELECT ''crm_business.lose_reason_code does not exist'' AS rollback_message'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
