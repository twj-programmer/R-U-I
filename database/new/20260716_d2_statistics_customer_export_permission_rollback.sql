-- D2-STAT-01：客户转化明细导出权限回滚
-- 只删除 crm:statistics-customer:export 及其角色关联，不删除已有统计菜单或业务数据。

START TRANSACTION;

DELETE role_menu
  FROM `system_role_menu` AS role_menu
  INNER JOIN `system_menu` AS menu ON menu.`id` = role_menu.`menu_id`
 WHERE menu.`permission` = 'crm:statistics-customer:export';

DELETE FROM `system_menu`
 WHERE `permission` = 'crm:statistics-customer:export';

COMMIT;
