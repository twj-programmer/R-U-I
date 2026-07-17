CREATE TABLE IF NOT EXISTS crm_customer
(
    id                 BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    name               VARCHAR(255) COMMENT '客户名称',
    follow_up_status   BOOLEAN DEFAULT FALSE COMMENT '跟进状态',
    contact_last_time  TIMESTAMP COMMENT '最后跟进时间',
    contact_last_content VARCHAR(255) COMMENT '最后跟进内容',
    contact_next_time  TIMESTAMP COMMENT '下次联系时间',
    owner_user_id      BIGINT COMMENT '负责人的用户编号',
    owner_time         TIMESTAMP NOT NULL COMMENT '成为负责人的时间',
    lock_status        BOOLEAN DEFAULT FALSE COMMENT '锁定状态',
    deal_status        BOOLEAN DEFAULT FALSE COMMENT '成交状态',
    mobile             VARCHAR(20) COMMENT '手机',
    telephone          VARCHAR(20) COMMENT '电话',
    qq                 VARCHAR(20) COMMENT 'QQ',
    wechat             VARCHAR(255) COMMENT '微信',
    email              VARCHAR(255) COMMENT '邮箱',
    area_id            BIGINT COMMENT '地区编号',
    detail_address     VARCHAR(255) COMMENT '详细地址',
    industry_id        INT COMMENT '所属行业',
    level              INT COMMENT '客户等级',
    source             INT COMMENT '客户来源',
    remark             VARCHAR(500) COMMENT '备注',
    creator            VARCHAR(64) NOT NULL DEFAULT '' COMMENT '创建者',
    create_time        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater            VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time        TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted            BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id          BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_clue
(
    id                 BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    name               VARCHAR(128) NOT NULL DEFAULT '' COMMENT '线索名称',
    follow_up_status   BOOLEAN DEFAULT FALSE COMMENT '跟进状态',
    contact_last_time  TIMESTAMP COMMENT '最后跟进时间',
    contact_last_content VARCHAR(255) COMMENT '最后跟进内容',
    contact_next_time  TIMESTAMP COMMENT '下次联系时间',
    owner_user_id      BIGINT NOT NULL COMMENT '负责人的用户编号',
    transform_status   BOOLEAN DEFAULT FALSE COMMENT '转化状态',
    customer_id        BIGINT COMMENT '客户编号',
    mobile             VARCHAR(20) COMMENT '手机号',
    telephone          VARCHAR(20) COMMENT '电话',
    qq                 VARCHAR(20) COMMENT 'QQ',
    wechat             VARCHAR(255) COMMENT '微信',
    email              VARCHAR(255) COMMENT '邮箱',
    area_id            BIGINT COMMENT '地区编号',
    detail_address     VARCHAR(255) COMMENT '详细地址',
    industry_id        INT COMMENT '所属行业',
    level              INT COMMENT '客户等级',
    source             INT COMMENT '客户来源',
    remark             VARCHAR(500) COMMENT '备注',
    creator            VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater            VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted            BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id          BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_business_status_type
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    name        VARCHAR(100) NOT NULL COMMENT '状态组名',
    dept_ids    VARCHAR(255) NOT NULL COMMENT '使用的部门编号',
    creator     VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater     VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    tenant_id   BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号',
    deleted     BOOLEAN DEFAULT FALSE COMMENT '是否删除'
);

CREATE TABLE IF NOT EXISTS crm_business_status
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    type_id     BIGINT NOT NULL COMMENT '状态类型编号',
    name        VARCHAR(100) NOT NULL COMMENT '状态类型名',
    percent     DECIMAL(24,6) NOT NULL COMMENT '赢单率',
    sort        INT NOT NULL DEFAULT 1 COMMENT '排序',
    creator     VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater     VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    tenant_id   BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号',
    deleted     BOOLEAN DEFAULT FALSE COMMENT '是否删除'
);

CREATE TABLE IF NOT EXISTS crm_business
(
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    name                VARCHAR(100) NOT NULL COMMENT '商机名称',
    customer_id         BIGINT NOT NULL COMMENT '客户编号',
    follow_up_status    BOOLEAN DEFAULT FALSE COMMENT '跟进状态',
    contact_last_time   TIMESTAMP COMMENT '最后跟进时间',
    contact_next_time   TIMESTAMP COMMENT '下次联系时间',
    owner_user_id       BIGINT COMMENT '负责人的用户编号',
    status_type_id      BIGINT COMMENT '商机状态类型编号',
    status_id           BIGINT COMMENT '商机状态编号',
    end_status          SMALLINT COMMENT '结束状态：1-赢单 2-输单 3-无效',
    deal_time           TIMESTAMP COMMENT '预计成交日期',
    total_product_price DECIMAL(24,6) COMMENT '产品总金额',
    discount_percent    DECIMAL(24,6) COMMENT '整单折扣',
    total_price         DECIMAL(24,6) COMMENT '商机总金额',
    remark              VARCHAR(500) COMMENT '备注',
    creator             VARCHAR(64) NOT NULL DEFAULT '' COMMENT '创建人',
    updater             VARCHAR(64) DEFAULT '' COMMENT '更新人',
    create_time         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time         TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    end_remark          VARCHAR(500) COMMENT '结束时的备注',
    deleted             BOOLEAN DEFAULT FALSE COMMENT '逻辑删除',
    tenant_id           BIGINT DEFAULT 0 COMMENT '租户ID'
);

CREATE TABLE IF NOT EXISTS crm_contract
(
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    name                VARCHAR(128) NOT NULL COMMENT '合同名称',
    no                  VARCHAR(128) NOT NULL COMMENT '合同编号',
    customer_id         BIGINT NOT NULL COMMENT '客户编号',
    business_id         BIGINT COMMENT '商机编号',
    contact_last_time   TIMESTAMP COMMENT '最后跟进时间',
    owner_user_id       BIGINT COMMENT '负责人的用户编号',
    process_instance_id VARCHAR(64) COMMENT '工作流编号',
    audit_status        SMALLINT NOT NULL DEFAULT 0 COMMENT '审批状态',
    order_date          TIMESTAMP COMMENT '下单日期',
    start_time          TIMESTAMP COMMENT '开始时间',
    end_time            TIMESTAMP COMMENT '结束时间',
    total_product_price DECIMAL(24,6) COMMENT '产品总金额',
    discount_percent    DECIMAL(24,6) COMMENT '整单折扣',
    total_price         DECIMAL(10,2) COMMENT '合同总金额',
    sign_contact_id     BIGINT COMMENT '联系人编号',
    sign_user_id        BIGINT COMMENT '公司签约人',
    remark              VARCHAR(500) COMMENT '备注',
    creator             VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater             VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted             BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id           BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_receivable
(
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    no                  VARCHAR(128) NOT NULL COMMENT '回款编号',
    plan_id             BIGINT COMMENT '回款计划编号',
    customer_id         BIGINT NOT NULL COMMENT '客户编号',
    contract_id         BIGINT NOT NULL COMMENT '合同编号',
    owner_user_id       BIGINT COMMENT '负责人编号',
    return_time         TIMESTAMP COMMENT '回款日期',
    return_type         INT COMMENT '回款方式',
    price               DECIMAL(24,6) COMMENT '计划回款金额',
    remark              VARCHAR(500) COMMENT '备注',
    process_instance_id VARCHAR(64) COMMENT '工作流编号',
    audit_status        SMALLINT NOT NULL DEFAULT 0 COMMENT '审批状态',
    creator             VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater             VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted             BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id           BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_contact
(
    id                 BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    name               VARCHAR(128) COMMENT '联系人名称',
    customer_id        BIGINT COMMENT '客户编号',
    contact_last_time  TIMESTAMP COMMENT '最后跟进时间',
    contact_last_content VARCHAR(255) COMMENT '最后跟进内容',
    contact_next_time  TIMESTAMP COMMENT '下次联系时间',
    owner_user_id      BIGINT COMMENT '负责人用户编号',
    mobile             VARCHAR(16) COMMENT '手机号',
    telephone          VARCHAR(16) COMMENT '电话',
    email              VARCHAR(128) COMMENT '电子邮箱',
    qq                 INT COMMENT 'QQ',
    wechat             VARCHAR(128) COMMENT '微信',
    area_id            BIGINT COMMENT '地区',
    detail_address     VARCHAR(256) COMMENT '地址',
    sex                INT COMMENT '性别',
    master             BOOLEAN COMMENT '是否关键决策人',
    parent_id          BIGINT COMMENT '直系上属',
    post               VARCHAR(32) COMMENT '职务',
    remark             VARCHAR(512) COMMENT '备注',
    creator            VARCHAR(64) COMMENT '创建人',
    create_time        TIMESTAMP COMMENT '创建时间',
    updater            VARCHAR(64) COMMENT '更新人',
    update_time        TIMESTAMP COMMENT '更新时间',
    deleted            BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id          BIGINT COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_follow_up_record
(
    id            BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    biz_type      INT COMMENT '数据类型',
    biz_id        BIGINT COMMENT '数据编号',
    type          INT COMMENT '跟进类型',
    content       VARCHAR(512) DEFAULT '' COMMENT '跟进内容',
    next_time     TIMESTAMP COMMENT '下次联系时间',
    pic_urls      VARCHAR(1024) COMMENT '图片',
    file_urls     VARCHAR(1024) COMMENT '附件',
    business_ids  VARCHAR(255) DEFAULT '' COMMENT '关联的商机编号数组',
    contact_ids   VARCHAR(255) DEFAULT '' COMMENT '关联的联系人编号数组',
    creator       VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater       VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted       BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id     BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_customer_pool_config
(
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    enabled             SMALLINT NOT NULL COMMENT '是否启用客户公海',
    contact_expire_days INT COMMENT '未跟进放入公海天数',
    deal_expire_days    INT COMMENT '未成交放入公海天数',
      notify_enabled      SMALLINT COMMENT '是否开启提前提醒',
      notify_days         INT COMMENT '提前提醒天数',
      receive_limit_per_day INT COMMENT '每用户每日领取上限',
      receive_cooldown_days INT COMMENT '同一客户重复领取冷却天数',
      creator             VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater             VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted             BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id           BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_customer_limit_config
(
    id              BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    type            INT NOT NULL COMMENT '规则类型',
    user_ids        VARCHAR(2048) DEFAULT '' COMMENT '规则适用人群',
    dept_ids        VARCHAR(2048) DEFAULT '' COMMENT '规则适用部门',
    max_count       INT NOT NULL COMMENT '数量上限',
    deal_count_enabled SMALLINT COMMENT '成交客户是否占有拥有客户数',
    creator         VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater         VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted         BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id       BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_contact_business
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    contact_id  BIGINT COMMENT '联系人编号',
    business_id BIGINT COMMENT '商机编号',
    creator     VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater     VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted     BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id   BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_business_product
(
    id             BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    business_id    BIGINT COMMENT '商机编号',
    product_id     BIGINT COMMENT '产品编号',
    product_price  DECIMAL(24,6) COMMENT '产品单价',
    business_price DECIMAL(24,6) COMMENT '商机价格',
    count          DECIMAL(24,6) COMMENT '数量',
    total_price    DECIMAL(24,6) COMMENT '总计价格',
    creator        VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater        VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted        BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id      BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_contract_product
(
    id             BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    contract_id    BIGINT COMMENT '合同编号',
    product_id     BIGINT COMMENT '产品编号',
    product_price  DECIMAL(24,6) COMMENT '产品单价',
    contract_price DECIMAL(24,6) COMMENT '合同价格',
    count          DECIMAL(24,6) COMMENT '数量',
    total_price    DECIMAL(24,6) COMMENT '总计价格',
    creator        VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater        VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted        BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id      BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_receivable_plan
(
    id            BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    period        INT COMMENT '期数',
    customer_id   BIGINT COMMENT '客户编号',
    contract_id   BIGINT COMMENT '合同编号',
    owner_user_id BIGINT COMMENT '负责人编号',
    return_time   TIMESTAMP COMMENT '计划回款日期',
    return_type   INT COMMENT '计划回款类型',
    price         DECIMAL(24,6) COMMENT '计划回款金额',
    receivable_id BIGINT COMMENT '回款编号',
    remind_days   INT COMMENT '提前几天提醒',
    remind_time   TIMESTAMP COMMENT '提醒日期',
    remark        VARCHAR(500) COMMENT '备注',
    creator       VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater       VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted       BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id     BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_product_category
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '分类编号',
    name        VARCHAR(100) COMMENT '分类名称',
    parent_id   BIGINT COMMENT '父级编号',
    creator     VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater     VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted     BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id   BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_product
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    name        VARCHAR(255) COMMENT '产品名称',
    no          VARCHAR(128) COMMENT '产品编码',
    unit        INT COMMENT '单位',
    price       DECIMAL(24,6) COMMENT '价格',
    status      INT COMMENT '状态',
    category_id BIGINT COMMENT '产品分类ID',
    description VARCHAR(500) COMMENT '产品描述',
    owner_user_id BIGINT COMMENT '负责人的用户编号',
    creator     VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater     VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted     BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id   BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);

CREATE TABLE IF NOT EXISTS crm_permission
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '编号',
    biz_type    INT COMMENT '数据类型',
    biz_id      BIGINT COMMENT '数据编号',
    user_id     BIGINT COMMENT '用户编号',
    level       INT COMMENT '权限级别',
    creator     VARCHAR(64) DEFAULT '' COMMENT '创建者',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updater     VARCHAR(64) DEFAULT '' COMMENT '更新者',
    update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted     BOOLEAN DEFAULT FALSE COMMENT '是否删除',
    tenant_id   BIGINT NOT NULL DEFAULT 0 COMMENT '租户编号'
);
