-- D2-CUS-01/D2-CUS-02：客户查重、负责人历史、公海记录权限回滚
-- 只删除由本迁移以 creator=D2-CUS-01/D2-CUS-02 创建的权限及其角色关联。
-- 若部署前已存在同名历史权限，正向迁移不会修改 creator，本脚本也不会删除它。

START TRANSACTION;

-- 1. 删除客户查重权限的角色关联和菜单
DELETE role_menu
  FROM `system_role_menu` AS role_menu
  INNER JOIN `system_menu` AS menu ON menu.`id` = role_menu.`menu_id`
 WHERE menu.`permission` = 'crm:customer:check-duplicate'
   AND menu.`creator` = 'D2-CUS-01';

DELETE FROM `system_menu`
 WHERE `permission` = 'crm:customer:check-duplicate'
   AND `creator` = 'D2-CUS-01';

-- 2. 删除负责人历史权限的角色关联和菜单
DELETE role_menu
  FROM `system_role_menu` AS role_menu
  INNER JOIN `system_menu` AS menu ON menu.`id` = role_menu.`menu_id`
 WHERE menu.`permission` = 'crm:customer-owner-history:query'
   AND menu.`creator` = 'D2-CUS-02';

DELETE FROM `system_menu`
 WHERE `permission` = 'crm:customer-owner-history:query'
   AND `creator` = 'D2-CUS-02';

-- 3. 删除公海记录权限的角色关联和菜单
DELETE role_menu
  FROM `system_role_menu` AS role_menu
  INNER JOIN `system_menu` AS menu ON menu.`id` = role_menu.`menu_id`
 WHERE menu.`permission` = 'crm:high-seas-record:query'
   AND menu.`creator` = 'D2-CUS-02';

DELETE FROM `system_menu`
 WHERE `permission` = 'crm:high-seas-record:query'
   AND `creator` = 'D2-CUS-02';

COMMIT;