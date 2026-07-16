DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS rollback_business_lose_reason_dict()
BEGIN
    DECLARE column_exists INT DEFAULT 0;
    DECLARE ref_count INT DEFAULT 0;
    DECLARE error_msg VARCHAR(255);

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

    IF column_exists = 0 THEN
        SELECT 'ROLLBACK OK: Column lose_reason_code does not exist, safe to delete' AS rollback_status;
        DELETE FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason';
        DELETE FROM `system_dict_type` WHERE `type` = 'crm_business_lose_reason';
    ELSEIF ref_count = 0 THEN
        SELECT 'ROLLBACK OK: Column exists but no references found' AS rollback_status;
        DELETE FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason';
        DELETE FROM `system_dict_type` WHERE `type` = 'crm_business_lose_reason';
    ELSE
        SET error_msg = CONCAT('Rollback failed: Found ', ref_count, ' business records referencing lose reason codes');
        SELECT CONCAT('ROLLBACK ABORTED: Found ', ref_count, ' business records referencing lose reason codes') AS rollback_status;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_msg;
    END IF;
END$$

DELIMITER ;

CALL rollback_business_lose_reason_dict();

DROP PROCEDURE IF EXISTS rollback_business_lose_reason_dict;
