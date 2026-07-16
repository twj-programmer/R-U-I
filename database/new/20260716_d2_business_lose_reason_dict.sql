-- D2-MKT-01: the marker distinguishes rows created by this migration from pre-existing dictionary data.
DROP PROCEDURE IF EXISTS migrate_business_lose_reason_dict;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS migrate_business_lose_reason_dict()
BEGIN
    DECLARE source_marker VARCHAR(64) DEFAULT 'D2-MKT-01:20260716';
    DECLARE conflict_count INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Never take ownership of an existing dictionary type or one of its six fixed codes.
    SELECT COUNT(*) INTO conflict_count
    FROM (
        SELECT 1 FROM `system_dict_type`
        WHERE `type` = 'crm_business_lose_reason'
          AND (`deleted` <> b'0' OR COALESCE(`remark`, '') <> source_marker)
        UNION ALL
        SELECT 1 FROM `system_dict_data`
        WHERE `dict_type` = 'crm_business_lose_reason'
          AND (`deleted` <> b'0' OR COALESCE(`remark`, '') <> source_marker)
    ) AS conflicts;

    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'D2-MKT-01 migration aborted: existing dictionary data is not owned by this migration';
    END IF;

    START TRANSACTION;

    INSERT INTO `system_dict_type` (`name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`)
    SELECT 'CRM 商机输单原因', 'crm_business_lose_reason', 0, source_marker, '1', NOW(), '1', NOW(), b'0', NULL
    WHERE NOT EXISTS (SELECT 1 FROM `system_dict_type` WHERE `type` = 'crm_business_lose_reason' AND `deleted` = b'0' AND `remark` = source_marker);

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 1, '竞品原因', 'COMPETITOR', 'crm_business_lose_reason', 0, '', '', source_marker, '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'COMPETITOR' AND `deleted` = b'0' AND `remark` = source_marker);

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 2, '价格原因', 'PRICE', 'crm_business_lose_reason', 0, '', '', source_marker, '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'PRICE' AND `deleted` = b'0' AND `remark` = source_marker);

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 3, '需求不匹配', 'REQUIREMENT_MISMATCH', 'crm_business_lose_reason', 0, '', '', source_marker, '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'REQUIREMENT_MISMATCH' AND `deleted` = b'0' AND `remark` = source_marker);

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 4, '预算不足', 'BUDGET', 'crm_business_lose_reason', 0, '', '', source_marker, '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'BUDGET' AND `deleted` = b'0' AND `remark` = source_marker);

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 5, '时机不符', 'TIMING', 'crm_business_lose_reason', 0, '', '', source_marker, '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'TIMING' AND `deleted` = b'0' AND `remark` = source_marker);

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 6, '其他', 'OTHER', 'crm_business_lose_reason', 0, '', '', source_marker, '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'OTHER' AND `deleted` = b'0' AND `remark` = source_marker);

    COMMIT;
END$$

DELIMITER ;

CALL migrate_business_lose_reason_dict();

DROP PROCEDURE IF EXISTS migrate_business_lose_reason_dict;
