SET @ref_count = 0;
SET @column_exists = 0;

SELECT COUNT(*) INTO @column_exists
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'crm_business'
  AND COLUMN_NAME = 'lose_reason_code';

IF @column_exists > 0 THEN
    SELECT COUNT(*) INTO @ref_count
    FROM `crm_business`
    WHERE `lose_reason_code` IN ('COMPETITOR', 'PRICE', 'REQUIREMENT_MISMATCH', 'BUDGET', 'TIMING', 'OTHER')
      AND `deleted` = 0;
END IF;

SELECT IF(@ref_count > 0,
    CONCAT('ROLLBACK ABORTED: Found ', @ref_count, ' business records referencing lose reason codes'),
    'ROLLBACK OK: No references found'
) AS rollback_status;

DELETE FROM `system_dict_data`
WHERE `dict_type` = 'crm_business_lose_reason'
  AND @ref_count = 0;

DELETE FROM `system_dict_type`
WHERE `type` = 'crm_business_lose_reason'
  AND @ref_count = 0;
