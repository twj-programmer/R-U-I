-- 23计科4班 黄金戈
-- CRM 商机阶段 2：状态、输单原因、报价与乐观锁增量升级

ALTER TABLE `crm_business`
    ADD COLUMN `lose_reason_code` varchar(64) NULL COMMENT '输单原因字典编码' AFTER `end_status`,
    ADD COLUMN `version` int NOT NULL DEFAULT 0 COMMENT '乐观锁版本号' AFTER `end_remark`;

ALTER TABLE `crm_business_status`
    MODIFY COLUMN `percent` decimal(5, 2) NOT NULL COMMENT '赢单率，百分比';

-- 历史 0 与当前 NULL=进行中的状态口径归一。
UPDATE `crm_business`
SET `end_status` = NULL
WHERE `end_status` = 0;

-- 仅在状态组存在有效阶段时，回填进行中商机的最早阶段。
UPDATE `crm_business` b
SET `status_id` = (
    SELECT s.`id`
    FROM `crm_business_status` s
    WHERE s.`type_id` = b.`status_type_id`
      AND s.`deleted` = b'0'
    ORDER BY s.`sort`, s.`id`
    LIMIT 1
)
WHERE b.`deleted` = b'0'
  AND b.`end_status` IS NULL
  AND b.`status_id` IS NULL
  AND EXISTS (
    SELECT 1
    FROM `crm_business_status` s2
    WHERE s2.`type_id` = b.`status_type_id`
      AND s2.`deleted` = b'0'
  );

-- 发布前该查询必须返回空集；否则由业务负责人确认异常商机，禁止构造阶段。
SELECT b.`id`, b.`status_type_id`, b.`status_id`, b.`end_status`
FROM `crm_business` b
LEFT JOIN `crm_business_status` s
       ON s.`id` = b.`status_id`
      AND s.`type_id` = b.`status_type_id`
      AND s.`deleted` = b'0'
WHERE b.`deleted` = b'0'
  AND b.`end_status` IS NULL
  AND (b.`status_id` IS NULL OR s.`id` IS NULL);

-- 回滚说明：生产环境不可直接删除 version/lose_reason_code。
-- 若尚未产生新数据，可在人工确认后删除两列，并将 percent 改回原类型。
