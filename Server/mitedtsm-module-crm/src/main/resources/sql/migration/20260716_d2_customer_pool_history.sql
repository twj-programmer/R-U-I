CREATE TABLE IF NOT EXISTS `crm_high_seas_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '编号',
    `customer_id` BIGINT NOT NULL COMMENT '客户编号',
    `action_type` VARCHAR(32) NOT NULL COMMENT '操作类型：MANUAL_PUT-手动移入公海，AUTO_PUT-自动移入公海，RECEIVE-领取公海客户，ASSIGN-分配，TRANSFER-转移',
    `before_owner_user_id` BIGINT NULL COMMENT '移入前负责人用户编号',
    `after_owner_user_id` BIGINT NULL COMMENT '移入后负责人用户编号',
    `reason` VARCHAR(500) NULL COMMENT '原因',
    `operator_user_id` BIGINT NOT NULL COMMENT '操作人用户编号，0表示系统',
    `action_time` DATETIME NOT NULL COMMENT '操作时间',
    `tenant_id` BIGINT NOT NULL COMMENT '租户编号',
    `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '是否删除',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_time` DATETIME NOT NULL COMMENT '更新时间',
    `creator` VARCHAR(64) NULL COMMENT '创建者',
    `updater` VARCHAR(64) NULL COMMENT '更新者',
    PRIMARY KEY (`id`),
    INDEX `idx_tenant_customer_time` (`tenant_id`, `customer_id`, `action_time`),
    INDEX `idx_tenant_operator_time` (`tenant_id`, `operator_user_id`, `action_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公海记录表';

CREATE TABLE IF NOT EXISTS `crm_customer_owner_history` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '编号',
    `customer_id` BIGINT NOT NULL COMMENT '客户编号',
    `change_type` VARCHAR(32) NOT NULL COMMENT '变更类型：RECEIVE-领取，ASSIGN-分配，TRANSFER-转移，PUT_POOL-移入公海',
    `before_owner_user_id` BIGINT NULL COMMENT '变更前负责人用户编号',
    `after_owner_user_id` BIGINT NULL COMMENT '变更后负责人用户编号',
    `reason` VARCHAR(500) NULL COMMENT '原因',
    `operator_user_id` BIGINT NOT NULL COMMENT '操作人用户编号，0表示系统',
    `change_time` DATETIME NOT NULL COMMENT '变更时间',
    `tenant_id` BIGINT NOT NULL COMMENT '租户编号',
    `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '是否删除',
    `create_time` DATETIME NOT NULL COMMENT '创建时间',
    `update_time` DATETIME NOT NULL COMMENT '更新时间',
    `creator` VARCHAR(64) NULL COMMENT '创建者',
    `updater` VARCHAR(64) NULL COMMENT '更新者',
    PRIMARY KEY (`id`),
    INDEX `idx_tenant_customer_time` (`tenant_id`, `customer_id`, `change_time`),
    INDEX `idx_tenant_operator_time` (`tenant_id`, `operator_user_id`, `change_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户归属历史表';