-- 23计科4班 黄金戈
-- D2-BIZ-01 商机状态机增量迁移
-- 执行顺序：基础建表完成后、应用启动前执行。

SET @schema_name = DATABASE();

SET @ddl = IF(
    EXISTS(
        SELECT 1
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = @schema_name
          AND TABLE_NAME = 'crm_business'
          AND COLUMN_NAME = 'lose_reason_code'
    ),
    'SELECT ''crm_business.lose_reason_code already exists'' AS migration_message',
    'ALTER TABLE `crm_business` ADD COLUMN `lose_reason_code` varchar(64) NULL COMMENT ''输单原因字典编码'' AFTER `end_status`'
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
          AND COLUMN_NAME = 'version'
    ),
    'SELECT ''crm_business.version already exists'' AS migration_message',
    'ALTER TABLE `crm_business` ADD COLUMN `version` int NOT NULL DEFAULT 0 COMMENT ''乐观锁版本号'' AFTER `end_remark`'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 历史记录统一从版本 0 开始；不修改既有终态、阶段或输单业务事实。
UPDATE `crm_business`
SET `version` = 0
WHERE `version` IS NULL;

SELECT `COLUMN_NAME`, `COLUMN_TYPE`, `IS_NULLABLE`, `COLUMN_DEFAULT`
FROM information_schema.COLUMNS
WHERE `TABLE_SCHEMA` = @schema_name
  AND `TABLE_NAME` = 'crm_business'
  AND `COLUMN_NAME` IN ('lose_reason_code', 'version')
ORDER BY `COLUMN_NAME`;

SELECT COUNT(*) AS `business_count`,
       COALESCE(SUM(`version`), 0) AS `version_sum`,
       COUNT(`lose_reason_code`) AS `lose_reason_count`
FROM `crm_business`;
