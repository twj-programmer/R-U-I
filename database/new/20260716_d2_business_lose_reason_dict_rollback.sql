DROP PROCEDURE IF EXISTS rollback_business_lose_reason_dict;

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS rollback_business_lose_reason_dict()
BEGIN
    DECLARE source_marker VARCHAR(64) DEFAULT 'D2-MKT-01:20260716';
    DECLARE column_exists INT DEFAULT 0;
    DECLARE ref_count INT DEFAULT 0;
    DECLARE ownership_conflict_count INT DEFAULT 0;
    DECLARE mutation_count INT DEFAULT 0;
    DECLARE error_msg VARCHAR(255);

    -- The migration may only remove rows it can prove it created.
    SELECT COUNT(*) INTO ownership_conflict_count
    FROM `system_dict_type`
    WHERE `type` = 'crm_business_lose_reason'
      AND COALESCE(`remark`, '') <> source_marker;

    SELECT ownership_conflict_count + COUNT(*) INTO ownership_conflict_count
    FROM `system_dict_data`
    WHERE `dict_type` = 'crm_business_lose_reason'
      AND COALESCE(`remark`, '') <> source_marker;

    IF ownership_conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'D2-MKT-01 rollback aborted: dictionary contains data not owned by this migration';
    END IF;

    -- Preserve administrator changes to labels, ordering, or enablement.
    SELECT COUNT(*) INTO mutation_count
    FROM `system_dict_type`
    WHERE `type` = 'crm_business_lose_reason'
      AND (`name` <> 'CRM 商机输单原因' OR `status` <> 0 OR `deleted` <> b'0' OR `remark` <> source_marker);

    SELECT mutation_count + COUNT(*) INTO mutation_count
    FROM `system_dict_data`
    WHERE `dict_type` = 'crm_business_lose_reason'
      AND (
          `value` NOT IN ('COMPETITOR', 'PRICE', 'REQUIREMENT_MISMATCH', 'BUDGET', 'TIMING', 'OTHER') OR
          `deleted` <> b'0' OR `remark` <> source_marker OR
          (`value` = 'COMPETITOR' AND (`sort` <> 1 OR `label` <> '竞品原因' OR `status` <> 0)) OR
          (`value` = 'PRICE' AND (`sort` <> 2 OR `label` <> '价格原因' OR `status` <> 0)) OR
          (`value` = 'REQUIREMENT_MISMATCH' AND (`sort` <> 3 OR `label` <> '需求不匹配' OR `status` <> 0)) OR
          (`value` = 'BUDGET' AND (`sort` <> 4 OR `label` <> '预算不足' OR `status` <> 0)) OR
          (`value` = 'TIMING' AND (`sort` <> 5 OR `label` <> '时机不符' OR `status` <> 0)) OR
          (`value` = 'OTHER' AND (`sort` <> 6 OR `label` <> '其他' OR `status` <> 0))
      );

    IF mutation_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'D2-MKT-01 rollback aborted: dictionary data changed after migration';
    END IF;

    SELECT COUNT(*) INTO column_exists
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'crm_business'
      AND COLUMN_NAME = 'lose_reason_code';

    IF column_exists > 0 THEN
        SELECT COUNT(*) INTO ref_count
        FROM `crm_business`
        WHERE `lose_reason_code` IS NOT NULL
          AND TRIM(`lose_reason_code`) <> ''
          AND `deleted` = b'0';
    END IF;

    IF ref_count > 0 THEN
        SET error_msg = CONCAT('Rollback failed: Found ', ref_count, ' business records referencing lose reason codes');
        SELECT CONCAT('ROLLBACK ABORTED: Found ', ref_count, ' business records referencing lose reason codes') AS rollback_status;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_msg;
    END IF;

    DELETE FROM `system_dict_data`
    WHERE `dict_type` = 'crm_business_lose_reason' AND `remark` = source_marker;
    DELETE FROM `system_dict_type`
    WHERE `type` = 'crm_business_lose_reason' AND `remark` = source_marker;

    SELECT 'ROLLBACK OK: Removed D2-MKT-01 dictionary rows created by this migration' AS rollback_status;
END$$

DELIMITER ;

CALL rollback_business_lose_reason_dict();

DROP PROCEDURE IF EXISTS rollback_business_lose_reason_dict;
