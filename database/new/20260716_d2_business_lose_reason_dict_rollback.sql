DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS rollback_business_lose_reason_dict()
BEGIN
    DECLARE column_exists INT DEFAULT 0;
    DECLARE ref_count INT DEFAULT 0;

    SELECT COUNT(*) INTO column_exists
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'crm_business'
      AND COLUMN_NAME = 'lose_reason_code';

    IF column_exists > 0 THEN
        SELECT COUNT(*) INTO ref_count
        FROM `crm_business`
        WHERE `lose_reason_code` IN ('COMPETITOR', 'PRICE', 'REQUIREMENT_MISMATCH', 'BUDGET', 'TIMING', 'OTHER')
          AND `deleted` = 0;
    END IF;

    IF column_exists = 0 THEN
        SELECT 'ROLLBACK OK: Column lose_reason_code does not exist, safe to delete' AS rollback_status;
        DELETE FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason';
        DELETE FROM `system_dict_type` WHERE `type` = 'crm_business_lose_reason';
    ELSEIF ref_count = 0 THEN
        SELECT 'ROLLBACK OK: Column exists but no references found' AS rollback_status;
        DELETE FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason';
        DELETE FROM `system_dict_type` WHERE `type` = 'crm_business_lose_reason';
    ELSE
        SELECT CONCAT('ROLLBACK ABORTED: Found ', ref_count, ' business records referencing lose reason codes') AS rollback_status;
    END IF;
END$$

DELIMITER ;

CALL rollback_business_lose_reason_dict();

DROP PROCEDURE IF EXISTS rollback_business_lose_reason_dict;
