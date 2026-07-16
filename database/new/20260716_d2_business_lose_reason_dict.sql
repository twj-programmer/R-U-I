INSERT INTO `system_dict_type` (`name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`, `deleted_time`)
SELECT 'CRM 商机输单原因', 'crm_business_lose_reason', 0, 'CRM 商机输单原因', '1', NOW(), '1', NOW(), b'0', NULL
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_type` WHERE `type` = 'crm_business_lose_reason');

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 1, '竞品原因', 'COMPETITOR', 'crm_business_lose_reason', 0, '', '', '', '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'COMPETITOR');

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 2, '价格原因', 'PRICE', 'crm_business_lose_reason', 0, '', '', '', '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'PRICE');

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 3, '需求不匹配', 'REQUIREMENT_MISMATCH', 'crm_business_lose_reason', 0, '', '', '', '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'REQUIREMENT_MISMATCH');

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 4, '预算不足', 'BUDGET', 'crm_business_lose_reason', 0, '', '', '', '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'BUDGET');

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 5, '时机不符', 'TIMING', 'crm_business_lose_reason', 0, '', '', '', '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'TIMING');

INSERT INTO `system_dict_data` (`sort`, `label`, `value`, `dict_type`, `status`, `color_type`, `css_class`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
SELECT 6, '其他', 'OTHER', 'crm_business_lose_reason', 0, '', '', '', '1', NOW(), '1', NOW(), b'0'
WHERE NOT EXISTS (SELECT 1 FROM `system_dict_data` WHERE `dict_type` = 'crm_business_lose_reason' AND `value` = 'OTHER');
