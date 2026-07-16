INSERT INTO `system_permission` (`id`, `name`, `code`, `type`, `sort`, `status`, `tenant_id`, `deleted`, `create_time`, `update_time`, `creator`, `updater`)
VALUES
    (NULL, '客户查重', 'crm:customer:check-duplicate', 1, 100, 1, NULL, 0, NOW(), NOW(), 'system', 'system'),
    (NULL, '客户归属历史查询', 'crm:customer-owner-history:query', 1, 101, 1, NULL, 0, NOW(), NOW(), 'system', 'system'),
    (NULL, '公海记录查询', 'crm:customer-high-seas-record:query', 1, 102, 1, NULL, 0, NOW(), NOW(), 'system', 'system');