-- D2-STAT-01：客户转化明细导出权限回滚
-- 只删除由本迁移以 creator=D2-STAT-01 创建的权限及其角色关联。
-- 若部署前已存在同名历史权限，正向迁移不会修改 creator，本脚本也不会删除它。

START TRANSACTION;

DELETE role_menu
  FROM `system_role_menu` AS role_menu
  INNER JOIN `system_menu` AS menu ON menu.`id` = role_menu.`menu_id`
 WHERE menu.`permission` = 'crm:statistics-customer:export'
   AND menu.`creator` = 'D2-STAT-01';

DELETE FROM `system_menu`
 WHERE `permission` = 'crm:statistics-customer:export'
   AND `creator` = 'D2-STAT-01';

COMMIT;
