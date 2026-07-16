SELECT 
    IF(
        (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
         WHERE TABLE_SCHEMA = DATABASE() 
           AND TABLE_NAME = 'crm_business' 
           AND COLUMN_NAME = 'lose_reason_code') > 0 
        AND 
        (SELECT COUNT(*) FROM `crm_business` 
         WHERE `lose_reason_code` IN ('COMPETITOR', 'PRICE', 'REQUIREMENT_MISMATCH', 'BUDGET', 'TIMING', 'OTHER') 
           AND `deleted` = 0) > 0,
        CONCAT('ROLLBACK ABORTED: Found ', 
               (SELECT COUNT(*) FROM `crm_business` 
                WHERE `lose_reason_code` IN ('COMPETITOR', 'PRICE', 'REQUIREMENT_MISMATCH', 'BUDGET', 'TIMING', 'OTHER') 
                  AND `deleted` = 0), 
               ' business records referencing lose reason codes'),
        'ROLLBACK OK: No references found'
    ) AS rollback_status;

DELETE FROM `system_dict_data`
WHERE `dict_type` = 'crm_business_lose_reason'
  AND NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'crm_business' 
      AND COLUMN_NAME = 'lose_reason_code'
  )
  OR NOT EXISTS (
    SELECT 1 FROM `crm_business` 
    WHERE `lose_reason_code` IN ('COMPETITOR', 'PRICE', 'REQUIREMENT_MISMATCH', 'BUDGET', 'TIMING', 'OTHER') 
      AND `deleted` = 0
  );

DELETE FROM `system_dict_type`
WHERE `type` = 'crm_business_lose_reason'
  AND NOT EXISTS (
    SELECT 1 FROM `system_dict_data` 
    WHERE `dict_type` = 'crm_business_lose_reason'
  );
