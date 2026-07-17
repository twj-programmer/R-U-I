-- D2-CUS-02 rollback. Remove only this migration's menus and tables.
START TRANSACTION;
DELETE role_menu FROM `system_role_menu` AS role_menu
 INNER JOIN `system_menu` AS menu ON menu.`id` = role_menu.`menu_id`
 WHERE menu.`creator` = 'D2-CUS-02'
   AND menu.`permission` IN ('crm:high-seas-record:query', 'crm:customer-owner-history:query');
DELETE FROM `system_menu`
 WHERE `creator` = 'D2-CUS-02'
   AND `permission` IN ('crm:high-seas-record:query', 'crm:customer-owner-history:query');
COMMIT;
DROP TABLE IF EXISTS `crm_customer_owner_history`;
DROP TABLE IF EXISTS `crm_high_seas_record`;
