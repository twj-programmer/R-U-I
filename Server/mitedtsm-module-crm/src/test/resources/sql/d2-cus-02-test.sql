CREATE TABLE IF NOT EXISTS crm_high_seas_record (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tenant_id BIGINT NOT NULL DEFAULT 0,
    customer_id BIGINT NOT NULL,
    action_type VARCHAR(32) NOT NULL,
    before_owner_user_id BIGINT,
    after_owner_user_id BIGINT,
    reason VARCHAR(500),
    operator_user_id BIGINT NOT NULL,
    action_time TIMESTAMP NOT NULL,
    creator VARCHAR(64) DEFAULT '',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater VARCHAR(64) DEFAULT '',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS crm_customer_owner_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tenant_id BIGINT NOT NULL DEFAULT 0,
    customer_id BIGINT NOT NULL,
    change_type VARCHAR(32) NOT NULL,
    old_owner_user_id BIGINT,
    new_owner_user_id BIGINT,
    reason VARCHAR(500),
    operator_user_id BIGINT NOT NULL,
    change_time TIMESTAMP NOT NULL,
    creator VARCHAR(64) DEFAULT '',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater VARCHAR(64) DEFAULT '',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted BOOLEAN DEFAULT FALSE
);

DELETE FROM crm_high_seas_record;
DELETE FROM crm_customer_owner_history;
