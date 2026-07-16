-- 只回滚由 D2-CUS-01 本次迁移创建的客户查重权限及角色关联。

START TRANSACTION;

DELETE role_menu
  FROM `system_role_menu` AS role_menu
  INNER JOIN `system_menu` AS menu ON menu.`id` = role_menu.`menu_id`
 WHERE menu.`permission` = 'crm:customer:check-duplicate'
   AND menu.`creator` = 'D2-CUS-01';

DELETE FROM `system_menu`
 WHERE `permission` = 'crm:customer:check-duplicate'
   AND `creator` = 'D2-CUS-01';

COMMIT;
