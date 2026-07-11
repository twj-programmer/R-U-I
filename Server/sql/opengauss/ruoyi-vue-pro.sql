/*
 Mitedtsm Database Transfer Tool

 Source Server Type    : MySQL

 Target Server Type    : OpenGauss

 Date: 2025-05-22 21:40:02
*/


-- ----------------------------
-- Table structure for dual
-- ----------------------------
DROP TABLE IF EXISTS dual;
CREATE TABLE dual
(
    id int2
);

COMMENT ON TABLE dual IS '数据库连接的表';

-- ----------------------------
-- Records of dual
-- ----------------------------
-- @formatter:off
INSERT INTO dual VALUES (1);
-- @formatter:on

-- ----------------------------
-- Table structure for infra_api_access_log
-- ----------------------------
DROP TABLE IF EXISTS infra_api_access_log;
CREATE TABLE infra_api_access_log
(
    id               int8         NOT NULL,
    trace_id         varchar(64)  NULL     DEFAULT '',
    user_id          int8         NOT NULL DEFAULT 0,
    user_type        int2         NOT NULL DEFAULT 0,
    application_name varchar(50)  NOT NULL,
    request_method   varchar(16)  NULL     DEFAULT '',
    request_url      varchar(255) NULL     DEFAULT '',
    request_params   text         NULL,
    response_body    text         NULL,
    user_ip          varchar(50)  NOT NULL,
    user_agent       varchar(512) NOT NULL,
    operate_module   varchar(50)  NULL     DEFAULT NULL,
    operate_name     varchar(50)  NULL     DEFAULT NULL,
    operate_type     int2         NULL     DEFAULT 0,
    begin_time       timestamp    NOT NULL,
    end_time         timestamp    NOT NULL,
    duration         int4         NOT NULL,
    result_code      int4         NOT NULL DEFAULT 0,
    result_msg       varchar(512) NULL     DEFAULT '',
    creator          varchar(64)  NULL     DEFAULT '',
    create_time      timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater          varchar(64)  NULL     DEFAULT '',
    update_time      timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted          int2         NOT NULL DEFAULT 0,
    tenant_id        int8         NOT NULL DEFAULT 0
);

ALTER TABLE infra_api_access_log
    ADD CONSTRAINT pk_infra_api_access_log PRIMARY KEY (id);

CREATE INDEX idx_infra_api_access_log_01 ON infra_api_access_log (create_time);

COMMENT ON COLUMN infra_api_access_log.id IS '日志主键';
COMMENT ON COLUMN infra_api_access_log.trace_id IS '链路追踪编号';
COMMENT ON COLUMN infra_api_access_log.user_id IS '用户编号';
COMMENT ON COLUMN infra_api_access_log.user_type IS '用户类型';
COMMENT ON COLUMN infra_api_access_log.application_name IS '应用名';
COMMENT ON COLUMN infra_api_access_log.request_method IS '请求方法名';
COMMENT ON COLUMN infra_api_access_log.request_url IS '请求地址';
COMMENT ON COLUMN infra_api_access_log.request_params IS '请求参数';
COMMENT ON COLUMN infra_api_access_log.response_body IS '响应结果';
COMMENT ON COLUMN infra_api_access_log.user_ip IS '用户 IP';
COMMENT ON COLUMN infra_api_access_log.user_agent IS '浏览器 UA';
COMMENT ON COLUMN infra_api_access_log.operate_module IS '操作模块';
COMMENT ON COLUMN infra_api_access_log.operate_name IS '操作名';
COMMENT ON COLUMN infra_api_access_log.operate_type IS '操作分类';
COMMENT ON COLUMN infra_api_access_log.begin_time IS '开始请求时间';
COMMENT ON COLUMN infra_api_access_log.end_time IS '结束请求时间';
COMMENT ON COLUMN infra_api_access_log.duration IS '执行时长';
COMMENT ON COLUMN infra_api_access_log.result_code IS '结果码';
COMMENT ON COLUMN infra_api_access_log.result_msg IS '结果提示';
COMMENT ON COLUMN infra_api_access_log.creator IS '创建者';
COMMENT ON COLUMN infra_api_access_log.create_time IS '创建时间';
COMMENT ON COLUMN infra_api_access_log.updater IS '更新者';
COMMENT ON COLUMN infra_api_access_log.update_time IS '更新时间';
COMMENT ON COLUMN infra_api_access_log.deleted IS '是否删除';
COMMENT ON COLUMN infra_api_access_log.tenant_id IS '租户编号';
COMMENT ON TABLE infra_api_access_log IS 'API 访问日志表';

DROP SEQUENCE IF EXISTS infra_api_access_log_seq;
CREATE SEQUENCE infra_api_access_log_seq
    START 1;

-- ----------------------------
-- Table structure for infra_api_error_log
-- ----------------------------
DROP TABLE IF EXISTS infra_api_error_log;
CREATE TABLE infra_api_error_log
(
    id                           int8          NOT NULL,
    trace_id                     varchar(64)   NOT NULL,
    user_id                      int8          NOT NULL DEFAULT 0,
    user_type                    int2          NOT NULL DEFAULT 0,
    application_name             varchar(50)   NOT NULL,
    request_method               varchar(16)   NOT NULL,
    request_url                  varchar(255)  NOT NULL,
    request_params               varchar(8000) NOT NULL,
    user_ip                      varchar(50)   NOT NULL,
    user_agent                   varchar(512)  NOT NULL,
    exception_time               timestamp     NOT NULL,
    exception_name               varchar(128)  NULL     DEFAULT '',
    exception_message            text          NULL,
    exception_root_cause_message text          NULL,
    exception_stack_trace        text          NULL,
    exception_class_name         varchar(512)  NOT NULL,
    exception_file_name          varchar(512)  NOT NULL,
    exception_method_name        varchar(512)  NOT NULL,
    exception_line_number        int4          NOT NULL,
    process_status               int2          NOT NULL,
    process_time                 timestamp     NULL     DEFAULT NULL,
    process_user_id              int4          NULL     DEFAULT 0,
    creator                      varchar(64)   NULL     DEFAULT '',
    create_time                  timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater                      varchar(64)   NULL     DEFAULT '',
    update_time                  timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted                      int2          NOT NULL DEFAULT 0,
    tenant_id                    int8          NOT NULL DEFAULT 0
);

ALTER TABLE infra_api_error_log
    ADD CONSTRAINT pk_infra_api_error_log PRIMARY KEY (id);

COMMENT ON COLUMN infra_api_error_log.id IS '编号';
COMMENT ON COLUMN infra_api_error_log.trace_id IS '链路追踪编号';
COMMENT ON COLUMN infra_api_error_log.user_id IS '用户编号';
COMMENT ON COLUMN infra_api_error_log.user_type IS '用户类型';
COMMENT ON COLUMN infra_api_error_log.application_name IS '应用名';
COMMENT ON COLUMN infra_api_error_log.request_method IS '请求方法名';
COMMENT ON COLUMN infra_api_error_log.request_url IS '请求地址';
COMMENT ON COLUMN infra_api_error_log.request_params IS '请求参数';
COMMENT ON COLUMN infra_api_error_log.user_ip IS '用户 IP';
COMMENT ON COLUMN infra_api_error_log.user_agent IS '浏览器 UA';
COMMENT ON COLUMN infra_api_error_log.exception_time IS '异常发生时间';
COMMENT ON COLUMN infra_api_error_log.exception_name IS '异常名';
COMMENT ON COLUMN infra_api_error_log.exception_message IS '异常导致的消息';
COMMENT ON COLUMN infra_api_error_log.exception_root_cause_message IS '异常导致的根消息';
COMMENT ON COLUMN infra_api_error_log.exception_stack_trace IS '异常的栈轨迹';
COMMENT ON COLUMN infra_api_error_log.exception_class_name IS '异常发生的类全名';
COMMENT ON COLUMN infra_api_error_log.exception_file_name IS '异常发生的类文件';
COMMENT ON COLUMN infra_api_error_log.exception_method_name IS '异常发生的方法名';
COMMENT ON COLUMN infra_api_error_log.exception_line_number IS '异常发生的方法所在行';
COMMENT ON COLUMN infra_api_error_log.process_status IS '处理状态';
COMMENT ON COLUMN infra_api_error_log.process_time IS '处理时间';
COMMENT ON COLUMN infra_api_error_log.process_user_id IS '处理用户编号';
COMMENT ON COLUMN infra_api_error_log.creator IS '创建者';
COMMENT ON COLUMN infra_api_error_log.create_time IS '创建时间';
COMMENT ON COLUMN infra_api_error_log.updater IS '更新者';
COMMENT ON COLUMN infra_api_error_log.update_time IS '更新时间';
COMMENT ON COLUMN infra_api_error_log.deleted IS '是否删除';
COMMENT ON COLUMN infra_api_error_log.tenant_id IS '租户编号';
COMMENT ON TABLE infra_api_error_log IS '系统异常日志';

DROP SEQUENCE IF EXISTS infra_api_error_log_seq;
CREATE SEQUENCE infra_api_error_log_seq
    START 1;

-- ----------------------------
-- Table structure for infra_codegen_column
-- ----------------------------
DROP TABLE IF EXISTS infra_codegen_column;
CREATE TABLE infra_codegen_column
(
    id                       int8         NOT NULL,
    table_id                 int8         NOT NULL,
    column_name              varchar(200) NOT NULL,
    data_type                varchar(100) NOT NULL,
    column_comment           varchar(500) NOT NULL,
    nullable                 bool         NOT NULL,
    primary_key              bool         NOT NULL,
    ordinal_position         int4         NOT NULL,
    java_type                varchar(32)  NOT NULL,
    java_field               varchar(64)  NOT NULL,
    dict_type                varchar(200) NULL     DEFAULT '',
    example                  varchar(64)  NULL     DEFAULT NULL,
    create_operation         bool         NOT NULL,
    update_operation         bool         NOT NULL,
    list_operation           bool         NOT NULL,
    list_operation_condition varchar(32)  NOT NULL DEFAULT '=',
    list_operation_result    bool         NOT NULL,
    html_type                varchar(32)  NOT NULL,
    creator                  varchar(64)  NULL     DEFAULT '',
    create_time              timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater                  varchar(64)  NULL     DEFAULT '',
    update_time              timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted                  int2         NOT NULL DEFAULT 0
);

ALTER TABLE infra_codegen_column
    ADD CONSTRAINT pk_infra_codegen_column PRIMARY KEY (id);

COMMENT ON COLUMN infra_codegen_column.id IS '编号';
COMMENT ON COLUMN infra_codegen_column.table_id IS '表编号';
COMMENT ON COLUMN infra_codegen_column.column_name IS '字段名';
COMMENT ON COLUMN infra_codegen_column.data_type IS '字段类型';
COMMENT ON COLUMN infra_codegen_column.column_comment IS '字段描述';
COMMENT ON COLUMN infra_codegen_column.nullable IS '是否允许为空';
COMMENT ON COLUMN infra_codegen_column.primary_key IS '是否主键';
COMMENT ON COLUMN infra_codegen_column.ordinal_position IS '排序';
COMMENT ON COLUMN infra_codegen_column.java_type IS 'Java 属性类型';
COMMENT ON COLUMN infra_codegen_column.java_field IS 'Java 属性名';
COMMENT ON COLUMN infra_codegen_column.dict_type IS '字典类型';
COMMENT ON COLUMN infra_codegen_column.example IS '数据示例';
COMMENT ON COLUMN infra_codegen_column.create_operation IS '是否为 Create 创建操作的字段';
COMMENT ON COLUMN infra_codegen_column.update_operation IS '是否为 Update 更新操作的字段';
COMMENT ON COLUMN infra_codegen_column.list_operation IS '是否为 List 查询操作的字段';
COMMENT ON COLUMN infra_codegen_column.list_operation_condition IS 'List 查询操作的条件类型';
COMMENT ON COLUMN infra_codegen_column.list_operation_result IS '是否为 List 查询操作的返回字段';
COMMENT ON COLUMN infra_codegen_column.html_type IS '显示类型';
COMMENT ON COLUMN infra_codegen_column.creator IS '创建者';
COMMENT ON COLUMN infra_codegen_column.create_time IS '创建时间';
COMMENT ON COLUMN infra_codegen_column.updater IS '更新者';
COMMENT ON COLUMN infra_codegen_column.update_time IS '更新时间';
COMMENT ON COLUMN infra_codegen_column.deleted IS '是否删除';
COMMENT ON TABLE infra_codegen_column IS '代码生成表字段定义';

DROP SEQUENCE IF EXISTS infra_codegen_column_seq;
CREATE SEQUENCE infra_codegen_column_seq
    START 1;

-- ----------------------------
-- Table structure for infra_codegen_table
-- ----------------------------
DROP TABLE IF EXISTS infra_codegen_table;
CREATE TABLE infra_codegen_table
(
    id                    int8         NOT NULL,
    data_source_config_id int8         NOT NULL,
    scene                 int2         NOT NULL DEFAULT 1,
    table_name            varchar(200) NULL     DEFAULT '',
    table_comment         varchar(500) NULL     DEFAULT '',
    remark                varchar(500) NULL     DEFAULT NULL,
    module_name           varchar(30)  NOT NULL,
    business_name         varchar(30)  NOT NULL,
    class_name            varchar(100) NULL     DEFAULT '',
    class_comment         varchar(50)  NOT NULL,
    author                varchar(50)  NOT NULL,
    template_type         int2         NOT NULL DEFAULT 1,
    front_type            int2         NOT NULL,
    parent_menu_id        int8         NULL     DEFAULT NULL,
    master_table_id       int8         NULL     DEFAULT NULL,
    sub_join_column_id    int8         NULL     DEFAULT NULL,
    sub_join_many         bool         NULL     DEFAULT NULL,
    tree_parent_column_id int8         NULL     DEFAULT NULL,
    tree_name_column_id   int8         NULL     DEFAULT NULL,
    creator               varchar(64)  NULL     DEFAULT '',
    create_time           timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater               varchar(64)  NULL     DEFAULT '',
    update_time           timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted               int2         NOT NULL DEFAULT 0
);

ALTER TABLE infra_codegen_table
    ADD CONSTRAINT pk_infra_codegen_table PRIMARY KEY (id);

COMMENT ON COLUMN infra_codegen_table.id IS '编号';
COMMENT ON COLUMN infra_codegen_table.data_source_config_id IS '数据源配置的编号';
COMMENT ON COLUMN infra_codegen_table.scene IS '生成场景';
COMMENT ON COLUMN infra_codegen_table.table_name IS '表名称';
COMMENT ON COLUMN infra_codegen_table.table_comment IS '表描述';
COMMENT ON COLUMN infra_codegen_table.remark IS '备注';
COMMENT ON COLUMN infra_codegen_table.module_name IS '模块名';
COMMENT ON COLUMN infra_codegen_table.business_name IS '业务名';
COMMENT ON COLUMN infra_codegen_table.class_name IS '类名称';
COMMENT ON COLUMN infra_codegen_table.class_comment IS '类描述';
COMMENT ON COLUMN infra_codegen_table.author IS '作者';
COMMENT ON COLUMN infra_codegen_table.template_type IS '模板类型';
COMMENT ON COLUMN infra_codegen_table.front_type IS '前端类型';
COMMENT ON COLUMN infra_codegen_table.parent_menu_id IS '父菜单编号';
COMMENT ON COLUMN infra_codegen_table.master_table_id IS '主表的编号';
COMMENT ON COLUMN infra_codegen_table.sub_join_column_id IS '子表关联主表的字段编号';
COMMENT ON COLUMN infra_codegen_table.sub_join_many IS '主表与子表是否一对多';
COMMENT ON COLUMN infra_codegen_table.tree_parent_column_id IS '树表的父字段编号';
COMMENT ON COLUMN infra_codegen_table.tree_name_column_id IS '树表的名字字段编号';
COMMENT ON COLUMN infra_codegen_table.creator IS '创建者';
COMMENT ON COLUMN infra_codegen_table.create_time IS '创建时间';
COMMENT ON COLUMN infra_codegen_table.updater IS '更新者';
COMMENT ON COLUMN infra_codegen_table.update_time IS '更新时间';
COMMENT ON COLUMN infra_codegen_table.deleted IS '是否删除';
COMMENT ON TABLE infra_codegen_table IS '代码生成表定义';

DROP SEQUENCE IF EXISTS infra_codegen_table_seq;
CREATE SEQUENCE infra_codegen_table_seq
    START 1;

-- ----------------------------
-- Table structure for infra_config
-- ----------------------------
DROP TABLE IF EXISTS infra_config;
CREATE TABLE infra_config
(
    id          int8         NOT NULL,
    category    varchar(50)  NOT NULL,
    type        int2         NOT NULL,
    name        varchar(100) NULL     DEFAULT '',
    config_key  varchar(100) NULL     DEFAULT '',
    value       varchar(500) NULL     DEFAULT '',
    visible     bool         NOT NULL,
    remark      varchar(500) NULL     DEFAULT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0
);

ALTER TABLE infra_config
    ADD CONSTRAINT pk_infra_config PRIMARY KEY (id);

COMMENT ON COLUMN infra_config.id IS '参数主键';
COMMENT ON COLUMN infra_config.category IS '参数分组';
COMMENT ON COLUMN infra_config.type IS '参数类型';
COMMENT ON COLUMN infra_config.name IS '参数名称';
COMMENT ON COLUMN infra_config.config_key IS '参数键名';
COMMENT ON COLUMN infra_config.value IS '参数键值';
COMMENT ON COLUMN infra_config.visible IS '是否可见';
COMMENT ON COLUMN infra_config.remark IS '备注';
COMMENT ON COLUMN infra_config.creator IS '创建者';
COMMENT ON COLUMN infra_config.create_time IS '创建时间';
COMMENT ON COLUMN infra_config.updater IS '更新者';
COMMENT ON COLUMN infra_config.update_time IS '更新时间';
COMMENT ON COLUMN infra_config.deleted IS '是否删除';
COMMENT ON TABLE infra_config IS '参数配置表';

-- ----------------------------
-- Records of infra_config
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO infra_config (id, category, type, name, config_key, value, visible, remark, creator, create_time, updater, update_time, deleted) VALUES (2, 'biz', 1, '用户管理-账号初始密码', 'system.user.init-password', '123456', '0', '初始化密码 123456', 'admin', '2021-01-05 17:03:48', '1', '2024-07-20 17:22:47', '0');
INSERT INTO infra_config (id, category, type, name, config_key, value, visible, remark, creator, create_time, updater, update_time, deleted) VALUES (7, 'url', 2, 'MySQL 监控的地址', 'url.druid', '', '1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:33:38', '0');
INSERT INTO infra_config (id, category, type, name, config_key, value, visible, remark, creator, create_time, updater, update_time, deleted) VALUES (8, 'url', 2, 'SkyWalking 监控的地址', 'url.skywalking', '', '1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:57:03', '0');
INSERT INTO infra_config (id, category, type, name, config_key, value, visible, remark, creator, create_time, updater, update_time, deleted) VALUES (9, 'url', 2, 'Spring Boot Admin 监控的地址', 'url.spring-boot-admin', '', '1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:52:07', '0');
INSERT INTO infra_config (id, category, type, name, config_key, value, visible, remark, creator, create_time, updater, update_time, deleted) VALUES (10, 'url', 2, 'Swagger 接口文档的地址', 'url.swagger', '', '1', '', '1', '2023-04-07 13:41:16', '1', '2023-04-07 14:59:00', '0');
INSERT INTO infra_config (id, category, type, name, config_key, value, visible, remark, creator, create_time, updater, update_time, deleted) VALUES (11, 'ui', 2, '腾讯地图 key', 'tencent.lbs.key', 'TVDBZ-TDILD-4ON4B-PFDZA-RNLKH-VVF6E', '1', '腾讯地图 key', '1', '2023-06-03 19:16:27', '1', '2023-06-03 19:16:27', '0');
INSERT INTO infra_config (id, category, type, name, config_key, value, visible, remark, creator, create_time, updater, update_time, deleted) VALUES (12, 'test2', 2, 'test3', 'test4', 'test5', '1', 'test6', '1', '2023-12-03 09:55:16', '1', '2025-04-06 21:00:09', '0');
INSERT INTO infra_config (id, category, type, name, config_key, value, visible, remark, creator, create_time, updater, update_time, deleted) VALUES (13, '用户管理-账号初始密码', 2, '用户管理-注册开关', 'system.user.register-enabled', 'true', '0', '', '1', '2025-04-26 17:23:41', '1', '2025-04-26 17:23:41', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS infra_config_seq;
CREATE SEQUENCE infra_config_seq
    START 14;

-- ----------------------------
-- Table structure for infra_data_source_config
-- ----------------------------
DROP TABLE IF EXISTS infra_data_source_config;
CREATE TABLE infra_data_source_config
(
    id          int8          NOT NULL,
    name        varchar(100)  NULL     DEFAULT '',
    url         varchar(1024) NOT NULL,
    username    varchar(255)  NOT NULL,
    password    varchar(255)  NULL     DEFAULT '',
    creator     varchar(64)   NULL     DEFAULT '',
    create_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)   NULL     DEFAULT '',
    update_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2          NOT NULL DEFAULT 0
);

ALTER TABLE infra_data_source_config
    ADD CONSTRAINT pk_infra_data_source_config PRIMARY KEY (id);

COMMENT ON COLUMN infra_data_source_config.id IS '主键编号';
COMMENT ON COLUMN infra_data_source_config.name IS '参数名称';
COMMENT ON COLUMN infra_data_source_config.url IS '数据源连接';
COMMENT ON COLUMN infra_data_source_config.username IS '用户名';
COMMENT ON COLUMN infra_data_source_config.password IS '密码';
COMMENT ON COLUMN infra_data_source_config.creator IS '创建者';
COMMENT ON COLUMN infra_data_source_config.create_time IS '创建时间';
COMMENT ON COLUMN infra_data_source_config.updater IS '更新者';
COMMENT ON COLUMN infra_data_source_config.update_time IS '更新时间';
COMMENT ON COLUMN infra_data_source_config.deleted IS '是否删除';
COMMENT ON TABLE infra_data_source_config IS '数据源配置表';

DROP SEQUENCE IF EXISTS infra_data_source_config_seq;
CREATE SEQUENCE infra_data_source_config_seq
    START 1;

-- ----------------------------
-- Table structure for infra_file
-- ----------------------------
DROP TABLE IF EXISTS infra_file;
CREATE TABLE infra_file
(
    id          int8          NOT NULL,
    config_id   int8          NULL     DEFAULT NULL,
    name        varchar(256)  NULL     DEFAULT NULL,
    path        varchar(512)  NOT NULL,
    url         varchar(1024) NOT NULL,
    type        varchar(128)  NULL     DEFAULT NULL,
    size        int4          NOT NULL,
    creator     varchar(64)   NULL     DEFAULT '',
    create_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)   NULL     DEFAULT '',
    update_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2          NOT NULL DEFAULT 0
);

ALTER TABLE infra_file
    ADD CONSTRAINT pk_infra_file PRIMARY KEY (id);

COMMENT ON COLUMN infra_file.id IS '文件编号';
COMMENT ON COLUMN infra_file.config_id IS '配置编号';
COMMENT ON COLUMN infra_file.name IS '文件名';
COMMENT ON COLUMN infra_file.path IS '文件路径';
COMMENT ON COLUMN infra_file.url IS '文件 URL';
COMMENT ON COLUMN infra_file.type IS '文件类型';
COMMENT ON COLUMN infra_file.size IS '文件大小';
COMMENT ON COLUMN infra_file.creator IS '创建者';
COMMENT ON COLUMN infra_file.create_time IS '创建时间';
COMMENT ON COLUMN infra_file.updater IS '更新者';
COMMENT ON COLUMN infra_file.update_time IS '更新时间';
COMMENT ON COLUMN infra_file.deleted IS '是否删除';
COMMENT ON TABLE infra_file IS '文件表';

DROP SEQUENCE IF EXISTS infra_file_seq;
CREATE SEQUENCE infra_file_seq
    START 1;

-- ----------------------------
-- Table structure for infra_file_config
-- ----------------------------
DROP TABLE IF EXISTS infra_file_config;
CREATE TABLE infra_file_config
(
    id          int8          NOT NULL,
    name        varchar(63)   NOT NULL,
    storage     int2          NOT NULL,
    remark      varchar(255)  NULL     DEFAULT NULL,
    master      bool          NOT NULL,
    config      varchar(4096) NOT NULL,
    creator     varchar(64)   NULL     DEFAULT '',
    create_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)   NULL     DEFAULT '',
    update_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2          NOT NULL DEFAULT 0
);

ALTER TABLE infra_file_config
    ADD CONSTRAINT pk_infra_file_config PRIMARY KEY (id);

COMMENT ON COLUMN infra_file_config.id IS '编号';
COMMENT ON COLUMN infra_file_config.name IS '配置名';
COMMENT ON COLUMN infra_file_config.storage IS '存储器';
COMMENT ON COLUMN infra_file_config.remark IS '备注';
COMMENT ON COLUMN infra_file_config.master IS '是否为主配置';
COMMENT ON COLUMN infra_file_config.config IS '存储配置';
COMMENT ON COLUMN infra_file_config.creator IS '创建者';
COMMENT ON COLUMN infra_file_config.create_time IS '创建时间';
COMMENT ON COLUMN infra_file_config.updater IS '更新者';
COMMENT ON COLUMN infra_file_config.update_time IS '更新时间';
COMMENT ON COLUMN infra_file_config.deleted IS '是否删除';
COMMENT ON TABLE infra_file_config IS '文件配置表';

-- ----------------------------
-- Records of infra_file_config
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO infra_file_config (id, name, storage, remark, master, config, creator, create_time, updater, update_time, deleted) VALUES (4, '数据库（示例）', 1, '我是数据库', '0', '{"@class":"com.meession.etm.module.infra.framework.file.core.client.db.DBFileClientConfig","domain":"http://127.0.0.1:48080"}', '1', '2022-03-15 23:56:24', '1', '2025-05-02 18:30:28', '0');
INSERT INTO infra_file_config (id, name, storage, remark, master, config, creator, create_time, updater, update_time, deleted) VALUES (22, '七牛存储器（示例）', 20, '请换成你自己的密钥！！！', '1', '{"@class":"com.meession.etm.module.infra.framework.file.core.client.s3.S3FileClientConfig","endpoint":"s3.cn-south-1.qiniucs.com","domain":"http://xxx","bucket":"ruoyi-vue-pro","accessKey":"3TvrJ70gl2Gt6IBe7_IZT1F6i_k0iMuRtyEv4EyS","accessSecret":"wd0tbVBYlp0S-ihA8Qg2hPLncoP83wyrIq24OZuY","enablePathStyleAccess":false}', '1', '2024-01-13 22:11:12', '1', '2025-05-02 18:30:28', '0');
INSERT INTO infra_file_config (id, name, storage, remark, master, config, creator, create_time, updater, update_time, deleted) VALUES (24, '腾讯云存储（示例）', 20, '请换成你的密钥！！！', '0', '{"@class":"com.meession.etm.module.infra.framework.file.core.client.s3.S3FileClientConfig","endpoint":"https://cos.ap-shanghai.myqcloud.com","domain":"http://xxx","bucket":"aoteman-1255880240","accessKey":"AKIDAF6WSh1uiIjwqtrOsGSN3WryqTM6cTMt","accessSecret":"X"}', '1', '2024-11-09 16:03:22', '1', '2025-05-02 18:30:28', '0');
INSERT INTO infra_file_config (id, name, storage, remark, master, config, creator, create_time, updater, update_time, deleted) VALUES (25, '阿里云存储（示例）', 20, '', '0', '{"@class":"com.meession.etm.module.infra.framework.file.core.client.s3.S3FileClientConfig","endpoint":"oss-cn-beijing.aliyuncs.com","domain":"http://xxx","bucket":"yunai-aoteman","accessKey":"LTAI5tEQLgnDyjh3WpNcdMKA","accessSecret":"X","enablePathStyleAccess":false}', '1', '2024-11-09 16:47:08', '1', '2025-05-02 18:30:28', '0');
INSERT INTO infra_file_config (id, name, storage, remark, master, config, creator, create_time, updater, update_time, deleted) VALUES (26, '火山云存储（示例）', 20, '', '0', '{"@class":"com.meession.etm.module.infra.framework.file.core.client.s3.S3FileClientConfig","endpoint":"tos-s3-cn-beijing.volces.com","domain":null,"bucket":"yunai","accessKey":"AKLTZjc3Zjc4MzZmMjU3NDk0ZTgxYmIyMmFkNTIwMDI1ZGE","accessSecret":"X==","enablePathStyleAccess":false}', '1', '2024-11-09 16:56:42', '1', '2025-05-02 18:30:28', '0');
INSERT INTO infra_file_config (id, name, storage, remark, master, config, creator, create_time, updater, update_time, deleted) VALUES (27, '华为云存储（示例）', 20, '', '0', '{"@class":"com.meession.etm.module.infra.framework.file.core.client.s3.S3FileClientConfig","endpoint":"obs.cn-east-3.myhuaweicloud.com","domain":"","bucket":"mitedtsm","accessKey":"PVDONDEIOTW88LF8DC4U","accessSecret":"X","enablePathStyleAccess":false}', '1', '2024-11-09 17:18:41', '1', '2025-05-02 18:30:28', '0');
INSERT INTO infra_file_config (id, name, storage, remark, master, config, creator, create_time, updater, update_time, deleted) VALUES (28, 'MinIO 存储（示例）', 20, '', '0', '{"@class":"com.meession.etm.module.infra.framework.file.core.client.s3.S3FileClientConfig","endpoint":"http://127.0.0.1:9000","domain":"http://127.0.0.1:9000/mitedtsm","bucket":"mitedtsm","accessKey":"admin","accessSecret":"password","enablePathStyleAccess":false}', '1', '2024-11-09 17:43:10', '1', '2025-05-02 18:30:28', '0');
INSERT INTO infra_file_config (id, name, storage, remark, master, config, creator, create_time, updater, update_time, deleted) VALUES (29, '本地存储（示例）', 10, '仅适合 mac 或 windows', '0', '{"@class":"com.meession.etm.module.infra.framework.file.core.client.local.LocalFileClientConfig","basePath":"/Users/yunai/tmp/file","domain":"http://127.0.0.1:48080"}', '1', '2025-05-02 11:25:45', '1', '2025-05-02 18:30:28', '0');
INSERT INTO infra_file_config (id, name, storage, remark, master, config, creator, create_time, updater, update_time, deleted) VALUES (30, 'SFTP 存储（示例）', 12, '', '0', '{"@class":"com.meession.etm.module.infra.framework.file.core.client.sftp.SftpFileClientConfig","basePath":"/upload","domain":"http://127.0.0.1:48080","host":"127.0.0.1","port":2222,"username":"foo","password":"pass"}', '1', '2025-05-02 16:34:10', '1', '2025-05-02 18:30:28', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS infra_file_config_seq;
CREATE SEQUENCE infra_file_config_seq
    START 31;

-- ----------------------------
-- Table structure for infra_file_content
-- ----------------------------
DROP TABLE IF EXISTS infra_file_content;
CREATE TABLE infra_file_content
(
    id          int8         NOT NULL,
    config_id   int8         NOT NULL,
    path        varchar(512) NOT NULL,
    content     bytea        NOT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0
);

ALTER TABLE infra_file_content
    ADD CONSTRAINT pk_infra_file_content PRIMARY KEY (id);

COMMENT ON COLUMN infra_file_content.id IS '编号';
COMMENT ON COLUMN infra_file_content.config_id IS '配置编号';
COMMENT ON COLUMN infra_file_content.path IS '文件路径';
COMMENT ON COLUMN infra_file_content.content IS '文件内容';
COMMENT ON COLUMN infra_file_content.creator IS '创建者';
COMMENT ON COLUMN infra_file_content.create_time IS '创建时间';
COMMENT ON COLUMN infra_file_content.updater IS '更新者';
COMMENT ON COLUMN infra_file_content.update_time IS '更新时间';
COMMENT ON COLUMN infra_file_content.deleted IS '是否删除';
COMMENT ON TABLE infra_file_content IS '文件表';

DROP SEQUENCE IF EXISTS infra_file_content_seq;
CREATE SEQUENCE infra_file_content_seq
    START 1;

-- ----------------------------
-- Table structure for infra_job
-- ----------------------------
DROP TABLE IF EXISTS infra_job;
CREATE TABLE infra_job
(
    id              int8         NOT NULL,
    name            varchar(32)  NOT NULL,
    status          int2         NOT NULL,
    handler_name    varchar(64)  NOT NULL,
    handler_param   varchar(255) NULL     DEFAULT NULL,
    cron_expression varchar(32)  NOT NULL,
    retry_count     int4         NOT NULL DEFAULT 0,
    retry_interval  int4         NOT NULL DEFAULT 0,
    monitor_timeout int4         NOT NULL DEFAULT 0,
    creator         varchar(64)  NULL     DEFAULT '',
    create_time     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater         varchar(64)  NULL     DEFAULT '',
    update_time     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted         int2         NOT NULL DEFAULT 0
);

ALTER TABLE infra_job
    ADD CONSTRAINT pk_infra_job PRIMARY KEY (id);

COMMENT ON COLUMN infra_job.id IS '任务编号';
COMMENT ON COLUMN infra_job.name IS '任务名称';
COMMENT ON COLUMN infra_job.status IS '任务状态';
COMMENT ON COLUMN infra_job.handler_name IS '处理器的名字';
COMMENT ON COLUMN infra_job.handler_param IS '处理器的参数';
COMMENT ON COLUMN infra_job.cron_expression IS 'CRON 表达式';
COMMENT ON COLUMN infra_job.retry_count IS '重试次数';
COMMENT ON COLUMN infra_job.retry_interval IS '重试间隔';
COMMENT ON COLUMN infra_job.monitor_timeout IS '监控超时时间';
COMMENT ON COLUMN infra_job.creator IS '创建者';
COMMENT ON COLUMN infra_job.create_time IS '创建时间';
COMMENT ON COLUMN infra_job.updater IS '更新者';
COMMENT ON COLUMN infra_job.update_time IS '更新时间';
COMMENT ON COLUMN infra_job.deleted IS '是否删除';
COMMENT ON TABLE infra_job IS '定时任务表';

-- ----------------------------
-- Records of infra_job
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (5, '支付通知 Job', 2, 'payNotifyJob', NULL, '* * * * * ?', 0, 0, 0, '1', '2021-10-27 08:34:42', '1', '2024-09-12 13:32:48', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (17, '支付订单同步 Job', 2, 'payOrderSyncJob', NULL, '0 0/1 * * * ?', 0, 0, 0, '1', '2023-07-22 14:36:26', '1', '2023-07-22 15:39:08', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (18, '支付订单过期 Job', 2, 'payOrderExpireJob', NULL, '0 0/1 * * * ?', 0, 0, 0, '1', '2023-07-22 15:36:23', '1', '2023-07-22 15:39:54', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (19, '退款订单的同步 Job', 2, 'payRefundSyncJob', NULL, '0 0/1 * * * ?', 0, 0, 0, '1', '2023-07-23 21:03:44', '1', '2023-07-23 21:09:00', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (21, '交易订单的自动过期 Job', 2, 'tradeOrderAutoCancelJob', '', '0 * * * * ?', 3, 0, 0, '1', '2023-09-25 23:43:26', '1', '2023-09-26 19:23:30', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (22, '交易订单的自动收货 Job', 2, 'tradeOrderAutoReceiveJob', '', '0 * * * * ?', 3, 0, 0, '1', '2023-09-26 19:23:53', '1', '2023-09-26 23:38:08', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (23, '交易订单的自动评论 Job', 2, 'tradeOrderAutoCommentJob', '', '0 * * * * ?', 3, 0, 0, '1', '2023-09-26 23:38:29', '1', '2023-09-27 11:03:10', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (24, '佣金解冻 Job', 2, 'brokerageRecordUnfreezeJob', '', '0 * * * * ?', 3, 0, 0, '1', '2023-09-28 22:01:46', '1', '2023-09-28 22:01:56', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (25, '访问日志清理 Job', 2, 'accessLogCleanJob', '', '0 0 0 * * ?', 3, 0, 0, '1', '2023-10-03 10:59:41', '1', '2023-10-03 11:01:10', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (26, '错误日志清理 Job', 2, 'errorLogCleanJob', '', '0 0 0 * * ?', 3, 0, 0, '1', '2023-10-03 11:00:43', '1', '2023-10-03 11:01:12', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (27, '任务日志清理 Job', 2, 'jobLogCleanJob', '', '0 0 0 * * ?', 3, 0, 0, '1', '2023-10-03 11:01:33', '1', '2024-09-12 13:40:34', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (33, 'demoJob', 2, 'demoJob', '', '0 * * * * ?', 1, 1, 0, '1', '2024-10-27 19:38:46', '1', '2025-05-10 18:13:54', '0');
INSERT INTO infra_job (id, name, status, handler_name, handler_param, cron_expression, retry_count, retry_interval, monitor_timeout, creator, create_time, updater, update_time, deleted) VALUES (35, '转账订单的同步 Job', 2, 'payTransferSyncJob', '', '0 * * * * ?', 0, 0, 0, '1', '2025-05-10 17:35:54', '1', '2025-05-10 18:13:52', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS infra_job_seq;
CREATE SEQUENCE infra_job_seq
    START 36;

-- ----------------------------
-- Table structure for infra_job_log
-- ----------------------------
DROP TABLE IF EXISTS infra_job_log;
CREATE TABLE infra_job_log
(
    id            int8          NOT NULL,
    job_id        int8          NOT NULL,
    handler_name  varchar(64)   NOT NULL,
    handler_param varchar(255)  NULL     DEFAULT NULL,
    execute_index int2          NOT NULL DEFAULT 1,
    begin_time    timestamp     NOT NULL,
    end_time      timestamp     NULL     DEFAULT NULL,
    duration      int4          NULL     DEFAULT NULL,
    status        int2          NOT NULL,
    result        varchar(4000) NULL     DEFAULT '',
    creator       varchar(64)   NULL     DEFAULT '',
    create_time   timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater       varchar(64)   NULL     DEFAULT '',
    update_time   timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted       int2          NOT NULL DEFAULT 0
);

ALTER TABLE infra_job_log
    ADD CONSTRAINT pk_infra_job_log PRIMARY KEY (id);

COMMENT ON COLUMN infra_job_log.id IS '日志编号';
COMMENT ON COLUMN infra_job_log.job_id IS '任务编号';
COMMENT ON COLUMN infra_job_log.handler_name IS '处理器的名字';
COMMENT ON COLUMN infra_job_log.handler_param IS '处理器的参数';
COMMENT ON COLUMN infra_job_log.execute_index IS '第几次执行';
COMMENT ON COLUMN infra_job_log.begin_time IS '开始执行时间';
COMMENT ON COLUMN infra_job_log.end_time IS '结束执行时间';
COMMENT ON COLUMN infra_job_log.duration IS '执行时长';
COMMENT ON COLUMN infra_job_log.status IS '任务状态';
COMMENT ON COLUMN infra_job_log.result IS '结果数据';
COMMENT ON COLUMN infra_job_log.creator IS '创建者';
COMMENT ON COLUMN infra_job_log.create_time IS '创建时间';
COMMENT ON COLUMN infra_job_log.updater IS '更新者';
COMMENT ON COLUMN infra_job_log.update_time IS '更新时间';
COMMENT ON COLUMN infra_job_log.deleted IS '是否删除';
COMMENT ON TABLE infra_job_log IS '定时任务日志表';

DROP SEQUENCE IF EXISTS infra_job_log_seq;
CREATE SEQUENCE infra_job_log_seq
    START 1;

-- ----------------------------
-- Table structure for system_dept
-- ----------------------------
DROP TABLE IF EXISTS system_dept;
CREATE TABLE system_dept
(
    id             int8        NOT NULL,
    name           varchar(30) NULL     DEFAULT '',
    parent_id      int8        NOT NULL DEFAULT 0,
    sort           int4        NOT NULL DEFAULT 0,
    leader_user_id int8        NULL     DEFAULT NULL,
    phone          varchar(11) NULL     DEFAULT NULL,
    email          varchar(50) NULL     DEFAULT NULL,
    status         int2        NOT NULL,
    creator        varchar(64) NULL     DEFAULT '',
    create_time    timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater        varchar(64) NULL     DEFAULT '',
    update_time    timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted        int2        NOT NULL DEFAULT 0,
    tenant_id      int8        NOT NULL DEFAULT 0
);

ALTER TABLE system_dept
    ADD CONSTRAINT pk_system_dept PRIMARY KEY (id);

COMMENT ON COLUMN system_dept.id IS '部门id';
COMMENT ON COLUMN system_dept.name IS '部门名称';
COMMENT ON COLUMN system_dept.parent_id IS '父部门id';
COMMENT ON COLUMN system_dept.sort IS '显示顺序';
COMMENT ON COLUMN system_dept.leader_user_id IS '负责人';
COMMENT ON COLUMN system_dept.phone IS '联系电话';
COMMENT ON COLUMN system_dept.email IS '邮箱';
COMMENT ON COLUMN system_dept.status IS '部门状态（0正常 1停用）';
COMMENT ON COLUMN system_dept.creator IS '创建者';
COMMENT ON COLUMN system_dept.create_time IS '创建时间';
COMMENT ON COLUMN system_dept.updater IS '更新者';
COMMENT ON COLUMN system_dept.update_time IS '更新时间';
COMMENT ON COLUMN system_dept.deleted IS '是否删除';
COMMENT ON COLUMN system_dept.tenant_id IS '租户编号';
COMMENT ON TABLE system_dept IS '部门表';

-- ----------------------------
-- Records of system_dept
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (100, '密讯', 0, 0, 1, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2025-03-29 15:47:53', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (101, '深圳总公司', 100, 1, 104, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2025-03-29 15:49:55', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (102, '长沙分公司', 100, 2, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:40', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (103, '研发部门', 101, 1, 1, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2024-10-02 10:22:03', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (104, '市场部门', 101, 2, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:38', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (105, '测试部门', 101, 3, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2022-05-16 20:25:15', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (106, '财务部门', 101, 4, 103, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '103', '2022-01-15 21:32:22', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (107, '运维部门', 101, 5, 1, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2023-12-02 09:28:22', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (108, '市场部门', 102, 1, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '1', '2022-02-16 08:35:45', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (109, '财务部门', 102, 2, NULL, '15888888888', 'ry@qq.com', 0, 'admin', '2021-01-05 17:03:47', '', '2021-12-15 05:01:29', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (110, '新部门', 0, 1, NULL, NULL, NULL, 0, '110', '2022-02-23 20:46:30', '110', '2022-02-23 20:46:30', '0', 121);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (111, '顶级部门', 0, 1, NULL, NULL, NULL, 0, '113', '2022-03-07 21:44:50', '113', '2022-03-07 21:44:50', '0', 122);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (112, '产品部门', 101, 100, 1, NULL, NULL, 1, '1', '2023-12-02 09:45:13', '1', '2023-12-02 09:45:31', '0', 1);
INSERT INTO system_dept (id, name, parent_id, sort, leader_user_id, phone, email, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (113, '支持部门', 102, 3, 104, NULL, NULL, 1, '1', '2023-12-02 09:47:38', '1', '2025-03-29 15:00:56', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_dept_seq;
CREATE SEQUENCE system_dept_seq
    START 114;

-- ----------------------------
-- Table structure for system_dict_data
-- ----------------------------
DROP TABLE IF EXISTS system_dict_data;
CREATE TABLE system_dict_data
(
    id          int8         NOT NULL,
    sort        int4         NOT NULL DEFAULT 0,
    label       varchar(100) NULL     DEFAULT '',
    value       varchar(100) NULL     DEFAULT '',
    dict_type   varchar(100) NULL     DEFAULT '',
    status      int2         NOT NULL DEFAULT 0,
    color_type  varchar(100) NULL     DEFAULT '',
    css_class   varchar(100) NULL     DEFAULT '',
    remark      varchar(500) NULL     DEFAULT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0
);

ALTER TABLE system_dict_data
    ADD CONSTRAINT pk_system_dict_data PRIMARY KEY (id);

COMMENT ON COLUMN system_dict_data.id IS '字典编码';
COMMENT ON COLUMN system_dict_data.sort IS '字典排序';
COMMENT ON COLUMN system_dict_data.label IS '字典标签';
COMMENT ON COLUMN system_dict_data.value IS '字典键值';
COMMENT ON COLUMN system_dict_data.dict_type IS '字典类型';
COMMENT ON COLUMN system_dict_data.status IS '状态（0正常 1停用）';
COMMENT ON COLUMN system_dict_data.color_type IS '颜色类型';
COMMENT ON COLUMN system_dict_data.css_class IS 'css 样式';
COMMENT ON COLUMN system_dict_data.remark IS '备注';
COMMENT ON COLUMN system_dict_data.creator IS '创建者';
COMMENT ON COLUMN system_dict_data.create_time IS '创建时间';
COMMENT ON COLUMN system_dict_data.updater IS '更新者';
COMMENT ON COLUMN system_dict_data.update_time IS '更新时间';
COMMENT ON COLUMN system_dict_data.deleted IS '是否删除';
COMMENT ON TABLE system_dict_data IS '字典数据表';

-- ----------------------------
-- Records of system_dict_data
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1, 1, '男', '1', 'system_user_sex', 0, 'default', 'A', '性别男', 'admin', '2021-01-05 17:03:48', '1', '2022-03-29 00:14:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2, 2, '女', '2', 'system_user_sex', 0, 'success', '', '性别女', 'admin', '2021-01-05 17:03:48', '1', '2023-11-15 23:30:37', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (8, 1, '正常', '1', 'infra_job_status', 0, 'success', '', '正常状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:33:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (9, 2, '暂停', '2', 'infra_job_status', 0, 'danger', '', '停用状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:33:45', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (12, 1, '系统内置', '1', 'infra_config_type', 0, 'danger', '', '参数类型 - 系统内置', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:06:02', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (13, 2, '自定义', '2', 'infra_config_type', 0, 'primary', '', '参数类型 - 自定义', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 19:06:07', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (14, 1, '通知', '1', 'system_notice_type', 0, 'success', '', '通知', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:05:57', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (15, 2, '公告', '2', 'system_notice_type', 0, 'info', '', '公告', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:06:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (16, 0, '其它', '0', 'infra_operate_type', 0, 'default', '', '其它操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (17, 1, '查询', '1', 'infra_operate_type', 0, 'info', '', '查询操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (18, 2, '新增', '2', 'infra_operate_type', 0, 'primary', '', '新增操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:21', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (19, 3, '修改', '3', 'infra_operate_type', 0, 'warning', '', '修改操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (20, 4, '删除', '4', 'infra_operate_type', 0, 'danger', '', '删除操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:23', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (22, 5, '导出', '5', 'infra_operate_type', 0, 'default', '', '导出操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (23, 6, '导入', '6', 'infra_operate_type', 0, 'default', '', '导入操作', 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:25', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (27, 1, '开启', '0', 'common_status', 0, 'primary', '', '开启状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 08:00:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (28, 2, '关闭', '1', 'common_status', 0, 'info', '', '关闭状态', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 08:00:44', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (29, 1, '目录', '1', 'system_menu_type', 0, '', '', '目录', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:43:45', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (30, 2, '菜单', '2', 'system_menu_type', 0, '', '', '菜单', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:43:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (31, 3, '按钮', '3', 'system_menu_type', 0, '', '', '按钮', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:43:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (32, 1, '内置', '1', 'system_role_type', 0, 'danger', '', '内置角色', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:02:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (33, 2, '自定义', '2', 'system_role_type', 0, 'primary', '', '自定义角色', 'admin', '2021-01-05 17:03:48', '1', '2022-02-16 13:02:12', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (34, 1, '全部数据权限', '1', 'system_data_scope', 0, '', '', '全部数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (35, 2, '指定部门数据权限', '2', 'system_data_scope', 0, '', '', '指定部门数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (36, 3, '本部门数据权限', '3', 'system_data_scope', 0, '', '', '本部门数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (37, 4, '本部门及以下数据权限', '4', 'system_data_scope', 0, '', '', '本部门及以下数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:21', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (38, 5, '仅本人数据权限', '5', 'system_data_scope', 0, '', '', '仅本人数据权限', 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:47:23', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (39, 0, '成功', '0', 'system_login_result', 0, 'success', '', '登陆结果 - 成功', '', '2021-01-18 06:17:36', '1', '2022-02-16 13:23:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (40, 10, '账号或密码不正确', '10', 'system_login_result', 0, 'primary', '', '登陆结果 - 账号或密码不正确', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:27', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (41, 20, '用户被禁用', '20', 'system_login_result', 0, 'warning', '', '登陆结果 - 用户被禁用', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:23:57', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (42, 30, '验证码不存在', '30', 'system_login_result', 0, 'info', '', '登陆结果 - 验证码不存在', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:07', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (43, 31, '验证码不正确', '31', 'system_login_result', 0, 'info', '', '登陆结果 - 验证码不正确', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:11', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (44, 100, '未知异常', '100', 'system_login_result', 0, 'danger', '', '登陆结果 - 未知异常', '', '2021-01-18 06:17:54', '1', '2022-02-16 13:24:23', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (45, 1, '是', 'true', 'infra_boolean_string', 0, 'danger', '', 'Boolean 是否类型 - 是', '', '2021-01-19 03:20:55', '1', '2022-03-15 23:01:45', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (46, 1, '否', 'false', 'infra_boolean_string', 0, 'info', '', 'Boolean 是否类型 - 否', '', '2021-01-19 03:20:55', '1', '2022-03-15 23:09:45', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (50, 1, '单表（增删改查）', '1', 'infra_codegen_template_type', 0, '', '', NULL, '', '2021-02-05 07:09:06', '', '2022-03-10 16:33:15', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (51, 2, '树表（增删改查）', '2', 'infra_codegen_template_type', 0, '', '', NULL, '', '2021-02-05 07:14:46', '', '2022-03-10 16:33:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (53, 0, '初始化中', '0', 'infra_job_status', 0, 'primary', '', NULL, '', '2021-02-07 07:46:49', '1', '2022-02-16 19:33:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (57, 0, '运行中', '0', 'infra_job_log_status', 0, 'primary', '', 'RUNNING', '', '2021-02-08 10:04:24', '1', '2022-02-16 19:07:48', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (58, 1, '成功', '1', 'infra_job_log_status', 0, 'success', '', NULL, '', '2021-02-08 10:06:57', '1', '2022-02-16 19:07:52', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (59, 2, '失败', '2', 'infra_job_log_status', 0, 'warning', '', '失败', '', '2021-02-08 10:07:38', '1', '2022-02-16 19:07:56', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (60, 1, '会员', '1', 'user_type', 0, 'primary', '', NULL, '', '2021-02-26 00:16:27', '1', '2022-02-16 10:22:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (61, 2, '管理员', '2', 'user_type', 0, 'success', '', NULL, '', '2021-02-26 00:16:34', '1', '2025-04-06 18:37:43', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (62, 0, '未处理', '0', 'infra_api_error_log_process_status', 0, 'primary', '', NULL, '', '2021-02-26 07:07:19', '1', '2022-02-16 20:14:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (63, 1, '已处理', '1', 'infra_api_error_log_process_status', 0, 'success', '', NULL, '', '2021-02-26 07:07:26', '1', '2022-02-16 20:14:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (64, 2, '已忽略', '2', 'infra_api_error_log_process_status', 0, 'danger', '', NULL, '', '2021-02-26 07:07:34', '1', '2022-02-16 20:14:14', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (66, 1, '阿里云', 'ALIYUN', 'system_sms_channel_code', 0, 'primary', '', NULL, '1', '2021-04-05 01:05:26', '1', '2024-07-22 22:23:25', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (67, 1, '验证码', '1', 'system_sms_template_type', 0, 'warning', '', NULL, '1', '2021-04-05 21:50:57', '1', '2022-02-16 12:48:30', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (68, 2, '通知', '2', 'system_sms_template_type', 0, 'primary', '', NULL, '1', '2021-04-05 21:51:08', '1', '2022-02-16 12:48:27', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (69, 0, '营销', '3', 'system_sms_template_type', 0, 'danger', '', NULL, '1', '2021-04-05 21:51:15', '1', '2022-02-16 12:48:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (70, 0, '初始化', '0', 'system_sms_send_status', 0, 'primary', '', NULL, '1', '2021-04-11 20:18:33', '1', '2022-02-16 10:26:07', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (71, 1, '发送成功', '10', 'system_sms_send_status', 0, 'success', '', NULL, '1', '2021-04-11 20:18:43', '1', '2022-02-16 10:25:56', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (72, 2, '发送失败', '20', 'system_sms_send_status', 0, 'danger', '', NULL, '1', '2021-04-11 20:18:49', '1', '2022-02-16 10:26:03', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (73, 3, '不发送', '30', 'system_sms_send_status', 0, 'info', '', NULL, '1', '2021-04-11 20:19:44', '1', '2022-02-16 10:26:10', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (74, 0, '等待结果', '0', 'system_sms_receive_status', 0, 'primary', '', NULL, '1', '2021-04-11 20:27:43', '1', '2022-02-16 10:28:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (75, 1, '接收成功', '10', 'system_sms_receive_status', 0, 'success', '', NULL, '1', '2021-04-11 20:29:25', '1', '2022-02-16 10:28:28', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (76, 2, '接收失败', '20', 'system_sms_receive_status', 0, 'danger', '', NULL, '1', '2021-04-11 20:29:31', '1', '2022-02-16 10:28:32', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (77, 0, '调试(钉钉)', 'DEBUG_DING_TALK', 'system_sms_channel_code', 0, 'info', '', NULL, '1', '2021-04-13 00:20:37', '1', '2022-02-16 10:10:00', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (80, 100, '账号登录', '100', 'system_login_type', 0, 'primary', '', '账号登录', '1', '2021-10-06 00:52:02', '1', '2022-02-16 13:11:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (81, 101, '社交登录', '101', 'system_login_type', 0, 'info', '', '社交登录', '1', '2021-10-06 00:52:17', '1', '2022-02-16 13:11:40', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (83, 200, '主动登出', '200', 'system_login_type', 0, 'primary', '', '主动登出', '1', '2021-10-06 00:52:58', '1', '2022-02-16 13:11:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (85, 202, '强制登出', '202', 'system_login_type', 0, 'danger', '', '强制退出', '1', '2021-10-06 00:53:41', '1', '2022-02-16 13:11:57', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (86, 0, '病假', '1', 'bpm_oa_leave_type', 0, 'primary', '', NULL, '1', '2021-09-21 22:35:28', '1', '2022-02-16 10:00:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (87, 1, '事假', '2', 'bpm_oa_leave_type', 0, 'info', '', NULL, '1', '2021-09-21 22:36:11', '1', '2022-02-16 10:00:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (88, 2, '婚假', '3', 'bpm_oa_leave_type', 0, 'warning', '', NULL, '1', '2021-09-21 22:36:38', '1', '2022-02-16 10:00:53', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (112, 0, '微信 Wap 网站支付', 'wx_wap', 'pay_channel_code', 0, 'success', '', '微信 Wap 网站支付', '1', '2023-07-19 20:08:06', '1', '2023-07-19 20:09:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (113, 1, '微信公众号支付', 'wx_pub', 'pay_channel_code', 0, 'success', '', '微信公众号支付', '1', '2021-12-03 10:40:24', '1', '2023-07-19 20:08:47', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (114, 2, '微信小程序支付', 'wx_lite', 'pay_channel_code', 0, 'success', '', '微信小程序支付', '1', '2021-12-03 10:41:06', '1', '2023-07-19 20:08:50', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (115, 3, '微信 App 支付', 'wx_app', 'pay_channel_code', 0, 'success', '', '微信 App 支付', '1', '2021-12-03 10:41:20', '1', '2023-07-19 20:08:56', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (116, 10, '支付宝 PC 网站支付', 'alipay_pc', 'pay_channel_code', 0, 'primary', '', '支付宝 PC 网站支付', '1', '2021-12-03 10:42:09', '1', '2023-07-19 20:09:12', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (117, 11, '支付宝 Wap 网站支付', 'alipay_wap', 'pay_channel_code', 0, 'primary', '', '支付宝 Wap 网站支付', '1', '2021-12-03 10:42:26', '1', '2023-07-19 20:09:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (118, 12, '支付宝 App 支付', 'alipay_app', 'pay_channel_code', 0, 'primary', '', '支付宝 App 支付', '1', '2021-12-03 10:42:55', '1', '2023-07-19 20:09:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (119, 14, '支付宝扫码支付', 'alipay_qr', 'pay_channel_code', 0, 'primary', '', '支付宝扫码支付', '1', '2021-12-03 10:43:10', '1', '2023-07-19 20:09:28', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (120, 10, '通知成功', '10', 'pay_notify_status', 0, 'success', '', '通知成功', '1', '2021-12-03 11:02:41', '1', '2023-07-19 10:08:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (121, 20, '通知失败', '20', 'pay_notify_status', 0, 'danger', '', '通知失败', '1', '2021-12-03 11:02:59', '1', '2023-07-19 10:08:21', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (122, 0, '等待通知', '0', 'pay_notify_status', 0, 'info', '', '未通知', '1', '2021-12-03 11:03:10', '1', '2023-07-19 10:08:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (123, 10, '支付成功', '10', 'pay_order_status', 0, 'success', '', '支付成功', '1', '2021-12-03 11:18:29', '1', '2023-07-19 18:04:28', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (124, 30, '支付关闭', '30', 'pay_order_status', 0, 'info', '', '支付关闭', '1', '2021-12-03 11:18:42', '1', '2023-07-19 18:05:07', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (125, 0, '等待支付', '0', 'pay_order_status', 0, 'info', '', '未支付', '1', '2021-12-03 11:18:18', '1', '2023-07-19 18:04:15', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (600, 5, '首页', '1', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (601, 4, '秒杀活动页', '2', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (602, 3, '砍价活动页', '3', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (603, 2, '限时折扣页', '4', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (604, 1, '满减送页', '5', 'promotion_banner_position', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1118, 0, '等待退款', '0', 'pay_refund_status', 0, 'info', '', '等待退款', '1', '2021-12-10 16:44:59', '1', '2023-07-19 10:14:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1119, 20, '退款失败', '20', 'pay_refund_status', 0, 'danger', '', '退款失败', '1', '2021-12-10 16:45:10', '1', '2023-07-19 10:15:10', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1124, 10, '退款成功', '10', 'pay_refund_status', 0, 'success', '', '退款成功', '1', '2021-12-10 16:46:26', '1', '2023-07-19 10:15:00', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1127, 1, '审批中', '1', 'bpm_process_instance_status', 0, 'default', '', '流程实例的状态 - 进行中', '1', '2022-01-07 23:47:22', '1', '2024-03-16 16:11:45', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1128, 2, '审批通过', '2', 'bpm_process_instance_status', 0, 'success', '', '流程实例的状态 - 已完成', '1', '2022-01-07 23:47:49', '1', '2024-03-16 16:11:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1129, 1, '审批中', '1', 'bpm_task_status', 0, 'primary', '', '流程实例的结果 - 处理中', '1', '2022-01-07 23:48:32', '1', '2024-03-08 22:41:37', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1130, 2, '审批通过', '2', 'bpm_task_status', 0, 'success', '', '流程实例的结果 - 通过', '1', '2022-01-07 23:48:45', '1', '2024-03-08 22:41:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1131, 3, '审批不通过', '3', 'bpm_task_status', 0, 'danger', '', '流程实例的结果 - 不通过', '1', '2022-01-07 23:48:55', '1', '2024-03-08 22:41:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1132, 4, '已取消', '4', 'bpm_task_status', 0, 'info', '', '流程实例的结果 - 撤销', '1', '2022-01-07 23:49:06', '1', '2024-03-08 22:41:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1133, 10, '流程表单', '10', 'bpm_model_form_type', 0, '', '', '流程的表单类型 - 流程表单', '103', '2022-01-11 23:51:30', '103', '2022-01-11 23:51:30', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1134, 20, '业务表单', '20', 'bpm_model_form_type', 0, '', '', '流程的表单类型 - 业务表单', '103', '2022-01-11 23:51:47', '103', '2022-01-11 23:51:47', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1135, 10, '角色', '10', 'bpm_task_candidate_strategy', 0, 'info', '', '任务分配规则的类型 - 角色', '103', '2022-01-12 23:21:22', '1', '2024-03-06 02:53:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1136, 20, '部门的成员', '20', 'bpm_task_candidate_strategy', 0, 'primary', '', '任务分配规则的类型 - 部门的成员', '103', '2022-01-12 23:21:47', '1', '2024-03-06 02:53:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1137, 21, '部门的负责人', '21', 'bpm_task_candidate_strategy', 0, 'primary', '', '任务分配规则的类型 - 部门的负责人', '103', '2022-01-12 23:33:36', '1', '2024-03-06 02:53:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1138, 30, '用户', '30', 'bpm_task_candidate_strategy', 0, 'info', '', '任务分配规则的类型 - 用户', '103', '2022-01-12 23:34:02', '1', '2024-03-06 02:53:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1139, 40, '用户组', '40', 'bpm_task_candidate_strategy', 0, 'warning', '', '任务分配规则的类型 - 用户组', '103', '2022-01-12 23:34:21', '1', '2024-03-06 02:53:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1140, 60, '流程表达式', '60', 'bpm_task_candidate_strategy', 0, 'danger', '', '任务分配规则的类型 - 流程表达式', '103', '2022-01-12 23:34:43', '1', '2024-03-06 02:53:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1141, 22, '岗位', '22', 'bpm_task_candidate_strategy', 0, 'success', '', '任务分配规则的类型 - 岗位', '103', '2022-01-14 18:41:55', '1', '2024-03-06 02:53:21', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1145, 1, '管理后台', '1', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 管理后台', '1', '2022-02-02 13:15:06', '1', '2022-03-10 16:32:59', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1146, 2, '用户 APP', '2', 'infra_codegen_scene', 0, '', '', '代码生成的场景枚举 - 用户 APP', '1', '2022-02-02 13:15:19', '1', '2022-03-10 16:33:03', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1150, 1, '数据库', '1', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:25:28', '1', '2022-03-15 00:25:28', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1151, 10, '本地磁盘', '10', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:25:41', '1', '2022-03-15 00:25:56', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1152, 11, 'FTP 服务器', '11', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:26:06', '1', '2022-03-15 00:26:10', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1153, 12, 'SFTP 服务器', '12', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:26:22', '1', '2022-03-15 00:26:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1154, 20, 'S3 对象存储', '20', 'infra_file_storage', 0, 'default', '', NULL, '1', '2022-03-15 00:26:31', '1', '2022-03-15 00:26:45', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1155, 103, '短信登录', '103', 'system_login_type', 0, 'default', '', NULL, '1', '2022-05-09 23:57:58', '1', '2022-05-09 23:58:09', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1156, 1, 'password', 'password', 'system_oauth2_grant_type', 0, 'default', '', '密码模式', '1', '2022-05-12 00:22:05', '1', '2022-05-11 16:26:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1157, 2, 'authorization_code', 'authorization_code', 'system_oauth2_grant_type', 0, 'primary', '', '授权码模式', '1', '2022-05-12 00:22:59', '1', '2022-05-11 16:26:02', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1158, 3, 'implicit', 'implicit', 'system_oauth2_grant_type', 0, 'success', '', '简化模式', '1', '2022-05-12 00:23:40', '1', '2022-05-11 16:26:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1159, 4, 'client_credentials', 'client_credentials', 'system_oauth2_grant_type', 0, 'default', '', '客户端模式', '1', '2022-05-12 00:23:51', '1', '2022-05-11 16:26:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1160, 5, 'refresh_token', 'refresh_token', 'system_oauth2_grant_type', 0, 'info', '', '刷新模式', '1', '2022-05-12 00:24:02', '1', '2022-05-11 16:26:11', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1162, 1, '销售中', '1', 'product_spu_status', 0, 'success', '', '商品 SPU 状态 - 销售中', '1', '2022-10-24 21:19:47', '1', '2022-10-24 21:20:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1163, 0, '仓库中', '0', 'product_spu_status', 0, 'info', '', '商品 SPU 状态 - 仓库中', '1', '2022-10-24 21:20:54', '1', '2022-10-24 21:21:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1164, 0, '回收站', '-1', 'product_spu_status', 0, 'default', '', '商品 SPU 状态 - 回收站', '1', '2022-10-24 21:21:11', '1', '2022-10-24 21:21:11', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1165, 1, '满减', '1', 'promotion_discount_type', 0, 'success', '', '优惠类型 - 满减', '1', '2022-11-01 12:46:41', '1', '2022-11-01 12:50:11', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1166, 2, '折扣', '2', 'promotion_discount_type', 0, 'primary', '', '优惠类型 - 折扣', '1', '2022-11-01 12:46:51', '1', '2022-11-01 12:50:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1167, 1, '固定日期', '1', 'promotion_coupon_template_validity_type', 0, 'default', '', '优惠劵模板的有限期类型 - 固定日期', '1', '2022-11-02 00:07:34', '1', '2022-11-04 00:07:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1168, 2, '领取之后', '2', 'promotion_coupon_template_validity_type', 0, 'default', '', '优惠劵模板的有限期类型 - 领取之后', '1', '2022-11-02 00:07:54', '1', '2022-11-04 00:07:52', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1169, 1, '通用劵', '1', 'promotion_product_scope', 0, 'default', '', '营销的商品范围 - 全部商品参与', '1', '2022-11-02 00:28:22', '1', '2023-09-28 00:27:42', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1170, 2, '商品劵', '2', 'promotion_product_scope', 0, 'default', '', '营销的商品范围 - 指定商品参与', '1', '2022-11-02 00:28:34', '1', '2023-09-28 00:27:44', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1171, 1, '未使用', '1', 'promotion_coupon_status', 0, 'primary', '', '优惠劵的状态 - 已领取', '1', '2022-11-04 00:15:08', '1', '2023-10-03 12:54:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1172, 2, '已使用', '2', 'promotion_coupon_status', 0, 'success', '', '优惠劵的状态 - 已使用', '1', '2022-11-04 00:15:21', '1', '2022-11-04 19:16:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1173, 3, '已过期', '3', 'promotion_coupon_status', 0, 'info', '', '优惠劵的状态 - 已过期', '1', '2022-11-04 00:15:43', '1', '2022-11-04 19:16:12', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1174, 1, '直接领取', '1', 'promotion_coupon_take_type', 0, 'primary', '', '优惠劵的领取方式 - 直接领取', '1', '2022-11-04 19:13:00', '1', '2022-11-04 19:13:25', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1175, 2, '指定发放', '2', 'promotion_coupon_take_type', 0, 'success', '', '优惠劵的领取方式 - 指定发放', '1', '2022-11-04 19:13:13', '1', '2022-11-04 19:14:48', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1176, 10, '未开始', '10', 'promotion_activity_status', 0, 'primary', '', '促销活动的状态枚举 - 未开始', '1', '2022-11-04 22:54:49', '1', '2022-11-04 22:55:53', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1177, 20, '进行中', '20', 'promotion_activity_status', 0, 'success', '', '促销活动的状态枚举 - 进行中', '1', '2022-11-04 22:55:06', '1', '2022-11-04 22:55:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1178, 30, '已结束', '30', 'promotion_activity_status', 0, 'info', '', '促销活动的状态枚举 - 已结束', '1', '2022-11-04 22:55:41', '1', '2022-11-04 22:55:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1179, 40, '已关闭', '40', 'promotion_activity_status', 0, 'warning', '', '促销活动的状态枚举 - 已关闭', '1', '2022-11-04 22:56:10', '1', '2022-11-04 22:56:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1180, 10, '满 N 元', '10', 'promotion_condition_type', 0, 'primary', '', '营销的条件类型 - 满 N 元', '1', '2022-11-04 22:59:45', '1', '2022-11-04 22:59:45', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1181, 20, '满 N 件', '20', 'promotion_condition_type', 0, 'success', '', '营销的条件类型 - 满 N 件', '1', '2022-11-04 23:00:02', '1', '2022-11-04 23:00:02', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1182, 10, '申请售后', '10', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 申请售后', '1', '2022-11-19 20:53:33', '1', '2022-11-19 20:54:42', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1183, 20, '商品待退货', '20', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 商品待退货', '1', '2022-11-19 20:54:36', '1', '2022-11-19 20:58:58', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1184, 30, '商家待收货', '30', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 商家待收货', '1', '2022-11-19 20:56:56', '1', '2022-11-19 20:59:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1185, 40, '等待退款', '40', 'trade_after_sale_status', 0, 'primary', '', '交易售后状态 - 等待退款', '1', '2022-11-19 20:59:54', '1', '2022-11-19 21:00:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1186, 50, '退款成功', '50', 'trade_after_sale_status', 0, 'default', '', '交易售后状态 - 退款成功', '1', '2022-11-19 21:00:33', '1', '2022-11-19 21:00:33', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1187, 61, '买家取消', '61', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 买家取消', '1', '2022-11-19 21:01:29', '1', '2022-11-19 21:01:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1188, 62, '商家拒绝', '62', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 商家拒绝', '1', '2022-11-19 21:02:17', '1', '2022-11-19 21:02:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1189, 63, '商家拒收货', '63', 'trade_after_sale_status', 0, 'info', '', '交易售后状态 - 商家拒收货', '1', '2022-11-19 21:02:37', '1', '2022-11-19 21:03:07', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1190, 10, '售中退款', '10', 'trade_after_sale_type', 0, 'success', '', '交易售后的类型 - 售中退款', '1', '2022-11-19 21:05:05', '1', '2022-11-19 21:38:23', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1191, 20, '售后退款', '20', 'trade_after_sale_type', 0, 'primary', '', '交易售后的类型 - 售后退款', '1', '2022-11-19 21:05:32', '1', '2022-11-19 21:38:32', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1192, 10, '仅退款', '10', 'trade_after_sale_way', 0, 'primary', '', '交易售后的方式 - 仅退款', '1', '2022-11-19 21:39:19', '1', '2022-11-19 21:39:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1193, 20, '退货退款', '20', 'trade_after_sale_way', 0, 'success', '', '交易售后的方式 - 退货退款', '1', '2022-11-19 21:39:38', '1', '2022-11-19 21:39:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1194, 10, '微信小程序', '10', 'terminal', 0, 'default', '', '终端 - 微信小程序', '1', '2022-12-10 10:51:11', '1', '2022-12-10 10:51:57', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1195, 20, 'H5 网页', '20', 'terminal', 0, 'default', '', '终端 - H5 网页', '1', '2022-12-10 10:51:30', '1', '2022-12-10 10:51:59', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1196, 11, '微信公众号', '11', 'terminal', 0, 'default', '', '终端 - 微信公众号', '1', '2022-12-10 10:54:16', '1', '2022-12-10 10:52:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1197, 31, '苹果 App', '31', 'terminal', 0, 'default', '', '终端 - 苹果 App', '1', '2022-12-10 10:54:42', '1', '2022-12-10 10:52:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1198, 32, '安卓 App', '32', 'terminal', 0, 'default', '', '终端 - 安卓 App', '1', '2022-12-10 10:55:02', '1', '2022-12-10 10:59:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1199, 0, '普通订单', '0', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 普通订单', '1', '2022-12-10 16:34:14', '1', '2022-12-10 16:34:14', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1200, 1, '秒杀订单', '1', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 秒杀订单', '1', '2022-12-10 16:34:26', '1', '2022-12-10 16:34:26', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1201, 2, '砍价订单', '2', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 拼团订单', '1', '2022-12-10 16:34:36', '1', '2024-09-07 14:18:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1202, 3, '拼团订单', '3', 'trade_order_type', 0, 'default', '', '交易订单的类型 - 砍价订单', '1', '2022-12-10 16:34:48', '1', '2024-09-07 14:18:32', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1203, 0, '待支付', '0', 'trade_order_status', 0, 'default', '', '交易订单状态 - 待支付', '1', '2022-12-10 16:49:29', '1', '2022-12-10 16:49:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1204, 10, '待发货', '10', 'trade_order_status', 0, 'primary', '', '交易订单状态 - 待发货', '1', '2022-12-10 16:49:53', '1', '2022-12-10 16:51:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1205, 20, '已发货', '20', 'trade_order_status', 0, 'primary', '', '交易订单状态 - 已发货', '1', '2022-12-10 16:50:13', '1', '2022-12-10 16:51:31', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1206, 30, '已完成', '30', 'trade_order_status', 0, 'success', '', '交易订单状态 - 已完成', '1', '2022-12-10 16:50:30', '1', '2022-12-10 16:51:06', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1207, 40, '已取消', '40', 'trade_order_status', 0, 'danger', '', '交易订单状态 - 已取消', '1', '2022-12-10 16:50:50', '1', '2022-12-10 16:51:00', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1208, 0, '未售后', '0', 'trade_order_item_after_sale_status', 0, 'info', '', '交易订单项的售后状态 - 未售后', '1', '2022-12-10 20:58:42', '1', '2022-12-10 20:59:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1209, 10, '售后中', '10', 'trade_order_item_after_sale_status', 0, 'primary', '', '交易订单项的售后状态 - 售后中', '1', '2022-12-10 20:59:21', '1', '2024-07-21 17:01:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1210, 20, '已退款', '20', 'trade_order_item_after_sale_status', 0, 'success', '', '交易订单项的售后状态 - 已退款', '1', '2022-12-10 20:59:46', '1', '2024-07-21 17:01:35', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1211, 1, '完全匹配', '1', 'mp_auto_reply_request_match', 0, 'primary', '', '公众号自动回复的请求关键字匹配模式 - 完全匹配', '1', '2023-01-16 23:30:39', '1', '2023-01-16 23:31:00', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1212, 2, '半匹配', '2', 'mp_auto_reply_request_match', 0, 'success', '', '公众号自动回复的请求关键字匹配模式 - 半匹配', '1', '2023-01-16 23:30:55', '1', '2023-01-16 23:31:10', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1213, 1, '文本', 'text', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 文本', '1', '2023-01-17 22:17:32', '1', '2023-01-17 22:17:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1214, 2, '图片', 'image', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 图片', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:19:47', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1215, 3, '语音', 'voice', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 语音', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:20:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1216, 4, '视频', 'video', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 视频', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:21:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1217, 5, '小视频', 'shortvideo', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 小视频', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:19:59', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1218, 6, '图文', 'news', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 图文', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:22:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1219, 7, '音乐', 'music', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 音乐', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:22:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1220, 8, '地理位置', 'location', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 地理位置', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:23:51', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1221, 9, '链接', 'link', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 链接', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:24:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1222, 10, '事件', 'event', 'mp_message_type', 0, 'default', '', '公众号的消息类型 - 事件', '1', '2023-01-17 22:17:32', '1', '2023-01-17 14:24:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1223, 0, '初始化', '0', 'system_mail_send_status', 0, 'primary', '', '邮件发送状态 - 初始化\n', '1', '2023-01-26 09:53:49', '1', '2023-01-26 16:36:14', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1224, 10, '发送成功', '10', 'system_mail_send_status', 0, 'success', '', '邮件发送状态 - 发送成功', '1', '2023-01-26 09:54:28', '1', '2023-01-26 16:36:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1225, 20, '发送失败', '20', 'system_mail_send_status', 0, 'danger', '', '邮件发送状态 - 发送失败', '1', '2023-01-26 09:54:50', '1', '2023-01-26 16:36:26', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1226, 30, '不发送', '30', 'system_mail_send_status', 0, 'info', '', '邮件发送状态 -  不发送', '1', '2023-01-26 09:55:06', '1', '2023-01-26 16:36:36', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1227, 1, '通知公告', '1', 'system_notify_template_type', 0, 'primary', '', '站内信模版的类型 - 通知公告', '1', '2023-01-28 10:35:59', '1', '2023-01-28 10:35:59', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1228, 2, '系统消息', '2', 'system_notify_template_type', 0, 'success', '', '站内信模版的类型 - 系统消息', '1', '2023-01-28 10:36:20', '1', '2023-01-28 10:36:25', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1230, 13, '支付宝条码支付', 'alipay_bar', 'pay_channel_code', 0, 'primary', '', '支付宝条码支付', '1', '2023-02-18 23:32:24', '1', '2023-07-19 20:09:23', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1231, 10, 'Vue2 Element UI 标准模版', '10', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:03:55', '1', '2023-04-13 00:03:55', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1232, 20, 'Vue3 Element Plus 标准模版', '20', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:08', '1', '2023-04-13 00:04:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1234, 30, 'Vben2.0 Ant Design Schema 模版', '30', 'infra_codegen_front_type', 0, '', '', '', '1', '2023-04-13 00:04:26', '1', '2025-04-23 21:27:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1244, 0, '按件', '1', 'trade_delivery_express_charge_mode', 0, '', '', '', '1', '2023-05-21 22:46:40', '1', '2023-05-21 22:46:40', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1245, 1, '按重量', '2', 'trade_delivery_express_charge_mode', 0, '', '', '', '1', '2023-05-21 22:46:58', '1', '2023-05-21 22:46:58', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1246, 2, '按体积', '3', 'trade_delivery_express_charge_mode', 0, '', '', '', '1', '2023-05-21 22:47:18', '1', '2023-05-21 22:47:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1335, 11, '订单积分抵扣', '11', 'member_point_biz_type', 0, '', '', '', '1', '2023-06-10 12:15:27', '1', '2023-10-11 07:41:43', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1336, 1, '签到', '1', 'member_point_biz_type', 0, '', '', '', '1', '2023-06-10 12:15:48', '1', '2023-08-20 11:59:53', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1341, 20, '已退款', '20', 'pay_order_status', 0, 'danger', '', '已退款', '1', '2023-07-19 18:05:37', '1', '2023-07-19 18:05:37', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1342, 21, '请求成功，但是结果失败', '21', 'pay_notify_status', 0, 'warning', '', '请求成功，但是结果失败', '1', '2023-07-19 18:10:47', '1', '2023-07-19 18:11:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1343, 22, '请求失败', '22', 'pay_notify_status', 0, 'warning', '', NULL, '1', '2023-07-19 18:11:05', '1', '2023-07-19 18:11:27', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1344, 4, '微信扫码支付', 'wx_native', 'pay_channel_code', 0, 'success', '', '微信扫码支付', '1', '2023-07-19 20:07:47', '1', '2023-07-19 20:09:03', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1345, 5, '微信条码支付', 'wx_bar', 'pay_channel_code', 0, 'success', '', '微信条码支付\n', '1', '2023-07-19 20:08:06', '1', '2023-07-19 20:09:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1346, 1, '支付单', '1', 'pay_notify_type', 0, 'primary', '', '支付单', '1', '2023-07-20 12:23:17', '1', '2023-07-20 12:23:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1347, 2, '退款单', '2', 'pay_notify_type', 0, 'danger', '', NULL, '1', '2023-07-20 12:23:26', '1', '2023-07-20 12:23:26', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1348, 20, '模拟支付', 'mock', 'pay_channel_code', 0, 'default', '', '模拟支付', '1', '2023-07-29 11:10:51', '1', '2023-07-29 03:14:10', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1349, 12, '订单积分抵扣（整单取消）', '12', 'member_point_biz_type', 0, '', '', '', '1', '2023-08-20 12:00:03', '1', '2023-10-11 07:42:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1350, 0, '管理员调整', '0', 'member_experience_biz_type', 0, '', '', NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1351, 1, '邀新奖励', '1', 'member_experience_biz_type', 0, '', '', NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1352, 11, '下单奖励', '11', 'member_experience_biz_type', 0, 'success', '', NULL, '', '2023-08-22 12:41:01', '1', '2023-10-11 07:45:09', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1353, 12, '下单奖励（整单取消）', '12', 'member_experience_biz_type', 0, 'warning', '', NULL, '', '2023-08-22 12:41:01', '1', '2023-10-11 07:45:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1354, 4, '签到奖励', '4', 'member_experience_biz_type', 0, '', '', NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1355, 5, '抽奖奖励', '5', 'member_experience_biz_type', 0, '', '', NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1356, 1, '快递发货', '1', 'trade_delivery_type', 0, '', '', '', '1', '2023-08-23 00:04:55', '1', '2023-08-23 00:04:55', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1357, 2, '用户自提', '2', 'trade_delivery_type', 0, '', '', '', '1', '2023-08-23 00:05:05', '1', '2023-08-23 00:05:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1358, 3, '品类劵', '3', 'promotion_product_scope', 0, 'default', '', '', '1', '2023-09-01 23:43:07', '1', '2023-09-28 00:27:47', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1359, 1, '人人分销', '1', 'brokerage_enabled_condition', 0, '', '', '所有用户都可以分销', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1360, 2, '指定分销', '2', 'brokerage_enabled_condition', 0, '', '', '仅可后台手动设置推广员', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1361, 1, '首次绑定', '1', 'brokerage_bind_mode', 0, '', '', '只要用户没有推广人，随时都可以绑定推广关系', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1362, 2, '注册绑定', '2', 'brokerage_bind_mode', 0, '', '', '仅新用户注册时才能绑定推广关系', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1363, 3, '覆盖绑定', '3', 'brokerage_bind_mode', 0, '', '', '如果用户已经有推广人，推广人会被变更', '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1364, 1, '钱包', '1', 'brokerage_withdraw_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1365, 2, '银行卡', '2', 'brokerage_withdraw_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1366, 3, '微信收款码', '3', 'brokerage_withdraw_type', 0, '', '', '手动打款', '', '2023-09-28 02:46:05', '1', '2025-05-10 08:24:25', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1367, 4, '支付宝收款码', '4', 'brokerage_withdraw_type', 0, '', '', '手动打款', '', '2023-09-28 02:46:05', '1', '2025-05-10 08:24:37', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1368, 1, '订单返佣', '1', 'brokerage_record_biz_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1369, 2, '申请提现', '2', 'brokerage_record_biz_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1370, 3, '申请提现驳回', '3', 'brokerage_record_biz_type', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1371, 0, '待结算', '0', 'brokerage_record_status', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1372, 1, '已结算', '1', 'brokerage_record_status', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1373, 2, '已取消', '2', 'brokerage_record_status', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1374, 0, '审核中', '0', 'brokerage_withdraw_status', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1375, 10, '审核通过', '10', 'brokerage_withdraw_status', 0, 'success', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1376, 11, '提现成功', '11', 'brokerage_withdraw_status', 0, 'success', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1377, 20, '审核不通过', '20', 'brokerage_withdraw_status', 0, 'danger', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1378, 21, '提现失败', '21', 'brokerage_withdraw_status', 0, 'danger', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1379, 0, '工商银行', '0', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1380, 1, '建设银行', '1', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1381, 2, '农业银行', '2', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1382, 3, '中国银行', '3', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1383, 4, '交通银行', '4', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1384, 5, '招商银行', '5', 'brokerage_bank_name', 0, '', '', NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1385, 21, '钱包', 'wallet', 'pay_channel_code', 0, 'primary', '', '', '1', '2023-10-01 21:46:19', '1', '2023-10-01 21:48:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1386, 1, '砍价中', '1', 'promotion_bargain_record_status', 0, 'default', '', '', '1', '2023-10-05 10:41:26', '1', '2023-10-05 10:41:26', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1387, 2, '砍价成功', '2', 'promotion_bargain_record_status', 0, 'success', '', '', '1', '2023-10-05 10:41:39', '1', '2023-10-05 10:41:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1388, 3, '砍价失败', '3', 'promotion_bargain_record_status', 0, 'warning', '', '', '1', '2023-10-05 10:41:57', '1', '2023-10-05 10:41:57', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1389, 0, '拼团中', '0', 'promotion_combination_record_status', 0, '', '', '', '1', '2023-10-08 07:24:44', '1', '2024-10-13 10:08:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1390, 1, '拼团成功', '1', 'promotion_combination_record_status', 0, 'success', '', '', '1', '2023-10-08 07:24:56', '1', '2024-10-13 10:08:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1391, 2, '拼团失败', '2', 'promotion_combination_record_status', 0, 'warning', '', '', '1', '2023-10-08 07:25:11', '1', '2024-10-13 10:08:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1392, 2, '管理员修改', '2', 'member_point_biz_type', 0, 'default', '', '', '1', '2023-10-11 07:41:34', '1', '2023-10-11 07:41:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1393, 13, '订单积分抵扣（单个退款）', '13', 'member_point_biz_type', 0, '', '', '', '1', '2023-10-11 07:42:29', '1', '2023-10-11 07:42:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1394, 21, '订单积分奖励', '21', 'member_point_biz_type', 0, 'default', '', '', '1', '2023-10-11 07:42:44', '1', '2023-10-11 07:42:44', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1395, 22, '订单积分奖励（整单取消）', '22', 'member_point_biz_type', 0, 'default', '', '', '1', '2023-10-11 07:42:55', '1', '2023-10-11 07:43:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1396, 23, '订单积分奖励（单个退款）', '23', 'member_point_biz_type', 0, 'default', '', '', '1', '2023-10-11 07:43:16', '1', '2023-10-11 07:43:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1397, 13, '下单奖励（单个退款）', '13', 'member_experience_biz_type', 0, 'warning', '', '', '1', '2023-10-11 07:45:24', '1', '2023-10-11 07:45:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1398, 5, '网上转账', '5', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:55:24', '1', '2023-10-18 21:55:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1399, 6, '支付宝', '6', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:55:38', '1', '2023-10-18 21:55:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1400, 7, '微信支付', '7', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:55:53', '1', '2023-10-18 21:55:53', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1401, 8, '其他', '8', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:56:06', '1', '2023-10-18 21:56:06', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1402, 1, 'IT', '1', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:02:15', '1', '2024-02-18 23:30:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1403, 2, '金融业', '2', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:02:29', '1', '2024-02-18 23:30:43', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1404, 3, '房地产', '3', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:02:41', '1', '2024-02-18 23:30:48', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1405, 4, '商业服务', '4', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:02:54', '1', '2024-02-18 23:30:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1406, 5, '运输/物流', '5', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:03:03', '1', '2024-02-18 23:31:00', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1407, 6, '生产', '6', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:03:13', '1', '2024-02-18 23:31:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1408, 7, '政府', '7', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:03:27', '1', '2024-02-18 23:31:13', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1409, 8, '文化传媒', '8', 'crm_customer_industry', 0, 'default', '', '', '1', '2023-10-28 23:03:37', '1', '2024-02-18 23:31:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1422, 1, 'A （重点客户）', '1', 'crm_customer_level', 0, 'primary', '', '', '1', '2023-10-28 23:07:13', '1', '2023-10-28 23:07:13', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1423, 2, 'B （普通客户）', '2', 'crm_customer_level', 0, 'info', '', '', '1', '2023-10-28 23:07:35', '1', '2023-10-28 23:07:35', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1424, 3, 'C （非优先客户）', '3', 'crm_customer_level', 0, 'default', '', '', '1', '2023-10-28 23:07:53', '1', '2023-10-28 23:07:53', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1425, 1, '促销', '1', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:08:29', '1', '2023-10-28 23:08:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1426, 2, '搜索引擎', '2', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:08:39', '1', '2023-10-28 23:08:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1427, 3, '广告', '3', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:08:47', '1', '2023-10-28 23:08:47', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1428, 4, '转介绍', '4', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:08:58', '1', '2023-10-28 23:08:58', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1429, 5, '线上注册', '5', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:09:12', '1', '2023-10-28 23:09:12', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1430, 6, '线上咨询', '6', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:09:22', '1', '2023-10-28 23:09:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1431, 7, '预约上门', '7', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:09:39', '1', '2023-10-28 23:09:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1432, 8, '陌拜', '8', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:10:04', '1', '2023-10-28 23:10:04', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1433, 9, '电话咨询', '9', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:10:18', '1', '2023-10-28 23:10:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1434, 10, '邮件咨询', '10', 'crm_customer_source', 0, 'default', '', '', '1', '2023-10-28 23:10:33', '1', '2023-10-28 23:10:33', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1435, 10, 'Gitee', '10', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:04:42', '1', '2023-11-04 13:04:42', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1436, 20, '钉钉', '20', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:04:54', '1', '2023-11-04 13:04:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1437, 30, '企业微信', '30', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:05:09', '1', '2023-11-04 13:05:09', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1438, 31, '微信公众平台', '31', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:05:18', '1', '2023-11-04 13:05:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1439, 32, '微信开放平台', '32', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:05:30', '1', '2023-11-04 13:05:30', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1440, 34, '微信小程序', '34', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:05:38', '1', '2023-11-04 13:07:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1441, 1, '上架', '1', 'crm_product_status', 0, 'success', '', '', '1', '2023-10-30 21:49:34', '1', '2023-10-30 21:49:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1442, 0, '下架', '0', 'crm_product_status', 0, 'success', '', '', '1', '2023-10-30 21:49:13', '1', '2023-10-30 21:49:13', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1443, 15, '子表', '15', 'infra_codegen_template_type', 0, 'default', '', '', '1', '2023-11-13 23:06:16', '1', '2023-11-13 23:06:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1444, 10, '主表（标准模式）', '10', 'infra_codegen_template_type', 0, 'default', '', '', '1', '2023-11-14 12:32:49', '1', '2023-11-14 12:32:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1445, 11, '主表（ERP 模式）', '11', 'infra_codegen_template_type', 0, 'default', '', '', '1', '2023-11-14 12:33:05', '1', '2023-11-14 12:33:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1446, 12, '主表（内嵌模式）', '12', 'infra_codegen_template_type', 0, '', '', '', '1', '2023-11-14 12:33:31', '1', '2023-11-14 12:33:31', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1447, 1, '负责人', '1', 'crm_permission_level', 0, 'default', '', '', '1', '2023-11-30 09:53:12', '1', '2023-11-30 09:53:12', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1448, 2, '只读', '2', 'crm_permission_level', 0, '', '', '', '1', '2023-11-30 09:53:29', '1', '2023-11-30 09:53:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1449, 3, '读写', '3', 'crm_permission_level', 0, '', '', '', '1', '2023-11-30 09:53:36', '1', '2023-11-30 09:53:36', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1450, 0, '未提交', '0', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:56:59', '1', '2023-11-30 18:56:59', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1451, 10, '审批中', '10', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:57:10', '1', '2023-11-30 18:57:10', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1452, 20, '审核通过', '20', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:57:24', '1', '2023-11-30 18:57:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1453, 30, '审核不通过', '30', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:57:32', '1', '2023-11-30 18:57:32', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1454, 40, '已取消', '40', 'crm_audit_status', 0, '', '', '', '1', '2023-11-30 18:57:42', '1', '2023-11-30 18:57:42', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1456, 1, '支票', '1', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:54:29', '1', '2023-10-18 21:54:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1457, 2, '现金', '2', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:54:41', '1', '2023-10-18 21:54:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1458, 3, '邮政汇款', '3', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:54:53', '1', '2023-10-18 21:54:53', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1459, 4, '电汇', '4', 'crm_receivable_return_type', 0, 'default', '', '', '1', '2023-10-18 21:55:07', '1', '2023-10-18 21:55:07', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1461, 1, '个', '1', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:02:26', '1', '2023-12-05 23:02:26', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1462, 2, '块', '2', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:02:34', '1', '2023-12-05 23:02:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1463, 3, '只', '3', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:02:57', '1', '2023-12-05 23:02:57', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1464, 4, '把', '4', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:05', '1', '2023-12-05 23:03:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1465, 5, '枚', '5', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:14', '1', '2023-12-05 23:03:14', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1466, 6, '瓶', '6', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:20', '1', '2023-12-05 23:03:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1467, 7, '盒', '7', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:30', '1', '2023-12-05 23:03:30', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1468, 8, '台', '8', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:41', '1', '2023-12-05 23:03:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1469, 9, '吨', '9', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:03:48', '1', '2023-12-05 23:03:48', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1470, 10, '千克', '10', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:04:03', '1', '2023-12-05 23:04:03', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1471, 11, '米', '11', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:04:12', '1', '2023-12-05 23:04:12', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1472, 12, '箱', '12', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:04:25', '1', '2023-12-05 23:04:25', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1473, 13, '套', '13', 'crm_product_unit', 0, '', '', '', '1', '2023-12-05 23:04:34', '1', '2023-12-05 23:04:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1474, 1, '打电话', '1', 'crm_follow_up_type', 0, '', '', '', '1', '2024-01-15 20:48:20', '1', '2024-01-15 20:48:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1475, 2, '发短信', '2', 'crm_follow_up_type', 0, '', '', '', '1', '2024-01-15 20:48:31', '1', '2024-01-15 20:48:31', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1476, 3, '上门拜访', '3', 'crm_follow_up_type', 0, '', '', '', '1', '2024-01-15 20:49:07', '1', '2024-01-15 20:49:07', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1477, 4, '微信沟通', '4', 'crm_follow_up_type', 0, '', '', '', '1', '2024-01-15 20:49:15', '1', '2024-01-15 20:49:15', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1482, 4, '转账失败', '20', 'pay_transfer_status', 0, 'warning', '', '', '1', '2023-10-28 16:24:16', '1', '2025-05-08 12:59:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1483, 3, '转账成功', '10', 'pay_transfer_status', 0, 'success', '', '', '1', '2023-10-28 16:23:50', '1', '2025-05-08 12:58:58', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1484, 2, '转账进行中', '5', 'pay_transfer_status', 0, 'info', '', '', '1', '2023-10-28 16:23:12', '1', '2025-05-08 12:58:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1485, 1, '等待转账', '0', 'pay_transfer_status', 0, 'default', '', '', '1', '2023-10-28 16:21:43', '1', '2023-10-28 16:23:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1486, 10, '其它入库', '10', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-05 18:07:25', '1', '2024-02-05 18:07:43', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1487, 11, '其它入库（作废）', '11', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-05 18:08:07', '1', '2024-02-05 19:20:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1488, 20, '其它出库', '20', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-05 18:08:51', '1', '2024-02-05 18:08:51', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1489, 21, '其它出库（作废）', '21', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-05 18:09:00', '1', '2024-02-05 19:20:10', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1490, 10, '未审核', '10', 'erp_audit_status', 0, 'default', '', '', '1', '2024-02-06 00:00:21', '1', '2024-02-06 00:00:21', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1491, 20, '已审核', '20', 'erp_audit_status', 0, 'success', '', '', '1', '2024-02-06 00:00:35', '1', '2024-02-06 00:00:35', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1492, 30, '调拨入库', '30', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-07 20:34:19', '1', '2024-02-07 12:36:31', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1493, 31, '调拨入库（作废）', '31', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-07 20:34:29', '1', '2024-02-07 20:37:11', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1494, 32, '调拨出库', '32', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-07 20:34:38', '1', '2024-02-07 12:36:33', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1495, 33, '调拨出库（作废）', '33', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-07 20:34:49', '1', '2024-02-07 20:37:06', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1496, 40, '盘盈入库', '40', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-08 08:53:00', '1', '2024-02-08 08:53:09', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1497, 41, '盘盈入库（作废）', '41', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-08 08:53:39', '1', '2024-02-16 19:40:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1498, 42, '盘亏出库', '42', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-08 08:54:16', '1', '2024-02-08 08:54:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1499, 43, '盘亏出库（作废）', '43', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-08 08:54:31', '1', '2024-02-16 19:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1500, 50, '销售出库', '50', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-11 21:47:25', '1', '2024-02-11 21:50:40', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1501, 51, '销售出库（作废）', '51', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-11 21:47:37', '1', '2024-02-11 21:51:12', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1502, 60, '销售退货入库', '60', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-12 06:51:05', '1', '2024-02-12 06:51:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1503, 61, '销售退货入库（作废）', '61', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-12 06:51:18', '1', '2024-02-12 06:51:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1504, 70, '采购入库', '70', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-16 13:10:02', '1', '2024-02-16 13:10:02', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1505, 71, '采购入库（作废）', '71', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-16 13:10:10', '1', '2024-02-16 19:40:40', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1506, 80, '采购退货出库', '80', 'erp_stock_record_biz_type', 0, '', '', '', '1', '2024-02-16 13:10:17', '1', '2024-02-16 13:10:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1507, 81, '采购退货出库（作废）', '81', 'erp_stock_record_biz_type', 0, 'danger', '', '', '1', '2024-02-16 13:10:26', '1', '2024-02-16 19:40:33', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1509, 3, '审批不通过', '3', 'bpm_process_instance_status', 0, 'danger', '', '', '1', '2024-03-16 16:12:06', '1', '2024-03-16 16:12:06', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1510, 4, '已取消', '4', 'bpm_process_instance_status', 0, 'warning', '', '', '1', '2024-03-16 16:12:22', '1', '2024-03-16 16:12:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1511, 5, '已退回', '5', 'bpm_task_status', 0, 'warning', '', '', '1', '2024-03-16 19:10:46', '1', '2024-03-08 22:41:40', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1512, 6, '委派中', '6', 'bpm_task_status', 0, 'primary', '', '', '1', '2024-03-17 10:06:22', '1', '2024-03-08 22:41:40', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1513, 7, '审批通过中', '7', 'bpm_task_status', 0, 'success', '', '', '1', '2024-03-17 10:06:47', '1', '2024-03-08 22:41:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1514, 0, '待审批', '0', 'bpm_task_status', 0, 'info', '', '', '1', '2024-03-17 10:07:11', '1', '2024-03-08 22:41:42', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1515, 35, '发起人自选', '35', 'bpm_task_candidate_strategy', 0, '', '', '', '1', '2024-03-22 19:45:16', '1', '2024-03-22 19:45:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1516, 1, '执行监听器', 'execution', 'bpm_process_listener_type', 0, 'primary', '', '', '1', '2024-03-23 12:54:03', '1', '2024-03-23 19:14:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1517, 1, '任务监听器', 'task', 'bpm_process_listener_type', 0, 'success', '', '', '1', '2024-03-23 12:54:13', '1', '2024-03-23 19:14:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1526, 1, 'Java 类', 'class', 'bpm_process_listener_value_type', 0, 'primary', '', '', '1', '2024-03-23 15:08:45', '1', '2024-03-23 19:14:32', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1527, 2, '表达式', 'expression', 'bpm_process_listener_value_type', 0, 'success', '', '', '1', '2024-03-23 15:09:06', '1', '2024-03-23 19:14:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1528, 3, '代理表达式', 'delegateExpression', 'bpm_process_listener_value_type', 0, 'info', '', '', '1', '2024-03-23 15:11:23', '1', '2024-03-23 19:14:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1529, 1, '天', '1', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:50:26', '1', '2024-03-29 22:50:26', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1530, 2, '周', '2', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:50:36', '1', '2024-03-29 22:50:36', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1531, 3, '月', '3', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:50:46', '1', '2024-03-29 22:50:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1532, 4, '季度', '4', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:51:01', '1', '2024-03-29 22:51:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1533, 5, '年', '5', 'date_interval', 0, '', '', '', '1', '2024-03-29 22:51:07', '1', '2024-03-29 22:51:07', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1534, 1, '赢单', '1', 'crm_business_end_status_type', 0, 'success', '', '', '1', '2024-04-13 23:26:57', '1', '2024-04-13 23:26:57', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1535, 2, '输单', '2', 'crm_business_end_status_type', 0, 'primary', '', '', '1', '2024-04-13 23:27:31', '1', '2024-04-13 23:27:31', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1536, 3, '无效', '3', 'crm_business_end_status_type', 0, 'info', '', '', '1', '2024-04-13 23:27:59', '1', '2024-04-13 23:27:59', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1537, 1, 'OpenAI', 'OpenAI', 'ai_platform', 0, '', '', '', '1', '2024-05-09 22:33:47', '1', '2024-05-09 22:58:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1538, 2, 'Ollama', 'Ollama', 'ai_platform', 0, '', '', '', '1', '2024-05-17 23:02:55', '1', '2024-05-17 23:02:55', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1539, 3, '文心一言', 'YiYan', 'ai_platform', 0, '', '', '', '1', '2024-05-18 09:24:20', '1', '2024-05-18 09:29:01', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1540, 4, '讯飞星火', 'XingHuo', 'ai_platform', 0, '', '', '', '1', '2024-05-18 10:08:56', '1', '2024-05-18 10:08:56', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1541, 5, '通义千问', 'TongYi', 'ai_platform', 0, '', '', '', '1', '2024-05-18 10:32:29', '1', '2024-07-06 15:42:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1542, 6, 'StableDiffusion', 'StableDiffusion', 'ai_platform', 0, '', '', '', '1', '2024-06-01 15:09:31', '1', '2024-06-01 15:10:25', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1543, 10, '进行中', '10', 'ai_image_status', 0, 'primary', '', '', '1', '2024-06-26 20:51:41', '1', '2024-06-26 20:52:48', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1544, 20, '已完成', '20', 'ai_image_status', 0, 'success', '', '', '1', '2024-06-26 20:52:07', '1', '2024-06-26 20:52:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1545, 30, '已失败', '30', 'ai_image_status', 0, 'warning', '', '', '1', '2024-06-26 20:52:25', '1', '2024-06-26 20:52:35', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1546, 7, 'Midjourney', 'Midjourney', 'ai_platform', 0, '', '', '', '1', '2024-06-26 22:14:46', '1', '2024-06-26 22:14:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1547, 10, '进行中', '10', 'ai_music_status', 0, 'primary', '', '', '1', '2024-06-27 22:45:22', '1', '2024-06-28 00:56:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1548, 20, '已完成', '20', 'ai_music_status', 0, 'success', '', '', '1', '2024-06-27 22:45:33', '1', '2024-06-28 00:56:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1549, 30, '已失败', '30', 'ai_music_status', 0, 'danger', '', '', '1', '2024-06-27 22:45:44', '1', '2024-06-28 00:56:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1550, 1, '歌词模式', '1', 'ai_generate_mode', 0, '', '', '', '1', '2024-06-27 22:46:31', '1', '2024-06-28 01:22:25', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1551, 2, '描述模式', '2', 'ai_generate_mode', 0, '', '', '', '1', '2024-06-27 22:46:37', '1', '2024-06-28 01:22:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1552, 8, 'Suno', 'Suno', 'ai_platform', 0, '', '', '', '1', '2024-06-29 09:13:36', '1', '2024-06-29 09:13:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1553, 9, 'DeepSeek', 'DeepSeek', 'ai_platform', 0, '', '', '', '1', '2024-07-06 12:04:30', '1', '2024-07-06 12:05:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1554, 13, '智谱', 'ZhiPu', 'ai_platform', 0, '', '', '', '1', '2024-07-06 18:00:35', '1', '2025-02-24 20:18:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1555, 4, '长', '4', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:49:03', '1', '2024-07-07 15:49:03', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1556, 5, '段落', '5', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:49:54', '1', '2024-07-07 15:49:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1557, 6, '文章', '6', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:50:05', '1', '2024-07-07 15:50:05', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1558, 7, '博客文章', '7', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:50:23', '1', '2024-07-07 15:50:23', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1559, 8, '想法', '8', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:50:31', '1', '2024-07-07 15:50:31', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1560, 9, '大纲', '9', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:50:37', '1', '2024-07-07 15:50:37', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1561, 1, '自动', '1', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:06', '1', '2024-07-07 15:51:06', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1562, 2, '友善', '2', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:19', '1', '2024-07-07 15:51:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1563, 3, '随意', '3', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:27', '1', '2024-07-07 15:51:27', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1564, 4, '友好', '4', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:37', '1', '2024-07-07 15:51:37', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1565, 5, '专业', '5', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:51:49', '1', '2024-07-07 15:52:02', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1566, 6, '诙谐', '6', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:52:15', '1', '2024-07-07 15:52:15', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1567, 7, '有趣', '7', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:52:24', '1', '2024-07-07 15:52:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1568, 8, '正式', '8', 'ai_write_tone', 0, '', '', '', '1', '2024-07-07 15:54:33', '1', '2024-07-07 15:54:33', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1569, 5, '段落', '5', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:49:54', '1', '2024-07-07 15:49:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1570, 1, '自动', '1', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:19:34', '1', '2024-07-07 15:19:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1571, 2, '电子邮件', '2', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:19:50', '1', '2024-07-07 15:49:30', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1572, 3, '消息', '3', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:20:01', '1', '2024-07-07 15:49:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1573, 4, '评论', '4', 'ai_write_format', 0, '', '', '', '1', '2024-07-07 15:20:13', '1', '2024-07-07 15:49:45', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1574, 1, '自动', '1', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:44:18', '1', '2024-07-07 15:44:18', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1575, 2, '中文', '2', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:44:28', '1', '2024-07-07 15:44:28', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1576, 3, '英文', '3', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:44:37', '1', '2024-07-07 15:44:37', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1577, 4, '韩语', '4', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:46:28', '1', '2024-07-07 15:46:28', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1578, 5, '日语', '5', 'ai_write_language', 0, '', '', '', '1', '2024-07-07 15:46:44', '1', '2024-07-07 15:46:44', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1579, 1, '自动', '1', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:48:34', '1', '2024-07-07 15:48:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1580, 2, '短', '2', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:48:44', '1', '2024-07-07 15:48:44', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1581, 3, '中等', '3', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:48:52', '1', '2024-07-07 15:48:52', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1582, 4, '长', '4', 'ai_write_length', 0, '', '', '', '1', '2024-07-07 15:49:03', '1', '2024-07-07 15:49:03', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1584, 1, '撰写', '1', 'ai_write_type', 0, '', '', '', '1', '2024-07-10 21:26:00', '1', '2024-07-10 21:26:00', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1585, 2, '回复', '2', 'ai_write_type', 0, '', '', '', '1', '2024-07-10 21:26:06', '1', '2024-07-10 21:26:06', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1586, 2, '腾讯云', 'TENCENT', 'system_sms_channel_code', 0, '', '', '', '1', '2024-07-22 22:23:16', '1', '2024-07-22 22:23:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1587, 3, '华为云', 'HUAWEI', 'system_sms_channel_code', 0, '', '', '', '1', '2024-07-22 22:23:46', '1', '2024-07-22 22:23:53', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1588, 1, 'OpenAI 微软', 'AzureOpenAI', 'ai_platform', 0, '', '', '', '1', '2024-08-10 14:07:41', '1', '2024-08-10 14:07:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1589, 10, 'BPMN 设计器', '10', 'bpm_model_type', 0, 'primary', '', '', '1', '2024-08-26 15:22:17', '1', '2024-08-26 16:46:02', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1590, 20, 'SIMPLE 设计器', '20', 'bpm_model_type', 0, 'success', '', '', '1', '2024-08-26 15:22:27', '1', '2024-08-26 16:45:58', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1591, 4, '七牛云', 'QINIU', 'system_sms_channel_code', 0, '', '', '', '1', '2024-08-31 08:45:03', '1', '2024-08-31 08:45:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1592, 3, '新人券', '3', 'promotion_coupon_take_type', 0, 'info', '', '新人注册后，自动发放', '1', '2024-09-03 11:57:16', '1', '2024-09-03 11:57:28', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1593, 5, '微信零钱', '5', 'brokerage_withdraw_type', 0, '', '', 'API 打款', '1', '2024-10-13 11:06:48', '1', '2025-05-10 08:24:55', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1683, 10, '字节豆包', 'DouBao', 'ai_platform', 0, '', '', '', '1', '2025-02-23 19:51:40', '1', '2025-02-23 19:52:02', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1684, 11, '腾讯混元', 'HunYuan', 'ai_platform', 0, '', '', '', '1', '2025-02-23 20:58:04', '1', '2025-02-23 20:58:04', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1685, 12, '硅基流动', 'SiliconFlow', 'ai_platform', 0, '', '', '', '1', '2025-02-24 20:19:09', '1', '2025-02-24 20:19:09', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1686, 1, '聊天', '1', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:26:34', '1', '2025-03-03 12:26:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1687, 2, '图像', '2', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:27:23', '1', '2025-03-03 12:27:23', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1688, 3, '音频', '3', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:27:51', '1', '2025-03-03 12:27:51', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1689, 4, '视频', '4', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:28:03', '1', '2025-03-03 12:28:03', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1690, 5, '向量', '5', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:28:15', '1', '2025-03-03 12:28:15', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1691, 6, '重排', '6', 'ai_model_type', 0, '', '', '', '1', '2025-03-03 12:28:26', '1', '2025-03-03 12:28:26', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1692, 14, 'MiniMax', 'MiniMax', 'ai_platform', 0, '', '', '', '1', '2025-03-11 20:04:51', '1', '2025-03-11 20:04:51', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (1693, 15, '月之暗面', 'Moonshot', 'ai_platform', 0, '', '', '', '1', '2025-03-11 20:05:08', '1', '2025-03-11 20:05:08', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2000, 0, '标准数据格式（JSON）', '0', 'iot_data_format', 0, 'default', '', '', '1', '2024-08-10 11:53:26', '1', '2025-03-17 09:28:16', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2001, 1, '透传/自定义', '1', 'iot_data_format', 0, 'default', '', '', '1', '2024-08-10 11:53:37', '1', '2025-03-17 09:28:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2002, 0, '直连设备', '0', 'iot_product_device_type', 0, 'default', '', '', '1', '2024-08-10 11:54:58', '1', '2025-03-17 09:28:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2003, 2, '网关设备', '2', 'iot_product_device_type', 0, 'default', '', '', '1', '2024-08-10 11:55:08', '1', '2025-03-17 09:28:28', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2004, 1, '网关子设备', '1', 'iot_product_device_type', 0, 'default', '', '', '1', '2024-08-10 11:55:20', '1', '2025-03-17 09:28:31', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2005, 1, '已发布', '1', 'iot_product_status', 0, 'success', '', '', '1', '2024-08-10 12:10:33', '1', '2025-03-17 09:28:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2006, 0, '开发中', '0', 'iot_product_status', 0, 'default', '', '', '1', '2024-08-10 14:19:18', '1', '2025-03-17 09:28:39', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2007, 0, '弱校验', '0', 'iot_validate_type', 0, '', '', '', '1', '2024-09-06 20:05:48', '1', '2025-03-17 09:28:41', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2008, 1, '免校验', '1', 'iot_validate_type', 0, '', '', '', '1', '2024-09-06 20:06:03', '1', '2025-03-17 09:28:44', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2009, 0, 'Wi-Fi', '0', 'iot_net_type', 0, '', '', '', '1', '2024-09-06 22:04:47', '1', '2025-03-17 09:28:47', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2010, 1, '蜂窝（2G / 3G / 4G / 5G）', '1', 'iot_net_type', 0, '', '', '', '1', '2024-09-06 22:05:14', '1', '2025-03-17 09:28:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2011, 2, '以太网', '2', 'iot_net_type', 0, '', '', '', '1', '2024-09-06 22:05:35', '1', '2025-03-17 09:28:51', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2012, 3, '其他', '3', 'iot_net_type', 0, '', '', '', '1', '2024-09-06 22:05:52', '1', '2025-03-17 09:28:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2013, 0, '自定义', '0', 'iot_protocol_type', 0, '', '', '', '1', '2024-09-06 22:26:10', '1', '2025-03-17 09:28:56', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2014, 1, 'Modbus', '1', 'iot_protocol_type', 0, '', '', '', '1', '2024-09-06 22:26:21', '1', '2025-03-17 09:28:58', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2015, 2, 'OPC UA', '2', 'iot_protocol_type', 0, '', '', '', '1', '2024-09-06 22:26:31', '1', '2025-03-17 09:29:00', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2016, 3, 'ZigBee', '3', 'iot_protocol_type', 0, '', '', '', '1', '2024-09-06 22:26:39', '1', '2025-03-17 09:29:04', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2017, 4, 'BLE', '4', 'iot_protocol_type', 0, '', '', '', '1', '2024-09-06 22:26:48', '1', '2025-03-17 09:29:06', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2018, 0, '未激活', '0', 'iot_device_state', 0, '', '', '', '1', '2024-09-21 08:13:34', '1', '2025-03-17 09:29:09', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2019, 1, '在线', '1', 'iot_device_state', 0, '', '', '', '1', '2024-09-21 08:13:48', '1', '2025-03-17 09:29:12', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2020, 2, '离线', '2', 'iot_device_state', 0, '', '', '', '1', '2024-09-21 08:13:59', '1', '2025-03-17 09:29:14', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2021, 1, '属性', '1', 'iot_thing_model_type', 0, '', '', '', '1', '2024-09-29 20:03:01', '1', '2025-03-17 09:29:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2022, 2, '服务', '2', 'iot_thing_model_type', 0, '', '', '', '1', '2024-09-29 20:03:11', '1', '2025-03-17 09:29:27', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2023, 3, '事件', '3', 'iot_thing_model_type', 0, '', '', '', '1', '2024-09-29 20:03:20', '1', '2025-03-17 09:29:29', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2024, 1, 'JAR 部署', '0', 'iot_plugin_deploy_type', 0, '', '', '', '1', '2024-12-13 10:55:32', '1', '2025-03-17 09:29:32', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2025, 2, '独立部署', '1', 'iot_plugin_deploy_type', 0, '', '', '', '1', '2024-12-13 10:55:43', '1', '2025-03-17 09:29:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2026, 0, '停止', '0', 'iot_plugin_status', 0, 'danger', '', '', '1', '2024-12-13 11:07:37', '1', '2025-03-17 09:29:37', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2027, 1, '运行', '1', 'iot_plugin_status', 0, '', '', '', '1', '2024-12-13 11:07:45', '1', '2025-03-17 09:34:17', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2028, 0, '普通插件', '0', 'iot_plugin_type', 0, '', '', '', '1', '2024-12-13 11:08:32', '1', '2025-03-17 09:34:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2029, 1, '设备插件', '1', 'iot_plugin_type', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2030, 1, '升每分钟', 'L/min', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2031, 2, '毫克每千克', 'mg/kg', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:27', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2032, 3, '浊度', 'NTU', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:31', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2033, 4, 'PH值', 'pH', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:36', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2034, 5, '土壤EC值', 'dS/m', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:34:43', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2035, 6, '太阳总辐射', 'W/㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:36:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2036, 7, '降雨量', 'mm/hour', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:36:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2037, 8, '乏', 'var', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:36:27', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2038, 9, '厘泊', 'cP', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:36:33', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2039, 10, '饱和度', 'aw', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:11', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2040, 11, '个', 'pcs', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:19', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2041, 12, '厘斯', 'cst', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:22', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2042, 13, '巴', 'bar', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2043, 14, '纳克每升', 'ppt', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:27', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2044, 15, '微克每升', 'ppb', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:31', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2045, 16, '微西每厘米', 'uS/cm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:34', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2046, 17, '牛顿每库仑', 'N/C', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:38', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2047, 18, '伏特每米', 'V/m', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:43', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2048, 19, '滴速', 'ml/min', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2049, 20, '毫米汞柱', 'mmHg', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:48', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2050, 21, '血糖', 'mmol/L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:37:54', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2051, 22, '毫米每秒', 'mm/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:02', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2052, 23, '转每分钟', 'turn/m', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:07', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2053, 24, '次', 'count', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:09', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2054, 25, '档', 'gear', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:11', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2055, 26, '步', 'stepCount', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:13', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2056, 27, '标准立方米每小时', 'Nm3/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:15', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2057, 28, '千伏', 'kV', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:20', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2058, 29, '千伏安', 'kVA', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:38:24', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2060, 30, '千乏', 'kVar', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2061, 31, '微瓦每平方厘米', 'uw/cm2', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2062, 32, '只', '只', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2063, 33, '相对湿度', '%RH', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2064, 34, '立方米每秒', 'm3/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2065, 35, '公斤每秒', 'kg/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2066, 36, '转每分钟', 'r/min', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2067, 37, '吨每小时', 't/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2068, 38, '千卡每小时', 'KCL/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2069, 39, '升每秒', 'L/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2070, 40, '兆帕', 'Mpa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2071, 41, '立方米每小时', 'm3/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2072, 42, '千乏时', 'kvarh', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2073, 43, '微克每升', 'μg/L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2074, 44, '千卡路里', 'kcal', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2075, 45, '吉字节', 'GB', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2076, 46, '兆字节', 'MB', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2077, 47, '千字节', 'KB', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2078, 48, '字节', 'B', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2079, 49, '微克每平方分米每天', 'μg/(d㎡·d)', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2080, 50, '无', '', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2081, 51, '百万分率', 'ppm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2082, 52, '像素', 'pixel', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2083, 53, '照度', 'Lux', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2084, 54, '重力加速度', 'grav', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2085, 55, '分贝', 'dB', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2086, 56, '百分比', '%', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2087, 57, '流明', 'lm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2088, 58, '比特', 'bit', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2089, 59, '克每毫升', 'g/mL', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2090, 60, '克每升', 'g/L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2091, 61, '毫克每升', 'mg/L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2092, 62, '微克每立方米', 'μg/m3', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2093, 63, '毫克每立方米', 'mg/m3', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2094, 64, '克每立方米', 'g/m3', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2095, 65, '千克每立方米', 'kg/m3', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2096, 66, '纳法', 'nF', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2097, 67, '皮法', 'pF', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2098, 68, '微法', 'μF', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2099, 69, '法拉', 'F', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2100, 70, '欧姆', 'Ω', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2101, 71, '微安', 'μA', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2102, 72, '毫安', 'mA', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2103, 73, '千安', 'kA', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2104, 74, '安培', 'A', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2105, 75, '毫伏', 'mV', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2106, 76, '伏特', 'V', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2107, 77, '毫秒', 'ms', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2108, 78, '秒', 's', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2109, 79, '分钟', 'min', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2110, 80, '小时', 'h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2111, 81, '日', 'day', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2112, 82, '周', 'week', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2113, 83, '月', 'month', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2114, 84, '年', 'year', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2115, 85, '节', 'kn', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2116, 86, '千米每小时', 'km/h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2117, 87, '米每秒', 'm/s', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2118, 88, '秒', '″', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2119, 89, '分', '′', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2120, 90, '度', '°', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2121, 91, '弧度', 'rad', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2122, 92, '赫兹', 'Hz', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2123, 93, '微瓦', 'μW', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2124, 94, '毫瓦', 'mW', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2125, 95, '千瓦特', 'kW', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2126, 96, '瓦特', 'W', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2127, 97, '卡路里', 'cal', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2128, 98, '千瓦时', 'kW·h', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2129, 99, '瓦时', 'Wh', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2130, 100, '电子伏', 'eV', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2131, 101, '千焦', 'kJ', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2132, 102, '焦耳', 'J', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2133, 103, '华氏度', '℉', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2134, 104, '开尔文', 'K', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2135, 105, '吨', 't', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2136, 106, '摄氏度', '°C', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2137, 107, '毫帕', 'mPa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2138, 108, '百帕', 'hPa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2139, 109, '千帕', 'kPa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2140, 110, '帕斯卡', 'Pa', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2141, 111, '毫克', 'mg', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2142, 112, '克', 'g', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2143, 113, '千克', 'kg', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2144, 114, '牛', 'N', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2145, 115, '毫升', 'mL', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2146, 116, '升', 'L', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2147, 117, '立方毫米', 'mm3', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2148, 118, '立方厘米', 'cm3', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2149, 119, '立方千米', 'km3', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2150, 120, '立方米', 'm3', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2151, 121, '公顷', 'h㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2152, 122, '平方厘米', 'c㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2153, 123, '平方毫米', 'm㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2154, 124, '平方千米', 'k㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2155, 125, '平方米', '㎡', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2156, 126, '纳米', 'nm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2157, 127, '微米', 'μm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2158, 128, '毫米', 'mm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2159, 129, '厘米', 'cm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2160, 130, '分米', 'dm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2161, 131, '千米', 'km', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2162, 132, '米', 'm', 'iot_thing_model_unit', 0, '', '', '', '1', '2024-12-13 11:08:41', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2163, 1, '输入', '1', 'iot_data_bridge_direction_enum', 0, 'primary', '', '', '1', '2025-03-09 12:38:24', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2164, 2, '输出', '2', 'iot_data_bridge_direction_enum', 0, 'primary', '', '', '1', '2025-03-09 12:38:36', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2165, 1, 'HTTP', '1', 'iot_data_bridge_type_enum', 0, 'primary', '', '', '1', '2025-03-09 12:39:54', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2166, 2, 'TCP', '2', 'iot_data_bridge_type_enum', 0, 'primary', '', '', '1', '2025-03-09 12:40:06', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2167, 3, 'WEBSOCKET', '3', 'iot_data_bridge_type_enum', 0, 'primary', '', '', '1', '2025-03-09 12:40:24', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2168, 10, 'MQTT', '10', 'iot_data_bridge_type_enum', 0, 'primary', '', '', '1', '2025-03-09 12:40:37', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2169, 20, 'DATABASE', '20', 'iot_data_bridge_type_enum', 0, 'primary', '', '', '1', '2025-03-09 12:41:05', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2170, 21, 'REDIS_STREAM', '21', 'iot_data_bridge_type_enum', 0, 'primary', '', '', '1', '2025-03-09 12:41:18', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2171, 30, 'ROCKETMQ', '30', 'iot_data_bridge_type_enum', 0, 'primary', '', '', '1', '2025-03-09 12:41:30', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2172, 31, 'RABBITMQ', '31', 'iot_data_bridge_type_enum', 0, 'primary', '', '', '1', '2025-03-09 12:41:47', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (2173, 32, 'KAFKA', '32', 'iot_data_bridge_type_enum', 0, 'primary', '', '', '1', '2025-03-09 12:41:59', '1', '2025-03-17 09:40:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (3000, 16, '百川智能', 'BaiChuan', 'ai_platform', 0, '', '', '', '1', '2025-03-23 12:15:46', '1', '2025-03-23 12:15:46', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (3001, 50, 'Vben5.0 Ant Design Schema 模版', '40', 'infra_codegen_front_type', 0, '', '', NULL, '1', '2025-04-23 21:47:47', '1', '2025-05-02 12:01:15', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (3002, 6, '支付宝余额', '6', 'brokerage_withdraw_type', 0, '', '', 'API 打款', '1', '2025-05-10 08:24:49', '1', '2025-05-10 08:24:49', '0');
INSERT INTO system_dict_data (id, sort, label, value, dict_type, status, color_type, css_class, remark, creator, create_time, updater, update_time, deleted) VALUES (3035, 40, '支付宝小程序', '40', 'system_social_type', 0, '', '', '', '1', '2023-11-04 13:05:38', '1', '2023-11-04 13:07:16', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_dict_data_seq;
CREATE SEQUENCE system_dict_data_seq
    START 3003;

-- ----------------------------
-- Table structure for system_dict_type
-- ----------------------------
DROP TABLE IF EXISTS system_dict_type;
CREATE TABLE system_dict_type
(
    id           int8         NOT NULL,
    name         varchar(100) NULL     DEFAULT '',
    type         varchar(100) NULL     DEFAULT '',
    status       int2         NOT NULL DEFAULT 0,
    remark       varchar(500) NULL     DEFAULT NULL,
    creator      varchar(64)  NULL     DEFAULT '',
    create_time  timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater      varchar(64)  NULL     DEFAULT '',
    update_time  timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted      int2         NOT NULL DEFAULT 0,
    deleted_time timestamp    NULL     DEFAULT NULL
);

ALTER TABLE system_dict_type
    ADD CONSTRAINT pk_system_dict_type PRIMARY KEY (id);

COMMENT ON COLUMN system_dict_type.id IS '字典主键';
COMMENT ON COLUMN system_dict_type.name IS '字典名称';
COMMENT ON COLUMN system_dict_type.type IS '字典类型';
COMMENT ON COLUMN system_dict_type.status IS '状态（0正常 1停用）';
COMMENT ON COLUMN system_dict_type.remark IS '备注';
COMMENT ON COLUMN system_dict_type.creator IS '创建者';
COMMENT ON COLUMN system_dict_type.create_time IS '创建时间';
COMMENT ON COLUMN system_dict_type.updater IS '更新者';
COMMENT ON COLUMN system_dict_type.update_time IS '更新时间';
COMMENT ON COLUMN system_dict_type.deleted IS '是否删除';
COMMENT ON COLUMN system_dict_type.deleted_time IS '删除时间';
COMMENT ON TABLE system_dict_type IS '字典类型表';

-- ----------------------------
-- Records of system_dict_type
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1, '用户性别', 'system_user_sex', 0, NULL, 'admin', '2021-01-05 17:03:48', '1', '2022-05-16 20:29:32', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (6, '参数类型', 'infra_config_type', 0, NULL, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:36:54', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (7, '通知类型', 'system_notice_type', 0, NULL, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:35:26', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (9, '操作类型', 'infra_operate_type', 0, NULL, 'admin', '2021-01-05 17:03:48', '1', '2024-03-14 12:44:01', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (10, '系统状态', 'common_status', 0, NULL, 'admin', '2021-01-05 17:03:48', '', '2022-02-01 16:21:28', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (11, 'Boolean 是否类型', 'infra_boolean_string', 0, 'boolean 转是否', '', '2021-01-19 03:20:08', '', '2022-02-01 16:37:10', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (104, '登陆结果', 'system_login_result', 0, '登陆结果', '', '2021-01-18 06:17:11', '', '2022-02-01 16:36:00', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (106, '代码生成模板类型', 'infra_codegen_template_type', 0, NULL, '', '2021-02-05 07:08:06', '1', '2022-05-16 20:26:50', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (107, '定时任务状态', 'infra_job_status', 0, NULL, '', '2021-02-07 07:44:16', '', '2022-02-01 16:51:11', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (108, '定时任务日志状态', 'infra_job_log_status', 0, NULL, '', '2021-02-08 10:03:51', '', '2022-02-01 16:50:43', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (109, '用户类型', 'user_type', 0, NULL, '', '2021-02-26 00:15:51', '', '2021-02-26 00:15:51', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (110, 'API 异常数据的处理状态', 'infra_api_error_log_process_status', 0, NULL, '', '2021-02-26 07:07:01', '', '2022-02-01 16:50:53', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (111, '短信渠道编码', 'system_sms_channel_code', 0, NULL, '1', '2021-04-05 01:04:50', '1', '2022-02-16 02:09:08', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (112, '短信模板的类型', 'system_sms_template_type', 0, NULL, '1', '2021-04-05 21:50:43', '1', '2022-02-01 16:35:06', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (113, '短信发送状态', 'system_sms_send_status', 0, NULL, '1', '2021-04-11 20:18:03', '1', '2022-02-01 16:35:09', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (114, '短信接收状态', 'system_sms_receive_status', 0, NULL, '1', '2021-04-11 20:27:14', '1', '2022-02-01 16:35:14', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (116, '登陆日志的类型', 'system_login_type', 0, '登陆日志的类型', '1', '2021-10-06 00:50:46', '1', '2022-02-01 16:35:56', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (117, 'OA 请假类型', 'bpm_oa_leave_type', 0, NULL, '1', '2021-09-21 22:34:33', '1', '2022-01-22 10:41:37', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (130, '支付渠道编码类型', 'pay_channel_code', 0, '支付渠道的编码', '1', '2021-12-03 10:35:08', '1', '2023-07-10 10:11:39', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (131, '支付回调状态', 'pay_notify_status', 0, '支付回调状态（包括退款回调）', '1', '2021-12-03 10:53:29', '1', '2023-07-19 18:09:43', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (132, '支付订单状态', 'pay_order_status', 0, '支付订单状态', '1', '2021-12-03 11:17:50', '1', '2021-12-03 11:17:50', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (134, '退款订单状态', 'pay_refund_status', 0, '退款订单状态', '1', '2021-12-10 16:42:50', '1', '2023-07-19 10:13:17', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (139, '流程实例的状态', 'bpm_process_instance_status', 0, '流程实例的状态', '1', '2022-01-07 23:46:42', '1', '2022-01-07 23:46:42', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (140, '流程实例的结果', 'bpm_task_status', 0, '流程实例的结果', '1', '2022-01-07 23:48:10', '1', '2024-03-08 22:42:03', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (141, '流程的表单类型', 'bpm_model_form_type', 0, '流程的表单类型', '103', '2022-01-11 23:50:45', '103', '2022-01-11 23:50:45', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (142, '任务分配规则的类型', 'bpm_task_candidate_strategy', 0, 'BPM 任务的候选人的策略', '103', '2022-01-12 23:21:04', '103', '2024-03-06 02:53:59', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (144, '代码生成的场景枚举', 'infra_codegen_scene', 0, '代码生成的场景枚举', '1', '2022-02-02 13:14:45', '1', '2022-03-10 16:33:46', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (145, '角色类型', 'system_role_type', 0, '角色类型', '1', '2022-02-16 13:01:46', '1', '2022-02-16 13:01:46', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (146, '文件存储器', 'infra_file_storage', 0, '文件存储器', '1', '2022-03-15 00:24:38', '1', '2022-03-15 00:24:38', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (147, 'OAuth 2.0 授权类型', 'system_oauth2_grant_type', 0, 'OAuth 2.0 授权类型（模式）', '1', '2022-05-12 00:20:52', '1', '2022-05-11 16:25:49', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (149, '商品 SPU 状态', 'product_spu_status', 0, '商品 SPU 状态', '1', '2022-10-24 21:19:04', '1', '2022-10-24 21:19:08', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (150, '优惠类型', 'promotion_discount_type', 0, '优惠类型', '1', '2022-11-01 12:46:06', '1', '2022-11-01 12:46:06', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (151, '优惠劵模板的有限期类型', 'promotion_coupon_template_validity_type', 0, '优惠劵模板的有限期类型', '1', '2022-11-02 00:06:20', '1', '2022-11-04 00:08:26', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (152, '营销的商品范围', 'promotion_product_scope', 0, '营销的商品范围', '1', '2022-11-02 00:28:01', '1', '2022-11-02 00:28:01', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (153, '优惠劵的状态', 'promotion_coupon_status', 0, '优惠劵的状态', '1', '2022-11-04 00:14:49', '1', '2022-11-04 00:14:49', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (154, '优惠劵的领取方式', 'promotion_coupon_take_type', 0, '优惠劵的领取方式', '1', '2022-11-04 19:12:27', '1', '2022-11-04 19:12:27', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (155, '促销活动的状态', 'promotion_activity_status', 0, '促销活动的状态', '1', '2022-11-04 22:54:23', '1', '2022-11-04 22:54:23', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (156, '营销的条件类型', 'promotion_condition_type', 0, '营销的条件类型', '1', '2022-11-04 22:59:23', '1', '2022-11-04 22:59:23', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (157, '交易售后状态', 'trade_after_sale_status', 0, '交易售后状态', '1', '2022-11-19 20:52:56', '1', '2022-11-19 20:52:56', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (158, '交易售后的类型', 'trade_after_sale_type', 0, '交易售后的类型', '1', '2022-11-19 21:04:09', '1', '2022-11-19 21:04:09', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (159, '交易售后的方式', 'trade_after_sale_way', 0, '交易售后的方式', '1', '2022-11-19 21:39:04', '1', '2022-11-19 21:39:04', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (160, '终端', 'terminal', 0, '终端', '1', '2022-12-10 10:50:50', '1', '2022-12-10 10:53:11', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (161, '交易订单的类型', 'trade_order_type', 0, '交易订单的类型', '1', '2022-12-10 16:33:54', '1', '2022-12-10 16:33:54', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (162, '交易订单的状态', 'trade_order_status', 0, '交易订单的状态', '1', '2022-12-10 16:48:44', '1', '2022-12-10 16:48:44', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (163, '交易订单项的售后状态', 'trade_order_item_after_sale_status', 0, '交易订单项的售后状态', '1', '2022-12-10 20:58:08', '1', '2022-12-10 20:58:08', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (164, '公众号自动回复的请求关键字匹配模式', 'mp_auto_reply_request_match', 0, '公众号自动回复的请求关键字匹配模式', '1', '2023-01-16 23:29:56', '1', '2023-01-16 23:29:56', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (165, '公众号的消息类型', 'mp_message_type', 0, '公众号的消息类型', '1', '2023-01-17 22:17:09', '1', '2023-01-17 22:17:09', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (166, '邮件发送状态', 'system_mail_send_status', 0, '邮件发送状态', '1', '2023-01-26 09:53:13', '1', '2023-01-26 09:53:13', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (167, '站内信模版的类型', 'system_notify_template_type', 0, '站内信模版的类型', '1', '2023-01-28 10:35:10', '1', '2023-01-28 10:35:10', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (168, '代码生成的前端类型', 'infra_codegen_front_type', 0, '', '1', '2023-04-12 23:57:52', '1', '2023-04-12 23:57:52', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (170, '快递计费方式', 'trade_delivery_express_charge_mode', 0, '用于商城交易模块配送管理', '1', '2023-05-21 22:45:03', '1', '2023-05-21 22:45:03', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (171, '积分业务类型', 'member_point_biz_type', 0, '', '1', '2023-06-10 12:15:00', '1', '2023-06-28 13:48:20', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (173, '支付通知类型', 'pay_notify_type', 0, NULL, '1', '2023-07-20 12:23:03', '1', '2023-07-20 12:23:03', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (174, '会员经验业务类型', 'member_experience_biz_type', 0, NULL, '', '2023-08-22 12:41:01', '', '2023-08-22 12:41:01', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (175, '交易配送类型', 'trade_delivery_type', 0, '', '1', '2023-08-23 00:03:14', '1', '2023-08-23 00:03:14', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (176, '分佣模式', 'brokerage_enabled_condition', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (177, '分销关系绑定模式', 'brokerage_bind_mode', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (178, '佣金提现类型', 'brokerage_withdraw_type', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (179, '佣金记录业务类型', 'brokerage_record_biz_type', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (180, '佣金记录状态', 'brokerage_record_status', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (181, '佣金提现状态', 'brokerage_withdraw_status', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (182, '佣金提现银行', 'brokerage_bank_name', 0, NULL, '', '2023-09-28 02:46:05', '', '2023-09-28 02:46:05', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (183, '砍价记录的状态', 'promotion_bargain_record_status', 0, '', '1', '2023-10-05 10:41:08', '1', '2023-10-05 10:41:08', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (184, '拼团记录的状态', 'promotion_combination_record_status', 0, '', '1', '2023-10-08 07:24:25', '1', '2023-10-08 07:24:25', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (185, '回款-回款方式', 'crm_receivable_return_type', 0, '回款-回款方式', '1', '2023-10-18 21:54:10', '1', '2023-10-18 21:54:10', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (186, 'CRM 客户行业', 'crm_customer_industry', 0, 'CRM 客户所属行业', '1', '2023-10-28 22:57:07', '1', '2024-02-18 23:30:22', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (187, '客户等级', 'crm_customer_level', 0, 'CRM 客户等级', '1', '2023-10-28 22:59:12', '1', '2023-10-28 15:11:16', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (188, '客户来源', 'crm_customer_source', 0, 'CRM 客户来源', '1', '2023-10-28 23:00:34', '1', '2023-10-28 15:11:16', '0', NULL);
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (600, 'Banner 位置', 'promotion_banner_position', 0, '', '1', '2023-10-08 07:24:25', '1', '2023-11-04 13:04:02', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (601, '社交类型', 'system_social_type', 0, '', '1', '2023-11-04 13:03:54', '1', '2023-11-04 13:03:54', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (604, '产品状态', 'crm_product_status', 0, '', '1', '2023-10-30 21:47:59', '1', '2023-10-30 21:48:45', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (605, 'CRM 数据权限的级别', 'crm_permission_level', 0, '', '1', '2023-11-30 09:51:59', '1', '2023-11-30 09:51:59', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (606, 'CRM 审批状态', 'crm_audit_status', 0, '', '1', '2023-11-30 18:56:23', '1', '2023-11-30 18:56:23', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (607, 'CRM 产品单位', 'crm_product_unit', 0, '', '1', '2023-12-05 23:01:51', '1', '2023-12-05 23:01:51', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (608, 'CRM 跟进方式', 'crm_follow_up_type', 0, '', '1', '2024-01-15 20:48:05', '1', '2024-01-15 20:48:05', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (610, '转账订单状态', 'pay_transfer_status', 0, '', '1', '2023-10-28 16:18:32', '1', '2023-10-28 16:18:32', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (611, 'ERP 库存明细的业务类型', 'erp_stock_record_biz_type', 0, 'ERP 库存明细的业务类型', '1', '2024-02-05 18:07:02', '1', '2024-02-05 18:07:02', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (612, 'ERP 审批状态', 'erp_audit_status', 0, '', '1', '2024-02-06 00:00:07', '1', '2024-02-06 00:00:07', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (613, 'BPM 监听器类型', 'bpm_process_listener_type', 0, '', '1', '2024-03-23 12:52:24', '1', '2024-03-09 15:54:28', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (615, 'BPM 监听器值类型', 'bpm_process_listener_value_type', 0, '', '1', '2024-03-23 13:00:31', '1', '2024-03-23 13:00:31', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (616, '时间间隔', 'date_interval', 0, '', '1', '2024-03-29 22:50:09', '1', '2024-03-29 22:50:09', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (619, 'CRM 商机结束状态类型', 'crm_business_end_status_type', 0, '', '1', '2024-04-13 23:23:00', '1', '2024-04-13 23:23:00', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (620, 'AI 模型平台', 'ai_platform', 0, '', '1', '2024-05-09 22:27:38', '1', '2024-05-09 22:27:38', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (621, 'AI 绘画状态', 'ai_image_status', 0, '', '1', '2024-06-26 20:51:23', '1', '2024-06-26 20:51:23', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (622, 'AI 音乐状态', 'ai_music_status', 0, '', '1', '2024-06-27 22:45:07', '1', '2024-06-28 00:56:27', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (623, 'AI 音乐生成模式', 'ai_generate_mode', 0, '', '1', '2024-06-27 22:46:21', '1', '2024-06-28 01:22:29', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (624, '写作语气', 'ai_write_tone', 0, '', '1', '2024-07-07 15:19:02', '1', '2024-07-07 15:19:02', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (625, '写作语言', 'ai_write_language', 0, '', '1', '2024-07-07 15:18:52', '1', '2024-07-07 15:18:52', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (626, '写作长度', 'ai_write_length', 0, '', '1', '2024-07-07 15:18:41', '1', '2024-07-07 15:18:41', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (627, '写作格式', 'ai_write_format', 0, '', '1', '2024-07-07 15:14:34', '1', '2024-07-07 15:14:34', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (628, 'AI 写作类型', 'ai_write_type', 0, '', '1', '2024-07-10 21:25:29', '1', '2024-07-10 21:25:29', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (629, 'BPM 流程模型类型', 'bpm_model_type', 0, '', '1', '2024-08-26 15:21:43', '1', '2024-08-26 15:21:43', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (640, 'AI 模型类型', 'ai_model_type', 0, '', '1', '2025-03-03 12:24:07', '1', '2025-03-03 12:24:07', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1000, 'IoT 数据格式', 'iot_data_format', 0, '', '1', '2024-08-10 11:52:58', '1', '2025-03-17 09:25:06', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1001, 'IoT 产品设备类型', 'iot_product_device_type', 0, '', '1', '2024-08-10 11:54:30', '1', '2025-03-17 09:25:08', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1002, 'IoT 产品状态', 'iot_product_status', 0, '', '1', '2024-08-10 12:06:09', '1', '2025-03-17 09:25:10', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1003, 'IoT 数据校验级别', 'iot_validate_type', 0, '', '1', '2024-09-06 20:05:13', '1', '2025-03-17 09:25:12', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1004, 'IoT 联网方式', 'iot_net_type', 0, '', '1', '2024-09-06 22:04:13', '1', '2025-03-17 09:25:14', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1005, 'IoT 接入网关协议', 'iot_protocol_type', 0, '', '1', '2024-09-06 22:20:17', '1', '2025-03-17 09:25:16', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1006, 'IoT 设备状态', 'iot_device_state', 0, '', '1', '2024-09-21 08:12:55', '1', '2025-03-17 09:25:19', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1007, 'IoT 物模型功能类型', 'iot_thing_model_type', 0, '', '1', '2024-09-29 20:02:36', '1', '2025-03-17 09:25:24', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1008, 'IoT 插件部署方式', 'iot_plugin_deploy_type', 0, '', '1', '2024-12-13 10:55:13', '1', '2025-03-17 09:25:27', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1009, 'IoT 插件状态', 'iot_plugin_status', 0, '', '1', '2024-12-13 11:05:34', '1', '2025-03-17 09:25:30', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1010, 'IoT 插件类型', 'iot_plugin_type', 0, '', '1', '2024-12-13 11:08:19', '1', '2025-03-17 09:25:32', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1011, 'IoT 物模型单位', 'iot_thing_model_unit', 0, '', '1', '2024-12-25 17:36:46', '1', '2025-03-17 09:25:35', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1012, 'IoT 数据桥接的方向枚举', 'iot_data_bridge_direction_enum', 0, '', '1', '2025-03-09 12:37:40', '1', '2025-03-17 09:25:39', '0', '1970-01-01 00:00:00');
INSERT INTO system_dict_type (id, name, type, status, remark, creator, create_time, updater, update_time, deleted, deleted_time) VALUES (1013, 'IoT 数据桥梁的类型枚举', 'iot_data_bridge_type_enum', 0, '', '1', '2025-03-09 12:39:36', '1', '2025-04-06 17:09:46', '0', '1970-01-01 00:00:00');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_dict_type_seq;
CREATE SEQUENCE system_dict_type_seq
    START 1014;

-- ----------------------------
-- Table structure for system_login_log
-- ----------------------------
DROP TABLE IF EXISTS system_login_log;
CREATE TABLE system_login_log
(
    id          int8         NOT NULL,
    log_type    int8         NOT NULL,
    trace_id    varchar(64)  NULL     DEFAULT '',
    user_id     int8         NOT NULL DEFAULT 0,
    user_type   int2         NOT NULL DEFAULT 0,
    username    varchar(50)  NULL     DEFAULT '',
    result      int2         NOT NULL,
    user_ip     varchar(50)  NOT NULL,
    user_agent  varchar(512) NOT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0,
    tenant_id   int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_login_log
    ADD CONSTRAINT pk_system_login_log PRIMARY KEY (id);

COMMENT ON COLUMN system_login_log.id IS '访问ID';
COMMENT ON COLUMN system_login_log.log_type IS '日志类型';
COMMENT ON COLUMN system_login_log.trace_id IS '链路追踪编号';
COMMENT ON COLUMN system_login_log.user_id IS '用户编号';
COMMENT ON COLUMN system_login_log.user_type IS '用户类型';
COMMENT ON COLUMN system_login_log.username IS '用户账号';
COMMENT ON COLUMN system_login_log.result IS '登陆结果';
COMMENT ON COLUMN system_login_log.user_ip IS '用户 IP';
COMMENT ON COLUMN system_login_log.user_agent IS '浏览器 UA';
COMMENT ON COLUMN system_login_log.creator IS '创建者';
COMMENT ON COLUMN system_login_log.create_time IS '创建时间';
COMMENT ON COLUMN system_login_log.updater IS '更新者';
COMMENT ON COLUMN system_login_log.update_time IS '更新时间';
COMMENT ON COLUMN system_login_log.deleted IS '是否删除';
COMMENT ON COLUMN system_login_log.tenant_id IS '租户编号';
COMMENT ON TABLE system_login_log IS '系统访问记录';

DROP SEQUENCE IF EXISTS system_login_log_seq;
CREATE SEQUENCE system_login_log_seq
    START 1;

-- ----------------------------
-- Table structure for system_mail_account
-- ----------------------------
DROP TABLE IF EXISTS system_mail_account;
CREATE TABLE system_mail_account
(
    id              int8         NOT NULL,
    mail            varchar(255) NOT NULL,
    username        varchar(255) NOT NULL,
    password        varchar(255) NOT NULL,
    host            varchar(255) NOT NULL,
    port            int4         NOT NULL,
    ssl_enable      bool         NOT NULL DEFAULT '0',
    starttls_enable bool         NOT NULL DEFAULT '0',
    creator         varchar(64)  NULL     DEFAULT '',
    create_time     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater         varchar(64)  NULL     DEFAULT '',
    update_time     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted         int2         NOT NULL DEFAULT 0
);

ALTER TABLE system_mail_account
    ADD CONSTRAINT pk_system_mail_account PRIMARY KEY (id);

COMMENT ON COLUMN system_mail_account.id IS '主键';
COMMENT ON COLUMN system_mail_account.mail IS '邮箱';
COMMENT ON COLUMN system_mail_account.username IS '用户名';
COMMENT ON COLUMN system_mail_account.password IS '密码';
COMMENT ON COLUMN system_mail_account.host IS 'SMTP 服务器域名';
COMMENT ON COLUMN system_mail_account.port IS 'SMTP 服务器端口';
COMMENT ON COLUMN system_mail_account.ssl_enable IS '是否开启 SSL';
COMMENT ON COLUMN system_mail_account.starttls_enable IS '是否开启 STARTTLS';
COMMENT ON COLUMN system_mail_account.creator IS '创建者';
COMMENT ON COLUMN system_mail_account.create_time IS '创建时间';
COMMENT ON COLUMN system_mail_account.updater IS '更新者';
COMMENT ON COLUMN system_mail_account.update_time IS '更新时间';
COMMENT ON COLUMN system_mail_account.deleted IS '是否删除';
COMMENT ON TABLE system_mail_account IS '邮箱账号表';

-- ----------------------------
-- Records of system_mail_account
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_mail_account (id, mail, username, password, host, port, ssl_enable, starttls_enable, creator, create_time, updater, update_time, deleted) VALUES (1, '7684413@qq.com', '7684413@qq.com', '1234576', '127.0.0.1', 8080, '0', '0', '1', '2023-01-25 17:39:52', '1', '2025-04-04 16:34:40', '0');
INSERT INTO system_mail_account (id, mail, username, password, host, port, ssl_enable, starttls_enable, creator, create_time, updater, update_time, deleted) VALUES (2, 'ydym_test@163.com', 'ydym_test@163.com', 'WBZTEINMIFVRYSOE', 'smtp.163.com', 465, '1', '0', '1', '2023-01-26 01:26:03', '1', '2023-04-12 22:39:38', '0');
INSERT INTO system_mail_account (id, mail, username, password, host, port, ssl_enable, starttls_enable, creator, create_time, updater, update_time, deleted) VALUES (3, '76854114@qq.com', '3335', '11234', 'yunai1.cn', 466, '0', '0', '1', '2023-01-27 15:06:38', '1', '2023-01-27 07:08:36', '1');
INSERT INTO system_mail_account (id, mail, username, password, host, port, ssl_enable, starttls_enable, creator, create_time, updater, update_time, deleted) VALUES (4, '7685413x@qq.com', '2', '3', '4', 5, '1', '0', '1', '2023-04-12 23:05:06', '1', '2023-04-12 15:05:11', '1');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_mail_account_seq;
CREATE SEQUENCE system_mail_account_seq
    START 5;

-- ----------------------------
-- Table structure for system_mail_log
-- ----------------------------
DROP TABLE IF EXISTS system_mail_log;
CREATE TABLE system_mail_log
(
    id                int8           NOT NULL,
    user_id           int8           NULL     DEFAULT NULL,
    user_type         int2           NULL     DEFAULT NULL,
    to_mail           varchar(255)   NOT NULL,
    account_id        int8           NOT NULL,
    from_mail         varchar(255)   NOT NULL,
    template_id       int8           NOT NULL,
    template_code     varchar(63)    NOT NULL,
    template_nickname varchar(255)   NULL     DEFAULT NULL,
    template_title    varchar(255)   NOT NULL,
    template_content  varchar(10240) NOT NULL,
    template_params   varchar(255)   NOT NULL,
    send_status       int2           NOT NULL DEFAULT 0,
    send_time         timestamp      NULL     DEFAULT NULL,
    send_message_id   varchar(255)   NULL     DEFAULT NULL,
    send_exception    varchar(4096)  NULL     DEFAULT NULL,
    creator           varchar(64)    NULL     DEFAULT '',
    create_time       timestamp      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater           varchar(64)    NULL     DEFAULT '',
    update_time       timestamp      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted           int2           NOT NULL DEFAULT 0
);

ALTER TABLE system_mail_log
    ADD CONSTRAINT pk_system_mail_log PRIMARY KEY (id);

COMMENT ON COLUMN system_mail_log.id IS '编号';
COMMENT ON COLUMN system_mail_log.user_id IS '用户编号';
COMMENT ON COLUMN system_mail_log.user_type IS '用户类型';
COMMENT ON COLUMN system_mail_log.to_mail IS '接收邮箱地址';
COMMENT ON COLUMN system_mail_log.account_id IS '邮箱账号编号';
COMMENT ON COLUMN system_mail_log.from_mail IS '发送邮箱地址';
COMMENT ON COLUMN system_mail_log.template_id IS '模板编号';
COMMENT ON COLUMN system_mail_log.template_code IS '模板编码';
COMMENT ON COLUMN system_mail_log.template_nickname IS '模版发送人名称';
COMMENT ON COLUMN system_mail_log.template_title IS '邮件标题';
COMMENT ON COLUMN system_mail_log.template_content IS '邮件内容';
COMMENT ON COLUMN system_mail_log.template_params IS '邮件参数';
COMMENT ON COLUMN system_mail_log.send_status IS '发送状态';
COMMENT ON COLUMN system_mail_log.send_time IS '发送时间';
COMMENT ON COLUMN system_mail_log.send_message_id IS '发送返回的消息 ID';
COMMENT ON COLUMN system_mail_log.send_exception IS '发送异常';
COMMENT ON COLUMN system_mail_log.creator IS '创建者';
COMMENT ON COLUMN system_mail_log.create_time IS '创建时间';
COMMENT ON COLUMN system_mail_log.updater IS '更新者';
COMMENT ON COLUMN system_mail_log.update_time IS '更新时间';
COMMENT ON COLUMN system_mail_log.deleted IS '是否删除';
COMMENT ON TABLE system_mail_log IS '邮件日志表';

DROP SEQUENCE IF EXISTS system_mail_log_seq;
CREATE SEQUENCE system_mail_log_seq
    START 1;

-- ----------------------------
-- Table structure for system_mail_template
-- ----------------------------
DROP TABLE IF EXISTS system_mail_template;
CREATE TABLE system_mail_template
(
    id          int8           NOT NULL,
    name        varchar(63)    NOT NULL,
    code        varchar(63)    NOT NULL,
    account_id  int8           NOT NULL,
    nickname    varchar(255)   NULL     DEFAULT NULL,
    title       varchar(255)   NOT NULL,
    content     varchar(10240) NOT NULL,
    params      varchar(255)   NOT NULL,
    status      int2           NOT NULL,
    remark      varchar(255)   NULL     DEFAULT NULL,
    creator     varchar(64)    NULL     DEFAULT '',
    create_time timestamp      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)    NULL     DEFAULT '',
    update_time timestamp      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2           NOT NULL DEFAULT 0
);

ALTER TABLE system_mail_template
    ADD CONSTRAINT pk_system_mail_template PRIMARY KEY (id);

COMMENT ON COLUMN system_mail_template.id IS '编号';
COMMENT ON COLUMN system_mail_template.name IS '模板名称';
COMMENT ON COLUMN system_mail_template.code IS '模板编码';
COMMENT ON COLUMN system_mail_template.account_id IS '发送的邮箱账号编号';
COMMENT ON COLUMN system_mail_template.nickname IS '发送人名称';
COMMENT ON COLUMN system_mail_template.title IS '模板标题';
COMMENT ON COLUMN system_mail_template.content IS '模板内容';
COMMENT ON COLUMN system_mail_template.params IS '参数数组';
COMMENT ON COLUMN system_mail_template.status IS '开启状态';
COMMENT ON COLUMN system_mail_template.remark IS '备注';
COMMENT ON COLUMN system_mail_template.creator IS '创建者';
COMMENT ON COLUMN system_mail_template.create_time IS '创建时间';
COMMENT ON COLUMN system_mail_template.updater IS '更新者';
COMMENT ON COLUMN system_mail_template.update_time IS '更新时间';
COMMENT ON COLUMN system_mail_template.deleted IS '是否删除';
COMMENT ON TABLE system_mail_template IS '邮件模版表';

-- ----------------------------
-- Records of system_mail_template
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_mail_template (id, name, code, account_id, nickname, title, content, params, status, remark, creator, create_time, updater, update_time, deleted) VALUES (13, '后台用户短信登录', 'admin-sms-login', 1, '奥特曼', '你猜我猜', '<p>您的验证码是{code}，名字是{name}</p>', '["code","name"]', 0, '3', '1', '2021-10-11 08:10:00', '1', '2023-12-02 19:51:14', '0');
INSERT INTO system_mail_template (id, name, code, account_id, nickname, title, content, params, status, remark, creator, create_time, updater, update_time, deleted) VALUES (14, '测试模版', 'test_01', 2, '管理员', '一个标题', '<p>你是 {key01} 吗？</p><p><br></p><p>是的话，赶紧 {key02} 一下！</p>', '["key01","key02"]', 0, NULL, '1', '2023-01-26 01:27:40', '1', '2023-01-27 10:32:16', '0');
INSERT INTO system_mail_template (id, name, code, account_id, nickname, title, content, params, status, remark, creator, create_time, updater, update_time, deleted) VALUES (15, '3', '2', 2, '7', '4', '<p>45</p>', '[]', 1, '80', '1', '2023-01-27 15:50:35', '1', '2023-01-27 16:34:49', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_mail_template_seq;
CREATE SEQUENCE system_mail_template_seq
    START 16;

-- ----------------------------
-- Table structure for system_menu
-- ----------------------------
DROP TABLE IF EXISTS system_menu;
CREATE TABLE system_menu
(
    id             int8         NOT NULL,
    name           varchar(50)  NOT NULL,
    permission     varchar(100) NULL     DEFAULT '',
    type           int2         NOT NULL,
    sort           int4         NOT NULL DEFAULT 0,
    parent_id      int8         NOT NULL DEFAULT 0,
    path           varchar(200) NULL     DEFAULT '',
    icon           varchar(100) NULL     DEFAULT '#',
    component      varchar(255) NULL     DEFAULT NULL,
    component_name varchar(255) NULL     DEFAULT NULL,
    status         int2         NOT NULL DEFAULT 0,
    visible        bool         NOT NULL DEFAULT '1',
    keep_alive     bool         NOT NULL DEFAULT '1',
    always_show    bool         NOT NULL DEFAULT '1',
    creator        varchar(64)  NULL     DEFAULT '',
    create_time    timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater        varchar(64)  NULL     DEFAULT '',
    update_time    timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted        int2         NOT NULL DEFAULT 0
);

ALTER TABLE system_menu
    ADD CONSTRAINT pk_system_menu PRIMARY KEY (id);

COMMENT ON COLUMN system_menu.id IS '菜单ID';
COMMENT ON COLUMN system_menu.name IS '菜单名称';
COMMENT ON COLUMN system_menu.permission IS '权限标识';
COMMENT ON COLUMN system_menu.type IS '菜单类型';
COMMENT ON COLUMN system_menu.sort IS '显示顺序';
COMMENT ON COLUMN system_menu.parent_id IS '父菜单ID';
COMMENT ON COLUMN system_menu.path IS '路由地址';
COMMENT ON COLUMN system_menu.icon IS '菜单图标';
COMMENT ON COLUMN system_menu.component IS '组件路径';
COMMENT ON COLUMN system_menu.component_name IS '组件名';
COMMENT ON COLUMN system_menu.status IS '菜单状态';
COMMENT ON COLUMN system_menu.visible IS '是否可见';
COMMENT ON COLUMN system_menu.keep_alive IS '是否缓存';
COMMENT ON COLUMN system_menu.always_show IS '是否总是显示';
COMMENT ON COLUMN system_menu.creator IS '创建者';
COMMENT ON COLUMN system_menu.create_time IS '创建时间';
COMMENT ON COLUMN system_menu.updater IS '更新者';
COMMENT ON COLUMN system_menu.update_time IS '更新时间';
COMMENT ON COLUMN system_menu.deleted IS '是否删除';
COMMENT ON TABLE system_menu IS '菜单权限表';

-- ----------------------------
-- Records of system_menu
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1, '系统管理', '', 1, 10, 0, '/system', 'ep:tools', NULL, NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2025-03-15 21:30:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2, '基础设施', '', 1, 20, 0, '/infra', 'ep:monitor', NULL, NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-03-01 08:28:40', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5, 'OA 示例', '', 1, 40, 1185, 'oa', 'fa:road', NULL, NULL, 0, '1', '1', '1', 'admin', '2021-09-20 16:26:19', '1', '2024-02-29 12:38:13', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (100, '用户管理', 'system:user:list', 2, 1, 1, 'user', 'ep:avatar', 'system/user/index', 'SystemUser', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2025-03-15 21:30:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (101, '角色管理', '', 2, 2, 1, 'role', 'ep:user', 'system/role/index', 'SystemRole', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-05-01 18:35:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (102, '菜单管理', '', 2, 3, 1, 'menu', 'ep:menu', 'system/menu/index', 'SystemMenu', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 01:03:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (103, '部门管理', '', 2, 4, 1, 'dept', 'fa:address-card', 'system/dept/index', 'SystemDept', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 01:06:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (104, '岗位管理', '', 2, 5, 1, 'post', 'fa:address-book-o', 'system/post/index', 'SystemPost', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 01:06:39', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (105, '字典管理', '', 2, 6, 1, 'dict', 'ep:collection', 'system/dict/index', 'SystemDictType', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 01:07:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (106, '配置管理', '', 2, 8, 2, 'config', 'fa:connectdevelop', 'infra/config/index', 'InfraConfig', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-04-23 00:02:45', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (107, '通知公告', '', 2, 4, 2739, 'notice', 'ep:takeaway-box', 'system/notice/index', 'SystemNotice', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-04-22 23:56:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (108, '审计日志', '', 1, 9, 1, 'log', 'ep:document-copy', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 01:08:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (109, '令牌管理', '', 2, 2, 1261, 'token', 'fa:key', 'system/oauth2/token/index', 'SystemTokenClient', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 01:13:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (110, '定时任务', '', 2, 7, 2, 'job', 'fa-solid:tasks', 'infra/job/index', 'InfraJob', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 08:57:36', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (111, 'MySQL 监控', '', 2, 1, 2740, 'druid', 'fa-solid:box', 'infra/druid/index', 'InfraDruid', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-04-23 00:05:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (112, 'Java 监控', '', 2, 3, 2740, 'admin-server', 'ep:coffee-cup', 'infra/server/index', 'InfraAdminServer', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-04-23 00:06:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (113, 'Redis 监控', '', 2, 2, 2740, 'redis', 'fa:reddit-square', 'infra/redis/index', 'InfraRedis', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-04-23 00:06:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (114, '表单构建', 'infra:build:list', 2, 2, 2, 'build', 'fa:wpforms', 'infra/build/index', 'InfraBuild', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 08:51:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (115, '代码生成', 'infra:codegen:query', 2, 1, 2, 'codegen', 'ep:document-copy', 'infra/codegen/index', 'InfraCodegen', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 08:51:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (116, 'API 接口', 'infra:swagger:list', 2, 3, 2, 'swagger', 'fa:fighter-jet', 'infra/swagger/index', 'InfraSwagger', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-04-23 00:01:24', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (500, '操作日志', '', 2, 1, 108, 'operate-log', 'ep:position', 'system/operatelog/index', 'SystemOperateLog', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 01:09:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (501, '登录日志', '', 2, 2, 108, 'login-log', 'ep:promotion', 'system/loginlog/index', 'SystemLoginLog', 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2024-02-29 01:10:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1001, '用户查询', 'system:user:query', 3, 1, 100, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1002, '用户新增', 'system:user:create', 3, 2, 100, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1003, '用户修改', 'system:user:update', 3, 3, 100, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1004, '用户删除', 'system:user:delete', 3, 4, 100, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1005, '用户导出', 'system:user:export', 3, 5, 100, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1006, '用户导入', 'system:user:import', 3, 6, 100, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1007, '重置密码', 'system:user:update-password', 3, 7, 100, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1008, '角色查询', 'system:role:query', 3, 1, 101, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1009, '角色新增', 'system:role:create', 3, 2, 101, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1010, '角色修改', 'system:role:update', 3, 3, 101, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1011, '角色删除', 'system:role:delete', 3, 4, 101, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1012, '角色导出', 'system:role:export', 3, 5, 101, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1013, '菜单查询', 'system:menu:query', 3, 1, 102, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1014, '菜单新增', 'system:menu:create', 3, 2, 102, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1015, '菜单修改', 'system:menu:update', 3, 3, 102, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1016, '菜单删除', 'system:menu:delete', 3, 4, 102, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1017, '部门查询', 'system:dept:query', 3, 1, 103, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1018, '部门新增', 'system:dept:create', 3, 2, 103, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1019, '部门修改', 'system:dept:update', 3, 3, 103, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1020, '部门删除', 'system:dept:delete', 3, 4, 103, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1021, '岗位查询', 'system:post:query', 3, 1, 104, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1022, '岗位新增', 'system:post:create', 3, 2, 104, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1023, '岗位修改', 'system:post:update', 3, 3, 104, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1024, '岗位删除', 'system:post:delete', 3, 4, 104, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1025, '岗位导出', 'system:post:export', 3, 5, 104, '', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1026, '字典查询', 'system:dict:query', 3, 1, 105, '#', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1027, '字典新增', 'system:dict:create', 3, 2, 105, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1028, '字典修改', 'system:dict:update', 3, 3, 105, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1029, '字典删除', 'system:dict:delete', 3, 4, 105, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1030, '字典导出', 'system:dict:export', 3, 5, 105, '#', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1031, '配置查询', 'infra:config:query', 3, 1, 106, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1032, '配置新增', 'infra:config:create', 3, 2, 106, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1033, '配置修改', 'infra:config:update', 3, 3, 106, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1034, '配置删除', 'infra:config:delete', 3, 4, 106, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1035, '配置导出', 'infra:config:export', 3, 5, 106, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1036, '公告查询', 'system:notice:query', 3, 1, 107, '#', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1037, '公告新增', 'system:notice:create', 3, 2, 107, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1038, '公告修改', 'system:notice:update', 3, 3, 107, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1039, '公告删除', 'system:notice:delete', 3, 4, 107, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1040, '操作查询', 'system:operate-log:query', 3, 1, 500, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1042, '日志导出', 'system:operate-log:export', 3, 2, 500, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1043, '登录查询', 'system:login-log:query', 3, 1, 501, '#', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1045, '日志导出', 'system:login-log:export', 3, 3, 501, '#', '#', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1046, '令牌列表', 'system:oauth2-token:page', 3, 1, 109, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-05-09 23:54:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1048, '令牌删除', 'system:oauth2-token:delete', 3, 2, 109, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-05-09 23:54:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1050, '任务新增', 'infra:job:create', 3, 2, 110, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1051, '任务修改', 'infra:job:update', 3, 3, 110, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1052, '任务删除', 'infra:job:delete', 3, 4, 110, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1053, '状态修改', 'infra:job:update', 3, 5, 110, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1054, '任务导出', 'infra:job:export', 3, 7, 110, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1056, '生成修改', 'infra:codegen:update', 3, 2, 115, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1057, '生成删除', 'infra:codegen:delete', 3, 3, 115, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1058, '导入代码', 'infra:codegen:create', 3, 2, 115, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1059, '预览代码', 'infra:codegen:preview', 3, 4, 115, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1060, '生成代码', 'infra:codegen:download', 3, 5, 115, '', '', '', NULL, 0, '1', '1', '1', 'admin', '2021-01-05 17:03:48', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1063, '设置角色菜单权限', 'system:permission:assign-role-menu', 3, 6, 101, '', '', '', NULL, 0, '1', '1', '1', '', '2021-01-06 17:53:44', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1064, '设置角色数据权限', 'system:permission:assign-role-data-scope', 3, 7, 101, '', '', '', NULL, 0, '1', '1', '1', '', '2021-01-06 17:56:31', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1065, '设置用户角色', 'system:permission:assign-user-role', 3, 8, 101, '', '', '', NULL, 0, '1', '1', '1', '', '2021-01-07 10:23:28', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1066, '获得 Redis 监控信息', 'infra:redis:get-monitor-info', 3, 1, 113, '', '', '', NULL, 0, '1', '1', '1', '', '2021-01-26 01:02:31', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1067, '获得 Redis Key 列表', 'infra:redis:get-key-list', 3, 2, 113, '', '', '', NULL, 0, '1', '1', '1', '', '2021-01-26 01:02:52', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1070, '代码生成案例', '', 1, 1, 2, 'demo', 'ep:aim', 'infra/testDemo/index', NULL, 0, '1', '1', '1', '', '2021-02-06 12:42:49', '1', '2023-11-15 23:45:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1075, '任务触发', 'infra:job:trigger', 3, 8, 110, '', '', '', NULL, 0, '1', '1', '1', '', '2021-02-07 13:03:10', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1077, '链路追踪', '', 2, 4, 2740, 'skywalking', 'fa:eye', 'infra/skywalking/index', 'InfraSkyWalking', 0, '1', '1', '1', '', '2021-02-08 20:41:31', '1', '2024-04-23 00:07:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1078, '访问日志', '', 2, 1, 1083, 'api-access-log', 'ep:place', 'infra/apiAccessLog/index', 'InfraApiAccessLog', 0, '1', '1', '1', '', '2021-02-26 01:32:59', '1', '2024-02-29 08:54:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1082, '日志导出', 'infra:api-access-log:export', 3, 2, 1078, '', '', '', NULL, 0, '1', '1', '1', '', '2021-02-26 01:32:59', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1083, 'API 日志', '', 2, 4, 2, 'log', 'fa:tasks', NULL, NULL, 0, '1', '1', '1', '', '2021-02-26 02:18:24', '1', '2024-04-22 23:58:36', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1084, '错误日志', 'infra:api-error-log:query', 2, 2, 1083, 'api-error-log', 'ep:warning-filled', 'infra/apiErrorLog/index', 'InfraApiErrorLog', 0, '1', '1', '1', '', '2021-02-26 07:53:20', '1', '2024-02-29 08:55:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1085, '日志处理', 'infra:api-error-log:update-status', 3, 2, 1084, '', '', '', NULL, 0, '1', '1', '1', '', '2021-02-26 07:53:20', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1086, '日志导出', 'infra:api-error-log:export', 3, 3, 1084, '', '', '', NULL, 0, '1', '1', '1', '', '2021-02-26 07:53:20', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1087, '任务查询', 'infra:job:query', 3, 1, 110, '', '', '', NULL, 0, '1', '1', '1', '1', '2021-03-10 01:26:19', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1088, '日志查询', 'infra:api-access-log:query', 3, 1, 1078, '', '', '', NULL, 0, '1', '1', '1', '1', '2021-03-10 01:28:04', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1089, '日志查询', 'infra:api-error-log:query', 3, 1, 1084, '', '', '', NULL, 0, '1', '1', '1', '1', '2021-03-10 01:29:09', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1090, '文件列表', '', 2, 5, 1243, 'file', 'ep:upload-filled', 'infra/file/index', 'InfraFile', 0, '1', '1', '1', '', '2021-03-12 20:16:20', '1', '2024-02-29 08:53:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1091, '文件查询', 'infra:file:query', 3, 1, 1090, '', '', '', NULL, 0, '1', '1', '1', '', '2021-03-12 20:16:20', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1092, '文件删除', 'infra:file:delete', 3, 4, 1090, '', '', '', NULL, 0, '1', '1', '1', '', '2021-03-12 20:16:20', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1093, '短信管理', '', 1, 1, 2739, 'sms', 'ep:message', NULL, NULL, 0, '1', '1', '1', '1', '2021-04-05 01:10:16', '1', '2024-04-22 23:56:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1094, '短信渠道', '', 2, 0, 1093, 'sms-channel', 'fa:stack-exchange', 'system/sms/channel/index', 'SystemSmsChannel', 0, '1', '1', '1', '', '2021-04-01 11:07:15', '1', '2024-02-29 01:15:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1095, '短信渠道查询', 'system:sms-channel:query', 3, 1, 1094, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1096, '短信渠道创建', 'system:sms-channel:create', 3, 2, 1094, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1097, '短信渠道更新', 'system:sms-channel:update', 3, 3, 1094, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1098, '短信渠道删除', 'system:sms-channel:delete', 3, 4, 1094, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-01 11:07:15', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1100, '短信模板', '', 2, 1, 1093, 'sms-template', 'ep:connection', 'system/sms/template/index', 'SystemSmsTemplate', 0, '1', '1', '1', '', '2021-04-01 17:35:17', '1', '2024-02-29 01:16:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1101, '短信模板查询', 'system:sms-template:query', 3, 1, 1100, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1102, '短信模板创建', 'system:sms-template:create', 3, 2, 1100, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1103, '短信模板更新', 'system:sms-template:update', 3, 3, 1100, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1104, '短信模板删除', 'system:sms-template:delete', 3, 4, 1100, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1105, '短信模板导出', 'system:sms-template:export', 3, 5, 1100, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-01 17:35:17', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1106, '发送测试短信', 'system:sms-template:send-sms', 3, 6, 1100, '', '', '', NULL, 0, '1', '1', '1', '1', '2021-04-11 00:26:40', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1107, '短信日志', '', 2, 2, 1093, 'sms-log', 'fa:edit', 'system/sms/log/index', 'SystemSmsLog', 0, '1', '1', '1', '', '2021-04-11 08:37:05', '1', '2024-02-29 08:49:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1108, '短信日志查询', 'system:sms-log:query', 3, 1, 1107, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-11 08:37:05', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1109, '短信日志导出', 'system:sms-log:export', 3, 5, 1107, '', '', '', NULL, 0, '1', '1', '1', '', '2021-04-11 08:37:05', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1117, '支付管理', '', 1, 30, 0, '/pay', 'ep:money', NULL, NULL, 0, '1', '1', '1', '1', '2021-12-25 16:43:41', '1', '2024-02-29 08:58:38', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1118, '请假查询', '', 2, 0, 5, 'leave', 'fa:leanpub', 'bpm/oa/leave/index', 'BpmOALeave', 0, '1', '1', '1', '', '2021-09-20 08:51:03', '1', '2024-02-29 12:38:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1119, '请假申请查询', 'bpm:oa-leave:query', 3, 1, 1118, '', '', '', NULL, 0, '1', '1', '1', '', '2021-09-20 08:51:03', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1120, '请假申请创建', 'bpm:oa-leave:create', 3, 2, 1118, '', '', '', NULL, 0, '1', '1', '1', '', '2021-09-20 08:51:03', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1126, '应用信息', '', 2, 1, 1117, 'app', 'fa:apple', 'pay/app/index', 'PayApp', 0, '1', '1', '1', '', '2021-11-10 01:13:30', '1', '2024-02-29 08:59:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1127, '支付应用信息查询', 'pay:app:query', 3, 1, 1126, '', '', '', NULL, 0, '1', '1', '1', '', '2021-11-10 01:13:31', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1128, '支付应用信息创建', 'pay:app:create', 3, 2, 1126, '', '', '', NULL, 0, '1', '1', '1', '', '2021-11-10 01:13:31', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1129, '支付应用信息更新', 'pay:app:update', 3, 3, 1126, '', '', '', NULL, 0, '1', '1', '1', '', '2021-11-10 01:13:31', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1130, '支付应用信息删除', 'pay:app:delete', 3, 4, 1126, '', '', '', NULL, 0, '1', '1', '1', '', '2021-11-10 01:13:31', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1132, '秘钥解析', 'pay:channel:parsing', 3, 6, 1129, '', '', '', NULL, 0, '1', '1', '1', '1', '2021-11-08 15:15:47', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1133, '支付商户信息查询', 'pay:merchant:query', 3, 1, 1132, '', '', '', NULL, 0, '1', '1', '1', '', '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1134, '支付商户信息创建', 'pay:merchant:create', 3, 2, 1132, '', '', '', NULL, 0, '1', '1', '1', '', '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1135, '支付商户信息更新', 'pay:merchant:update', 3, 3, 1132, '', '', '', NULL, 0, '1', '1', '1', '', '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1136, '支付商户信息删除', 'pay:merchant:delete', 3, 4, 1132, '', '', '', NULL, 0, '1', '1', '1', '', '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1137, '支付商户信息导出', 'pay:merchant:export', 3, 5, 1132, '', '', '', NULL, 0, '1', '1', '1', '', '2021-11-10 01:13:41', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1138, '租户列表', '', 2, 0, 1224, 'list', 'ep:house', 'system/tenant/index', 'SystemTenant', 0, '1', '1', '1', '', '2021-12-14 12:31:43', '1', '2024-02-29 01:01:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1139, '租户查询', 'system:tenant:query', 3, 1, 1138, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1140, '租户创建', 'system:tenant:create', 3, 2, 1138, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1141, '租户更新', 'system:tenant:update', 3, 3, 1138, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1142, '租户删除', 'system:tenant:delete', 3, 4, 1138, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1143, '租户导出', 'system:tenant:export', 3, 5, 1138, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-14 12:31:44', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1150, '秘钥解析', '', 3, 6, 1129, '', '', '', NULL, 0, '1', '1', '1', '1', '2021-11-08 15:15:47', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1161, '退款订单', '', 2, 3, 1117, 'refund', 'fa:registered', 'pay/refund/index', 'PayRefund', 0, '1', '1', '1', '', '2021-12-25 08:29:07', '1', '2024-02-29 08:59:20', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1162, '退款订单查询', 'pay:refund:query', 3, 1, 1161, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-25 08:29:07', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1166, '退款订单导出', 'pay:refund:export', 3, 5, 1161, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-25 08:29:07', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1173, '支付订单', '', 2, 2, 1117, 'order', 'fa:cc-paypal', 'pay/order/index', 'PayOrder', 0, '1', '1', '1', '', '2021-12-25 08:49:43', '1', '2024-02-29 08:59:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1174, '支付订单查询', 'pay:order:query', 3, 1, 1173, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-25 08:49:43', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1178, '支付订单导出', 'pay:order:export', 3, 5, 1173, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-25 08:49:43', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1185, '工作流程', '', 1, 50, 0, '/bpm', 'fa:medium', NULL, NULL, 0, '1', '1', '1', '1', '2021-12-30 20:26:36', '1', '2024-02-29 12:43:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1186, '流程管理', '', 1, 10, 1185, 'manager', 'fa:dedent', NULL, NULL, 0, '1', '1', '1', '1', '2021-12-30 20:28:30', '1', '2024-02-29 12:36:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1187, '流程表单', '', 2, 2, 1186, 'form', 'fa:hdd-o', 'bpm/form/index', 'BpmForm', 0, '1', '1', '1', '', '2021-12-30 12:38:22', '1', '2024-03-19 12:25:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1188, '表单查询', 'bpm:form:query', 3, 1, 1187, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1189, '表单创建', 'bpm:form:create', 3, 2, 1187, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1190, '表单更新', 'bpm:form:update', 3, 3, 1187, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1191, '表单删除', 'bpm:form:delete', 3, 4, 1187, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1192, '表单导出', 'bpm:form:export', 3, 5, 1187, '', '', '', NULL, 0, '1', '1', '1', '', '2021-12-30 12:38:22', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1193, '流程模型', '', 2, 1, 1186, 'model', 'fa-solid:project-diagram', 'bpm/model/index', 'BpmModel', 0, '1', '1', '1', '1', '2021-12-31 23:24:58', '1', '2024-03-19 12:25:19', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1194, '模型查询', 'bpm:model:query', 3, 1, 1193, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-03 19:01:10', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1195, '模型创建', 'bpm:model:create', 3, 2, 1193, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-03 19:01:24', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1197, '模型更新', 'bpm:model:update', 3, 4, 1193, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-03 19:02:28', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1198, '模型删除', 'bpm:model:delete', 3, 5, 1193, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-03 19:02:43', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1199, '模型发布', 'bpm:model:deploy', 3, 6, 1193, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-03 19:03:24', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1200, '审批中心', '', 2, 20, 1185, 'task', 'fa:tasks', NULL, NULL, 0, '1', '1', '1', '1', '2022-01-07 23:51:48', '1', '2024-03-21 00:33:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1201, '我的流程', '', 2, 1, 1200, 'my', 'fa-solid:book', 'bpm/processInstance/index', 'BpmProcessInstanceMy', 0, '1', '1', '1', '', '2022-01-07 15:53:44', '1', '2024-03-21 23:52:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1202, '流程实例的查询', 'bpm:process-instance:query', 3, 1, 1201, '', '', '', NULL, 0, '1', '1', '1', '', '2022-01-07 15:53:44', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1207, '待办任务', '', 2, 10, 1200, 'todo', 'fa:slack', 'bpm/task/todo/index', 'BpmTodoTask', 0, '1', '1', '1', '1', '2022-01-08 10:33:37', '1', '2024-02-29 12:37:39', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1208, '已办任务', '', 2, 20, 1200, 'done', 'fa:delicious', 'bpm/task/done/index', 'BpmDoneTask', 0, '1', '1', '1', '1', '2022-01-08 10:34:13', '1', '2024-02-29 12:37:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1209, '用户分组', '', 2, 4, 1186, 'user-group', 'fa:user-secret', 'bpm/group/index', 'BpmUserGroup', 0, '1', '1', '1', '', '2022-01-14 02:14:20', '1', '2024-03-21 23:55:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1210, '用户组查询', 'bpm:user-group:query', 3, 1, 1209, '', '', '', NULL, 0, '1', '1', '1', '', '2022-01-14 02:14:20', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1211, '用户组创建', 'bpm:user-group:create', 3, 2, 1209, '', '', '', NULL, 0, '1', '1', '1', '', '2022-01-14 02:14:20', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1212, '用户组更新', 'bpm:user-group:update', 3, 3, 1209, '', '', '', NULL, 0, '1', '1', '1', '', '2022-01-14 02:14:20', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1213, '用户组删除', 'bpm:user-group:delete', 3, 4, 1209, '', '', '', NULL, 0, '1', '1', '1', '', '2022-01-14 02:14:20', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1215, '流程定义查询', 'bpm:process-definition:query', 3, 10, 1193, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-23 00:21:43', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1216, '流程任务分配规则查询', 'bpm:task-assign-rule:query', 3, 20, 1193, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-23 00:26:53', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1217, '流程任务分配规则创建', 'bpm:task-assign-rule:create', 3, 21, 1193, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-23 00:28:15', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1218, '流程任务分配规则更新', 'bpm:task-assign-rule:update', 3, 22, 1193, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-23 00:28:41', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1219, '流程实例的创建', 'bpm:process-instance:create', 3, 2, 1201, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-23 00:36:15', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1220, '流程实例的取消', 'bpm:process-instance:cancel', 3, 3, 1201, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-23 00:36:33', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1221, '流程任务的查询', 'bpm:task:query', 3, 1, 1207, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-23 00:38:52', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1222, '流程任务的更新', 'bpm:task:update', 3, 2, 1207, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-01-23 00:39:24', '1', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1224, '租户管理', '', 2, 0, 1, 'tenant', 'fa-solid:house-user', NULL, NULL, 0, '1', '1', '1', '1', '2022-02-20 01:41:13', '1', '2024-02-29 00:59:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1225, '租户套餐', '', 2, 0, 1224, 'package', 'fa:bars', 'system/tenantPackage/index', 'SystemTenantPackage', 0, '1', '1', '1', '', '2022-02-19 17:44:06', '1', '2024-02-29 01:01:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1226, '租户套餐查询', 'system:tenant-package:query', 3, 1, 1225, '', '', '', NULL, 0, '1', '1', '1', '', '2022-02-19 17:44:06', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1227, '租户套餐创建', 'system:tenant-package:create', 3, 2, 1225, '', '', '', NULL, 0, '1', '1', '1', '', '2022-02-19 17:44:06', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1228, '租户套餐更新', 'system:tenant-package:update', 3, 3, 1225, '', '', '', NULL, 0, '1', '1', '1', '', '2022-02-19 17:44:06', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1229, '租户套餐删除', 'system:tenant-package:delete', 3, 4, 1225, '', '', '', NULL, 0, '1', '1', '1', '', '2022-02-19 17:44:06', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1237, '文件配置', '', 2, 0, 1243, 'file-config', 'fa-solid:file-signature', 'infra/fileConfig/index', 'InfraFileConfig', 0, '1', '1', '1', '', '2022-03-15 14:35:28', '1', '2024-02-29 08:52:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1238, '文件配置查询', 'infra:file-config:query', 3, 1, 1237, '', '', '', NULL, 0, '1', '1', '1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1239, '文件配置创建', 'infra:file-config:create', 3, 2, 1237, '', '', '', NULL, 0, '1', '1', '1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1240, '文件配置更新', 'infra:file-config:update', 3, 3, 1237, '', '', '', NULL, 0, '1', '1', '1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1241, '文件配置删除', 'infra:file-config:delete', 3, 4, 1237, '', '', '', NULL, 0, '1', '1', '1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1242, '文件配置导出', 'infra:file-config:export', 3, 5, 1237, '', '', '', NULL, 0, '1', '1', '1', '', '2022-03-15 14:35:28', '', '2022-04-20 17:03:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1243, '文件管理', '', 2, 6, 2, 'file', 'ep:files', NULL, '', 0, '1', '1', '1', '1', '2022-03-16 23:47:40', '1', '2024-04-23 00:02:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1254, '作者动态', '', 1, 0, 0, 'https://xxx', 'ep:avatar', NULL, NULL, 0, '1', '1', '1', '1', '2022-04-23 01:03:15', '1', '2025-04-29 17:45:38', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1255, '数据源配置', '', 2, 1, 2, 'data-source-config', 'ep:data-analysis', 'infra/dataSourceConfig/index', 'InfraDataSourceConfig', 0, '1', '1', '1', '', '2022-04-27 14:37:32', '1', '2024-02-29 08:51:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1256, '数据源配置查询', 'infra:data-source-config:query', 3, 1, 1255, '', '', '', NULL, 0, '1', '1', '1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1257, '数据源配置创建', 'infra:data-source-config:create', 3, 2, 1255, '', '', '', NULL, 0, '1', '1', '1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1258, '数据源配置更新', 'infra:data-source-config:update', 3, 3, 1255, '', '', '', NULL, 0, '1', '1', '1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1259, '数据源配置删除', 'infra:data-source-config:delete', 3, 4, 1255, '', '', '', NULL, 0, '1', '1', '1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1260, '数据源配置导出', 'infra:data-source-config:export', 3, 5, 1255, '', '', '', NULL, 0, '1', '1', '1', '', '2022-04-27 14:37:32', '', '2022-04-27 14:37:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1261, 'OAuth 2.0', '', 2, 10, 1, 'oauth2', 'fa:dashcube', NULL, NULL, 0, '1', '1', '1', '1', '2022-05-09 23:38:17', '1', '2024-02-29 01:12:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1263, '应用管理', '', 2, 0, 1261, 'oauth2/application', 'fa:hdd-o', 'system/oauth2/client/index', 'SystemOAuth2Client', 0, '1', '1', '1', '', '2022-05-10 16:26:33', '1', '2024-02-29 01:13:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1264, '客户端查询', 'system:oauth2-client:query', 3, 1, 1263, '', '', '', NULL, 0, '1', '1', '1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1265, '客户端创建', 'system:oauth2-client:create', 3, 2, 1263, '', '', '', NULL, 0, '1', '1', '1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1266, '客户端更新', 'system:oauth2-client:update', 3, 3, 1263, '', '', '', NULL, 0, '1', '1', '1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1267, '客户端删除', 'system:oauth2-client:delete', 3, 4, 1263, '', '', '', NULL, 0, '1', '1', '1', '', '2022-05-10 16:26:33', '1', '2022-05-11 00:31:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1281, '报表管理', '', 2, 40, 0, '/report', 'ep:pie-chart', NULL, NULL, 0, '1', '1', '1', '1', '2022-07-10 20:22:15', '1', '2024-02-29 12:33:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (1282, '报表设计器', '', 2, 1, 1281, 'jimu-report', 'ep:trend-charts', 'report/jmreport/index', 'JimuReport', 0, '1', '1', '1', '1', '2022-07-10 20:26:36', '1', '2025-05-03 09:57:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2000, '商品中心', '', 1, 60, 2362, 'product', 'fa:product-hunt', NULL, NULL, 0, '1', '1', '1', '', '2022-07-29 15:53:53', '1', '2023-09-30 11:52:36', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2002, '商品分类', '', 2, 2, 2000, 'category', 'ep:cellphone', 'mall/product/category/index', 'ProductCategory', 0, '1', '1', '1', '', '2022-07-29 15:53:53', '1', '2023-08-21 10:27:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2003, '分类查询', 'product:category:query', 3, 1, 2002, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2004, '分类创建', 'product:category:create', 3, 2, 2002, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2005, '分类更新', 'product:category:update', 3, 3, 2002, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2006, '分类删除', 'product:category:delete', 3, 4, 2002, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-29 15:53:53', '', '2022-07-29 15:53:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2008, '商品品牌', '', 2, 3, 2000, 'brand', 'ep:chicken', 'mall/product/brand/index', 'ProductBrand', 0, '1', '1', '1', '', '2022-07-30 13:52:44', '1', '2023-08-21 10:27:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2009, '品牌查询', 'product:brand:query', 3, 1, 2008, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-30 13:52:44', '', '2022-07-30 13:52:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2010, '品牌创建', 'product:brand:create', 3, 2, 2008, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-30 13:52:44', '', '2022-07-30 13:52:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2011, '品牌更新', 'product:brand:update', 3, 3, 2008, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-30 13:52:44', '', '2022-07-30 13:52:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2012, '品牌删除', 'product:brand:delete', 3, 4, 2008, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-30 13:52:44', '', '2022-07-30 13:52:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2014, '商品列表', '', 2, 1, 2000, 'spu', 'ep:apple', 'mall/product/spu/index', 'ProductSpu', 0, '1', '1', '1', '', '2022-07-30 14:22:58', '1', '2023-08-21 10:27:01', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2015, '商品查询', 'product:spu:query', 3, 1, 2014, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2016, '商品创建', 'product:spu:create', 3, 2, 2014, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2017, '商品更新', 'product:spu:update', 3, 3, 2014, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2018, '商品删除', 'product:spu:delete', 3, 4, 2014, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2019, '商品属性', '', 2, 4, 2000, 'property', 'ep:cold-drink', 'mall/product/property/index', 'ProductProperty', 0, '1', '1', '1', '', '2022-08-01 14:55:35', '1', '2023-08-26 11:01:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2020, '规格查询', 'product:property:query', 3, 1, 2019, '', '', '', NULL, 0, '1', '1', '1', '', '2022-08-01 14:55:35', '', '2022-12-12 20:26:24', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2021, '规格创建', 'product:property:create', 3, 2, 2019, '', '', '', NULL, 0, '1', '1', '1', '', '2022-08-01 14:55:35', '', '2022-12-12 20:26:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2022, '规格更新', 'product:property:update', 3, 3, 2019, '', '', '', NULL, 0, '1', '1', '1', '', '2022-08-01 14:55:35', '', '2022-12-12 20:26:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2023, '规格删除', 'product:property:delete', 3, 4, 2019, '', '', '', NULL, 0, '1', '1', '1', '', '2022-08-01 14:55:35', '', '2022-12-12 20:26:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2025, 'Banner', '', 2, 100, 2387, 'banner', 'fa:bandcamp', 'mall/promotion/banner/index', NULL, 0, '1', '1', '1', '', '2022-08-01 14:56:14', '1', '2023-10-24 20:20:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2026, 'Banner查询', 'promotion:banner:query', 3, 1, 2025, '', '', '', '', 0, '1', '1', '1', '', '2022-08-01 14:56:14', '1', '2023-10-24 20:20:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2027, 'Banner创建', 'promotion:banner:create', 3, 2, 2025, '', '', '', '', 0, '1', '1', '1', '', '2022-08-01 14:56:14', '1', '2023-10-24 20:20:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2028, 'Banner更新', 'promotion:banner:update', 3, 3, 2025, '', '', '', '', 0, '1', '1', '1', '', '2022-08-01 14:56:14', '1', '2023-10-24 20:20:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2029, 'Banner删除', 'promotion:banner:delete', 3, 4, 2025, '', '', '', '', 0, '1', '1', '1', '', '2022-08-01 14:56:14', '1', '2023-10-24 20:20:36', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2030, '营销中心', '', 1, 70, 2362, 'promotion', 'ep:present', NULL, NULL, 0, '1', '1', '1', '1', '2022-10-31 21:25:09', '1', '2023-09-30 11:54:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2032, '优惠劵列表', '', 2, 1, 2365, 'template', 'ep:discount', 'mall/promotion/coupon/template/index', 'PromotionCouponTemplate', 0, '1', '1', '1', '', '2022-10-31 22:27:14', '1', '2023-10-03 12:40:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2033, '优惠劵模板查询', 'promotion:coupon-template:query', 3, 1, 2032, '', '', '', NULL, 0, '1', '1', '1', '', '2022-10-31 22:27:14', '', '2022-10-31 22:27:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2034, '优惠劵模板创建', 'promotion:coupon-template:create', 3, 2, 2032, '', '', '', NULL, 0, '1', '1', '1', '', '2022-10-31 22:27:14', '', '2022-10-31 22:27:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2035, '优惠劵模板更新', 'promotion:coupon-template:update', 3, 3, 2032, '', '', '', NULL, 0, '1', '1', '1', '', '2022-10-31 22:27:14', '', '2022-10-31 22:27:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2036, '优惠劵模板删除', 'promotion:coupon-template:delete', 3, 4, 2032, '', '', '', NULL, 0, '1', '1', '1', '', '2022-10-31 22:27:14', '', '2022-10-31 22:27:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2038, '领取记录', '', 2, 2, 2365, 'list', 'ep:collection-tag', 'mall/promotion/coupon/index', 'PromotionCoupon', 0, '1', '1', '1', '', '2022-11-03 23:21:31', '1', '2023-10-03 12:55:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2039, '优惠劵查询', 'promotion:coupon:query', 3, 1, 2038, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-03 23:21:31', '', '2022-11-03 23:21:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2040, '优惠劵删除', 'promotion:coupon:delete', 3, 4, 2038, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-03 23:21:31', '', '2022-11-03 23:21:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2041, '满减送', '', 2, 10, 2390, 'reward-activity', 'ep:goblet-square-full', 'mall/promotion/rewardActivity/index', 'PromotionRewardActivity', 0, '1', '1', '1', '', '2022-11-04 23:47:49', '1', '2023-10-21 19:24:46', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2042, '满减送活动查询', 'promotion:reward-activity:query', 3, 1, 2041, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-04 23:47:49', '', '2022-11-04 23:47:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2043, '满减送活动创建', 'promotion:reward-activity:create', 3, 2, 2041, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-04 23:47:49', '', '2022-11-04 23:47:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2044, '满减送活动更新', 'promotion:reward-activity:update', 3, 3, 2041, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-04 23:47:50', '', '2022-11-04 23:47:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2045, '满减送活动删除', 'promotion:reward-activity:delete', 3, 4, 2041, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-04 23:47:50', '', '2022-11-04 23:47:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2046, '满减送活动关闭', 'promotion:reward-activity:close', 3, 5, 2041, '', '', '', NULL, 0, '1', '1', '1', '1', '2022-11-05 10:42:53', '1', '2022-11-05 10:42:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2047, '限时折扣', '', 2, 7, 2390, 'discount-activity', 'ep:timer', 'mall/promotion/discountActivity/index', 'PromotionDiscountActivity', 0, '1', '1', '1', '', '2022-11-05 17:12:15', '1', '2023-10-21 19:24:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2048, '限时折扣活动查询', 'promotion:discount-activity:query', 3, 1, 2047, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-05 17:12:15', '', '2022-11-05 17:12:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2049, '限时折扣活动创建', 'promotion:discount-activity:create', 3, 2, 2047, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-05 17:12:15', '', '2022-11-05 17:12:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2050, '限时折扣活动更新', 'promotion:discount-activity:update', 3, 3, 2047, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-05 17:12:16', '', '2022-11-05 17:12:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2051, '限时折扣活动删除', 'promotion:discount-activity:delete', 3, 4, 2047, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-05 17:12:16', '', '2022-11-05 17:12:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2052, '限时折扣活动关闭', 'promotion:discount-activity:close', 3, 5, 2047, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-05 17:12:16', '', '2022-11-05 17:12:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2059, '秒杀商品', '', 2, 2, 2209, 'activity', 'ep:basketball', 'mall/promotion/seckill/activity/index', 'PromotionSeckillActivity', 0, '1', '1', '1', '', '2022-11-06 22:24:49', '1', '2023-06-24 18:57:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2060, '秒杀活动查询', 'promotion:seckill-activity:query', 3, 1, 2059, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-06 22:24:49', '', '2022-11-06 22:24:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2061, '秒杀活动创建', 'promotion:seckill-activity:create', 3, 2, 2059, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-06 22:24:49', '', '2022-11-06 22:24:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2062, '秒杀活动更新', 'promotion:seckill-activity:update', 3, 3, 2059, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-06 22:24:49', '', '2022-11-06 22:24:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2063, '秒杀活动删除', 'promotion:seckill-activity:delete', 3, 4, 2059, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-06 22:24:49', '', '2022-11-06 22:24:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2066, '秒杀时段', '', 2, 1, 2209, 'config', 'ep:baseball', 'mall/promotion/seckill/config/index', 'PromotionSeckillConfig', 0, '1', '1', '1', '', '2022-11-15 19:46:50', '1', '2023-06-24 18:57:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2067, '秒杀时段查询', 'promotion:seckill-config:query', 3, 1, 2066, '', '', '', '', 0, '1', '1', '1', '', '2022-11-15 19:46:51', '1', '2023-06-24 17:50:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2068, '秒杀时段创建', 'promotion:seckill-config:create', 3, 2, 2066, '', '', '', '', 0, '1', '1', '1', '', '2022-11-15 19:46:51', '1', '2023-06-24 17:48:39', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2069, '秒杀时段更新', 'promotion:seckill-config:update', 3, 3, 2066, '', '', '', '', 0, '1', '1', '1', '', '2022-11-15 19:46:51', '1', '2023-06-24 17:50:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2070, '秒杀时段删除', 'promotion:seckill-config:delete', 3, 4, 2066, '', '', '', '', 0, '1', '1', '1', '', '2022-11-15 19:46:51', '1', '2023-06-24 17:50:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2072, '订单中心', '', 1, 65, 2362, 'trade', 'ep:eleme', NULL, NULL, 0, '1', '1', '1', '1', '2022-11-19 18:57:19', '1', '2023-09-30 11:54:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2073, '售后退款', '', 2, 2, 2072, 'after-sale', 'ep:refrigerator', 'mall/trade/afterSale/index', 'TradeAfterSale', 0, '1', '1', '1', '', '2022-11-19 20:15:32', '1', '2023-10-01 21:42:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2074, '售后查询', 'trade:after-sale:query', 3, 1, 2073, '', '', '', NULL, 0, '1', '1', '1', '', '2022-11-19 20:15:33', '1', '2022-12-10 21:04:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2075, '秒杀活动关闭', 'promotion:seckill-activity:close', 3, 5, 2059, '', '', '', '', 0, '1', '1', '1', '1', '2022-11-28 20:20:15', '1', '2023-10-03 18:34:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2076, '订单列表', '', 2, 1, 2072, 'order', 'ep:list', 'mall/trade/order/index', 'TradeOrder', 0, '1', '1', '1', '1', '2022-12-10 21:05:44', '1', '2023-10-01 21:42:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2083, '地区管理', '', 2, 14, 1, 'area', 'fa:map-marker', 'system/area/index', 'SystemArea', 0, '1', '1', '1', '1', '2022-12-23 17:35:05', '1', '2024-02-29 08:50:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2084, '公众号管理', '', 1, 100, 0, '/mp', 'ep:compass', NULL, NULL, 0, '1', '1', '1', '1', '2023-01-01 20:11:04', '1', '2024-02-29 12:39:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2085, '账号管理', '', 2, 1, 2084, 'account', 'fa:user', 'mp/account/index', 'MpAccount', 0, '1', '1', '1', '1', '2023-01-01 20:13:31', '1', '2024-02-29 12:42:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2086, '新增账号', 'mp:account:create', 3, 1, 2085, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-01 20:21:40', '1', '2023-01-07 17:32:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2087, '修改账号', 'mp:account:update', 3, 2, 2085, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-07 17:32:46', '1', '2023-01-07 17:32:46', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2088, '查询账号', 'mp:account:query', 3, 0, 2085, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-07 17:33:07', '1', '2023-01-07 17:33:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2089, '删除账号', 'mp:account:delete', 3, 3, 2085, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-07 17:33:21', '1', '2023-01-07 17:33:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2090, '生成二维码', 'mp:account:qr-code', 3, 4, 2085, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-07 17:33:58', '1', '2023-01-07 17:33:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2091, '清空 API 配额', 'mp:account:clear-quota', 3, 5, 2085, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-07 18:20:32', '1', '2023-01-07 18:20:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2092, '数据统计', 'mp:statistics:query', 2, 2, 2084, 'statistics', 'ep:trend-charts', 'mp/statistics/index', 'MpStatistics', 0, '1', '1', '1', '1', '2023-01-07 20:17:36', '1', '2024-02-29 12:42:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2093, '标签管理', '', 2, 3, 2084, 'tag', 'ep:collection-tag', 'mp/tag/index', 'MpTag', 0, '1', '1', '1', '1', '2023-01-08 11:37:32', '1', '2024-02-29 12:42:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2094, '查询标签', 'mp:tag:query', 3, 0, 2093, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-08 11:59:03', '1', '2023-01-08 11:59:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2095, '新增标签', 'mp:tag:create', 3, 1, 2093, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-08 11:59:23', '1', '2023-01-08 11:59:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2096, '修改标签', 'mp:tag:update', 3, 2, 2093, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-08 11:59:41', '1', '2023-01-08 11:59:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2097, '删除标签', 'mp:tag:delete', 3, 3, 2093, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-08 12:00:04', '1', '2023-01-08 12:00:13', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2098, '同步标签', 'mp:tag:sync', 3, 4, 2093, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-08 12:00:29', '1', '2023-01-08 12:00:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2099, '粉丝管理', '', 2, 4, 2084, 'user', 'fa:user-secret', 'mp/user/index', 'MpUser', 0, '1', '1', '1', '1', '2023-01-08 16:51:20', '1', '2024-02-29 12:42:39', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2100, '查询粉丝', 'mp:user:query', 3, 0, 2099, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-08 17:16:59', '1', '2023-01-08 17:17:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2101, '修改粉丝', 'mp:user:update', 3, 1, 2099, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-08 17:17:11', '1', '2023-01-08 17:17:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2102, '同步粉丝', 'mp:user:sync', 3, 2, 2099, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-08 17:17:40', '1', '2023-01-08 17:17:40', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2103, '消息管理', '', 2, 5, 2084, 'message', 'ep:message', 'mp/message/index', 'MpMessage', 0, '1', '1', '1', '1', '2023-01-08 18:44:19', '1', '2024-02-29 12:42:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2104, '图文发表记录', '', 2, 10, 2084, 'free-publish', 'ep:edit-pen', 'mp/freePublish/index', 'MpFreePublish', 0, '1', '1', '1', '1', '2023-01-13 00:30:50', '1', '2024-02-29 12:43:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2105, '查询发布列表', 'mp:free-publish:query', 3, 1, 2104, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-13 07:19:17', '1', '2023-01-13 07:19:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2106, '发布草稿', 'mp:free-publish:submit', 3, 2, 2104, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-13 07:19:46', '1', '2023-01-13 07:19:46', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2107, '删除发布记录', 'mp:free-publish:delete', 3, 3, 2104, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-13 07:20:01', '1', '2023-01-13 07:20:01', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2108, '图文草稿箱', '', 2, 9, 2084, 'draft', 'ep:edit', 'mp/draft/index', 'MpDraft', 0, '1', '1', '1', '1', '2023-01-13 07:40:21', '1', '2024-02-29 12:43:26', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2109, '新建草稿', 'mp:draft:create', 3, 1, 2108, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-13 23:15:30', '1', '2023-01-13 23:15:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2110, '修改草稿', 'mp:draft:update', 3, 2, 2108, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-14 10:08:47', '1', '2023-01-14 10:08:47', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2111, '查询草稿', 'mp:draft:query', 3, 0, 2108, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-14 10:09:01', '1', '2023-01-14 10:09:01', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2112, '删除草稿', 'mp:draft:delete', 3, 3, 2108, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-14 10:09:19', '1', '2023-01-14 10:09:19', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2113, '素材管理', '', 2, 8, 2084, 'material', 'ep:basketball', 'mp/material/index', 'MpMaterial', 0, '1', '1', '1', '1', '2023-01-14 14:12:07', '1', '2024-02-29 12:43:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2114, '上传临时素材', 'mp:material:upload-temporary', 3, 1, 2113, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-14 15:33:55', '1', '2023-01-14 15:33:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2115, '上传永久素材', 'mp:material:upload-permanent', 3, 2, 2113, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-14 15:34:14', '1', '2023-01-14 15:34:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2116, '删除素材', 'mp:material:delete', 3, 3, 2113, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-14 15:35:37', '1', '2023-01-14 15:35:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2117, '上传图文图片', 'mp:material:upload-news-image', 3, 4, 2113, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-14 15:36:31', '1', '2023-01-14 15:36:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2118, '查询素材', 'mp:material:query', 3, 5, 2113, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-14 15:39:22', '1', '2023-01-14 15:39:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2119, '菜单管理', '', 2, 6, 2084, 'menu', 'ep:menu', 'mp/menu/index', 'MpMenu', 0, '1', '1', '1', '1', '2023-01-14 17:43:54', '1', '2025-04-01 20:21:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2120, '自动回复', '', 2, 7, 2084, 'auto-reply', 'fa-solid:republican', 'mp/autoReply/index', 'MpAutoReply', 0, '1', '1', '1', '1', '2023-01-15 22:13:09', '1', '2024-02-29 12:43:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2121, '查询回复', 'mp:auto-reply:query', 3, 0, 2120, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-16 22:28:41', '1', '2023-01-16 22:28:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2122, '新增回复', 'mp:auto-reply:create', 3, 1, 2120, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-16 22:28:54', '1', '2023-01-16 22:28:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2123, '修改回复', 'mp:auto-reply:update', 3, 2, 2120, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-16 22:29:05', '1', '2023-01-16 22:29:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2124, '删除回复', 'mp:auto-reply:delete', 3, 3, 2120, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-16 22:29:34', '1', '2023-01-16 22:29:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2125, '查询菜单', 'mp:menu:query', 3, 0, 2119, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-17 23:05:41', '1', '2023-01-17 23:05:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2126, '保存菜单', 'mp:menu:save', 3, 1, 2119, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-17 23:06:01', '1', '2023-01-17 23:06:01', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2127, '删除菜单', 'mp:menu:delete', 3, 2, 2119, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-17 23:06:16', '1', '2023-01-17 23:06:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2128, '查询消息', 'mp:message:query', 3, 0, 2103, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-17 23:07:14', '1', '2023-01-17 23:07:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2129, '发送消息', 'mp:message:send', 3, 1, 2103, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-17 23:07:26', '1', '2023-01-17 23:07:26', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2130, '邮箱管理', '', 2, 2, 2739, 'mail', 'fa-solid:mail-bulk', NULL, NULL, 0, '1', '1', '1', '1', '2023-01-25 17:27:44', '1', '2024-04-22 23:56:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2131, '邮箱账号', '', 2, 0, 2130, 'mail-account', 'fa:universal-access', 'system/mail/account/index', 'SystemMailAccount', 0, '1', '1', '1', '', '2023-01-25 09:33:48', '1', '2024-02-29 08:48:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2132, '账号查询', 'system:mail-account:query', 3, 1, 2131, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2133, '账号创建', 'system:mail-account:create', 3, 2, 2131, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2134, '账号更新', 'system:mail-account:update', 3, 3, 2131, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2135, '账号删除', 'system:mail-account:delete', 3, 4, 2131, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-25 09:33:48', '', '2023-01-25 09:33:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2136, '邮件模版', '', 2, 0, 2130, 'mail-template', 'fa:tag', 'system/mail/template/index', 'SystemMailTemplate', 0, '1', '1', '1', '', '2023-01-25 12:05:31', '1', '2024-02-29 08:48:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2137, '模版查询', 'system:mail-template:query', 3, 1, 2136, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2138, '模版创建', 'system:mail-template:create', 3, 2, 2136, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2139, '模版更新', 'system:mail-template:update', 3, 3, 2136, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2140, '模版删除', 'system:mail-template:delete', 3, 4, 2136, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-25 12:05:31', '', '2023-01-25 12:05:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2141, '邮件记录', '', 2, 0, 2130, 'mail-log', 'fa:edit', 'system/mail/log/index', 'SystemMailLog', 0, '1', '1', '1', '', '2023-01-26 02:16:50', '1', '2024-02-29 08:48:51', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2142, '日志查询', 'system:mail-log:query', 3, 1, 2141, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-26 02:16:50', '', '2023-01-26 02:16:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2143, '发送测试邮件', 'system:mail-template:send-mail', 3, 5, 2136, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-26 23:29:15', '1', '2023-01-26 23:29:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2144, '站内信管理', '', 1, 3, 2739, 'notify', 'ep:message-box', NULL, NULL, 0, '1', '1', '1', '1', '2023-01-28 10:25:18', '1', '2024-04-22 23:56:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2145, '模板管理', '', 2, 0, 2144, 'notify-template', 'fa:archive', 'system/notify/template/index', 'SystemNotifyTemplate', 0, '1', '1', '1', '', '2023-01-28 02:26:42', '1', '2024-02-29 08:49:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2146, '站内信模板查询', 'system:notify-template:query', 3, 1, 2145, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2147, '站内信模板创建', 'system:notify-template:create', 3, 2, 2145, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2148, '站内信模板更新', 'system:notify-template:update', 3, 3, 2145, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2149, '站内信模板删除', 'system:notify-template:delete', 3, 4, 2145, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-28 02:26:42', '', '2023-01-28 02:26:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2150, '发送测试站内信', 'system:notify-template:send-notify', 3, 5, 2145, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-01-28 10:54:43', '1', '2023-01-28 10:54:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2151, '消息记录', '', 2, 0, 2144, 'notify-message', 'fa:edit', 'system/notify/message/index', 'SystemNotifyMessage', 0, '1', '1', '1', '', '2023-01-28 04:28:22', '1', '2024-02-29 08:49:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2152, '站内信消息查询', 'system:notify-message:query', 3, 1, 2151, '', '', '', NULL, 0, '1', '1', '1', '', '2023-01-28 04:28:22', '', '2023-01-28 04:28:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2153, '大屏设计器', '', 2, 2, 1281, 'go-view', 'fa:area-chart', 'report/goview/index', 'GoView', 0, '1', '1', '1', '1', '2023-02-07 00:03:19', '1', '2025-05-03 09:57:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2154, '创建项目', 'report:go-view-project:create', 3, 1, 2153, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-02-07 19:25:14', '1', '2023-02-07 19:25:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2155, '更新项目', 'report:go-view-project:update', 3, 2, 2153, '', '', '', '', 0, '1', '1', '1', '1', '2023-02-07 19:25:34', '1', '2024-04-24 20:01:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2156, '查询项目', 'report:go-view-project:query', 3, 0, 2153, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-02-07 19:25:53', '1', '2023-02-07 19:25:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2157, '使用 SQL 查询数据', 'report:go-view-data:get-by-sql', 3, 3, 2153, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-02-07 19:26:15', '1', '2023-02-07 19:26:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2158, '使用 HTTP 查询数据', 'report:go-view-data:get-by-http', 3, 4, 2153, '', '', '', NULL, 0, '1', '1', '1', '1', '2023-02-07 19:26:35', '1', '2023-02-07 19:26:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2159, 'Boot 开发文档', '', 1, 1, 0, 'https://xxx', 'ep:document', NULL, NULL, 0, '1', '1', '1', '1', '2023-02-10 22:46:28', '1', '2024-07-28 11:36:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2160, 'Cloud 开发文档', '', 1, 2, 0, 'https://xxx', 'ep:document-copy', NULL, NULL, 0, '1', '1', '1', '1', '2023-02-10 22:47:07', '1', '2023-12-02 21:32:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2161, '接入示例', '', 1, 99, 1117, 'demo', 'fa-solid:dragon', 'pay/demo/index', NULL, 0, '1', '1', '1', '', '2023-02-11 14:21:42', '1', '2024-01-18 23:50:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2162, '商品导出', 'product:spu:export', 3, 5, 2014, '', '', '', NULL, 0, '1', '1', '1', '', '2022-07-30 14:22:58', '', '2022-07-30 14:22:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2164, '配送管理', '', 1, 3, 2072, 'delivery', 'ep:shopping-cart', '', '', 0, '1', '1', '1', '1', '2023-05-18 09:18:02', '1', '2023-09-28 10:58:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2165, '快递发货', '', 1, 0, 2164, 'express', 'ep:bicycle', '', '', 0, '1', '1', '1', '1', '2023-05-18 09:22:06', '1', '2023-08-30 21:02:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2166, '门店自提', '', 1, 1, 2164, 'pick-up-store', 'ep:add-location', '', '', 0, '1', '1', '1', '1', '2023-05-18 09:23:14', '1', '2023-08-30 21:03:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2167, '快递公司', '', 2, 0, 2165, 'express', 'ep:compass', 'mall/trade/delivery/express/index', 'Express', 0, '1', '1', '1', '1', '2023-05-18 09:27:21', '1', '2024-11-29 11:20:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2168, '快递公司查询', 'trade:delivery:express:query', 3, 1, 2167, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2169, '快递公司创建', 'trade:delivery:express:create', 3, 2, 2167, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2170, '快递公司更新', 'trade:delivery:express:update', 3, 3, 2167, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2171, '快递公司删除', 'trade:delivery:express:delete', 3, 4, 2167, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2172, '快递公司导出', 'trade:delivery:express:export', 3, 5, 2167, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-18 09:37:53', '', '2023-05-18 09:37:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2173, '运费模版', 'trade:delivery:express-template:query', 2, 1, 2165, 'express-template', 'ep:coordinate', 'mall/trade/delivery/expressTemplate/index', 'ExpressTemplate', 0, '1', '1', '1', '1', '2023-05-20 06:48:10', '1', '2023-08-30 21:03:13', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2174, '快递运费模板查询', 'trade:delivery:express-template:query', 3, 1, 2173, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2175, '快递运费模板创建', 'trade:delivery:express-template:create', 3, 2, 2173, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2176, '快递运费模板更新', 'trade:delivery:express-template:update', 3, 3, 2173, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2177, '快递运费模板删除', 'trade:delivery:express-template:delete', 3, 4, 2173, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2178, '快递运费模板导出', 'trade:delivery:express-template:export', 3, 5, 2173, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-20 06:49:53', '', '2023-05-20 06:49:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2179, '门店管理', '', 2, 1, 2166, 'pick-up-store', 'ep:basketball', 'mall/trade/delivery/pickUpStore/index', 'PickUpStore', 0, '1', '1', '1', '1', '2023-05-25 10:50:00', '1', '2023-08-30 21:03:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2180, '自提门店查询', 'trade:delivery:pick-up-store:query', 3, 1, 2179, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2181, '自提门店创建', 'trade:delivery:pick-up-store:create', 3, 2, 2179, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2182, '自提门店更新', 'trade:delivery:pick-up-store:update', 3, 3, 2179, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2183, '自提门店删除', 'trade:delivery:pick-up-store:delete', 3, 4, 2179, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2184, '自提门店导出', 'trade:delivery:pick-up-store:export', 3, 5, 2179, '', '', '', NULL, 0, '1', '1', '1', '', '2023-05-25 10:53:29', '', '2023-05-25 10:53:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2209, '秒杀活动', '', 2, 3, 2030, 'seckill', 'ep:place', '', '', 0, '1', '1', '1', '1', '2023-06-24 17:39:13', '1', '2023-06-24 18:55:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2262, '会员中心', '', 1, 55, 0, '/member', 'ep:bicycle', NULL, NULL, 0, '1', '1', '1', '1', '2023-06-10 00:42:03', '1', '2023-08-20 09:23:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2275, '会员配置', '', 2, 0, 2262, 'config', 'fa:archive', 'member/config/index', 'MemberConfig', 0, '1', '1', '1', '', '2023-06-10 02:07:44', '1', '2023-10-01 23:41:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2276, '会员配置查询', 'member:config:query', 3, 1, 2275, '', '', '', '', 0, '1', '1', '1', '', '2023-06-10 02:07:44', '1', '2024-04-24 19:48:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2277, '会员配置保存', 'member:config:save', 3, 2, 2275, '', '', '', '', 0, '1', '1', '1', '', '2023-06-10 02:07:44', '1', '2024-04-24 19:49:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2281, '签到配置', '', 2, 2, 2300, 'config', 'ep:calendar', 'member/signin/config/index', 'SignInConfig', 0, '1', '1', '1', '', '2023-06-10 03:26:12', '1', '2023-08-20 19:25:51', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2282, '积分签到规则查询', 'point:sign-in-config:query', 3, 1, 2281, '', '', '', NULL, 0, '1', '1', '1', '', '2023-06-10 03:26:12', '', '2023-06-10 03:26:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2283, '积分签到规则创建', 'point:sign-in-config:create', 3, 2, 2281, '', '', '', NULL, 0, '1', '1', '1', '', '2023-06-10 03:26:12', '', '2023-06-10 03:26:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2284, '积分签到规则更新', 'point:sign-in-config:update', 3, 3, 2281, '', '', '', NULL, 0, '1', '1', '1', '', '2023-06-10 03:26:12', '', '2023-06-10 03:26:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2285, '积分签到规则删除', 'point:sign-in-config:delete', 3, 4, 2281, '', '', '', NULL, 0, '1', '1', '1', '', '2023-06-10 03:26:12', '', '2023-06-10 03:26:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2287, '会员积分', '', 2, 10, 2262, 'record', 'fa:asterisk', 'member/point/record/index', 'PointRecord', 0, '1', '1', '1', '', '2023-06-10 04:18:50', '1', '2023-10-01 23:42:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2288, '用户积分记录查询', 'point:record:query', 3, 1, 2287, '', '', '', NULL, 0, '1', '1', '1', '', '2023-06-10 04:18:50', '', '2023-06-10 04:18:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2293, '签到记录', '', 2, 3, 2300, 'record', 'ep:chicken', 'member/signin/record/index', 'SignInRecord', 0, '1', '1', '1', '', '2023-06-10 04:48:22', '1', '2023-08-20 19:26:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2294, '用户签到积分查询', 'point:sign-in-record:query', 3, 1, 2293, '', '', '', NULL, 0, '1', '1', '1', '', '2023-06-10 04:48:22', '', '2023-06-10 04:48:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2297, '用户签到积分删除', 'point:sign-in-record:delete', 3, 4, 2293, '', '', '', NULL, 0, '1', '1', '1', '', '2023-06-10 04:48:22', '', '2023-06-10 04:48:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2300, '会员签到', '', 1, 11, 2262, 'signin', 'ep:alarm-clock', '', '', 0, '1', '1', '1', '1', '2023-06-27 22:49:53', '1', '2023-08-20 09:23:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2301, '回调通知', '', 2, 5, 1117, 'notify', 'ep:mute-notification', 'pay/notify/index', 'PayNotify', 0, '1', '1', '1', '', '2023-07-20 04:41:32', '1', '2024-01-18 23:56:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2302, '支付通知查询', 'pay:notify:query', 3, 1, 2301, '', '', '', NULL, 0, '1', '1', '1', '', '2023-07-20 04:41:32', '', '2023-07-20 04:41:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2303, '拼团活动', '', 2, 3, 2030, 'combination', 'fa:group', '', '', 0, '1', '1', '1', '1', '2023-08-12 17:19:54', '1', '2023-08-12 17:20:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2304, '拼团商品', '', 2, 1, 2303, 'acitivity', 'ep:apple', 'mall/promotion/combination/activity/index', 'PromotionCombinationActivity', 0, '1', '1', '1', '1', '2023-08-12 17:22:03', '1', '2023-08-12 17:22:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2305, '拼团活动查询', 'promotion:combination-activity:query', 3, 1, 2304, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-12 17:54:32', '1', '2023-11-24 11:57:40', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2306, '拼团活动创建', 'promotion:combination-activity:create', 3, 2, 2304, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-12 17:54:49', '1', '2023-08-12 17:54:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2307, '拼团活动更新', 'promotion:combination-activity:update', 3, 3, 2304, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-12 17:55:04', '1', '2023-08-12 17:55:04', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2308, '拼团活动删除', 'promotion:combination-activity:delete', 3, 4, 2304, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-12 17:55:23', '1', '2023-08-12 17:55:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2309, '拼团活动关闭', 'promotion:combination-activity:close', 3, 5, 2304, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-12 17:55:37', '1', '2023-10-06 10:51:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2310, '砍价活动', '', 2, 4, 2030, 'bargain', 'ep:box', '', '', 0, '1', '1', '1', '1', '2023-08-13 00:27:25', '1', '2023-08-13 00:27:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2311, '砍价商品', '', 2, 1, 2310, 'activity', 'ep:burger', 'mall/promotion/bargain/activity/index', 'PromotionBargainActivity', 0, '1', '1', '1', '1', '2023-08-13 00:28:49', '1', '2023-10-05 01:16:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2312, '砍价活动查询', 'promotion:bargain-activity:query', 3, 1, 2311, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-13 00:32:30', '1', '2023-08-13 00:32:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2313, '砍价活动创建', 'promotion:bargain-activity:create', 3, 2, 2311, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-13 00:32:44', '1', '2023-08-13 00:32:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2314, '砍价活动更新', 'promotion:bargain-activity:update', 3, 3, 2311, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-13 00:32:55', '1', '2023-08-13 00:32:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2315, '砍价活动删除', 'promotion:bargain-activity:delete', 3, 4, 2311, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-13 00:34:50', '1', '2023-08-13 00:34:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2316, '砍价活动关闭', 'promotion:bargain-activity:close', 3, 5, 2311, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-13 00:35:02', '1', '2023-08-13 00:35:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2317, '会员管理', '', 2, 0, 2262, 'user', 'ep:avatar', 'member/user/index', 'MemberUser', 0, '1', '1', '1', '', '2023-08-19 04:12:15', '1', '2023-08-24 00:50:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2318, '会员用户查询', 'member:user:query', 3, 1, 2317, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-19 04:12:15', '', '2023-08-19 04:12:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2319, '会员用户更新', 'member:user:update', 3, 3, 2317, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-19 04:12:15', '', '2023-08-19 04:12:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2320, '会员标签', '', 2, 1, 2262, 'tag', 'ep:collection-tag', 'member/tag/index', 'MemberTag', 0, '1', '1', '1', '', '2023-08-20 01:03:08', '1', '2023-08-20 09:23:19', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2321, '会员标签查询', 'member:tag:query', 3, 1, 2320, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-20 01:03:08', '', '2023-08-20 01:03:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2322, '会员标签创建', 'member:tag:create', 3, 2, 2320, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-20 01:03:08', '', '2023-08-20 01:03:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2323, '会员标签更新', 'member:tag:update', 3, 3, 2320, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-20 01:03:08', '', '2023-08-20 01:03:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2324, '会员标签删除', 'member:tag:delete', 3, 4, 2320, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-20 01:03:08', '', '2023-08-20 01:03:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2325, '会员等级', '', 2, 2, 2262, 'level', 'fa:level-up', 'member/level/index', 'MemberLevel', 0, '1', '1', '1', '', '2023-08-22 12:41:01', '1', '2023-08-22 21:47:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2326, '会员等级查询', 'member:level:query', 3, 1, 2325, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-22 12:41:02', '', '2023-08-22 12:41:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2327, '会员等级创建', 'member:level:create', 3, 2, 2325, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-22 12:41:02', '', '2023-08-22 12:41:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2328, '会员等级更新', 'member:level:update', 3, 3, 2325, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-22 12:41:02', '', '2023-08-22 12:41:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2329, '会员等级删除', 'member:level:delete', 3, 4, 2325, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-22 12:41:02', '', '2023-08-22 12:41:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2330, '会员分组', '', 2, 3, 2262, 'group', 'fa:group', 'member/group/index', 'MemberGroup', 0, '1', '1', '1', '', '2023-08-22 13:50:06', '1', '2023-10-01 23:42:01', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2331, '用户分组查询', 'member:group:query', 3, 1, 2330, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-22 13:50:06', '', '2023-08-22 13:50:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2332, '用户分组创建', 'member:group:create', 3, 2, 2330, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-22 13:50:06', '', '2023-08-22 13:50:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2333, '用户分组更新', 'member:group:update', 3, 3, 2330, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-22 13:50:06', '', '2023-08-22 13:50:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2334, '用户分组删除', 'member:group:delete', 3, 4, 2330, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-22 13:50:06', '', '2023-08-22 13:50:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2335, '用户等级修改', 'member:user:update-level', 3, 5, 2317, '', '', '', NULL, 0, '1', '1', '1', '', '2023-08-23 16:49:05', '', '2023-08-23 16:50:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2336, '商品评论', '', 2, 5, 2000, 'comment', 'ep:comment', 'mall/product/comment/index', 'ProductComment', 0, '1', '1', '1', '1', '2023-08-26 11:03:00', '1', '2023-08-26 11:03:38', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2337, '评论查询', 'product:comment:query', 3, 1, 2336, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-26 11:04:01', '1', '2023-08-26 11:04:01', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2338, '添加自评', 'product:comment:create', 3, 2, 2336, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-26 11:04:23', '1', '2023-08-26 11:08:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2339, '商家回复', 'product:comment:update', 3, 3, 2336, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-26 11:04:37', '1', '2023-08-26 11:04:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2340, '显隐评论', 'product:comment:update', 3, 4, 2336, '', '', '', '', 0, '1', '1', '1', '1', '2023-08-26 11:04:55', '1', '2023-08-26 11:04:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2341, '优惠劵发送', 'promotion:coupon:send', 3, 2, 2038, '', '', '', '', 0, '1', '1', '1', '1', '2023-09-02 00:03:14', '1', '2023-09-02 00:03:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2342, '交易配置', '', 2, 0, 2072, 'config', 'ep:setting', 'mall/trade/config/index', 'TradeConfig', 0, '1', '1', '1', '', '2023-09-28 02:46:22', '1', '2024-02-26 20:30:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2343, '交易中心配置查询', 'trade:config:query', 3, 1, 2342, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-28 02:46:22', '', '2023-09-28 02:46:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2344, '交易中心配置保存', 'trade:config:save', 3, 2, 2342, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-28 02:46:22', '', '2023-09-28 02:46:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2345, '分销管理', '', 1, 4, 2072, 'brokerage', 'fa-solid:project-diagram', '', '', 0, '1', '1', '1', '', '2023-09-28 02:46:22', '1', '2023-09-28 10:58:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2346, '分销用户', '', 2, 0, 2345, 'brokerage-user', 'fa-solid:user-tie', 'mall/trade/brokerage/user/index', 'TradeBrokerageUser', 0, '1', '1', '1', '', '2023-09-28 02:46:22', '1', '2024-02-26 20:33:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2347, '分销用户查询', 'trade:brokerage-user:query', 3, 1, 2346, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-28 02:46:22', '', '2023-09-28 02:46:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2348, '分销用户推广人查询', 'trade:brokerage-user:user-query', 3, 2, 2346, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-28 02:46:22', '', '2023-09-28 02:46:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2349, '分销用户推广订单查询', 'trade:brokerage-user:order-query', 3, 3, 2346, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-28 02:46:22', '', '2023-09-28 02:46:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2350, '分销用户修改推广资格', 'trade:brokerage-user:update-brokerage-enable', 3, 4, 2346, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-28 02:46:22', '', '2023-09-28 02:46:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2351, '修改推广员', 'trade:brokerage-user:update-bind-user', 3, 5, 2346, '', '', '', '', 0, '1', '1', '1', '', '2023-09-28 02:46:22', '1', '2024-12-01 14:33:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2352, '清除推广员', 'trade:brokerage-user:clear-bind-user', 3, 6, 2346, '', '', '', '', 0, '1', '1', '1', '', '2023-09-28 02:46:22', '1', '2024-12-01 14:33:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2353, '佣金记录', '', 2, 1, 2345, 'brokerage-record', 'fa:money', 'mall/trade/brokerage/record/index', 'TradeBrokerageRecord', 0, '1', '1', '1', '', '2023-09-28 02:46:22', '1', '2024-02-26 20:33:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2354, '佣金记录查询', 'trade:brokerage-record:query', 3, 1, 2353, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-28 02:46:22', '', '2023-09-28 02:46:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2355, '佣金提现', '', 2, 2, 2345, 'brokerage-withdraw', 'fa:credit-card', 'mall/trade/brokerage/withdraw/index', 'TradeBrokerageWithdraw', 0, '1', '1', '1', '', '2023-09-28 02:46:22', '1', '2024-02-26 20:33:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2356, '佣金提现查询', 'trade:brokerage-withdraw:query', 3, 1, 2355, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-28 02:46:22', '', '2023-09-28 02:46:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2357, '佣金提现审核', 'trade:brokerage-withdraw:audit', 3, 2, 2355, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-28 02:46:22', '', '2023-09-28 02:46:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2358, '统计中心', '', 1, 75, 2362, 'statistics', 'ep:data-line', '', '', 0, '1', '1', '1', '', '2023-09-30 03:22:40', '1', '2023-09-30 11:54:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2359, '交易统计', '', 2, 4, 2358, 'trade', 'fa-solid:credit-card', 'mall/statistics/trade/index', 'TradeStatistics', 0, '1', '1', '1', '', '2023-09-30 03:22:40', '1', '2024-02-26 20:42:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2360, '交易统计查询', 'statistics:trade:query', 3, 1, 2359, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-30 03:22:40', '', '2023-09-30 03:22:40', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2361, '交易统计导出', 'statistics:trade:export', 3, 2, 2359, '', '', '', NULL, 0, '1', '1', '1', '', '2023-09-30 03:22:40', '', '2023-09-30 03:22:40', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2362, '商城系统', '', 1, 59, 0, '/mall', 'ep:shop', '', '', 0, '1', '1', '1', '1', '2023-09-30 11:52:02', '1', '2023-09-30 11:52:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2363, '用户积分修改', 'member:user:update-point', 3, 6, 2317, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-01 14:39:43', '', '2023-10-01 14:39:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2364, '用户余额修改', 'pay:wallet:update-balance', 3, 7, 2317, '', '', '', '', 0, '1', '1', '1', '', '2023-10-01 14:39:43', '1', '2024-10-01 09:42:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2365, '优惠劵', '', 1, 2, 2030, 'coupon', 'fa-solid:disease', '', '', 0, '1', '1', '1', '1', '2023-10-03 12:39:15', '1', '2023-10-05 00:16:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2366, '砍价记录', '', 2, 2, 2310, 'record', 'ep:list', 'mall/promotion/bargain/record/index', 'PromotionBargainRecord', 0, '1', '1', '1', '', '2023-10-05 02:49:06', '1', '2023-10-05 10:50:38', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2367, '砍价记录查询', 'promotion:bargain-record:query', 3, 1, 2366, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-05 02:49:06', '', '2023-10-05 02:49:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2368, '助力记录查询', 'promotion:bargain-help:query', 3, 2, 2366, '', '', '', '', 0, '1', '1', '1', '1', '2023-10-05 12:27:49', '1', '2023-10-05 12:27:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2369, '拼团记录', 'promotion:combination-record:query', 2, 2, 2303, 'record', 'ep:avatar', 'mall/promotion/combination/record/index.vue', 'PromotionCombinationRecord', 0, '1', '1', '1', '1', '2023-10-08 07:10:22', '1', '2023-10-08 07:34:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2374, '会员统计', '', 2, 2, 2358, 'member', 'ep:avatar', 'mall/statistics/member/index', 'MemberStatistics', 0, '1', '1', '1', '', '2023-10-11 04:39:24', '1', '2024-02-26 20:41:46', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2375, '会员统计查询', 'statistics:member:query', 3, 1, 2374, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-11 04:39:24', '', '2023-10-11 04:39:24', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2376, '订单核销', 'trade:order:pick-up', 3, 10, 2076, '', '', '', '', 0, '1', '1', '1', '1', '2023-10-14 17:11:58', '1', '2023-10-14 17:11:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2377, '文章分类', '', 2, 0, 2387, 'article/category', 'fa:certificate', 'mall/promotion/article/category/index', 'ArticleCategory', 0, '1', '1', '1', '', '2023-10-16 01:26:18', '1', '2023-10-16 09:38:26', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2378, '分类查询', 'promotion:article-category:query', 3, 1, 2377, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-16 01:26:18', '', '2023-10-16 01:26:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2379, '分类创建', 'promotion:article-category:create', 3, 2, 2377, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-16 01:26:18', '', '2023-10-16 01:26:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2380, '分类更新', 'promotion:article-category:update', 3, 3, 2377, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-16 01:26:18', '', '2023-10-16 01:26:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2381, '分类删除', 'promotion:article-category:delete', 3, 4, 2377, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-16 01:26:18', '', '2023-10-16 01:26:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2382, '文章列表', '', 2, 2, 2387, 'article', 'ep:connection', 'mall/promotion/article/index', 'Article', 0, '1', '1', '1', '', '2023-10-16 01:26:18', '1', '2023-10-16 09:41:19', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2383, '文章管理查询', 'promotion:article:query', 3, 1, 2382, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-16 01:26:18', '', '2023-10-16 01:26:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2384, '文章管理创建', 'promotion:article:create', 3, 2, 2382, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-16 01:26:18', '', '2023-10-16 01:26:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2385, '文章管理更新', 'promotion:article:update', 3, 3, 2382, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-16 01:26:18', '', '2023-10-16 01:26:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2386, '文章管理删除', 'promotion:article:delete', 3, 4, 2382, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-16 01:26:18', '', '2023-10-16 01:26:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2387, '内容管理', '', 1, 1, 2030, 'content', 'ep:collection', '', '', 0, '1', '1', '1', '1', '2023-10-16 09:37:31', '1', '2023-10-16 09:37:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2388, '商城首页', '', 2, 1, 2362, 'home', 'ep:home-filled', 'mall/home/index', 'MallHome', 0, '1', '1', '1', '', '2023-10-16 12:10:33', '', '2023-10-16 12:10:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2389, '核销订单', '', 2, 2, 2166, 'pick-up-order', 'ep:list', 'mall/trade/delivery/pickUpOrder/index', 'PickUpOrder', 0, '1', '1', '1', '', '2023-10-19 16:09:51', '', '2023-10-19 16:09:51', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2390, '优惠活动', '', 1, 99, 2030, 'youhui', 'ep:aim', '', '', 0, '1', '1', '1', '1', '2023-10-21 19:23:49', '1', '2023-10-21 19:23:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2391, '客户管理', '', 2, 10, 2397, 'customer', 'fa:address-book-o', 'crm/customer/index', 'CrmCustomer', 0, '1', '1', '1', '', '2023-10-29 09:04:21', '1', '2024-02-17 17:13:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2392, '客户查询', 'crm:customer:query', 3, 1, 2391, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 09:04:21', '', '2023-10-29 09:04:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2393, '客户创建', 'crm:customer:create', 3, 2, 2391, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 09:04:21', '', '2023-10-29 09:04:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2394, '客户更新', 'crm:customer:update', 3, 3, 2391, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 09:04:21', '', '2023-10-29 09:04:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2395, '客户删除', 'crm:customer:delete', 3, 4, 2391, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 09:04:21', '', '2023-10-29 09:04:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2396, '客户导出', 'crm:customer:export', 3, 5, 2391, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 09:04:21', '', '2023-10-29 09:04:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2397, 'CRM 系统', '', 1, 200, 0, '/crm', 'simple-icons:civicrm', '', '', 0, '1', '1', '1', '1', '2023-10-29 17:08:30', '1', '2025-04-19 18:56:38', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2398, '合同管理', '', 2, 50, 2397, 'contract', 'ep:notebook', 'crm/contract/index', 'CrmContract', 0, '1', '1', '1', '', '2023-10-29 10:50:41', '1', '2024-02-17 17:15:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2399, '合同查询', 'crm:contract:query', 3, 1, 2398, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 10:50:41', '', '2023-10-29 10:50:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2400, '合同创建', 'crm:contract:create', 3, 2, 2398, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 10:50:41', '', '2023-10-29 10:50:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2401, '合同更新', 'crm:contract:update', 3, 3, 2398, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 10:50:41', '', '2023-10-29 10:50:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2402, '合同删除', 'crm:contract:delete', 3, 4, 2398, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 10:50:41', '', '2023-10-29 10:50:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2403, '合同导出', 'crm:contract:export', 3, 5, 2398, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 10:50:41', '', '2023-10-29 10:50:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2404, '线索管理', '', 2, 8, 2397, 'clue', 'fa:pagelines', 'crm/clue/index', 'CrmClue', 0, '1', '1', '1', '', '2023-10-29 11:06:29', '1', '2024-02-17 17:15:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2405, '线索查询', 'crm:clue:query', 3, 1, 2404, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:06:29', '', '2023-10-29 11:06:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2406, '线索创建', 'crm:clue:create', 3, 2, 2404, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:06:29', '', '2023-10-29 11:06:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2407, '线索更新', 'crm:clue:update', 3, 3, 2404, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:06:29', '', '2023-10-29 11:06:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2408, '线索删除', 'crm:clue:delete', 3, 4, 2404, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:06:29', '', '2023-10-29 11:06:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2409, '线索导出', 'crm:clue:export', 3, 5, 2404, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:06:29', '', '2023-10-29 11:06:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2410, '商机管理', '', 2, 40, 2397, 'business', 'fa:bus', 'crm/business/index', 'CrmBusiness', 0, '1', '1', '1', '', '2023-10-29 11:12:35', '1', '2024-02-17 17:14:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2411, '商机查询', 'crm:business:query', 3, 1, 2410, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:12:35', '', '2023-10-29 11:12:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2412, '商机创建', 'crm:business:create', 3, 2, 2410, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:12:35', '', '2023-10-29 11:12:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2413, '商机更新', 'crm:business:update', 3, 3, 2410, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:12:35', '', '2023-10-29 11:12:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2414, '商机删除', 'crm:business:delete', 3, 4, 2410, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:12:35', '', '2023-10-29 11:12:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2415, '商机导出', 'crm:business:export', 3, 5, 2410, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:12:35', '', '2023-10-29 11:12:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2416, '联系人管理', '', 2, 20, 2397, 'contact', 'fa:address-book-o', 'crm/contact/index', 'CrmContact', 0, '1', '1', '1', '', '2023-10-29 11:14:56', '1', '2024-02-17 17:13:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2417, '联系人查询', 'crm:contact:query', 3, 1, 2416, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:14:56', '', '2023-10-29 11:14:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2418, '联系人创建', 'crm:contact:create', 3, 2, 2416, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:14:56', '', '2023-10-29 11:14:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2419, '联系人更新', 'crm:contact:update', 3, 3, 2416, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:14:56', '', '2023-10-29 11:14:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2420, '联系人删除', 'crm:contact:delete', 3, 4, 2416, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:14:56', '', '2023-10-29 11:14:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2421, '联系人导出', 'crm:contact:export', 3, 5, 2416, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:14:56', '', '2023-10-29 11:14:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2422, '回款管理', '', 2, 60, 2397, 'receivable', 'ep:money', 'crm/receivable/index', 'CrmReceivable', 0, '1', '1', '1', '', '2023-10-29 11:18:09', '1', '2024-02-17 17:16:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2423, '回款管理查询', 'crm:receivable:query', 3, 1, 2422, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2424, '回款管理创建', 'crm:receivable:create', 3, 2, 2422, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2425, '回款管理更新', 'crm:receivable:update', 3, 3, 2422, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2426, '回款管理删除', 'crm:receivable:delete', 3, 4, 2422, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2427, '回款管理导出', 'crm:receivable:export', 3, 5, 2422, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2428, '回款计划', '', 2, 61, 2397, 'receivable-plan', 'fa:money', 'crm/receivable/plan/index', 'CrmReceivablePlan', 0, '1', '1', '1', '', '2023-10-29 11:18:09', '1', '2024-02-17 17:16:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2429, '回款计划查询', 'crm:receivable-plan:query', 3, 1, 2428, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2430, '回款计划创建', 'crm:receivable-plan:create', 3, 2, 2428, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2431, '回款计划更新', 'crm:receivable-plan:update', 3, 3, 2428, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2432, '回款计划删除', 'crm:receivable-plan:delete', 3, 4, 2428, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2433, '回款计划导出', 'crm:receivable-plan:export', 3, 5, 2428, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 11:18:09', '', '2023-10-29 11:18:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2435, '商城装修', '', 2, 20, 2030, 'diy-template', 'fa6-solid:brush', 'mall/promotion/diy/template/index', '', 0, '1', '1', '1', '', '2023-10-29 14:19:25', '1', '2025-03-15 21:34:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2436, '装修模板', '', 2, 1, 2435, 'diy-template', 'fa6-solid:brush', 'mall/promotion/diy/template/index', 'DiyTemplate', 0, '1', '1', '1', '', '2023-10-29 14:19:25', '', '2023-10-29 14:19:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2437, '装修模板查询', 'promotion:diy-template:query', 3, 1, 2436, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 14:19:25', '', '2023-10-29 14:19:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2438, '装修模板创建', 'promotion:diy-template:create', 3, 2, 2436, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 14:19:25', '', '2023-10-29 14:19:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2439, '装修模板更新', 'promotion:diy-template:update', 3, 3, 2436, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 14:19:25', '', '2023-10-29 14:19:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2440, '装修模板删除', 'promotion:diy-template:delete', 3, 4, 2436, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 14:19:25', '', '2023-10-29 14:19:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2441, '装修模板使用', 'promotion:diy-template:use', 3, 5, 2436, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 14:19:25', '', '2023-10-29 14:19:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2442, '装修页面', '', 2, 2, 2435, 'diy-page', 'foundation:page-edit', 'mall/promotion/diy/page/index', 'DiyPage', 0, '1', '1', '1', '', '2023-10-29 14:19:25', '', '2023-10-29 14:19:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2443, '装修页面查询', 'promotion:diy-page:query', 3, 1, 2442, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 14:19:25', '', '2023-10-29 14:19:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2444, '装修页面创建', 'promotion:diy-page:create', 3, 2, 2442, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 14:19:26', '', '2023-10-29 14:19:26', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2445, '装修页面更新', 'promotion:diy-page:update', 3, 3, 2442, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 14:19:26', '', '2023-10-29 14:19:26', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2446, '装修页面删除', 'promotion:diy-page:delete', 3, 4, 2442, '', '', '', NULL, 0, '1', '1', '1', '', '2023-10-29 14:19:26', '', '2023-10-29 14:19:26', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2447, '三方登录', '', 1, 10, 1, 'social', 'fa:rocket', '', '', 0, '1', '1', '1', '1', '2023-11-04 12:12:01', '1', '2024-02-29 01:14:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2448, '三方应用', '', 2, 1, 2447, 'client', 'ep:set-up', 'system/social/client/index.vue', 'SocialClient', 0, '1', '1', '1', '1', '2023-11-04 12:17:19', '1', '2024-05-04 19:09:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2449, '三方应用查询', 'system:social-client:query', 3, 1, 2448, '', '', '', '', 0, '1', '1', '1', '1', '2023-11-04 12:43:12', '1', '2023-11-04 12:43:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2450, '三方应用创建', 'system:social-client:create', 3, 2, 2448, '', '', '', '', 0, '1', '1', '1', '1', '2023-11-04 12:43:58', '1', '2023-11-04 12:43:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2451, '三方应用更新', 'system:social-client:update', 3, 3, 2448, '', '', '', '', 0, '1', '1', '1', '1', '2023-11-04 12:44:27', '1', '2023-11-04 12:44:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2452, '三方应用删除', 'system:social-client:delete', 3, 4, 2448, '', '', '', '', 0, '1', '1', '1', '1', '2023-11-04 12:44:43', '1', '2023-11-04 12:44:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2453, '三方用户', 'system:social-user:query', 2, 2, 2447, 'user', 'ep:avatar', 'system/social/user/index.vue', 'SocialUser', 0, '1', '1', '1', '1', '2023-11-04 14:01:05', '1', '2023-11-04 14:01:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2472, '主子表（内嵌）', '', 2, 12, 1070, 'demo03-inner', 'fa:power-off', 'infra/demo/demo03/inner/index', 'Demo03StudentInner', 0, '1', '1', '1', '', '2023-11-13 04:39:51', '1', '2023-11-16 23:53:46', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2478, '单表（增删改查）', '', 2, 1, 1070, 'demo01-contact', 'ep:bicycle', 'infra/demo/demo01/index', 'Demo01Contact', 0, '1', '1', '1', '', '2023-11-15 14:42:30', '1', '2023-11-16 20:34:40', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2479, '示例联系人查询', 'infra:demo01-contact:query', 3, 1, 2478, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-15 14:42:30', '', '2023-11-15 14:42:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2480, '示例联系人创建', 'infra:demo01-contact:create', 3, 2, 2478, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-15 14:42:30', '', '2023-11-15 14:42:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2481, '示例联系人更新', 'infra:demo01-contact:update', 3, 3, 2478, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-15 14:42:30', '', '2023-11-15 14:42:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2482, '示例联系人删除', 'infra:demo01-contact:delete', 3, 4, 2478, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-15 14:42:30', '', '2023-11-15 14:42:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2483, '示例联系人导出', 'infra:demo01-contact:export', 3, 5, 2478, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-15 14:42:30', '', '2023-11-15 14:42:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2484, '树表（增删改查）', '', 2, 2, 1070, 'demo02-category', 'fa:tree', 'infra/demo/demo02/index', 'Demo02Category', 0, '1', '1', '1', '', '2023-11-16 12:18:27', '1', '2023-11-16 20:35:01', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2485, '示例分类查询', 'infra:demo02-category:query', 3, 1, 2484, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:18:27', '', '2023-11-16 12:18:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2486, '示例分类创建', 'infra:demo02-category:create', 3, 2, 2484, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:18:27', '', '2023-11-16 12:18:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2487, '示例分类更新', 'infra:demo02-category:update', 3, 3, 2484, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:18:27', '', '2023-11-16 12:18:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2488, '示例分类删除', 'infra:demo02-category:delete', 3, 4, 2484, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:18:27', '', '2023-11-16 12:18:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2489, '示例分类导出', 'infra:demo02-category:export', 3, 5, 2484, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:18:27', '', '2023-11-16 12:18:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2490, '主子表（标准）', '', 2, 10, 1070, 'demo03-normal', 'fa:battery-3', 'infra/demo/demo03/normal/index', 'Demo03StudentNormal', 0, '1', '1', '1', '', '2023-11-16 12:53:37', '1', '2023-11-16 23:10:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2491, '学生查询', 'infra:demo03-student:query', 3, 1, 2490, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:53:37', '', '2023-11-16 12:53:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2492, '学生创建', 'infra:demo03-student:create', 3, 2, 2490, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:53:37', '', '2023-11-16 12:53:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2493, '学生更新', 'infra:demo03-student:update', 3, 3, 2490, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:53:37', '', '2023-11-16 12:53:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2494, '学生删除', 'infra:demo03-student:delete', 3, 4, 2490, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:53:37', '', '2023-11-16 12:53:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2495, '学生导出', 'infra:demo03-student:export', 3, 5, 2490, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-16 12:53:37', '', '2023-11-16 12:53:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2497, '主子表（ERP）', '', 2, 11, 1070, 'demo03-erp', 'ep:calendar', 'infra/demo/demo03/erp/index', 'Demo03StudentERP', 0, '1', '1', '1', '', '2023-11-16 15:50:59', '1', '2023-11-17 13:19:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2516, '客户公海配置', '', 2, 0, 2524, 'customer-pool-config', 'ep:data-analysis', 'crm/customer/poolConfig/index', 'CrmCustomerPoolConfig', 0, '1', '1', '1', '', '2023-11-18 13:33:31', '1', '2024-01-03 19:52:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2517, '客户公海配置保存', 'crm:customer-pool-config:update', 3, 1, 2516, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-18 13:33:31', '', '2023-11-18 13:33:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2518, '客户限制配置', '', 2, 1, 2524, 'customer-limit-config', 'ep:avatar', 'crm/customer/limitConfig/index', 'CrmCustomerLimitConfig', 0, '1', '1', '1', '', '2023-11-18 13:33:53', '1', '2024-02-24 16:43:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2519, '客户限制配置查询', 'crm:customer-limit-config:query', 3, 1, 2518, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-18 13:33:53', '', '2023-11-18 13:33:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2520, '客户限制配置创建', 'crm:customer-limit-config:create', 3, 2, 2518, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-18 13:33:53', '', '2023-11-18 13:33:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2521, '客户限制配置更新', 'crm:customer-limit-config:update', 3, 3, 2518, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-18 13:33:53', '', '2023-11-18 13:33:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2522, '客户限制配置删除', 'crm:customer-limit-config:delete', 3, 4, 2518, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-18 13:33:53', '', '2023-11-18 13:33:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2523, '客户限制配置导出', 'crm:customer-limit-config:export', 3, 5, 2518, '', '', '', NULL, 0, '1', '1', '1', '', '2023-11-18 13:33:53', '', '2023-11-18 13:33:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2524, '系统配置', '', 1, 999, 2397, 'config', 'ep:connection', '', '', 0, '1', '1', '1', '1', '2023-11-18 21:58:00', '1', '2024-02-17 17:14:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2525, 'WebSocket', '', 2, 5, 2, 'websocket', 'ep:connection', 'infra/webSocket/index', 'InfraWebSocket', 0, '1', '1', '1', '1', '2023-11-23 19:41:55', '1', '2024-04-23 00:02:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2526, '产品管理', '', 2, 80, 2397, 'product', 'fa:product-hunt', 'crm/product/index', 'CrmProduct', 0, '1', '1', '1', '1', '2023-12-05 22:45:26', '1', '2024-02-20 20:36:20', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2527, '产品查询', 'crm:product:query', 3, 1, 2526, '', '', '', '', 0, '1', '1', '1', '1', '2023-12-05 22:47:16', '1', '2023-12-05 22:47:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2528, '产品创建', 'crm:product:create', 3, 2, 2526, '', '', '', '', 0, '1', '1', '1', '1', '2023-12-05 22:47:41', '1', '2023-12-05 22:47:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2529, '产品更新', 'crm:product:update', 3, 3, 2526, '', '', '', '', 0, '1', '1', '1', '1', '2023-12-05 22:48:03', '1', '2023-12-05 22:48:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2530, '产品删除', 'crm:product:delete', 3, 4, 2526, '', '', '', '', 0, '1', '1', '1', '1', '2023-12-05 22:48:17', '1', '2023-12-05 22:48:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2531, '产品导出', 'crm:product:export', 3, 5, 2526, '', '', '', '', 0, '1', '1', '1', '1', '2023-12-05 22:48:29', '1', '2023-12-05 22:48:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2532, '产品分类配置', '', 2, 3, 2524, 'product/category', 'fa-solid:window-restore', 'crm/product/category/index', 'CrmProductCategory', 0, '1', '1', '1', '1', '2023-12-06 12:52:36', '1', '2023-12-06 12:52:51', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2533, '产品分类查询', 'crm:product-category:query', 3, 1, 2532, '', '', '', '', 0, '1', '1', '1', '1', '2023-12-06 12:53:23', '1', '2023-12-06 12:53:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2534, '产品分类创建', 'crm:product-category:create', 3, 2, 2532, '', '', '', '', 0, '1', '1', '1', '1', '2023-12-06 12:53:41', '1', '2023-12-06 12:53:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2535, '产品分类更新', 'crm:product-category:update', 3, 3, 2532, '', '', '', '', 0, '1', '1', '1', '1', '2023-12-06 12:53:59', '1', '2023-12-06 12:53:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2536, '产品分类删除', 'crm:product-category:delete', 3, 4, 2532, '', '', '', '', 0, '1', '1', '1', '1', '2023-12-06 12:54:14', '1', '2023-12-06 12:54:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2543, '关联商机', 'crm:contact:create-business', 3, 10, 2416, '', '', '', '', 0, '1', '1', '1', '1', '2024-01-02 17:28:25', '1', '2024-01-02 17:28:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2544, '取关商机', 'crm:contact:delete-business', 3, 11, 2416, '', '', '', '', 0, '1', '1', '1', '1', '2024-01-02 17:28:43', '1', '2024-01-02 17:28:51', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2545, '商品统计', '', 2, 3, 2358, 'product', 'fa:product-hunt', 'mall/statistics/product/index', 'ProductStatistics', 0, '1', '1', '1', '', '2023-12-15 18:54:28', '1', '2024-02-26 20:41:52', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2546, '客户公海', '', 2, 30, 2397, 'customer/pool', 'fa-solid:swimming-pool', 'crm/customer/pool/index', 'CrmCustomerPool', 0, '1', '1', '1', '1', '2024-01-15 21:29:34', '1', '2024-02-17 17:14:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2547, '订单查询', 'trade:order:query', 3, 1, 2076, '', '', '', '', 0, '1', '1', '1', '1', '2024-01-16 08:52:00', '1', '2024-01-16 08:52:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2548, '订单更新', 'trade:order:update', 3, 2, 2076, '', '', '', '', 0, '1', '1', '1', '1', '2024-01-16 08:52:21', '1', '2024-01-16 08:52:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2549, '支付&退款案例', '', 2, 1, 2161, 'order', 'fa:paypal', 'pay/demo/order/index', '', 0, '1', '1', '1', '1', '2024-01-18 23:45:00', '1', '2024-01-18 23:47:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2550, '提现转账案例', '', 2, 2, 2161, 'transfer', 'fa:transgender-alt', 'pay/demo/withdraw/index', '', 0, '1', '1', '1', '1', '2024-01-18 23:51:16', '1', '2025-05-08 13:04:36', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2551, '钱包管理', '', 1, 4, 1117, 'wallet', 'ep:wallet', '', '', 0, '1', '1', '1', '', '2023-12-29 02:32:54', '1', '2024-02-29 08:58:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2552, '充值套餐', '', 2, 2, 2551, 'wallet-recharge-package', 'fa:leaf', 'pay/wallet/rechargePackage/index', 'WalletRechargePackage', 0, '1', '1', '1', '', '2023-12-29 02:32:54', '', '2023-12-29 02:32:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2553, '钱包充值套餐查询', 'pay:wallet-recharge-package:query', 3, 1, 2552, '', '', '', NULL, 0, '1', '1', '1', '', '2023-12-29 02:32:54', '', '2023-12-29 02:32:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2554, '钱包充值套餐创建', 'pay:wallet-recharge-package:create', 3, 2, 2552, '', '', '', NULL, 0, '1', '1', '1', '', '2023-12-29 02:32:54', '', '2023-12-29 02:32:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2555, '钱包充值套餐更新', 'pay:wallet-recharge-package:update', 3, 3, 2552, '', '', '', NULL, 0, '1', '1', '1', '', '2023-12-29 02:32:54', '', '2023-12-29 02:32:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2556, '钱包充值套餐删除', 'pay:wallet-recharge-package:delete', 3, 4, 2552, '', '', '', NULL, 0, '1', '1', '1', '', '2023-12-29 02:32:54', '', '2023-12-29 02:32:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2557, '钱包余额', '', 2, 1, 2551, 'wallet-balance', 'fa:leaf', 'pay/wallet/balance/index', 'WalletBalance', 0, '1', '1', '1', '', '2023-12-29 02:32:54', '', '2023-12-29 02:32:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2558, '钱包余额查询', 'pay:wallet:query', 3, 1, 2557, '', '', '', NULL, 0, '1', '1', '1', '', '2023-12-29 02:32:54', '', '2023-12-29 02:32:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2559, '转账订单', '', 2, 3, 1117, 'transfer', 'ep:credit-card', 'pay/transfer/index', 'PayTransfer', 0, '1', '1', '1', '', '2023-12-29 02:32:54', '', '2023-12-29 02:32:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2560, '数据统计', '', 1, 200, 2397, 'statistics', 'ep:data-line', '', '', 0, '1', '1', '1', '1', '2024-01-26 22:50:35', '1', '2024-02-24 20:10:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2561, '排行榜', 'crm:statistics-rank:query', 2, 1, 2560, 'ranking', 'fa:area-chart', 'crm/statistics/rank/index', 'CrmStatisticsRank', 0, '1', '1', '1', '1', '2024-01-26 22:52:09', '1', '2024-04-24 19:39:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2562, '客户导入', 'crm:customer:import', 3, 6, 2391, '', '', '', '', 0, '1', '1', '1', '1', '2024-02-01 13:09:00', '1', '2024-02-01 13:09:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2563, 'ERP 系统', '', 1, 300, 0, '/erp', 'simple-icons:erpnext', '', '', 0, '1', '1', '1', '1', '2024-02-04 15:37:25', '1', '2025-04-19 18:56:15', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2564, '产品管理', '', 1, 40, 2563, 'product', 'fa:product-hunt', '', '', 0, '1', '1', '1', '1', '2024-02-04 15:38:43', '1', '2024-02-04 15:38:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2565, '产品信息', '', 2, 0, 2564, 'product', 'fa-solid:apple-alt', 'erp/product/product/index', 'ErpProduct', 0, '1', '1', '1', '', '2024-02-04 07:52:15', '1', '2024-02-05 14:42:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2566, '产品查询', 'erp:product:query', 3, 1, 2565, '', '', '', '', 0, '1', '1', '1', '', '2024-02-04 07:52:15', '1', '2024-02-04 17:21:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2567, '产品创建', 'erp:product:create', 3, 2, 2565, '', '', '', '', 0, '1', '1', '1', '', '2024-02-04 07:52:15', '1', '2024-02-04 17:22:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2568, '产品更新', 'erp:product:update', 3, 3, 2565, '', '', '', '', 0, '1', '1', '1', '', '2024-02-04 07:52:15', '1', '2024-02-04 17:22:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2569, '产品删除', 'erp:product:delete', 3, 4, 2565, '', '', '', '', 0, '1', '1', '1', '', '2024-02-04 07:52:15', '1', '2024-02-04 17:22:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2570, '产品导出', 'erp:product:export', 3, 5, 2565, '', '', '', '', 0, '1', '1', '1', '', '2024-02-04 07:52:15', '1', '2024-02-04 17:22:26', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2571, '产品分类', '', 2, 1, 2564, 'product-category', 'fa:certificate', 'erp/product/category/index', 'ErpProductCategory', 0, '1', '1', '1', '', '2024-02-04 09:21:04', '1', '2024-02-04 17:24:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2572, '分类查询', 'erp:product-category:query', 3, 1, 2571, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 09:21:04', '', '2024-02-04 09:21:04', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2573, '分类创建', 'erp:product-category:create', 3, 2, 2571, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 09:21:04', '', '2024-02-04 09:21:04', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2574, '分类更新', 'erp:product-category:update', 3, 3, 2571, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 09:21:04', '', '2024-02-04 09:21:04', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2575, '分类删除', 'erp:product-category:delete', 3, 4, 2571, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 09:21:04', '', '2024-02-04 09:21:04', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2576, '分类导出', 'erp:product-category:export', 3, 5, 2571, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 09:21:04', '', '2024-02-04 09:21:04', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2577, '产品单位', '', 2, 2, 2564, 'unit', 'ep:opportunity', 'erp/product/unit/index', 'ErpProductUnit', 0, '1', '1', '1', '', '2024-02-04 11:54:08', '1', '2024-02-04 19:54:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2578, '单位查询', 'erp:product-unit:query', 3, 1, 2577, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 11:54:08', '', '2024-02-04 11:54:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2579, '单位创建', 'erp:product-unit:create', 3, 2, 2577, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 11:54:08', '', '2024-02-04 11:54:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2580, '单位更新', 'erp:product-unit:update', 3, 3, 2577, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 11:54:08', '', '2024-02-04 11:54:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2581, '单位删除', 'erp:product-unit:delete', 3, 4, 2577, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 11:54:08', '', '2024-02-04 11:54:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2582, '单位导出', 'erp:product-unit:export', 3, 5, 2577, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 11:54:08', '', '2024-02-04 11:54:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2583, '库存管理', '', 1, 30, 2563, 'stock', 'fa:window-restore', '', '', 0, '1', '1', '1', '1', '2024-02-05 00:29:37', '1', '2024-02-05 00:29:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2584, '仓库信息', '', 2, 0, 2583, 'warehouse', 'ep:house', 'erp/stock/warehouse/index', 'ErpWarehouse', 0, '1', '1', '1', '', '2024-02-04 17:12:09', '1', '2024-02-05 01:12:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2585, '仓库查询', 'erp:warehouse:query', 3, 1, 2584, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 17:12:09', '', '2024-02-04 17:12:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2586, '仓库创建', 'erp:warehouse:create', 3, 2, 2584, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 17:12:09', '', '2024-02-04 17:12:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2587, '仓库更新', 'erp:warehouse:update', 3, 3, 2584, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 17:12:09', '', '2024-02-04 17:12:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2588, '仓库删除', 'erp:warehouse:delete', 3, 4, 2584, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 17:12:09', '', '2024-02-04 17:12:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2589, '仓库导出', 'erp:warehouse:export', 3, 5, 2584, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-04 17:12:09', '', '2024-02-04 17:12:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2590, '产品库存', '', 2, 1, 2583, 'stock', 'ep:coffee', 'erp/stock/stock/index', 'ErpStock', 0, '1', '1', '1', '', '2024-02-05 06:40:50', '1', '2024-02-05 14:42:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2591, '库存查询', 'erp:stock:query', 3, 1, 2590, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 06:40:50', '', '2024-02-05 06:40:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2592, '库存导出', 'erp:stock:export', 3, 5, 2590, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 06:40:50', '', '2024-02-05 06:40:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2593, '出入库明细', '', 2, 2, 2583, 'record', 'fa-solid:blog', 'erp/stock/record/index', 'ErpStockRecord', 0, '1', '1', '1', '', '2024-02-05 10:27:21', '1', '2024-02-06 17:26:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2594, '库存明细查询', 'erp:stock-record:query', 3, 1, 2593, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 10:27:21', '', '2024-02-05 10:27:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2595, '库存明细导出', 'erp:stock-record:export', 3, 5, 2593, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 10:27:21', '', '2024-02-05 10:27:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2596, '其它入库', '', 2, 3, 2583, 'in', 'ep:zoom-in', 'erp/stock/in/index', 'ErpStockIn', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-07 19:06:51', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2597, '其它入库单查询', 'erp:stock-in:query', 3, 1, 2596, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-05 16:08:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2598, '其它入库单创建', 'erp:stock-in:create', 3, 2, 2596, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-05 16:08:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2599, '其它入库单更新', 'erp:stock-in:update', 3, 3, 2596, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-05 16:08:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2600, '其它入库单删除', 'erp:stock-in:delete', 3, 4, 2596, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-05 16:08:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2601, '其它入库单导出', 'erp:stock-in:export', 3, 5, 2596, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-05 16:08:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2602, '采购管理', '', 1, 10, 2563, 'purchase', 'fa:buysellads', '', '', 0, '1', '1', '1', '1', '2024-02-06 16:01:01', '1', '2024-02-06 16:01:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2603, '供应商信息', '', 2, 4, 2602, 'supplier', 'fa:superpowers', 'erp/purchase/supplier/index', 'ErpSupplier', 0, '1', '1', '1', '', '2024-02-06 08:21:55', '1', '2024-02-06 16:22:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2604, '供应商查询', 'erp:supplier:query', 3, 1, 2603, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-06 08:21:55', '', '2024-02-06 08:21:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2605, '供应商创建', 'erp:supplier:create', 3, 2, 2603, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-06 08:21:55', '', '2024-02-06 08:21:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2606, '供应商更新', 'erp:supplier:update', 3, 3, 2603, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-06 08:21:55', '', '2024-02-06 08:21:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2607, '供应商删除', 'erp:supplier:delete', 3, 4, 2603, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-06 08:21:55', '', '2024-02-06 08:21:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2608, '供应商导出', 'erp:supplier:export', 3, 5, 2603, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-06 08:21:55', '', '2024-02-06 08:21:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2609, '其它入库单审批', 'erp:stock-in:update-status', 3, 6, 2596, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-05 16:08:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2610, '其它出库', '', 2, 4, 2583, 'out', 'ep:zoom-out', 'erp/stock/out/index', 'ErpStockOut', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-07 19:06:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2611, '其它出库单查询', 'erp:stock-out:query', 3, 1, 2610, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 06:43:39', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2612, '其它出库单创建', 'erp:stock-out:create', 3, 2, 2610, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 06:43:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2613, '其它出库单更新', 'erp:stock-out:update', 3, 3, 2610, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 06:43:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2614, '其它出库单删除', 'erp:stock-out:delete', 3, 4, 2610, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 06:43:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2615, '其它出库单导出', 'erp:stock-out:export', 3, 5, 2610, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 06:43:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2616, '其它出库单审批', 'erp:stock-out:update-status', 3, 6, 2610, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 06:43:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2617, '销售管理', '', 1, 20, 2563, 'sale', 'fa:sellsy', '', '', 0, '1', '1', '1', '1', '2024-02-07 15:12:32', '1', '2024-02-07 15:12:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2618, '客户信息', '', 2, 4, 2617, 'customer', 'ep:avatar', 'erp/sale/customer/index', 'ErpCustomer', 0, '1', '1', '1', '', '2024-02-07 07:21:45', '1', '2024-02-07 15:22:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2619, '客户查询', 'erp:customer:query', 3, 1, 2618, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-07 07:21:45', '', '2024-02-07 07:21:45', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2620, '客户创建', 'erp:customer:create', 3, 2, 2618, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-07 07:21:45', '', '2024-02-07 07:21:45', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2621, '客户更新', 'erp:customer:update', 3, 3, 2618, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-07 07:21:45', '', '2024-02-07 07:21:45', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2622, '客户删除', 'erp:customer:delete', 3, 4, 2618, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-07 07:21:45', '', '2024-02-07 07:21:45', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2623, '客户导出', 'erp:customer:export', 3, 5, 2618, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-07 07:21:45', '', '2024-02-07 07:21:45', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2624, '库存调拨', '', 2, 5, 2583, 'move', 'ep:folder-remove', 'erp/stock/move/index', 'ErpStockMove', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-16 18:53:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2625, '库存调度单查询', 'erp:stock-move:query', 3, 1, 2624, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2626, '库存调度单创建', 'erp:stock-move:create', 3, 2, 2624, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:52', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2627, '库存调度单更新', 'erp:stock-move:update', 3, 3, 2624, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2628, '库存调度单删除', 'erp:stock-move:delete', 3, 4, 2624, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2629, '库存调度单导出', 'erp:stock-move:export', 3, 5, 2624, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2630, '库存调度单审批', 'erp:stock-move:update-status', 3, 6, 2624, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:13:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2631, '库存盘点', '', 2, 6, 2583, 'check', 'ep:circle-check-filled', 'erp/stock/check/index', 'ErpStockCheck', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-08 08:31:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2632, '库存盘点单查询', 'erp:stock-check:query', 3, 1, 2631, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2633, '库存盘点单创建', 'erp:stock-check:create', 3, 2, 2631, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:52', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2634, '库存盘点单更新', 'erp:stock-check:update', 3, 3, 2631, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2635, '库存盘点单删除', 'erp:stock-check:delete', 3, 4, 2631, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2636, '库存盘点单导出', 'erp:stock-check:export', 3, 5, 2631, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2637, '库存盘点单审批', 'erp:stock-check:update-status', 3, 6, 2631, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:13:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2638, '销售订单', '', 2, 1, 2617, 'order', 'fa:first-order', 'erp/sale/order/index', 'ErpSaleOrder', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-10 21:59:20', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2639, '销售订单查询', 'erp:sale-order:query', 3, 1, 2638, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2640, '销售订单创建', 'erp:sale-order:create', 3, 2, 2638, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:52', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2641, '销售订单更新', 'erp:sale-order:update', 3, 3, 2638, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2642, '销售订单删除', 'erp:sale-order:delete', 3, 4, 2638, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2643, '销售订单导出', 'erp:sale-order:export', 3, 5, 2638, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2644, '销售订单审批', 'erp:sale-order:update-status', 3, 6, 2638, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:13:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2645, '财务管理', '', 1, 50, 2563, 'finance', 'ep:money', '', '', 0, '1', '1', '1', '1', '2024-02-10 08:05:58', '1', '2024-02-10 08:06:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2646, '结算账户', '', 2, 10, 2645, 'account', 'fa:universal-access', 'erp/finance/account/index', 'ErpAccount', 0, '1', '1', '1', '', '2024-02-10 00:15:07', '1', '2024-02-14 08:24:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2647, '结算账户查询', 'erp:account:query', 3, 1, 2646, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-10 00:15:07', '', '2024-02-10 00:15:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2648, '结算账户创建', 'erp:account:create', 3, 2, 2646, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-10 00:15:07', '', '2024-02-10 00:15:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2649, '结算账户更新', 'erp:account:update', 3, 3, 2646, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-10 00:15:07', '', '2024-02-10 00:15:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2650, '结算账户删除', 'erp:account:delete', 3, 4, 2646, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-10 00:15:07', '', '2024-02-10 00:15:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2651, '结算账户导出', 'erp:account:export', 3, 5, 2646, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-10 00:15:07', '', '2024-02-10 00:15:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2652, '销售出库', '', 2, 2, 2617, 'out', 'ep:sold-out', 'erp/sale/out/index', 'ErpSaleOut', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-10 22:02:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2653, '销售出库查询', 'erp:sale-out:query', 3, 1, 2652, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2654, '销售出库创建', 'erp:sale-out:create', 3, 2, 2652, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:52', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2655, '销售出库更新', 'erp:sale-out:update', 3, 3, 2652, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2656, '销售出库删除', 'erp:sale-out:delete', 3, 4, 2652, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2657, '销售出库导出', 'erp:sale-out:export', 3, 5, 2652, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2658, '销售出库审批', 'erp:sale-out:update-status', 3, 6, 2652, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:13:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2659, '销售退货', '', 2, 3, 2617, 'return', 'fa-solid:bone', 'erp/sale/return/index', 'ErpSaleReturn', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-12 06:12:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2660, '销售退货查询', 'erp:sale-return:query', 3, 1, 2659, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2661, '销售退货创建', 'erp:sale-return:create', 3, 2, 2659, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:52', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2662, '销售退货更新', 'erp:sale-return:update', 3, 3, 2659, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:55', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2663, '销售退货删除', 'erp:sale-return:delete', 3, 4, 2659, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2664, '销售退货导出', 'erp:sale-return:export', 3, 5, 2659, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:12:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2665, '销售退货审批', 'erp:sale-return:update-status', 3, 6, 2659, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-07 11:13:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2666, '采购订单', '', 2, 1, 2602, 'order', 'fa-solid:border-all', 'erp/purchase/order/index', 'ErpPurchaseOrder', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-12 08:51:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2667, '采购订单查询', 'erp:purchase-order:query', 3, 1, 2666, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2668, '采购订单创建', 'erp:purchase-order:create', 3, 2, 2666, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2669, '采购订单更新', 'erp:purchase-order:update', 3, 3, 2666, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2670, '采购订单删除', 'erp:purchase-order:delete', 3, 4, 2666, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2671, '采购订单导出', 'erp:purchase-order:export', 3, 5, 2666, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2672, '采购订单审批', 'erp:purchase-order:update-status', 3, 6, 2666, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2673, '采购入库', '', 2, 2, 2602, 'in', 'fa-solid:gopuram', 'erp/purchase/in/index', 'ErpPurchaseIn', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-12 11:19:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2674, '采购入库查询', 'erp:purchase-in:query', 3, 1, 2673, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2675, '采购入库创建', 'erp:purchase-in:create', 3, 2, 2673, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2676, '采购入库更新', 'erp:purchase-in:update', 3, 3, 2673, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2677, '采购入库删除', 'erp:purchase-in:delete', 3, 4, 2673, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2678, '采购入库导出', 'erp:purchase-in:export', 3, 5, 2673, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2679, '采购入库审批', 'erp:purchase-in:update-status', 3, 6, 2673, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2680, '采购退货', '', 2, 3, 2602, 'return', 'ep:minus', 'erp/purchase/return/index', 'ErpPurchaseReturn', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-12 20:51:02', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2681, '采购退货查询', 'erp:purchase-return:query', 3, 1, 2680, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2682, '采购退货创建', 'erp:purchase-return:create', 3, 2, 2680, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2683, '采购退货更新', 'erp:purchase-return:update', 3, 3, 2680, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2684, '采购退货删除', 'erp:purchase-return:delete', 3, 4, 2680, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2685, '采购退货导出', 'erp:purchase-return:export', 3, 5, 2680, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2686, '采购退货审批', 'erp:purchase-return:update-status', 3, 6, 2680, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2687, '付款单', '', 2, 1, 2645, 'payment', 'ep:caret-right', 'erp/finance/payment/index', 'ErpFinancePayment', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-14 08:24:23', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2688, '付款单查询', 'erp:finance-payment:query', 3, 1, 2687, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2689, '付款单创建', 'erp:finance-payment:create', 3, 2, 2687, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2690, '付款单更新', 'erp:finance-payment:update', 3, 3, 2687, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2691, '付款单删除', 'erp:finance-payment:delete', 3, 4, 2687, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2692, '付款单导出', 'erp:finance-payment:export', 3, 5, 2687, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2693, '付款单审批', 'erp:finance-payment:update-status', 3, 6, 2687, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2694, '收款单', '', 2, 2, 2645, 'receipt', 'ep:expand', 'erp/finance/receipt/index', 'ErpFinanceReceipt', 0, '1', '1', '1', '', '2024-02-05 16:08:56', '1', '2024-02-15 19:35:45', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2695, '收款单查询', 'erp:finance-receipt:query', 3, 1, 2694, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2696, '收款单创建', 'erp:finance-receipt:create', 3, 2, 2694, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2697, '收款单更新', 'erp:finance-receipt:update', 3, 3, 2694, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:44:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2698, '收款单删除', 'erp:finance-receipt:delete', 3, 4, 2694, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2699, '收款单导出', 'erp:finance-receipt:export', 3, 5, 2694, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2700, '收款单审批', 'erp:finance-receipt:update-status', 3, 6, 2694, '', '', '', NULL, 0, '1', '1', '1', '', '2024-02-05 16:08:56', '', '2024-02-12 00:45:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2701, '待办事项', '', 2, 0, 2397, 'backlog', 'fa-solid:tasks', 'crm/backlog/index', 'CrmBacklog', 0, '1', '1', '1', '1', '2024-02-17 17:17:11', '1', '2024-02-17 17:17:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2702, 'ERP 首页', 'erp:statistics:query', 2, 0, 2563, 'home', 'ep:home-filled', 'erp/home/index.vue', 'ErpHome', 0, '1', '1', '1', '1', '2024-02-18 16:49:40', '1', '2024-02-26 21:12:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2703, '商机状态配置', '', 2, 4, 2524, 'business-status', 'fa-solid:charging-station', 'crm/business/status/index', 'CrmBusinessStatus', 0, '1', '1', '1', '1', '2024-02-21 20:15:17', '1', '2024-02-21 20:15:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2704, '商机状态查询', 'crm:business-status:query', 3, 1, 2703, '', '', '', '', 0, '1', '1', '1', '1', '2024-02-21 20:35:36', '1', '2024-02-21 20:36:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2705, '商机状态创建', 'crm:business-status:create', 3, 2, 2703, '', '', '', '', 0, '1', '1', '1', '1', '2024-02-21 20:35:57', '1', '2024-02-21 20:35:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2706, '商机状态更新', 'crm:business-status:update', 3, 3, 2703, '', '', '', '', 0, '1', '1', '1', '1', '2024-02-21 20:36:21', '1', '2024-02-21 20:36:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2707, '商机状态删除', 'crm:business-status:delete', 3, 4, 2703, '', '', '', '', 0, '1', '1', '1', '1', '2024-02-21 20:36:36', '1', '2024-02-21 20:36:36', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2708, '合同配置', '', 2, 5, 2524, 'contract-config', 'ep:connection', 'crm/contract/config/index', 'CrmContractConfig', 0, '1', '1', '1', '1', '2024-02-24 16:44:40', '1', '2024-02-24 16:44:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2709, '客户公海配置查询', 'crm:customer-pool-config:query', 3, 2, 2516, '', '', '', '', 0, '1', '1', '1', '1', '2024-02-24 16:45:19', '1', '2024-02-24 16:45:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2710, '合同配置更新', 'crm:contract-config:update', 3, 1, 2708, '', '', '', '', 0, '1', '1', '1', '1', '2024-02-24 16:45:56', '1', '2024-02-24 16:45:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2711, '合同配置查询', 'crm:contract-config:query', 3, 2, 2708, '', '', '', '', 0, '1', '1', '1', '1', '2024-02-24 16:46:16', '1', '2024-02-24 16:46:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2712, '客户分析', 'crm:statistics-customer:query', 2, 0, 2560, 'customer', 'ep:avatar', 'crm/statistics/customer/index.vue', 'CrmStatisticsCustomer', 0, '1', '1', '1', '1', '2024-03-09 16:43:56', '1', '2024-05-04 20:38:50', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2713, '抄送我的', 'bpm:process-instance-cc:query', 2, 30, 1200, 'copy', 'ep:copy-document', 'bpm/task/copy/index', 'BpmProcessInstanceCopy', 0, '1', '1', '1', '1', '2024-03-17 21:50:23', '1', '2024-04-24 19:55:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2714, '流程分类', '', 2, 3, 1186, 'category', 'fa:object-ungroup', 'bpm/category/index', 'BpmCategory', 0, '1', '1', '1', '', '2024-03-08 02:00:51', '1', '2024-03-21 23:51:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2715, '分类查询', 'bpm:category:query', 3, 1, 2714, '', '', '', '', 0, '1', '1', '1', '', '2024-03-08 02:00:51', '1', '2024-03-19 14:36:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2716, '分类创建', 'bpm:category:create', 3, 2, 2714, '', '', '', '', 0, '1', '1', '1', '', '2024-03-08 02:00:51', '1', '2024-03-19 14:36:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2717, '分类更新', 'bpm:category:update', 3, 3, 2714, '', '', '', '', 0, '1', '1', '1', '', '2024-03-08 02:00:51', '1', '2024-03-19 14:36:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2718, '分类删除', 'bpm:category:delete', 3, 4, 2714, '', '', '', '', 0, '1', '1', '1', '', '2024-03-08 02:00:51', '1', '2024-03-19 14:36:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2720, '发起流程', '', 2, 0, 1200, 'create', 'fa-solid:grin-stars', 'bpm/processInstance/create/index', 'BpmProcessInstanceCreate', 0, '1', '0', '1', '1', '2024-03-19 19:46:05', '1', '2024-03-23 19:03:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2721, '流程实例', '', 2, 10, 1186, 'process-instance/manager', 'fa:square', 'bpm/processInstance/manager/index', 'BpmProcessInstanceManager', 0, '1', '1', '1', '1', '2024-03-21 23:57:30', '1', '2024-03-21 23:57:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2722, '流程实例的查询（管理员）', 'bpm:process-instance:manager-query', 3, 1, 2721, '', '', '', '', 0, '1', '1', '1', '1', '2024-03-22 08:18:27', '1', '2024-03-22 08:19:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2723, '流程实例的取消（管理员）', 'bpm:process-instance:cancel-by-admin', 3, 2, 2721, '', '', '', '', 0, '1', '1', '1', '1', '2024-03-22 08:19:25', '1', '2024-03-22 08:19:25', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2724, '流程任务', '', 2, 11, 1186, 'process-tasnk', 'ep:collection-tag', 'bpm/task/manager/index', 'BpmManagerTask', 0, '1', '1', '1', '1', '2024-03-22 08:43:22', '1', '2024-03-22 08:43:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2725, '流程任务的查询（管理员）', 'bpm:task:mananger-query', 3, 1, 2724, '', '', '', '', 0, '1', '1', '1', '1', '2024-03-22 08:43:49', '1', '2024-03-22 08:43:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2726, '流程监听器', '', 2, 5, 1186, 'process-listener', 'fa:assistive-listening-systems', 'bpm/processListener/index', 'BpmProcessListener', 0, '1', '1', '1', '', '2024-03-09 16:05:34', '1', '2024-03-23 13:13:38', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2727, '流程监听器查询', 'bpm:process-listener:query', 3, 1, 2726, '', '', '', NULL, 0, '1', '1', '1', '', '2024-03-09 16:05:34', '', '2024-03-09 16:05:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2728, '流程监听器创建', 'bpm:process-listener:create', 3, 2, 2726, '', '', '', NULL, 0, '1', '1', '1', '', '2024-03-09 16:05:34', '', '2024-03-09 16:05:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2729, '流程监听器更新', 'bpm:process-listener:update', 3, 3, 2726, '', '', '', NULL, 0, '1', '1', '1', '', '2024-03-09 16:05:34', '', '2024-03-09 16:05:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2730, '流程监听器删除', 'bpm:process-listener:delete', 3, 4, 2726, '', '', '', NULL, 0, '1', '1', '1', '', '2024-03-09 16:05:34', '', '2024-03-09 16:05:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2731, '流程表达式', '', 2, 6, 1186, 'process-expression', 'fa:wpexplorer', 'bpm/processExpression/index', 'BpmProcessExpression', 0, '1', '1', '1', '', '2024-03-09 22:35:08', '1', '2024-03-23 19:43:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2732, '流程表达式查询', 'bpm:process-expression:query', 3, 1, 2731, '', '', '', NULL, 0, '1', '1', '1', '', '2024-03-09 22:35:08', '', '2024-03-09 22:35:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2733, '流程表达式创建', 'bpm:process-expression:create', 3, 2, 2731, '', '', '', NULL, 0, '1', '1', '1', '', '2024-03-09 22:35:08', '', '2024-03-09 22:35:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2734, '流程表达式更新', 'bpm:process-expression:update', 3, 3, 2731, '', '', '', NULL, 0, '1', '1', '1', '', '2024-03-09 22:35:08', '', '2024-03-09 22:35:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2735, '流程表达式删除', 'bpm:process-expression:delete', 3, 4, 2731, '', '', '', NULL, 0, '1', '1', '1', '', '2024-03-09 22:35:08', '', '2024-03-09 22:35:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2736, '员工业绩', 'crm:statistics-performance:query', 2, 3, 2560, 'performance', 'ep:dish-dot', 'crm/statistics/performance/index', 'CrmStatisticsPerformance', 0, '1', '1', '1', '1', '2024-04-05 13:49:20', '1', '2024-04-24 19:42:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2737, '客户画像', 'crm:statistics-portrait:query', 2, 4, 2560, 'portrait', 'ep:picture', 'crm/statistics/portrait/index', 'CrmStatisticsPortrait', 0, '1', '1', '1', '1', '2024-04-05 13:57:40', '1', '2024-04-24 19:42:24', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2738, '销售漏斗', 'crm:statistics-funnel:query', 2, 5, 2560, 'funnel', 'ep:grape', 'crm/statistics/funnel/index', 'CrmStatisticsFunnel', 0, '1', '1', '1', '1', '2024-04-13 10:53:26', '1', '2024-04-24 19:39:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2739, '消息中心', '', 1, 7, 1, 'messages', 'ep:chat-dot-round', '', '', 0, '1', '1', '1', '1', '2024-04-22 23:54:30', '1', '2024-04-23 09:36:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2740, '监控中心', '', 1, 10, 2, 'monitors', 'ep:monitor', '', '', 0, '1', '1', '1', '1', '2024-04-23 00:04:44', '1', '2024-04-23 00:04:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2741, '领取公海客户', 'crm:customer:receive', 3, 1, 2546, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:47:45', '1', '2024-04-24 19:47:45', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2742, '分配公海客户', 'crm:customer:distribute', 3, 2, 2546, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:48:05', '1', '2024-04-24 19:48:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2743, '商品统计查询', 'statistics:product:query', 3, 1, 2545, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:50:05', '1', '2024-04-24 19:50:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2744, '商品统计导出', 'statistics:product:export', 3, 2, 2545, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:50:26', '1', '2024-04-24 19:50:26', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2745, '支付渠道查询', 'pay:channel:query', 3, 10, 1126, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:53:01', '1', '2024-04-24 19:53:01', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2746, '支付渠道创建', 'pay:channel:create', 3, 11, 1126, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:53:18', '1', '2024-04-24 19:53:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2747, '支付渠道更新', 'pay:channel:update', 3, 12, 1126, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:53:32', '1', '2024-04-24 19:53:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2748, '支付渠道删除', 'pay:channel:delete', 3, 13, 1126, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:54:34', '1', '2024-04-24 19:54:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2749, '商品收藏查询', 'product:favorite:query', 3, 10, 2014, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:55:47', '1', '2024-04-24 19:55:47', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2750, '商品浏览查询', 'product:browse-history:query', 3, 20, 2014, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:57:43', '1', '2024-04-24 19:57:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2751, '售后同意', 'trade:after-sale:agree', 3, 2, 2073, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:58:40', '1', '2024-04-24 19:58:40', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2752, '售后不同意', 'trade:after-sale:disagree', 3, 3, 2073, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 19:59:03', '1', '2024-04-24 19:59:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2753, '售后确认退货', 'trade:after-sale:receive', 3, 4, 2073, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 20:00:07', '1', '2024-04-24 20:00:07', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2754, '售后确认退款', 'trade:after-sale:refund', 3, 5, 2073, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 20:00:24', '1', '2024-04-24 20:00:24', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2755, '删除项目', 'report:go-view-project:delete', 3, 2, 2153, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 20:01:37', '1', '2024-04-24 20:01:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2756, '会员等级记录查询', 'member:level-record:query', 3, 10, 2325, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 20:02:32', '1', '2024-04-24 20:02:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2757, '会员经验记录查询', 'member:experience-record:query', 3, 11, 2325, '', '', '', '', 0, '1', '1', '1', '1', '2024-04-24 20:02:51', '1', '2024-04-24 20:02:51', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2758, 'AI 大模型', '', 1, 400, 0, '/ai', 'tabler:ai', '', '', 0, '1', '1', '1', '1', '2024-05-07 15:07:56', '1', '2025-04-19 18:57:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2759, 'AI 对话', '', 2, 1, 2758, 'chat', 'ep:message', 'ai/chat/index/index.vue', 'AiChat', 0, '1', '1', '1', '1', '2024-05-07 15:09:14', '1', '2024-07-07 17:15:36', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2760, '控制台', '', 1, 100, 2758, 'console', 'ep:setting', '', '', 0, '1', '1', '1', '1', '2024-05-09 22:39:09', '1', '2024-05-24 23:34:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2761, 'API 密钥', '', 2, 0, 2760, 'api-key', 'ep:key', 'ai/model/apiKey/index.vue', 'AiApiKey', 0, '1', '1', '1', '', '2024-05-09 14:52:56', '1', '2024-05-10 22:44:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2762, 'API 密钥查询', 'ai:api-key:query', 3, 1, 2761, '', '', '', '', 0, '1', '1', '1', '', '2024-05-09 14:52:56', '1', '2024-05-13 20:36:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2763, 'API 密钥创建', 'ai:api-key:create', 3, 2, 2761, '', '', '', '', 0, '1', '1', '1', '', '2024-05-09 14:52:56', '1', '2024-05-13 20:36:26', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2764, 'API 密钥更新', 'ai:api-key:update', 3, 3, 2761, '', '', '', '', 0, '1', '1', '1', '', '2024-05-09 14:52:56', '1', '2024-05-13 20:36:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2765, 'API 密钥删除', 'ai:api-key:delete', 3, 4, 2761, '', '', '', '', 0, '1', '1', '1', '', '2024-05-09 14:52:56', '1', '2024-05-13 20:36:48', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2767, '模型配置', '', 2, 0, 2760, 'model', 'fa-solid:abacus', 'ai/model/model/index.vue', 'AiModel', 0, '1', '1', '1', '', '2024-05-10 14:42:48', '1', '2025-03-03 09:57:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2768, '聊天模型查询', 'ai:model:query', 3, 1, 2767, '', '', '', '', 0, '1', '1', '1', '', '2024-05-10 14:42:48', '1', '2025-03-03 09:19:46', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2769, '聊天模型创建', 'ai:model:create', 3, 2, 2767, '', '', '', '', 0, '1', '1', '1', '', '2024-05-10 14:42:48', '1', '2025-03-03 09:20:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2770, '聊天模型更新', 'ai:model:update', 3, 3, 2767, '', '', '', '', 0, '1', '1', '1', '', '2024-05-10 14:42:48', '1', '2025-03-03 09:20:14', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2771, '聊天模型删除', 'ai:model:delete', 3, 4, 2767, '', '', '', '', 0, '1', '1', '1', '', '2024-05-10 14:42:48', '1', '2025-03-03 09:20:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2773, '聊天角色', '', 2, 0, 2760, 'chat-role', 'fa:user-secret', 'ai/model/chatRole/index.vue', 'AiChatRole', 0, '1', '1', '1', '', '2024-05-13 12:39:28', '1', '2024-05-13 20:41:45', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2774, '聊天角色查询', 'ai:chat-role:query', 3, 1, 2773, '', '', '', NULL, 0, '1', '1', '1', '', '2024-05-13 12:39:28', '', '2024-05-13 12:39:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2775, '聊天角色创建', 'ai:chat-role:create', 3, 2, 2773, '', '', '', NULL, 0, '1', '1', '1', '', '2024-05-13 12:39:28', '', '2024-05-13 12:39:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2776, '聊天角色更新', 'ai:chat-role:update', 3, 3, 2773, '', '', '', NULL, 0, '1', '1', '1', '', '2024-05-13 12:39:28', '', '2024-05-13 12:39:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2777, '聊天角色删除', 'ai:chat-role:delete', 3, 4, 2773, '', '', '', '', 0, '1', '1', '1', '1', '2024-05-13 21:43:38', '1', '2024-05-13 21:43:38', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2778, '聊天管理', '', 2, 10, 2760, 'chat-conversation', 'ep:chat-square', 'ai/chat/manager/index.vue', 'AiChatManager', 0, '1', '1', '1', '', '2024-05-24 15:39:18', '1', '2024-06-26 21:36:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2779, '会话查询', 'ai:chat-conversation:query', 3, 1, 2778, '', '', '', '', 0, '1', '1', '1', '', '2024-05-24 15:39:18', '1', '2024-05-25 08:38:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2780, '会话删除', 'ai:chat-conversation:delete', 3, 2, 2778, '', '', '', '', 0, '1', '1', '1', '', '2024-05-24 15:39:18', '1', '2024-05-25 08:38:40', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2781, '消息查询', 'ai:chat-message:query', 3, 11, 2778, '', '', '', '', 0, '1', '1', '1', '1', '2024-05-25 08:38:56', '1', '2024-05-25 08:38:56', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2782, '消息删除', 'ai:chat-message:delete', 3, 12, 2778, '', '', '', '', 0, '1', '1', '1', '1', '2024-05-25 08:39:10', '1', '2024-05-25 08:39:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2783, 'AI 绘画', '', 2, 2, 2758, 'image', 'ep:picture-rounded', 'ai/image/index/index.vue', 'AiImage', 0, '1', '1', '1', '1', '2024-05-26 11:45:17', '1', '2024-07-07 17:18:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2784, '绘画管理', '', 2, 11, 2760, 'image', 'fa:file-image-o', 'ai/image/manager/index.vue', 'AiImageManager', 0, '1', '1', '1', '', '2024-06-26 13:32:31', '1', '2024-06-26 21:37:13', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2785, '绘画查询', 'ai:image:query', 3, 1, 2784, '', '', '', '', 0, '1', '1', '1', '', '2024-06-26 13:32:31', '1', '2024-06-26 22:21:57', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2786, '绘画删除', 'ai:image:delete', 3, 4, 2784, '', '', '', '', 0, '1', '1', '1', '', '2024-06-26 13:32:31', '1', '2024-06-26 22:22:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2787, '绘图更新', 'ai:image:update', 3, 2, 2784, '', '', '', '', 0, '1', '1', '1', '1', '2024-06-26 22:47:56', '1', '2024-08-31 09:21:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2788, '音乐管理', '', 2, 12, 2760, 'music', 'fa:music', 'ai/music/manager/index.vue', 'AiMusicManager', 0, '1', '1', '1', '', '2024-06-27 15:03:33', '1', '2024-06-27 23:04:19', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2789, '音乐查询', 'ai:music:query', 3, 1, 2788, '', '', '', NULL, 0, '1', '1', '1', '', '2024-06-27 15:03:33', '', '2024-06-27 15:03:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2790, '音乐更新', 'ai:music:update', 3, 3, 2788, '', '', '', NULL, 0, '1', '1', '1', '', '2024-06-27 15:03:33', '', '2024-06-27 15:03:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2791, '音乐删除', 'ai:music:delete', 3, 4, 2788, '', '', '', NULL, 0, '1', '1', '1', '', '2024-06-27 15:03:33', '', '2024-06-27 15:03:33', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2792, 'AI 写作', '', 2, 3, 2758, 'write', 'fa-solid:book-reader', 'ai/write/index/index.vue', 'AiWrite', 0, '1', '1', '1', '1', '2024-07-08 09:26:44', '1', '2024-07-16 13:03:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2793, '写作管理', '', 2, 13, 2760, 'write', 'fa:bookmark-o', 'ai/write/manager/index.vue', 'AiWriteManager', 0, '1', '1', '1', '', '2024-07-10 13:24:34', '1', '2024-07-10 21:31:59', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2794, 'AI 写作查询', 'ai:write:query', 3, 1, 2793, '', '', '', NULL, 0, '1', '1', '1', '', '2024-07-10 13:24:34', '', '2024-07-10 13:24:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2795, 'AI 写作删除', 'ai:write:delete', 3, 4, 2793, '', '', '', NULL, 0, '1', '1', '1', '', '2024-07-10 13:24:34', '', '2024-07-10 13:24:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2796, 'AI 音乐', '', 2, 4, 2758, 'music', 'fa:music', 'ai/music/index/index.vue', 'AiMusic', 0, '1', '1', '1', '1', '2024-07-17 09:21:12', '1', '2024-07-29 21:11:52', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2797, '客服中心', '', 2, 100, 2362, 'kefu', 'fa-solid:user-alt', 'mall/promotion/kefu/index', 'KeFu', 0, '1', '1', '1', '1', '2024-07-17 23:49:05', '1', '2024-07-17 23:49:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2798, 'AI 思维导图', '', 2, 6, 2758, 'mind-map', 'fa:sitemap', 'ai/mindmap/index/index.vue', 'AiMindMap', 0, '1', '1', '1', '1', '2024-07-29 21:31:59', '1', '2025-03-02 18:57:31', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2799, '导图管理', '', 2, 14, 2760, 'mind-map', 'fa:map', 'ai/mindmap/manager/index', 'AiMindMapManager', 0, '1', '1', '1', '', '2024-08-10 09:15:09', '1', '2024-08-10 17:24:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2800, '思维导图查询', 'ai:mind-map:query', 3, 1, 2799, '', '', '', NULL, 0, '1', '1', '1', '', '2024-08-10 09:15:09', '', '2024-08-10 09:15:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2801, '思维导图删除', 'ai:mind-map:delete', 3, 4, 2799, '', '', '', NULL, 0, '1', '1', '1', '', '2024-08-10 09:15:09', '', '2024-08-10 09:15:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2802, '会话查询', 'promotion:kefu-conversation:query', 3, 1, 2797, '', '', '', '', 0, '1', '1', '1', '1', '2024-08-31 09:17:52', '1', '2024-08-31 09:18:52', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2803, '会话更新', 'promotion:kefu-conversation:update', 3, 2, 2797, '', '', '', '', 0, '1', '1', '1', '1', '2024-08-31 09:18:15', '1', '2024-08-31 09:19:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2804, '消息查询', 'promotion:kefu-message:query', 3, 10, 2797, '', '', '', '', 0, '1', '1', '1', '1', '2024-08-31 09:18:42', '1', '2024-08-31 09:18:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2805, '会话删除', 'promotion:kefu-conversation:delete', 3, 3, 2797, '', '', '', '', 0, '1', '1', '1', '1', '2024-08-31 09:19:51', '1', '2024-08-31 09:20:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2806, '消息发送', 'promotion:kefu-message:send', 3, 12, 2797, '', '', '', '', 0, '1', '1', '1', '1', '2024-08-31 09:20:06', '1', '2024-08-31 09:20:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2807, '消息更新', 'promotion:kefu-message:update', 3, 11, 2797, '', '', '', '', 0, '1', '1', '1', '1', '2024-08-31 09:20:22', '1', '2024-08-31 09:20:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2808, '积分商城', '', 2, 5, 2030, 'point-activity', 'ep:bowl', 'mall/promotion/point/activity/index', 'PointActivity', 0, '1', '1', '1', '', '2024-09-21 05:36:42', '1', '2024-09-23 09:14:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2809, '积分商城活动查询', 'promotion:point-activity:query', 3, 1, 2808, '', '', '', '', 0, '1', '1', '1', '', '2024-09-21 05:36:42', '1', '2024-09-22 14:49:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2810, '积分商城活动创建', 'promotion:point-activity:create', 3, 2, 2808, '', '', '', '', 0, '1', '1', '1', '', '2024-09-21 05:36:42', '1', '2024-09-22 14:49:08', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2811, '积分商城活动更新', 'promotion:point-activity:update', 3, 3, 2808, '', '', '', '', 0, '1', '1', '1', '', '2024-09-21 05:36:42', '1', '2024-09-22 14:49:10', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2812, '积分商城活动删除', 'promotion:point-activity:delete', 3, 4, 2808, '', '', '', '', 0, '1', '1', '1', '', '2024-09-21 05:36:42', '1', '2024-09-22 14:49:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2813, '积分商城活动导出', 'promotion:point-activity:export', 3, 5, 2808, '', '', '', '', 0, '1', '1', '1', '', '2024-09-21 05:36:42', '1', '2024-09-22 14:49:27', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2912, '创建推广员', 'trade:brokerage-user:create', 3, 7, 2346, '', '', '', '', 0, '1', '1', '1', '1', '2024-12-01 14:32:39', '1', '2024-12-01 14:32:39', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2913, '流程清理', 'bpm:model:clean', 3, 7, 1193, '', '', '', '', 0, '1', '1', '1', '1', '2025-01-17 19:32:06', '1', '2025-01-17 19:32:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2914, '积分商城活动关闭', 'promotion:point-activity:close', 3, 6, 2808, '', '', '', '', 0, '1', '1', '1', '1', '2025-01-23 20:23:34', '1', '2025-01-23 20:23:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2915, 'AI 知识库', '', 2, 5, 2758, 'knowledge', 'ep:notebook', 'ai/knowledge/knowledge/index', 'AiKnowledge', 0, '1', '1', '1', '', '2025-02-28 07:04:21', '1', '2025-03-02 18:58:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2916, 'AI 知识库查询', 'ai:knowledge:query', 3, 1, 2915, '', '', '', NULL, 0, '1', '1', '1', '', '2025-02-28 07:04:21', '', '2025-02-28 07:04:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2917, 'AI 知识库创建', 'ai:knowledge:create', 3, 2, 2915, '', '', '', NULL, 0, '1', '1', '1', '', '2025-02-28 07:04:21', '', '2025-02-28 07:04:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2918, 'AI 知识库更新', 'ai:knowledge:update', 3, 3, 2915, '', '', '', NULL, 0, '1', '1', '1', '', '2025-02-28 07:04:21', '', '2025-02-28 07:04:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2919, 'AI 知识库删除', 'ai:knowledge:delete', 3, 4, 2915, '', '', '', NULL, 0, '1', '1', '1', '', '2025-02-28 07:04:21', '', '2025-02-28 07:04:21', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2920, '工具管理', '', 2, 0, 2760, 'tool', 'fa-solid:tools', 'ai/model/tool/index.vue', 'AiTool', 0, '1', '1', '1', '', '2025-03-14 11:19:29', '1', '2025-03-14 19:20:18', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2921, '工具查询', 'ai:tool:query', 3, 1, 2920, '', '', '', NULL, 0, '1', '1', '1', '', '2025-03-14 11:19:29', '', '2025-03-14 11:19:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2922, '工具创建', 'ai:tool:create', 3, 2, 2920, '', '', '', NULL, 0, '1', '1', '1', '', '2025-03-14 11:19:29', '', '2025-03-14 11:19:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2923, '工具更新', 'ai:tool:update', 3, 3, 2920, '', '', '', NULL, 0, '1', '1', '1', '', '2025-03-14 11:19:29', '', '2025-03-14 11:19:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (2924, '工具删除', 'ai:tool:delete', 3, 4, 2920, '', '', '', NULL, 0, '1', '1', '1', '', '2025-03-14 11:19:29', '', '2025-03-14 11:19:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4000, 'IoT 物联网', '', 1, 500, 0, '/iot', 'fa-solid:hdd', '', '', 0, '1', '1', '1', '1', '2024-08-10 09:55:28', '1', '2024-12-07 15:58:34', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4001, '设备接入', '', 1, 2, 4000, 'device', 'ep:platform', '', '', 0, '1', '1', '1', '1', '2024-08-10 09:57:56', '1', '2025-02-27 08:39:49', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4002, '产品管理', '', 2, 2, 4001, 'product', 'fa-solid:tools', 'iot/product/product/index', 'IoTProduct', 0, '1', '1', '1', '', '2024-08-10 02:38:02', '1', '2024-12-07 18:47:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4003, '产品查询', 'iot:product:query', 3, 1, 4002, '', '', '', NULL, 0, '1', '1', '1', '', '2024-08-10 02:38:02', '', '2024-12-07 15:55:00', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4004, '产品创建', 'iot:product:create', 3, 2, 4002, '', '', '', NULL, 0, '1', '1', '1', '', '2024-08-10 02:38:02', '', '2024-12-07 15:55:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4005, '产品更新', 'iot:product:update', 3, 3, 4002, '', '', '', NULL, 0, '1', '1', '1', '', '2024-08-10 02:38:02', '', '2024-12-07 15:55:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4006, '产品删除', 'iot:product:delete', 3, 4, 4002, '', '', '', NULL, 0, '1', '1', '1', '', '2024-08-10 02:38:02', '', '2024-12-07 15:55:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4007, '产品导出', 'iot:product:export', 3, 5, 4002, '', '', '', NULL, 0, '1', '1', '1', '', '2024-08-10 02:38:02', '', '2024-12-07 15:55:13', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4008, '设备管理', '', 2, 4, 4001, 'device', 'fa:mobile', 'iot/device/device/index', 'IoTDevice', 0, '1', '1', '1', '', '2024-09-16 18:48:19', '1', '2024-12-14 11:39:30', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4009, '设备查询', 'iot:device:query', 3, 1, 4008, '', '', '', '', 0, '1', '1', '1', '', '2024-09-16 18:48:19', '1', '2024-12-07 15:55:40', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4010, '设备创建', 'iot:device:create', 3, 2, 4008, '', '', '', '', 0, '1', '1', '1', '', '2024-09-16 18:48:19', '1', '2024-12-07 15:55:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4011, '设备更新', 'iot:device:update', 3, 3, 4008, '', '', '', '', 0, '1', '1', '1', '', '2024-09-16 18:48:19', '1', '2024-12-07 15:55:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4012, '设备删除', 'iot:device:delete', 3, 4, 4008, '', '', '', '', 0, '1', '1', '1', '', '2024-09-16 18:48:19', '1', '2024-12-07 15:55:43', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4013, '设备导出', 'iot:device:export', 3, 5, 4008, '', '', '', '', 0, '1', '1', '1', '', '2024-09-16 18:48:19', '1', '2024-12-07 15:55:44', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4014, '产品分类', '', 2, 1, 4001, 'product-category', 'ep:notebook', 'iot/product/category/index', 'IotProductCategory', 0, '1', '1', '1', '', '2024-12-07 16:01:35', '1', '2024-12-07 16:31:52', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4015, '产品分类查询', 'iot:product-category:query', 3, 1, 4014, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-07 16:01:35', '', '2024-12-07 16:01:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4016, '产品分类创建', 'iot:product-category:create', 3, 2, 4014, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-07 16:01:35', '', '2024-12-07 16:01:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4017, '产品分类更新', 'iot:product-category:update', 3, 3, 4014, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-07 16:01:35', '', '2024-12-07 16:01:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4018, '产品分类删除', 'iot:product-category:delete', 3, 4, 4014, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-07 16:01:35', '', '2024-12-07 16:01:35', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4025, '插件管理', '', 2, 5, 4047, 'plugin-config', 'ep:folder-opened', 'iot/plugin/index', 'IoTPlugin', 0, '1', '1', '1', '', '2024-12-09 21:25:06', '1', '2025-02-05 22:23:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4026, '插件查询', 'iot:plugin-config:query', 3, 1, 4025, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-09 21:25:06', '', '2025-02-05 21:23:20', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4027, '插件创建', 'iot:plugin-config:create', 3, 2, 4025, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-09 21:25:06', '', '2025-02-05 21:23:16', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4028, '插件更新', 'iot:plugin-config:update', 3, 3, 4025, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-09 21:25:06', '', '2025-02-05 21:23:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4029, '插件删除', 'iot:plugin-config:delete', 3, 4, 4025, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-09 21:25:06', '', '2025-02-05 21:23:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4030, '插件导出', 'iot:plugin-config:export', 3, 5, 4025, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-09 21:25:06', '', '2025-02-05 21:23:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4031, '设备分组', '', 2, 3, 4001, 'device-group', 'fa-solid:layer-group', 'iot/device/group/index', 'IotDeviceGroup', 0, '1', '1', '1', '', '2024-12-14 17:08:29', '1', '2024-12-14 17:09:17', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4032, '设备分组查询', 'iot:device-group:query', 3, 1, 4031, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-14 17:08:29', '', '2024-12-14 17:08:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4033, '设备分组创建', 'iot:device-group:create', 3, 2, 4031, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-14 17:08:29', '', '2024-12-14 17:08:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4034, '设备分组更新', 'iot:device-group:update', 3, 3, 4031, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-14 17:08:29', '', '2024-12-14 17:08:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4035, '设备分组删除', 'iot:device-group:delete', 3, 4, 4031, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-14 17:08:29', '', '2024-12-14 17:08:29', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4036, '设备导入', 'iot:device:import', 3, 6, 4008, '', '', '', '', 0, '1', '1', '1', '1', '2024-12-15 10:35:47', '1', '2024-12-15 10:35:47', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4037, '产品物模型', '', 2, 2, 4001, 'thing-model', 'ep:mostly-cloudy', 'iot/thingmodel/index', 'IoTThingModel', 0, '0', '0', '0', '', '2024-12-16 17:17:50', '1', '2024-12-27 11:03:37', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4038, '产品物模型功能查询', 'iot:thing-model:query', 3, 1, 4037, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-16 17:17:51', '', '2025-03-17 09:14:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4039, '产品物模型功能创建', 'iot:thing-model:create', 3, 2, 4037, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-16 17:17:52', '', '2025-03-17 09:14:58', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4040, '产品物模型功能更新', 'iot:thing-model:update', 3, 3, 4037, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-16 17:17:52', '', '2025-03-17 09:15:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4041, '产品物模型功能删除', 'iot:thing-model:delete', 3, 4, 4037, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-16 17:17:52', '', '2025-03-17 09:15:06', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4042, '产品物模型功能导出', 'iot:thing-model:export', 3, 5, 4037, '', '', '', NULL, 0, '1', '1', '1', '', '2024-12-16 17:17:53', '', '2025-03-17 09:15:09', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4043, '设备上行', 'iot:device:upstream', 3, 7, 4008, '', '', '', '', 0, '1', '1', '1', '1', '2025-01-28 04:40:16', '1', '2025-01-31 22:45:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4044, '设备属性查询', 'iot:device:property-query', 3, 10, 4008, '', '', '', '', 0, '1', '1', '1', '1', '2025-01-28 11:52:54', '1', '2025-01-28 11:52:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4045, '设备日志查询', 'iot:device:log-query', 3, 11, 4008, '', '', '', '', 0, '1', '1', '1', '1', '2025-01-28 11:53:22', '1', '2025-01-28 11:53:22', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4046, '设备下行', 'iot:device:downstream', 3, 8, 4008, '', '', '', '', 0, '1', '1', '1', '1', '2025-01-31 22:46:11', '1', '2025-01-31 22:46:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4047, '运维管理', '', 1, 2, 4000, 'operations', 'fa:cog', '', '', 0, '1', '1', '1', '1', '2025-02-05 22:21:37', '1', '2025-02-05 22:22:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4048, '规则引擎', '', 1, 3, 4000, 'rule', 'fa-solid:cogs', '', '', 0, '1', '1', '1', '1', '2025-02-11 14:10:54', '1', '2025-02-11 14:10:54', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4049, '场景联动', '', 2, 1, 4048, 'scene', 'ep:link', 'iot/rule/scene/index', 'Scene', 0, '1', '1', '1', '1', '2025-02-11 14:12:44', '1', '2025-02-12 10:15:36', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4050, 'IoT首页', '', 2, 1, 4000, 'home', 'ep:home-filled', 'iot/home/index', 'IotHome', 0, '1', '1', '1', '1', '2025-02-27 08:39:35', '1', '2025-02-27 08:40:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4051, '数据桥梁', '', 2, 0, 4048, 'data-bridge', 'ep:guide', 'iot/rule/databridge/index', 'IotDataBridge', 0, '1', '1', '1', '', '2025-03-09 13:47:11', '1', '2025-03-09 13:47:51', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4052, 'IoT 数据桥梁查询', 'iot:data-bridge:query', 3, 1, 4051, '', '', '', NULL, 0, '1', '1', '1', '', '2025-03-09 13:47:11', '', '2025-03-09 13:47:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4053, 'IoT 数据桥梁创建', 'iot:data-bridge:create', 3, 2, 4051, '', '', '', NULL, 0, '1', '1', '1', '', '2025-03-09 13:47:11', '', '2025-03-09 13:47:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4054, 'IoT 数据桥梁更新', 'iot:data-bridge:update', 3, 3, 4051, '', '', '', NULL, 0, '1', '1', '1', '', '2025-03-09 13:47:11', '', '2025-03-09 13:47:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4055, 'IoT 数据桥梁删除', 'iot:data-bridge:delete', 3, 4, 4051, '', '', '', NULL, 0, '1', '1', '1', '', '2025-03-09 13:47:12', '', '2025-03-09 13:47:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (4056, 'IoT 数据桥梁导出', 'iot:data-bridge:export', 3, 5, 4051, '', '', '', NULL, 0, '1', '1', '1', '', '2025-03-09 13:47:12', '', '2025-03-09 13:47:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5000, 'AI 工作流', '', 2, 5, 2758, 'workflow', 'fa:hand-grab-o', 'ai/workflow/index.vue', 'AiWorkflow', 0, '1', '1', '1', '1', '2025-03-25 09:50:27', '1', '2025-05-03 18:55:12', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5001, 'AI 工作流查询', 'ai:workflow:query', 3, 1, 5000, '', '', '', '', 0, '1', '1', '1', '1', '2025-03-25 09:51:11', '1', '2025-03-25 09:51:11', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5002, 'AI 工作流创建', 'ai:workflow:create', 3, 2, 5000, '', '', '', '', 0, '1', '1', '1', '1', '2025-03-25 09:51:28', '1', '2025-03-25 09:51:28', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5003, 'AI 工作流更新', 'ai:workflow:update', 3, 3, 5000, '', '', '', '', 0, '1', '1', '1', '1', '2025-03-25 09:51:42', '1', '2025-03-25 09:51:42', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5004, 'AI 工作流删除', 'ai:workflow:delete', 3, 4, 5000, '', '', '', '', 0, '1', '1', '1', '1', '2025-03-25 09:51:55', '1', '2025-03-25 09:52:03', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5005, 'AI 工作流测试', 'ai:workflow:test', 3, 5, 5000, '', '', '', '', 0, '1', '1', '1', '1', '2025-03-30 10:29:41', '1', '2025-03-30 10:29:41', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5009, '仪表盘设计器', '', 2, 1, 1281, 'jimu-bi', 'fa:y-combinator', 'report/jmreport/bi', 'JimuBI', 0, '1', '1', '1', '1', '2025-05-03 09:57:15', '1', '2025-05-03 10:02:05', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5010, '租户切换', 'system:tenant:visit', 3, 999, 1138, '', '', '', '', 0, '1', '1', '1', '1', '2025-05-05 15:25:32', '1', '2025-05-05 15:25:32', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5011, '转账订单查询', 'pay:transfer:query', 3, 1, 2559, '', '', '', '', 0, '1', '1', '1', '1', '2025-05-08 12:46:53', '1', '2025-05-08 12:46:53', '0');
INSERT INTO system_menu (id, name, permission, type, sort, parent_id, path, icon, component, component_name, status, visible, keep_alive, always_show, creator, create_time, updater, update_time, deleted) VALUES (5012, '转账订单导出', 'pay:transfer:export', 3, 2, 2559, '', '', '', '', 0, '1', '1', '1', '1', '2025-05-10 17:00:28', '1', '2025-05-10 17:00:28', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_menu_seq;
CREATE SEQUENCE system_menu_seq
    START 5013;

-- ----------------------------
-- Table structure for system_notice
-- ----------------------------
DROP TABLE IF EXISTS system_notice;
CREATE TABLE system_notice
(
    id          int8        NOT NULL,
    title       varchar(50) NOT NULL,
    content     text        NULL,
    type        int2        NOT NULL,
    status      int2        NOT NULL DEFAULT 0,
    creator     varchar(64) NULL     DEFAULT '',
    create_time timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64) NULL     DEFAULT '',
    update_time timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2        NOT NULL DEFAULT 0,
    tenant_id   int8        NOT NULL DEFAULT 0
);

ALTER TABLE system_notice
    ADD CONSTRAINT pk_system_notice PRIMARY KEY (id);

COMMENT ON COLUMN system_notice.id IS '公告ID';
COMMENT ON COLUMN system_notice.title IS '公告标题';
COMMENT ON COLUMN system_notice.content IS '公告内容';
COMMENT ON COLUMN system_notice.type IS '公告类型（1通知 2公告）';
COMMENT ON COLUMN system_notice.status IS '公告状态（0正常 1关闭）';
COMMENT ON COLUMN system_notice.creator IS '创建者';
COMMENT ON COLUMN system_notice.create_time IS '创建时间';
COMMENT ON COLUMN system_notice.updater IS '更新者';
COMMENT ON COLUMN system_notice.update_time IS '更新时间';
COMMENT ON COLUMN system_notice.deleted IS '是否删除';
COMMENT ON COLUMN system_notice.tenant_id IS '租户编号';
COMMENT ON TABLE system_notice IS '通知公告表';

-- ----------------------------
-- Records of system_notice
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_notice (id, title, content, type, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1, '密讯的公众', '<p>新版本内容133</p>', 1, 0, 'admin', '2021-01-05 17:03:48', '1', '2022-05-04 21:00:20', '0', 1);
INSERT INTO system_notice (id, title, content, type, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2, '维护通知：2018-07-01 系统凌晨维护', '<p><img src="http://xxx/b7cb3cf49b4b3258bf7309a09dd2f4e5.jpg" alt="" data-href="">11112222<img src="http://xxx/fe44fc7bdb82ca421184b2eebbaee9e2148d4a1827479a4eb4521e11d2a062ba.png" alt="image" data-href="http://xxx/fe44fc7bdb82ca421184b2eebbaee9e2148d4a1827479a4eb4521e11d2a062ba.png">3333</p>', 2, 1, 'admin', '2021-01-05 17:03:48', '1', '2025-04-18 23:56:40', '0', 1);
INSERT INTO system_notice (id, title, content, type, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4, '我是测试标题', '<p>哈哈哈哈123</p>', 1, 0, '110', '2022-02-22 01:01:25', '110', '2022-02-22 01:01:46', '0', 121);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_notice_seq;
CREATE SEQUENCE system_notice_seq
    START 5;

-- ----------------------------
-- Table structure for system_notify_message
-- ----------------------------
DROP TABLE IF EXISTS system_notify_message;
CREATE TABLE system_notify_message
(
    id                int8          NOT NULL,
    user_id           int8          NOT NULL,
    user_type         int2          NOT NULL,
    template_id       int8          NOT NULL,
    template_code     varchar(64)   NOT NULL,
    template_nickname varchar(63)   NOT NULL,
    template_content  varchar(1024) NOT NULL,
    template_type     int4          NOT NULL,
    template_params   varchar(255)  NOT NULL,
    read_status       bool          NOT NULL,
    read_time         timestamp     NULL     DEFAULT NULL,
    creator           varchar(64)   NULL     DEFAULT '',
    create_time       timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater           varchar(64)   NULL     DEFAULT '',
    update_time       timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted           int2          NOT NULL DEFAULT 0,
    tenant_id         int8          NOT NULL DEFAULT 0
);

ALTER TABLE system_notify_message
    ADD CONSTRAINT pk_system_notify_message PRIMARY KEY (id);

COMMENT ON COLUMN system_notify_message.id IS '用户ID';
COMMENT ON COLUMN system_notify_message.user_id IS '用户id';
COMMENT ON COLUMN system_notify_message.user_type IS '用户类型';
COMMENT ON COLUMN system_notify_message.template_id IS '模版编号';
COMMENT ON COLUMN system_notify_message.template_code IS '模板编码';
COMMENT ON COLUMN system_notify_message.template_nickname IS '模版发送人名称';
COMMENT ON COLUMN system_notify_message.template_content IS '模版内容';
COMMENT ON COLUMN system_notify_message.template_type IS '模版类型';
COMMENT ON COLUMN system_notify_message.template_params IS '模版参数';
COMMENT ON COLUMN system_notify_message.read_status IS '是否已读';
COMMENT ON COLUMN system_notify_message.read_time IS '阅读时间';
COMMENT ON COLUMN system_notify_message.creator IS '创建者';
COMMENT ON COLUMN system_notify_message.create_time IS '创建时间';
COMMENT ON COLUMN system_notify_message.updater IS '更新者';
COMMENT ON COLUMN system_notify_message.update_time IS '更新时间';
COMMENT ON COLUMN system_notify_message.deleted IS '是否删除';
COMMENT ON COLUMN system_notify_message.tenant_id IS '租户编号';
COMMENT ON TABLE system_notify_message IS '站内信消息表';

-- ----------------------------
-- Records of system_notify_message
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname, template_content, template_type, template_params, read_status, read_time, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2, 1, 2, 1, 'test', '123', '我是 1，我开始 2 了', 1, '{"name":"1","what":"2"}', '1', '2025-04-21 14:59:37', '1', '2023-01-28 11:44:08', '1', '2025-04-21 14:59:37', '0', 1);
INSERT INTO system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname, template_content, template_type, template_params, read_status, read_time, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3, 1, 2, 1, 'test', '123', '我是 1，我开始 2 了', 1, '{"name":"1","what":"2"}', '1', '2025-04-21 14:59:37', '1', '2023-01-28 11:45:04', '1', '2025-04-21 14:59:37', '0', 1);
INSERT INTO system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname, template_content, template_type, template_params, read_status, read_time, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4, 103, 2, 2, 'register', '系统消息', '你好，欢迎 哈哈 加入大家庭！', 2, '{"name":"哈哈"}', '0', NULL, '1', '2023-01-28 21:02:20', '1', '2023-01-28 21:02:20', '0', 1);
INSERT INTO system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname, template_content, template_type, template_params, read_status, read_time, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5, 1, 2, 1, 'test', '123', '我是 管理员，我开始 写代码 了', 1, '{"name":"管理员","what":"写代码"}', '1', '2025-04-21 14:59:37', '1', '2023-01-28 22:21:42', '1', '2025-04-21 14:59:37', '0', 1);
INSERT INTO system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname, template_content, template_type, template_params, read_status, read_time, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6, 1, 2, 1, 'test', '123', '我是 管理员，我开始 写代码 了', 1, '{"name":"管理员","what":"写代码"}', '1', '2025-04-21 14:59:36', '1', '2023-01-28 22:22:07', '1', '2025-04-21 14:59:36', '0', 1);
INSERT INTO system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname, template_content, template_type, template_params, read_status, read_time, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (7, 1, 2, 1, 'test', '123', '我是 2，我开始 3 了', 1, '{"name":"2","what":"3"}', '1', '2025-04-21 14:59:35', '1', '2023-01-28 23:45:21', '1', '2025-04-21 14:59:35', '0', 1);
INSERT INTO system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname, template_content, template_type, template_params, read_status, read_time, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (8, 1, 2, 2, 'register', '系统消息', '你好，欢迎 123 加入大家庭！', 2, '{"name":"123"}', '1', '2025-04-21 14:59:35', '1', '2023-01-28 23:50:21', '1', '2025-04-21 14:59:35', '0', 1);
INSERT INTO system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname, template_content, template_type, template_params, read_status, read_time, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (9, 247, 1, 4, 'brokerage_withdraw_audit_approve', 'system', '您在2023-09-28 08:35:46提现￥0.09元的申请已通过审核', 2, '{"reason":null,"createTime":"2023-09-28 08:35:46","price":"0.09"}', '0', NULL, '1', '2023-09-28 16:36:22', '1', '2023-09-28 16:36:22', '0', 1);
INSERT INTO system_notify_message (id, user_id, user_type, template_id, template_code, template_nickname, template_content, template_type, template_params, read_status, read_time, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (10, 247, 1, 4, 'brokerage_withdraw_audit_approve', 'system', '您在2023-09-30 20:59:40提现￥1.00元的申请已通过审核', 2, '{"reason":null,"createTime":"2023-09-30 20:59:40","price":"1.00"}', '0', NULL, '1', '2023-10-03 12:11:34', '1', '2023-10-03 12:11:34', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_notify_message_seq;
CREATE SEQUENCE system_notify_message_seq
    START 11;

-- ----------------------------
-- Table structure for system_notify_template
-- ----------------------------
DROP TABLE IF EXISTS system_notify_template;
CREATE TABLE system_notify_template
(
    id          int8          NOT NULL,
    name        varchar(63)   NOT NULL,
    code        varchar(64)   NOT NULL,
    nickname    varchar(255)  NOT NULL,
    content     varchar(1024) NOT NULL,
    type        int2          NOT NULL,
    params      varchar(255)  NULL     DEFAULT NULL,
    status      int2          NOT NULL,
    remark      varchar(255)  NULL     DEFAULT NULL,
    creator     varchar(64)   NULL     DEFAULT '',
    create_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)   NULL     DEFAULT '',
    update_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2          NOT NULL DEFAULT 0
);

ALTER TABLE system_notify_template
    ADD CONSTRAINT pk_system_notify_template PRIMARY KEY (id);

COMMENT ON COLUMN system_notify_template.id IS '主键';
COMMENT ON COLUMN system_notify_template.name IS '模板名称';
COMMENT ON COLUMN system_notify_template.code IS '模版编码';
COMMENT ON COLUMN system_notify_template.nickname IS '发送人名称';
COMMENT ON COLUMN system_notify_template.content IS '模版内容';
COMMENT ON COLUMN system_notify_template.type IS '类型';
COMMENT ON COLUMN system_notify_template.params IS '参数数组';
COMMENT ON COLUMN system_notify_template.status IS '状态';
COMMENT ON COLUMN system_notify_template.remark IS '备注';
COMMENT ON COLUMN system_notify_template.creator IS '创建者';
COMMENT ON COLUMN system_notify_template.create_time IS '创建时间';
COMMENT ON COLUMN system_notify_template.updater IS '更新者';
COMMENT ON COLUMN system_notify_template.update_time IS '更新时间';
COMMENT ON COLUMN system_notify_template.deleted IS '是否删除';
COMMENT ON TABLE system_notify_template IS '站内信模板表';

DROP SEQUENCE IF EXISTS system_notify_template_seq;
CREATE SEQUENCE system_notify_template_seq
    START 1;

-- ----------------------------
-- Table structure for system_oauth2_access_token
-- ----------------------------
DROP TABLE IF EXISTS system_oauth2_access_token;
CREATE TABLE system_oauth2_access_token
(
    id            int8         NOT NULL,
    user_id       int8         NOT NULL,
    user_type     int2         NOT NULL,
    user_info     varchar(512) NOT NULL,
    access_token  varchar(255) NOT NULL,
    refresh_token varchar(32)  NOT NULL,
    client_id     varchar(255) NOT NULL,
    scopes        varchar(255) NULL     DEFAULT NULL,
    expires_time  timestamp    NOT NULL,
    creator       varchar(64)  NULL     DEFAULT '',
    create_time   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater       varchar(64)  NULL     DEFAULT '',
    update_time   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted       int2         NOT NULL DEFAULT 0,
    tenant_id     int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_oauth2_access_token
    ADD CONSTRAINT pk_system_oauth2_access_token PRIMARY KEY (id);

CREATE INDEX idx_system_oauth2_access_token_01 ON system_oauth2_access_token (access_token);
CREATE INDEX idx_system_oauth2_access_token_02 ON system_oauth2_access_token (refresh_token);

COMMENT ON COLUMN system_oauth2_access_token.id IS '编号';
COMMENT ON COLUMN system_oauth2_access_token.user_id IS '用户编号';
COMMENT ON COLUMN system_oauth2_access_token.user_type IS '用户类型';
COMMENT ON COLUMN system_oauth2_access_token.user_info IS '用户信息';
COMMENT ON COLUMN system_oauth2_access_token.access_token IS '访问令牌';
COMMENT ON COLUMN system_oauth2_access_token.refresh_token IS '刷新令牌';
COMMENT ON COLUMN system_oauth2_access_token.client_id IS '客户端编号';
COMMENT ON COLUMN system_oauth2_access_token.scopes IS '授权范围';
COMMENT ON COLUMN system_oauth2_access_token.expires_time IS '过期时间';
COMMENT ON COLUMN system_oauth2_access_token.creator IS '创建者';
COMMENT ON COLUMN system_oauth2_access_token.create_time IS '创建时间';
COMMENT ON COLUMN system_oauth2_access_token.updater IS '更新者';
COMMENT ON COLUMN system_oauth2_access_token.update_time IS '更新时间';
COMMENT ON COLUMN system_oauth2_access_token.deleted IS '是否删除';
COMMENT ON COLUMN system_oauth2_access_token.tenant_id IS '租户编号';
COMMENT ON TABLE system_oauth2_access_token IS 'OAuth2 访问令牌';

DROP SEQUENCE IF EXISTS system_oauth2_access_token_seq;
CREATE SEQUENCE system_oauth2_access_token_seq
    START 1;

-- ----------------------------
-- Table structure for system_oauth2_approve
-- ----------------------------
DROP TABLE IF EXISTS system_oauth2_approve;
CREATE TABLE system_oauth2_approve
(
    id           int8         NOT NULL,
    user_id      int8         NOT NULL,
    user_type    int2         NOT NULL,
    client_id    varchar(255) NOT NULL,
    scope        varchar(255) NULL     DEFAULT '',
    approved     bool         NOT NULL DEFAULT '0',
    expires_time timestamp    NOT NULL,
    creator      varchar(64)  NULL     DEFAULT '',
    create_time  timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater      varchar(64)  NULL     DEFAULT '',
    update_time  timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted      int2         NOT NULL DEFAULT 0,
    tenant_id    int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_oauth2_approve
    ADD CONSTRAINT pk_system_oauth2_approve PRIMARY KEY (id);

COMMENT ON COLUMN system_oauth2_approve.id IS '编号';
COMMENT ON COLUMN system_oauth2_approve.user_id IS '用户编号';
COMMENT ON COLUMN system_oauth2_approve.user_type IS '用户类型';
COMMENT ON COLUMN system_oauth2_approve.client_id IS '客户端编号';
COMMENT ON COLUMN system_oauth2_approve.scope IS '授权范围';
COMMENT ON COLUMN system_oauth2_approve.approved IS '是否接受';
COMMENT ON COLUMN system_oauth2_approve.expires_time IS '过期时间';
COMMENT ON COLUMN system_oauth2_approve.creator IS '创建者';
COMMENT ON COLUMN system_oauth2_approve.create_time IS '创建时间';
COMMENT ON COLUMN system_oauth2_approve.updater IS '更新者';
COMMENT ON COLUMN system_oauth2_approve.update_time IS '更新时间';
COMMENT ON COLUMN system_oauth2_approve.deleted IS '是否删除';
COMMENT ON COLUMN system_oauth2_approve.tenant_id IS '租户编号';
COMMENT ON TABLE system_oauth2_approve IS 'OAuth2 批准表';

DROP SEQUENCE IF EXISTS system_oauth2_approve_seq;
CREATE SEQUENCE system_oauth2_approve_seq
    START 1;

-- ----------------------------
-- Table structure for system_oauth2_client
-- ----------------------------
DROP TABLE IF EXISTS system_oauth2_client;
CREATE TABLE system_oauth2_client
(
    id                             int8          NOT NULL,
    client_id                      varchar(255)  NOT NULL,
    secret                         varchar(255)  NOT NULL,
    name                           varchar(255)  NOT NULL,
    logo                           varchar(255)  NOT NULL,
    description                    varchar(255)  NULL     DEFAULT NULL,
    status                         int2          NOT NULL,
    access_token_validity_seconds  int4          NOT NULL,
    refresh_token_validity_seconds int4          NOT NULL,
    redirect_uris                  varchar(255)  NOT NULL,
    authorized_grant_types         varchar(255)  NOT NULL,
    scopes                         varchar(255)  NULL     DEFAULT NULL,
    auto_approve_scopes            varchar(255)  NULL     DEFAULT NULL,
    authorities                    varchar(255)  NULL     DEFAULT NULL,
    resource_ids                   varchar(255)  NULL     DEFAULT NULL,
    additional_information         varchar(4096) NULL     DEFAULT NULL,
    creator                        varchar(64)   NULL     DEFAULT '',
    create_time                    timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater                        varchar(64)   NULL     DEFAULT '',
    update_time                    timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted                        int2          NOT NULL DEFAULT 0
);

ALTER TABLE system_oauth2_client
    ADD CONSTRAINT pk_system_oauth2_client PRIMARY KEY (id);

COMMENT ON COLUMN system_oauth2_client.id IS '编号';
COMMENT ON COLUMN system_oauth2_client.client_id IS '客户端编号';
COMMENT ON COLUMN system_oauth2_client.secret IS '客户端密钥';
COMMENT ON COLUMN system_oauth2_client.name IS '应用名';
COMMENT ON COLUMN system_oauth2_client.logo IS '应用图标';
COMMENT ON COLUMN system_oauth2_client.description IS '应用描述';
COMMENT ON COLUMN system_oauth2_client.status IS '状态';
COMMENT ON COLUMN system_oauth2_client.access_token_validity_seconds IS '访问令牌的有效期';
COMMENT ON COLUMN system_oauth2_client.refresh_token_validity_seconds IS '刷新令牌的有效期';
COMMENT ON COLUMN system_oauth2_client.redirect_uris IS '可重定向的 URI 地址';
COMMENT ON COLUMN system_oauth2_client.authorized_grant_types IS '授权类型';
COMMENT ON COLUMN system_oauth2_client.scopes IS '授权范围';
COMMENT ON COLUMN system_oauth2_client.auto_approve_scopes IS '自动通过的授权范围';
COMMENT ON COLUMN system_oauth2_client.authorities IS '权限';
COMMENT ON COLUMN system_oauth2_client.resource_ids IS '资源';
COMMENT ON COLUMN system_oauth2_client.additional_information IS '附加信息';
COMMENT ON COLUMN system_oauth2_client.creator IS '创建者';
COMMENT ON COLUMN system_oauth2_client.create_time IS '创建时间';
COMMENT ON COLUMN system_oauth2_client.updater IS '更新者';
COMMENT ON COLUMN system_oauth2_client.update_time IS '更新时间';
COMMENT ON COLUMN system_oauth2_client.deleted IS '是否删除';
COMMENT ON TABLE system_oauth2_client IS 'OAuth2 客户端表';

-- ----------------------------
-- Records of system_oauth2_client
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_oauth2_client (id, client_id, secret, name, logo, description, status, access_token_validity_seconds, refresh_token_validity_seconds, redirect_uris, authorized_grant_types, scopes, auto_approve_scopes, authorities, resource_ids, additional_information, creator, create_time, updater, update_time, deleted) VALUES (1, 'default', 'admin123', '密讯', 'http://xxx/20250502/sort2_1746189740718.png', '我是描述', 0, 1800, 2592000, '["https://xxx","https://xxx"]', '["password","authorization_code","implicit","refresh_token"]', '["user.read","user.write"]', '[]', '["user.read","user.write"]', '[]', '{}', '1', '2022-05-11 21:47:12', '1', '2025-05-02 20:42:22', '0');
INSERT INTO system_oauth2_client (id, client_id, secret, name, logo, description, status, access_token_validity_seconds, refresh_token_validity_seconds, redirect_uris, authorized_grant_types, scopes, auto_approve_scopes, authorities, resource_ids, additional_information, creator, create_time, updater, update_time, deleted) VALUES (40, 'test', 'test2', 'biubiu', 'http://xxx/xx/20250502/ed07110a37464b5299f8bd7c67ad65c7_1746187077009.jpg', '啦啦啦啦', 0, 1800, 43200, '["https://xxx"]', '["password","authorization_code","implicit"]', '["user_info","projects"]', '["user_info"]', '[]', '[]', '{}', '1', '2022-05-12 00:28:20', '1', '2025-05-02 19:58:08', '0');
INSERT INTO system_oauth2_client (id, client_id, secret, name, logo, description, status, access_token_validity_seconds, refresh_token_validity_seconds, redirect_uris, authorized_grant_types, scopes, auto_approve_scopes, authorities, resource_ids, additional_information, creator, create_time, updater, update_time, deleted) VALUES (41, 'mitedtsm-sso-demo-by-code', 'test', '基于授权码模式，如何实现 SSO 单点登录？', 'http://xxx/it/20250502/sign_1746181948685.png', NULL, 0, 1800, 43200, '["http://127.0.0.1:18080"]', '["authorization_code","refresh_token"]', '["user.read","user.write"]', '[]', '[]', '[]', NULL, '1', '2022-09-29 13:28:31', '1', '2025-05-02 18:32:30', '0');
INSERT INTO system_oauth2_client (id, client_id, secret, name, logo, description, status, access_token_validity_seconds, refresh_token_validity_seconds, redirect_uris, authorized_grant_types, scopes, auto_approve_scopes, authorities, resource_ids, additional_information, creator, create_time, updater, update_time, deleted) VALUES (42, 'mitedtsm-sso-demo-by-password', 'test', '基于密码模式，如何实现 SSO 单点登录？', 'http://xxx/604bdc695e13b3b22745be704d1f2aa8ee05c5f26f9fead6d1ca49005afbc857.jpeg', NULL, 0, 1800, 43200, '["http://127.0.0.1:18080"]', '["password","refresh_token"]', '["user.read","user.write"]', '[]', '[]', '[]', NULL, '1', '2022-10-04 17:40:16', '1', '2025-05-04 16:00:46', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_oauth2_client_seq;
CREATE SEQUENCE system_oauth2_client_seq
    START 43;

-- ----------------------------
-- Table structure for system_oauth2_code
-- ----------------------------
DROP TABLE IF EXISTS system_oauth2_code;
CREATE TABLE system_oauth2_code
(
    id           int8         NOT NULL,
    user_id      int8         NOT NULL,
    user_type    int2         NOT NULL,
    code         varchar(32)  NOT NULL,
    client_id    varchar(255) NOT NULL,
    scopes       varchar(255) NULL     DEFAULT '',
    expires_time timestamp    NOT NULL,
    redirect_uri varchar(255) NULL     DEFAULT NULL,
    state        varchar(255) NULL     DEFAULT '',
    creator      varchar(64)  NULL     DEFAULT '',
    create_time  timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater      varchar(64)  NULL     DEFAULT '',
    update_time  timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted      int2         NOT NULL DEFAULT 0,
    tenant_id    int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_oauth2_code
    ADD CONSTRAINT pk_system_oauth2_code PRIMARY KEY (id);

COMMENT ON COLUMN system_oauth2_code.id IS '编号';
COMMENT ON COLUMN system_oauth2_code.user_id IS '用户编号';
COMMENT ON COLUMN system_oauth2_code.user_type IS '用户类型';
COMMENT ON COLUMN system_oauth2_code.code IS '授权码';
COMMENT ON COLUMN system_oauth2_code.client_id IS '客户端编号';
COMMENT ON COLUMN system_oauth2_code.scopes IS '授权范围';
COMMENT ON COLUMN system_oauth2_code.expires_time IS '过期时间';
COMMENT ON COLUMN system_oauth2_code.redirect_uri IS '可重定向的 URI 地址';
COMMENT ON COLUMN system_oauth2_code.state IS '状态';
COMMENT ON COLUMN system_oauth2_code.creator IS '创建者';
COMMENT ON COLUMN system_oauth2_code.create_time IS '创建时间';
COMMENT ON COLUMN system_oauth2_code.updater IS '更新者';
COMMENT ON COLUMN system_oauth2_code.update_time IS '更新时间';
COMMENT ON COLUMN system_oauth2_code.deleted IS '是否删除';
COMMENT ON COLUMN system_oauth2_code.tenant_id IS '租户编号';
COMMENT ON TABLE system_oauth2_code IS 'OAuth2 授权码表';

DROP SEQUENCE IF EXISTS system_oauth2_code_seq;
CREATE SEQUENCE system_oauth2_code_seq
    START 1;

-- ----------------------------
-- Table structure for system_oauth2_refresh_token
-- ----------------------------
DROP TABLE IF EXISTS system_oauth2_refresh_token;
CREATE TABLE system_oauth2_refresh_token
(
    id            int8         NOT NULL,
    user_id       int8         NOT NULL,
    refresh_token varchar(32)  NOT NULL,
    user_type     int2         NOT NULL,
    client_id     varchar(255) NOT NULL,
    scopes        varchar(255) NULL     DEFAULT NULL,
    expires_time  timestamp    NOT NULL,
    creator       varchar(64)  NULL     DEFAULT '',
    create_time   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater       varchar(64)  NULL     DEFAULT '',
    update_time   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted       int2         NOT NULL DEFAULT 0,
    tenant_id     int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_oauth2_refresh_token
    ADD CONSTRAINT pk_system_oauth2_refresh_token PRIMARY KEY (id);

COMMENT ON COLUMN system_oauth2_refresh_token.id IS '编号';
COMMENT ON COLUMN system_oauth2_refresh_token.user_id IS '用户编号';
COMMENT ON COLUMN system_oauth2_refresh_token.refresh_token IS '刷新令牌';
COMMENT ON COLUMN system_oauth2_refresh_token.user_type IS '用户类型';
COMMENT ON COLUMN system_oauth2_refresh_token.client_id IS '客户端编号';
COMMENT ON COLUMN system_oauth2_refresh_token.scopes IS '授权范围';
COMMENT ON COLUMN system_oauth2_refresh_token.expires_time IS '过期时间';
COMMENT ON COLUMN system_oauth2_refresh_token.creator IS '创建者';
COMMENT ON COLUMN system_oauth2_refresh_token.create_time IS '创建时间';
COMMENT ON COLUMN system_oauth2_refresh_token.updater IS '更新者';
COMMENT ON COLUMN system_oauth2_refresh_token.update_time IS '更新时间';
COMMENT ON COLUMN system_oauth2_refresh_token.deleted IS '是否删除';
COMMENT ON COLUMN system_oauth2_refresh_token.tenant_id IS '租户编号';
COMMENT ON TABLE system_oauth2_refresh_token IS 'OAuth2 刷新令牌';

DROP SEQUENCE IF EXISTS system_oauth2_refresh_token_seq;
CREATE SEQUENCE system_oauth2_refresh_token_seq
    START 1;

-- ----------------------------
-- Table structure for system_operate_log
-- ----------------------------
DROP TABLE IF EXISTS system_operate_log;
CREATE TABLE system_operate_log
(
    id             int8          NOT NULL,
    trace_id       varchar(64)   NULL     DEFAULT '',
    user_id        int8          NOT NULL,
    user_type      int2          NOT NULL DEFAULT 0,
    type           varchar(50)   NOT NULL,
    sub_type       varchar(50)   NOT NULL,
    biz_id         int8          NOT NULL,
    action         varchar(2000) NULL     DEFAULT '',
    success        bool          NOT NULL DEFAULT '1',
    extra          varchar(2000) NULL     DEFAULT '',
    request_method varchar(16)   NULL     DEFAULT '',
    request_url    varchar(255)  NULL     DEFAULT '',
    user_ip        varchar(50)   NULL     DEFAULT NULL,
    user_agent     varchar(512)  NULL     DEFAULT NULL,
    creator        varchar(64)   NULL     DEFAULT '',
    create_time    timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater        varchar(64)   NULL     DEFAULT '',
    update_time    timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted        int2          NOT NULL DEFAULT 0,
    tenant_id      int8          NOT NULL DEFAULT 0
);

ALTER TABLE system_operate_log
    ADD CONSTRAINT pk_system_operate_log PRIMARY KEY (id);

COMMENT ON COLUMN system_operate_log.id IS '日志主键';
COMMENT ON COLUMN system_operate_log.trace_id IS '链路追踪编号';
COMMENT ON COLUMN system_operate_log.user_id IS '用户编号';
COMMENT ON COLUMN system_operate_log.user_type IS '用户类型';
COMMENT ON COLUMN system_operate_log.type IS '操作模块类型';
COMMENT ON COLUMN system_operate_log.sub_type IS '操作名';
COMMENT ON COLUMN system_operate_log.biz_id IS '操作数据模块编号';
COMMENT ON COLUMN system_operate_log.action IS '操作内容';
COMMENT ON COLUMN system_operate_log.success IS '操作结果';
COMMENT ON COLUMN system_operate_log.extra IS '拓展字段';
COMMENT ON COLUMN system_operate_log.request_method IS '请求方法名';
COMMENT ON COLUMN system_operate_log.request_url IS '请求地址';
COMMENT ON COLUMN system_operate_log.user_ip IS '用户 IP';
COMMENT ON COLUMN system_operate_log.user_agent IS '浏览器 UA';
COMMENT ON COLUMN system_operate_log.creator IS '创建者';
COMMENT ON COLUMN system_operate_log.create_time IS '创建时间';
COMMENT ON COLUMN system_operate_log.updater IS '更新者';
COMMENT ON COLUMN system_operate_log.update_time IS '更新时间';
COMMENT ON COLUMN system_operate_log.deleted IS '是否删除';
COMMENT ON COLUMN system_operate_log.tenant_id IS '租户编号';
COMMENT ON TABLE system_operate_log IS '操作日志记录 V2 版本';

DROP SEQUENCE IF EXISTS system_operate_log_seq;
CREATE SEQUENCE system_operate_log_seq
    START 1;

-- ----------------------------
-- Table structure for system_post
-- ----------------------------
DROP TABLE IF EXISTS system_post;
CREATE TABLE system_post
(
    id          int8         NOT NULL,
    code        varchar(64)  NOT NULL,
    name        varchar(50)  NOT NULL,
    sort        int4         NOT NULL,
    status      int2         NOT NULL,
    remark      varchar(500) NULL     DEFAULT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0,
    tenant_id   int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_post
    ADD CONSTRAINT pk_system_post PRIMARY KEY (id);

COMMENT ON COLUMN system_post.id IS '岗位ID';
COMMENT ON COLUMN system_post.code IS '岗位编码';
COMMENT ON COLUMN system_post.name IS '岗位名称';
COMMENT ON COLUMN system_post.sort IS '显示顺序';
COMMENT ON COLUMN system_post.status IS '状态（0正常 1停用）';
COMMENT ON COLUMN system_post.remark IS '备注';
COMMENT ON COLUMN system_post.creator IS '创建者';
COMMENT ON COLUMN system_post.create_time IS '创建时间';
COMMENT ON COLUMN system_post.updater IS '更新者';
COMMENT ON COLUMN system_post.update_time IS '更新时间';
COMMENT ON COLUMN system_post.deleted IS '是否删除';
COMMENT ON COLUMN system_post.tenant_id IS '租户编号';
COMMENT ON TABLE system_post IS '岗位信息表';

-- ----------------------------
-- Records of system_post
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_post (id, code, name, sort, status, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1, 'ceo', '董事长', 1, 0, '', 'admin', '2021-01-06 17:03:48', '1', '2023-02-11 15:19:04', '0', 1);
INSERT INTO system_post (id, code, name, sort, status, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2, 'se', '项目经理', 2, 0, '', 'admin', '2021-01-05 17:03:48', '1', '2023-11-15 09:18:20', '0', 1);
INSERT INTO system_post (id, code, name, sort, status, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4, 'user', '普通员工', 4, 0, '111222', 'admin', '2021-01-05 17:03:48', '1', '2025-03-24 21:32:40', '0', 1);
INSERT INTO system_post (id, code, name, sort, status, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5, 'HR', '人力资源', 5, 0, '`', '1', '2024-03-24 20:45:40', '1', '2025-03-29 19:08:10', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_post_seq;
CREATE SEQUENCE system_post_seq
    START 6;

-- ----------------------------
-- Table structure for system_role
-- ----------------------------
DROP TABLE IF EXISTS system_role;
CREATE TABLE system_role
(
    id                  int8         NOT NULL,
    name                varchar(30)  NOT NULL,
    code                varchar(100) NOT NULL,
    sort                int4         NOT NULL,
    data_scope          int2         NOT NULL DEFAULT 1,
    data_scope_dept_ids varchar(500) NULL     DEFAULT '',
    status              int2         NOT NULL,
    type                int2         NOT NULL,
    remark              varchar(500) NULL     DEFAULT NULL,
    creator             varchar(64)  NULL     DEFAULT '',
    create_time         timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater             varchar(64)  NULL     DEFAULT '',
    update_time         timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted             int2         NOT NULL DEFAULT 0,
    tenant_id           int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_role
    ADD CONSTRAINT pk_system_role PRIMARY KEY (id);

COMMENT ON COLUMN system_role.id IS '角色ID';
COMMENT ON COLUMN system_role.name IS '角色名称';
COMMENT ON COLUMN system_role.code IS '角色权限字符串';
COMMENT ON COLUMN system_role.sort IS '显示顺序';
COMMENT ON COLUMN system_role.data_scope IS '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）';
COMMENT ON COLUMN system_role.data_scope_dept_ids IS '数据范围 ( 指定部门数组)';
COMMENT ON COLUMN system_role.status IS '角色状态（0正常 1停用）';
COMMENT ON COLUMN system_role.type IS '角色类型';
COMMENT ON COLUMN system_role.remark IS '备注';
COMMENT ON COLUMN system_role.creator IS '创建者';
COMMENT ON COLUMN system_role.create_time IS '创建时间';
COMMENT ON COLUMN system_role.updater IS '更新者';
COMMENT ON COLUMN system_role.update_time IS '更新时间';
COMMENT ON COLUMN system_role.deleted IS '是否删除';
COMMENT ON COLUMN system_role.tenant_id IS '租户编号';
COMMENT ON TABLE system_role IS '角色信息表';

-- ----------------------------
-- Records of system_role
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1, '超级管理员', 'super_admin', 1, 1, '', 0, 1, '超级管理员', 'admin', '2021-01-05 17:03:48', '', '2022-02-22 05:08:21', '0', 1);
INSERT INTO system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2, '普通角色', 'common', 2, 2, '', 0, 1, '普通角色', 'admin', '2021-01-05 17:03:48', '', '2022-02-22 05:08:20', '0', 1);
INSERT INTO system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3, 'CRM 管理员', 'crm_admin', 2, 1, '', 0, 1, 'CRM 专属角色', '1', '2024-02-24 10:51:13', '1', '2024-02-24 02:51:32', '0', 1);
INSERT INTO system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (101, '测试账号', 'test', 0, 1, '[]', 0, 2, '123', '', '2021-01-06 13:49:35', '1', '2025-04-30 17:38:28', '0', 1);
INSERT INTO system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (109, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-02-22 00:56:14', '1', '2022-02-22 00:56:14', '0', 121);
INSERT INTO system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (111, '租户管理员', 'tenant_admin', 0, 1, '', 0, 1, '系统自动生成', '1', '2022-03-07 21:37:58', '1', '2022-03-07 21:37:58', '0', 122);
INSERT INTO system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (155, '测试数据权限', 'test-dp', 3, 2, '[100,102,103,104,105,108]', 0, 2, '', '1', '2025-03-31 14:58:06', '1', '2025-04-17 23:07:44', '0', 1);
INSERT INTO system_role (id, name, code, sort, data_scope, data_scope_dept_ids, status, type, remark, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (158, '2', '3', 4, 1, '', 0, 2, NULL, '1', '2025-04-17 20:08:08', '1', '2025-04-17 23:05:31', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_role_seq;
CREATE SEQUENCE system_role_seq
    START 159;

-- ----------------------------
-- Table structure for system_role_menu
-- ----------------------------
DROP TABLE IF EXISTS system_role_menu;
CREATE TABLE system_role_menu
(
    id          int8        NOT NULL,
    role_id     int8        NOT NULL,
    menu_id     int8        NOT NULL,
    creator     varchar(64) NULL     DEFAULT '',
    create_time timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64) NULL     DEFAULT '',
    update_time timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2        NOT NULL DEFAULT 0,
    tenant_id   int8        NOT NULL DEFAULT 0
);

ALTER TABLE system_role_menu
    ADD CONSTRAINT pk_system_role_menu PRIMARY KEY (id);

COMMENT ON COLUMN system_role_menu.id IS '自增编号';
COMMENT ON COLUMN system_role_menu.role_id IS '角色ID';
COMMENT ON COLUMN system_role_menu.menu_id IS '菜单ID';
COMMENT ON COLUMN system_role_menu.creator IS '创建者';
COMMENT ON COLUMN system_role_menu.create_time IS '创建时间';
COMMENT ON COLUMN system_role_menu.updater IS '更新者';
COMMENT ON COLUMN system_role_menu.update_time IS '更新时间';
COMMENT ON COLUMN system_role_menu.deleted IS '是否删除';
COMMENT ON COLUMN system_role_menu.tenant_id IS '租户编号';
COMMENT ON TABLE system_role_menu IS '角色和菜单关联表';

-- ----------------------------
-- Records of system_role_menu
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (263, 109, 1, '1', '2022-02-22 00:56:14', '1', '2022-02-22 00:56:14', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (434, 2, 1, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (454, 2, 1093, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (455, 2, 1094, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (460, 2, 1100, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (467, 2, 1107, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (476, 2, 1117, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (477, 2, 100, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (478, 2, 101, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (479, 2, 102, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (480, 2, 1126, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (481, 2, 103, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (483, 2, 104, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (485, 2, 105, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (488, 2, 107, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (490, 2, 108, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (492, 2, 109, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (498, 2, 1138, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (523, 2, 1224, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (524, 2, 1225, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (541, 2, 500, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (543, 2, 501, '1', '2022-02-22 13:09:12', '1', '2022-02-22 13:09:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (675, 2, 2, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (689, 2, 1077, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (690, 2, 1078, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (692, 2, 1083, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (693, 2, 1084, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (699, 2, 1090, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (703, 2, 106, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (704, 2, 110, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (705, 2, 111, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (706, 2, 112, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (707, 2, 113, '1', '2022-02-22 13:16:57', '1', '2022-02-22 13:16:57', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1296, 110, 1, '110', '2022-02-23 00:23:55', '110', '2022-02-23 00:23:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1578, 111, 1, '1', '2022-03-07 21:37:58', '1', '2022-03-07 21:37:58', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1604, 101, 1216, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1605, 101, 1217, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1606, 101, 1218, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1607, 101, 1219, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1608, 101, 1220, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1609, 101, 1221, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1610, 101, 5, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1611, 101, 1222, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1612, 101, 1118, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1613, 101, 1119, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1614, 101, 1120, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1615, 101, 1185, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1616, 101, 1186, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1617, 101, 1187, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1618, 101, 1188, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1619, 101, 1189, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1620, 101, 1190, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1621, 101, 1191, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1622, 101, 1192, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1623, 101, 1193, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1624, 101, 1194, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1625, 101, 1195, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1627, 101, 1197, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1628, 101, 1198, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1629, 101, 1199, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1630, 101, 1200, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1631, 101, 1201, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1632, 101, 1202, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1633, 101, 1207, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1634, 101, 1208, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1635, 101, 1209, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1636, 101, 1210, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1637, 101, 1211, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1638, 101, 1212, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1639, 101, 1213, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1640, 101, 1215, '1', '2022-03-19 21:45:52', '1', '2022-03-19 21:45:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1641, 101, 2, '1', '2022-04-01 22:21:24', '1', '2022-04-01 22:21:24', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1642, 101, 1031, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1643, 101, 1032, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1644, 101, 1033, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1645, 101, 1034, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1646, 101, 1035, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1647, 101, 1050, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1648, 101, 1051, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1649, 101, 1052, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1650, 101, 1053, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1651, 101, 1054, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1652, 101, 1056, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1653, 101, 1057, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1654, 101, 1058, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1655, 101, 1059, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1656, 101, 1060, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1657, 101, 1066, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1658, 101, 1067, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1659, 101, 1070, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1664, 101, 1075, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1666, 101, 1077, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1667, 101, 1078, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1668, 101, 1082, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1669, 101, 1083, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1670, 101, 1084, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1671, 101, 1085, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1672, 101, 1086, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1673, 101, 1087, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1674, 101, 1088, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1675, 101, 1089, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1679, 101, 1237, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1680, 101, 1238, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1681, 101, 1239, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1682, 101, 1240, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1683, 101, 1241, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1684, 101, 1242, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1685, 101, 1243, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1687, 101, 106, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1688, 101, 110, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1689, 101, 111, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1690, 101, 112, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1691, 101, 113, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1692, 101, 114, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1693, 101, 115, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1694, 101, 116, '1', '2022-04-01 22:21:37', '1', '2022-04-01 22:21:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1729, 109, 100, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1730, 109, 101, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1731, 109, 1063, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1732, 109, 1064, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1733, 109, 1001, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1734, 109, 1065, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1735, 109, 1002, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1736, 109, 1003, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1737, 109, 1004, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1738, 109, 1005, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1739, 109, 1006, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1740, 109, 1007, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1741, 109, 1008, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1742, 109, 1009, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1743, 109, 1010, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1744, 109, 1011, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1745, 109, 1012, '1', '2022-09-21 22:08:51', '1', '2022-09-21 22:08:51', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1746, 111, 100, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1747, 111, 101, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1748, 111, 1063, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1749, 111, 1064, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1750, 111, 1001, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1751, 111, 1065, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1752, 111, 1002, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1753, 111, 1003, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1754, 111, 1004, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1755, 111, 1005, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1756, 111, 1006, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1757, 111, 1007, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1758, 111, 1008, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1759, 111, 1009, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1760, 111, 1010, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1761, 111, 1011, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1762, 111, 1012, '1', '2022-09-21 22:08:52', '1', '2022-09-21 22:08:52', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1763, 109, 100, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1764, 109, 101, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1765, 109, 1063, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1766, 109, 1064, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1767, 109, 1001, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1768, 109, 1065, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1769, 109, 1002, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1770, 109, 1003, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1771, 109, 1004, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1772, 109, 1005, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1773, 109, 1006, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1774, 109, 1007, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1775, 109, 1008, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1776, 109, 1009, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1777, 109, 1010, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1778, 109, 1011, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1779, 109, 1012, '1', '2022-09-21 22:08:53', '1', '2022-09-21 22:08:53', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1780, 111, 100, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1781, 111, 101, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1782, 111, 1063, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1783, 111, 1064, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1784, 111, 1001, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1785, 111, 1065, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1786, 111, 1002, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1787, 111, 1003, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1788, 111, 1004, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1789, 111, 1005, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1790, 111, 1006, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1791, 111, 1007, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1792, 111, 1008, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1793, 111, 1009, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1794, 111, 1010, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1795, 111, 1011, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1796, 111, 1012, '1', '2022-09-21 22:08:54', '1', '2022-09-21 22:08:54', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1797, 109, 100, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1798, 109, 101, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1799, 109, 1063, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1800, 109, 1064, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1801, 109, 1001, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1802, 109, 1065, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1803, 109, 1002, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1804, 109, 1003, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1805, 109, 1004, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1806, 109, 1005, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1807, 109, 1006, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1808, 109, 1007, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1809, 109, 1008, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1810, 109, 1009, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1811, 109, 1010, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1812, 109, 1011, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1813, 109, 1012, '1', '2022-09-21 22:08:55', '1', '2022-09-21 22:08:55', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1814, 111, 100, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1815, 111, 101, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1816, 111, 1063, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1817, 111, 1064, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1818, 111, 1001, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1819, 111, 1065, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1820, 111, 1002, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1821, 111, 1003, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1822, 111, 1004, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1823, 111, 1005, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1824, 111, 1006, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1825, 111, 1007, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1826, 111, 1008, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1827, 111, 1009, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1828, 111, 1010, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1829, 111, 1011, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1830, 111, 1012, '1', '2022-09-21 22:08:56', '1', '2022-09-21 22:08:56', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1831, 109, 103, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1832, 109, 1017, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1833, 109, 1018, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1834, 109, 1019, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1835, 109, 1020, '1', '2022-09-21 22:43:23', '1', '2022-09-21 22:43:23', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1836, 111, 103, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1837, 111, 1017, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1838, 111, 1018, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1839, 111, 1019, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1840, 111, 1020, '1', '2022-09-21 22:43:24', '1', '2022-09-21 22:43:24', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1841, 109, 1036, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1842, 109, 1037, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1843, 109, 1038, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1844, 109, 1039, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1845, 109, 107, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1846, 111, 1036, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1847, 111, 1037, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1848, 111, 1038, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1849, 111, 1039, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1850, 111, 107, '1', '2022-09-21 22:48:13', '1', '2022-09-21 22:48:13', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1991, 2, 1024, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1992, 2, 1025, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1993, 2, 1026, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1994, 2, 1027, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1995, 2, 1028, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1996, 2, 1029, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1997, 2, 1030, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1998, 2, 1031, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1999, 2, 1032, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2000, 2, 1033, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2001, 2, 1034, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2002, 2, 1035, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2003, 2, 1036, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2004, 2, 1037, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2005, 2, 1038, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2006, 2, 1039, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2007, 2, 1040, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2008, 2, 1042, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2009, 2, 1043, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2010, 2, 1045, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2011, 2, 1046, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2012, 2, 1048, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2013, 2, 1050, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2014, 2, 1051, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2015, 2, 1052, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2016, 2, 1053, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2017, 2, 1054, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2018, 2, 1056, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2019, 2, 1057, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2020, 2, 1058, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2021, 2, 2083, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2022, 2, 1059, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2023, 2, 1060, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2024, 2, 1063, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2025, 2, 1064, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2026, 2, 1065, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2027, 2, 1066, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2028, 2, 1067, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2029, 2, 1070, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2034, 2, 1075, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2036, 2, 1082, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2037, 2, 1085, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2038, 2, 1086, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2039, 2, 1087, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2040, 2, 1088, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2041, 2, 1089, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2042, 2, 1091, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2043, 2, 1092, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2044, 2, 1095, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2045, 2, 1096, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2046, 2, 1097, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2047, 2, 1098, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2048, 2, 1101, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2049, 2, 1102, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2050, 2, 1103, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2051, 2, 1104, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2052, 2, 1105, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2053, 2, 1106, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2054, 2, 1108, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2055, 2, 1109, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2061, 2, 1127, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2062, 2, 1128, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2063, 2, 1129, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2064, 2, 1130, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2066, 2, 1132, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2067, 2, 1133, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2068, 2, 1134, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2069, 2, 1135, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2070, 2, 1136, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2071, 2, 1137, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2072, 2, 114, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2073, 2, 1139, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2074, 2, 115, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2075, 2, 1140, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2076, 2, 116, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2077, 2, 1141, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2078, 2, 1142, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2079, 2, 1143, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2080, 2, 1150, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2081, 2, 1161, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2082, 2, 1162, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2086, 2, 1166, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2087, 2, 1173, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2088, 2, 1174, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2092, 2, 1178, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2099, 2, 1226, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2100, 2, 1227, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2101, 2, 1228, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2102, 2, 1229, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2103, 2, 1237, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2104, 2, 1238, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2105, 2, 1239, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2106, 2, 1240, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2107, 2, 1241, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2108, 2, 1242, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2109, 2, 1243, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2116, 2, 1254, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2117, 2, 1255, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2118, 2, 1256, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2119, 2, 1257, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2120, 2, 1258, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2121, 2, 1259, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2122, 2, 1260, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2123, 2, 1261, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2124, 2, 1263, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2125, 2, 1264, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2126, 2, 1265, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2127, 2, 1266, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2128, 2, 1267, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2129, 2, 1001, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2130, 2, 1002, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2131, 2, 1003, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2132, 2, 1004, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2133, 2, 1005, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2134, 2, 1006, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2135, 2, 1007, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2136, 2, 1008, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2137, 2, 1009, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2138, 2, 1010, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2139, 2, 1011, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2140, 2, 1012, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2141, 2, 1013, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2143, 2, 1015, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2145, 2, 1017, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2146, 2, 1018, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2147, 2, 1019, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2148, 2, 1020, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2149, 2, 1021, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2150, 2, 1022, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2151, 2, 1023, '1', '2023-01-25 08:42:52', '1', '2023-01-25 08:42:52', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2152, 2, 1281, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2153, 2, 1282, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2154, 2, 2000, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2155, 2, 2002, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2156, 2, 2003, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2157, 2, 2004, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2158, 2, 2005, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2159, 2, 2006, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2160, 2, 2008, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2161, 2, 2009, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2162, 2, 2010, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2163, 2, 2011, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2164, 2, 2012, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2170, 2, 2019, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2171, 2, 2020, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2172, 2, 2021, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2173, 2, 2022, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2174, 2, 2023, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2175, 2, 2025, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2177, 2, 2027, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2178, 2, 2028, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2179, 2, 2029, '1', '2023-01-25 08:42:58', '1', '2023-01-25 08:42:58', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2180, 2, 2014, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2181, 2, 2015, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2182, 2, 2016, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2183, 2, 2017, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2184, 2, 2018, '1', '2023-01-25 08:43:12', '1', '2023-01-25 08:43:12', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2188, 101, 1024, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2189, 101, 1, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2190, 101, 1025, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2191, 101, 1026, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2192, 101, 1027, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2193, 101, 1028, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2194, 101, 1029, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2195, 101, 1030, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2196, 101, 1036, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2197, 101, 1037, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2198, 101, 1038, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2199, 101, 1039, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2200, 101, 1040, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2201, 101, 1042, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2202, 101, 1043, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2203, 101, 1045, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2204, 101, 1046, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2205, 101, 1048, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2206, 101, 2083, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2207, 101, 1063, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2208, 101, 1064, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2209, 101, 1065, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2210, 101, 1093, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2211, 101, 1094, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2212, 101, 1095, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2213, 101, 1096, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2214, 101, 1097, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2215, 101, 1098, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2216, 101, 1100, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2217, 101, 1101, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2218, 101, 1102, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2219, 101, 1103, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2220, 101, 1104, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2221, 101, 1105, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2222, 101, 1106, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2223, 101, 2130, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2224, 101, 1107, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2225, 101, 2131, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2226, 101, 1108, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2227, 101, 2132, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2228, 101, 1109, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2229, 101, 2133, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2230, 101, 2134, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2232, 101, 2135, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2234, 101, 2136, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2236, 101, 2137, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2238, 101, 2138, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2240, 101, 2139, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2242, 101, 2140, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2243, 101, 2141, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2244, 101, 2142, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2245, 101, 2143, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2246, 101, 2144, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2247, 101, 2145, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2248, 101, 2146, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2249, 101, 2147, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2250, 101, 100, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2251, 101, 2148, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2252, 101, 101, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2253, 101, 2149, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2254, 101, 102, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2255, 101, 2150, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2256, 101, 103, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2257, 101, 2151, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2258, 101, 104, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2259, 101, 2152, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2260, 101, 105, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2261, 101, 107, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2262, 101, 108, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2263, 101, 109, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2264, 101, 1138, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2265, 101, 1139, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2266, 101, 1140, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2267, 101, 1141, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2268, 101, 1142, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2269, 101, 1143, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2270, 101, 1224, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2271, 101, 1225, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2272, 101, 1226, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2273, 101, 1227, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2274, 101, 1228, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2275, 101, 1229, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2282, 101, 1261, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2283, 101, 1263, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2284, 101, 1264, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2285, 101, 1265, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2286, 101, 1266, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2287, 101, 1267, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2288, 101, 1001, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2289, 101, 1002, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2290, 101, 1003, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2291, 101, 1004, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2292, 101, 1005, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2293, 101, 1006, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2294, 101, 1007, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2295, 101, 1008, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2296, 101, 1009, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2297, 101, 1010, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2298, 101, 1011, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2299, 101, 1012, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2300, 101, 500, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2301, 101, 1013, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2302, 101, 501, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2303, 101, 1014, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2304, 101, 1015, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2305, 101, 1016, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2306, 101, 1017, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2307, 101, 1018, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2308, 101, 1019, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2309, 101, 1020, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2310, 101, 1021, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2311, 101, 1022, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2312, 101, 1023, '1', '2023-02-09 23:49:46', '1', '2023-02-09 23:49:46', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2929, 109, 1224, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2930, 109, 1225, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2931, 109, 1226, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2932, 109, 1227, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2933, 109, 1228, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2934, 109, 1229, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2935, 109, 1138, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2936, 109, 1139, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2937, 109, 1140, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2938, 109, 1141, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2939, 109, 1142, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2940, 109, 1143, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2941, 111, 1224, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2942, 111, 1225, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2943, 111, 1226, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2944, 111, 1227, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2945, 111, 1228, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2946, 111, 1229, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2947, 111, 1138, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2948, 111, 1139, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2949, 111, 1140, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2950, 111, 1141, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2951, 111, 1142, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2952, 111, 1143, '1', '2023-12-02 23:19:40', '1', '2023-12-02 23:19:40', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2993, 109, 2, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2994, 109, 1031, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2995, 109, 1032, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2996, 109, 1033, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2997, 109, 1034, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2998, 109, 1035, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2999, 109, 1050, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3000, 109, 1051, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3001, 109, 1052, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3002, 109, 1053, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3003, 109, 1054, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3004, 109, 1056, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3005, 109, 1057, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3006, 109, 1058, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3007, 109, 1059, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3008, 109, 1060, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3009, 109, 1066, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3010, 109, 1067, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3011, 109, 1070, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3012, 109, 1075, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3014, 109, 1077, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3015, 109, 1078, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3016, 109, 1082, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3017, 109, 1083, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3018, 109, 1084, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3019, 109, 1085, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3020, 109, 1086, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3021, 109, 1087, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3022, 109, 1088, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3023, 109, 1089, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3024, 109, 1090, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3025, 109, 1091, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3026, 109, 1092, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3027, 109, 106, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3028, 109, 110, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3029, 109, 111, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3030, 109, 112, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3031, 109, 113, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3032, 109, 114, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3033, 109, 115, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3034, 109, 116, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3035, 109, 2472, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3036, 109, 2478, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3037, 109, 2479, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3038, 109, 2480, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3039, 109, 2481, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3040, 109, 2482, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3041, 109, 2483, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3042, 109, 2484, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3043, 109, 2485, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3044, 109, 2486, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3045, 109, 2487, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3046, 109, 2488, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3047, 109, 2489, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3048, 109, 2490, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3049, 109, 2491, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3050, 109, 2492, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3051, 109, 2493, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3052, 109, 2494, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3053, 109, 2495, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3054, 109, 2497, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3055, 109, 1237, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3056, 109, 1238, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3057, 109, 1239, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3058, 109, 1240, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3059, 109, 1241, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3060, 109, 1242, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3061, 109, 1243, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3062, 109, 2525, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3063, 109, 1255, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3064, 109, 1256, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3065, 109, 1257, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3066, 109, 1258, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3067, 109, 1259, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3068, 109, 1260, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3069, 111, 2, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3070, 111, 1031, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3071, 111, 1032, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3072, 111, 1033, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3073, 111, 1034, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3074, 111, 1035, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3075, 111, 1050, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3076, 111, 1051, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3077, 111, 1052, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3078, 111, 1053, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3079, 111, 1054, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3080, 111, 1056, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3081, 111, 1057, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3082, 111, 1058, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3083, 111, 1059, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3084, 111, 1060, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3085, 111, 1066, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3086, 111, 1067, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3087, 111, 1070, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3088, 111, 1075, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3090, 111, 1077, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3091, 111, 1078, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3092, 111, 1082, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3093, 111, 1083, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3094, 111, 1084, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3095, 111, 1085, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3096, 111, 1086, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3097, 111, 1087, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3098, 111, 1088, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3099, 111, 1089, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3100, 111, 1090, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3101, 111, 1091, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3102, 111, 1092, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3103, 111, 106, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3104, 111, 110, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3105, 111, 111, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3106, 111, 112, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3107, 111, 113, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3108, 111, 114, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3109, 111, 115, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3110, 111, 116, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3111, 111, 2472, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3112, 111, 2478, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3113, 111, 2479, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3114, 111, 2480, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3115, 111, 2481, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3116, 111, 2482, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3117, 111, 2483, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3118, 111, 2484, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3119, 111, 2485, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3120, 111, 2486, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3121, 111, 2487, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3122, 111, 2488, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3123, 111, 2489, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3124, 111, 2490, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3125, 111, 2491, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3126, 111, 2492, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3127, 111, 2493, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3128, 111, 2494, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3129, 111, 2495, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3130, 111, 2497, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3131, 111, 1237, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3132, 111, 1238, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3133, 111, 1239, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3134, 111, 1240, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3135, 111, 1241, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3136, 111, 1242, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3137, 111, 1243, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3138, 111, 2525, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3139, 111, 1255, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3140, 111, 1256, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3141, 111, 1257, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3142, 111, 1258, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3143, 111, 1259, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3144, 111, 1260, '1', '2023-12-02 23:41:02', '1', '2023-12-02 23:41:02', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3221, 109, 102, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3222, 109, 1013, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3223, 109, 1014, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3224, 109, 1015, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3225, 109, 1016, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3226, 111, 102, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3227, 111, 1013, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3228, 111, 1014, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3229, 111, 1015, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3230, 111, 1016, '1', '2023-12-30 11:42:36', '1', '2023-12-30 11:42:36', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4163, 109, 5, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4164, 109, 1118, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4165, 109, 1119, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4166, 109, 1120, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4167, 109, 2713, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4168, 109, 2714, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4169, 109, 2715, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4170, 109, 2716, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4171, 109, 2717, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4172, 109, 2718, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4173, 109, 2720, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4174, 109, 1185, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4175, 109, 2721, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4176, 109, 1186, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4177, 109, 2722, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4178, 109, 1187, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4179, 109, 2723, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4180, 109, 1188, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4181, 109, 2724, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4182, 109, 1189, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4183, 109, 2725, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4184, 109, 1190, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4185, 109, 2726, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4186, 109, 1191, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4187, 109, 2727, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4188, 109, 1192, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4189, 109, 2728, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4190, 109, 1193, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4191, 109, 2729, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4192, 109, 1194, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4193, 109, 2730, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4194, 109, 1195, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4195, 109, 2731, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4196, 109, 1196, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4197, 109, 2732, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4198, 109, 1197, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4199, 109, 2733, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4200, 109, 1198, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4201, 109, 2734, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4202, 109, 1199, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4203, 109, 2735, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4204, 109, 1200, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4205, 109, 1201, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4206, 109, 1202, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4207, 109, 1207, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4208, 109, 1208, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4209, 109, 1209, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4210, 109, 1210, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4211, 109, 1211, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4212, 109, 1212, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4213, 109, 1213, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4214, 109, 1215, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4215, 109, 1216, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4216, 109, 1217, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4217, 109, 1218, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4218, 109, 1219, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4219, 109, 1220, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4220, 109, 1221, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4221, 109, 1222, '1', '2024-03-30 17:53:17', '1', '2024-03-30 17:53:17', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4222, 111, 5, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4223, 111, 1118, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4224, 111, 1119, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4225, 111, 1120, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4226, 111, 2713, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4227, 111, 2714, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4228, 111, 2715, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4229, 111, 2716, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4230, 111, 2717, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4231, 111, 2718, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4232, 111, 2720, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4233, 111, 1185, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4234, 111, 2721, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4235, 111, 1186, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4236, 111, 2722, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4237, 111, 1187, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4238, 111, 2723, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4239, 111, 1188, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4240, 111, 2724, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4241, 111, 1189, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4242, 111, 2725, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4243, 111, 1190, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4244, 111, 2726, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4245, 111, 1191, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4246, 111, 2727, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4247, 111, 1192, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4248, 111, 2728, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4249, 111, 1193, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4250, 111, 2729, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4251, 111, 1194, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4252, 111, 2730, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4253, 111, 1195, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4254, 111, 2731, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4255, 111, 1196, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4256, 111, 2732, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4257, 111, 1197, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4258, 111, 2733, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4259, 111, 1198, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4260, 111, 2734, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4261, 111, 1199, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4262, 111, 2735, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4263, 111, 1200, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4264, 111, 1201, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4265, 111, 1202, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4266, 111, 1207, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4267, 111, 1208, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4268, 111, 1209, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4269, 111, 1210, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4270, 111, 1211, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4271, 111, 1212, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4272, 111, 1213, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4273, 111, 1215, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4274, 111, 1216, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4275, 111, 1217, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4276, 111, 1218, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4277, 111, 1219, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4278, 111, 1220, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4279, 111, 1221, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4280, 111, 1222, '1', '2024-03-30 17:53:18', '1', '2024-03-30 17:53:18', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5777, 101, 2739, '1', '2024-04-30 09:38:37', '1', '2024-04-30 09:38:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5778, 101, 2740, '1', '2024-04-30 09:38:37', '1', '2024-04-30 09:38:37', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5779, 2, 2739, '1', '2024-07-07 20:39:38', '1', '2024-07-07 20:39:38', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5780, 2, 2740, '1', '2024-07-07 20:39:38', '1', '2024-07-07 20:39:38', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5781, 2, 2758, '1', '2024-07-07 20:39:38', '1', '2024-07-07 20:39:38', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5782, 2, 2759, '1', '2024-07-07 20:39:38', '1', '2024-07-07 20:39:38', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5783, 2, 2362, '1', '2024-07-07 20:39:38', '1', '2024-07-07 20:39:38', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5784, 2, 2387, '1', '2024-07-07 20:39:38', '1', '2024-07-07 20:39:38', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5785, 2, 2030, '1', '2024-07-07 20:39:38', '1', '2024-07-07 20:39:38', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5786, 101, 2758, '1', '2024-07-07 20:39:55', '1', '2024-07-07 20:39:55', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5787, 101, 2759, '1', '2024-07-07 20:39:55', '1', '2024-07-07 20:39:55', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5788, 101, 2783, '1', '2024-07-07 20:39:55', '1', '2024-07-07 20:39:55', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5789, 109, 2739, '1', '2024-07-13 22:37:24', '1', '2024-07-13 22:37:24', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5790, 109, 2740, '1', '2024-07-13 22:37:24', '1', '2024-07-13 22:37:24', '0', 121);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5791, 111, 2739, '1', '2024-07-13 22:37:24', '1', '2024-07-13 22:37:24', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5792, 111, 2740, '1', '2024-07-13 22:37:24', '1', '2024-07-13 22:37:24', '0', 122);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6053, 155, 4000, '1', '2025-04-01 13:48:26', '1', '2025-04-01 13:48:26', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6097, 155, 4050, '1', '2025-04-01 13:48:26', '1', '2025-04-01 13:48:26', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6104, 155, 4032, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6105, 155, 4033, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6106, 155, 4034, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6107, 155, 4035, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6108, 155, 4036, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6109, 155, 4037, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6110, 155, 4038, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6111, 155, 4039, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6112, 155, 4040, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6113, 155, 4041, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6114, 155, 4042, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6115, 155, 4043, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6116, 155, 4044, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6117, 155, 4045, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6118, 155, 4046, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6119, 155, 4001, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6120, 155, 4002, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6121, 155, 4003, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6122, 155, 4004, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6123, 155, 4005, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6124, 155, 4006, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6125, 155, 4007, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6126, 155, 4008, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6127, 155, 4009, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6128, 155, 4010, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6129, 155, 4011, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6130, 155, 4012, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6131, 155, 4013, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6132, 155, 4014, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6133, 155, 4015, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6134, 155, 4016, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6135, 155, 4017, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6136, 155, 4018, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6137, 155, 4031, '1', '2025-04-01 13:49:30', '1', '2025-04-01 13:49:30', '0', 1);
INSERT INTO system_role_menu (id, role_id, menu_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6138, 101, 5010, '1', '2025-05-05 17:49:17', '1', '2025-05-05 17:49:17', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_role_menu_seq;
CREATE SEQUENCE system_role_menu_seq
    START 6139;

-- ----------------------------
-- Table structure for system_sms_channel
-- ----------------------------
DROP TABLE IF EXISTS system_sms_channel;
CREATE TABLE system_sms_channel
(
    id           int8         NOT NULL,
    signature    varchar(12)  NOT NULL,
    code         varchar(63)  NOT NULL,
    status       int2         NOT NULL,
    remark       varchar(255) NULL     DEFAULT NULL,
    api_key      varchar(128) NOT NULL,
    api_secret   varchar(128) NULL     DEFAULT NULL,
    callback_url varchar(255) NULL     DEFAULT NULL,
    creator      varchar(64)  NULL     DEFAULT '',
    create_time  timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater      varchar(64)  NULL     DEFAULT '',
    update_time  timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted      int2         NOT NULL DEFAULT 0
);

ALTER TABLE system_sms_channel
    ADD CONSTRAINT pk_system_sms_channel PRIMARY KEY (id);

COMMENT ON COLUMN system_sms_channel.id IS '编号';
COMMENT ON COLUMN system_sms_channel.signature IS '短信签名';
COMMENT ON COLUMN system_sms_channel.code IS '渠道编码';
COMMENT ON COLUMN system_sms_channel.status IS '开启状态';
COMMENT ON COLUMN system_sms_channel.remark IS '备注';
COMMENT ON COLUMN system_sms_channel.api_key IS '短信 API 的账号';
COMMENT ON COLUMN system_sms_channel.api_secret IS '短信 API 的秘钥';
COMMENT ON COLUMN system_sms_channel.callback_url IS '短信发送回调 URL';
COMMENT ON COLUMN system_sms_channel.creator IS '创建者';
COMMENT ON COLUMN system_sms_channel.create_time IS '创建时间';
COMMENT ON COLUMN system_sms_channel.updater IS '更新者';
COMMENT ON COLUMN system_sms_channel.update_time IS '更新时间';
COMMENT ON COLUMN system_sms_channel.deleted IS '是否删除';
COMMENT ON TABLE system_sms_channel IS '短信渠道';

-- ----------------------------
-- Records of system_sms_channel
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_sms_channel (id, signature, code, status, remark, api_key, api_secret, callback_url, creator, create_time, updater, update_time, deleted) VALUES (2, 'Ballcat', 'ALIYUN', 0, '你要改哦，只有我可以用！！！！', 'LTAI5tCnKso2uG3kJ5gRav88', 'fGJ5SNXL7P1NHNRmJ7DJaMJGPyE55C', NULL, '', '2021-03-31 11:53:10', '1', '2024-08-04 08:53:26', '0');
INSERT INTO system_sms_channel (id, signature, code, status, remark, api_key, api_secret, callback_url, creator, create_time, updater, update_time, deleted) VALUES (4, '测试渠道', 'DEBUG_DING_TALK', 0, '123', '696b5d8ead48071237e4aa5861ff08dbadb2b4ded1c688a7b7c9afc615579859', 'SEC5c4e5ff888bc8a9923ae47f59e7ccd30af1f14d93c55b4e2c9cb094e35aeed67', NULL, '1', '2021-04-13 00:23:14', '1', '2022-03-27 20:29:49', '0');
INSERT INTO system_sms_channel (id, signature, code, status, remark, api_key, api_secret, callback_url, creator, create_time, updater, update_time, deleted) VALUES (7, 'mock腾讯云', 'TENCENT', 0, '', '1 2', '2 3', '', '1', '2024-09-30 08:53:45', '1', '2024-09-30 08:55:01', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_sms_channel_seq;
CREATE SEQUENCE system_sms_channel_seq
    START 8;

-- ----------------------------
-- Table structure for system_sms_code
-- ----------------------------
DROP TABLE IF EXISTS system_sms_code;
CREATE TABLE system_sms_code
(
    id          int8         NOT NULL,
    mobile      varchar(11)  NOT NULL,
    code        varchar(6)   NOT NULL,
    create_ip   varchar(15)  NOT NULL,
    scene       int2         NOT NULL,
    today_index int2         NOT NULL,
    used        int2         NOT NULL,
    used_time   timestamp    NULL     DEFAULT NULL,
    used_ip     varchar(255) NULL     DEFAULT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0,
    tenant_id   int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_sms_code
    ADD CONSTRAINT pk_system_sms_code PRIMARY KEY (id);

CREATE INDEX idx_system_sms_code_01 ON system_sms_code (mobile);

COMMENT ON COLUMN system_sms_code.id IS '编号';
COMMENT ON COLUMN system_sms_code.mobile IS '手机号';
COMMENT ON COLUMN system_sms_code.code IS '验证码';
COMMENT ON COLUMN system_sms_code.create_ip IS '创建 IP';
COMMENT ON COLUMN system_sms_code.scene IS '发送场景';
COMMENT ON COLUMN system_sms_code.today_index IS '今日发送的第几条';
COMMENT ON COLUMN system_sms_code.used IS '是否使用';
COMMENT ON COLUMN system_sms_code.used_time IS '使用时间';
COMMENT ON COLUMN system_sms_code.used_ip IS '使用 IP';
COMMENT ON COLUMN system_sms_code.creator IS '创建者';
COMMENT ON COLUMN system_sms_code.create_time IS '创建时间';
COMMENT ON COLUMN system_sms_code.updater IS '更新者';
COMMENT ON COLUMN system_sms_code.update_time IS '更新时间';
COMMENT ON COLUMN system_sms_code.deleted IS '是否删除';
COMMENT ON COLUMN system_sms_code.tenant_id IS '租户编号';
COMMENT ON TABLE system_sms_code IS '手机验证码';

DROP SEQUENCE IF EXISTS system_sms_code_seq;
CREATE SEQUENCE system_sms_code_seq
    START 1;

-- ----------------------------
-- Table structure for system_sms_log
-- ----------------------------
DROP TABLE IF EXISTS system_sms_log;
CREATE TABLE system_sms_log
(
    id               int8         NOT NULL,
    channel_id       int8         NOT NULL,
    channel_code     varchar(63)  NOT NULL,
    template_id      int8         NOT NULL,
    template_code    varchar(63)  NOT NULL,
    template_type    int2         NOT NULL,
    template_content varchar(255) NOT NULL,
    template_params  varchar(255) NOT NULL,
    api_template_id  varchar(63)  NOT NULL,
    mobile           varchar(11)  NOT NULL,
    user_id          int8         NULL     DEFAULT NULL,
    user_type        int2         NULL     DEFAULT NULL,
    send_status      int2         NOT NULL DEFAULT 0,
    send_time        timestamp    NULL     DEFAULT NULL,
    api_send_code    varchar(63)  NULL     DEFAULT NULL,
    api_send_msg     varchar(255) NULL     DEFAULT NULL,
    api_request_id   varchar(255) NULL     DEFAULT NULL,
    api_serial_no    varchar(255) NULL     DEFAULT NULL,
    receive_status   int2         NOT NULL DEFAULT 0,
    receive_time     timestamp    NULL     DEFAULT NULL,
    api_receive_code varchar(63)  NULL     DEFAULT NULL,
    api_receive_msg  varchar(255) NULL     DEFAULT NULL,
    creator          varchar(64)  NULL     DEFAULT '',
    create_time      timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater          varchar(64)  NULL     DEFAULT '',
    update_time      timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted          int2         NOT NULL DEFAULT 0
);

ALTER TABLE system_sms_log
    ADD CONSTRAINT pk_system_sms_log PRIMARY KEY (id);

COMMENT ON COLUMN system_sms_log.id IS '编号';
COMMENT ON COLUMN system_sms_log.channel_id IS '短信渠道编号';
COMMENT ON COLUMN system_sms_log.channel_code IS '短信渠道编码';
COMMENT ON COLUMN system_sms_log.template_id IS '模板编号';
COMMENT ON COLUMN system_sms_log.template_code IS '模板编码';
COMMENT ON COLUMN system_sms_log.template_type IS '短信类型';
COMMENT ON COLUMN system_sms_log.template_content IS '短信内容';
COMMENT ON COLUMN system_sms_log.template_params IS '短信参数';
COMMENT ON COLUMN system_sms_log.api_template_id IS '短信 API 的模板编号';
COMMENT ON COLUMN system_sms_log.mobile IS '手机号';
COMMENT ON COLUMN system_sms_log.user_id IS '用户编号';
COMMENT ON COLUMN system_sms_log.user_type IS '用户类型';
COMMENT ON COLUMN system_sms_log.send_status IS '发送状态';
COMMENT ON COLUMN system_sms_log.send_time IS '发送时间';
COMMENT ON COLUMN system_sms_log.api_send_code IS '短信 API 发送结果的编码';
COMMENT ON COLUMN system_sms_log.api_send_msg IS '短信 API 发送失败的提示';
COMMENT ON COLUMN system_sms_log.api_request_id IS '短信 API 发送返回的唯一请求 ID';
COMMENT ON COLUMN system_sms_log.api_serial_no IS '短信 API 发送返回的序号';
COMMENT ON COLUMN system_sms_log.receive_status IS '接收状态';
COMMENT ON COLUMN system_sms_log.receive_time IS '接收时间';
COMMENT ON COLUMN system_sms_log.api_receive_code IS 'API 接收结果的编码';
COMMENT ON COLUMN system_sms_log.api_receive_msg IS 'API 接收结果的说明';
COMMENT ON COLUMN system_sms_log.creator IS '创建者';
COMMENT ON COLUMN system_sms_log.create_time IS '创建时间';
COMMENT ON COLUMN system_sms_log.updater IS '更新者';
COMMENT ON COLUMN system_sms_log.update_time IS '更新时间';
COMMENT ON COLUMN system_sms_log.deleted IS '是否删除';
COMMENT ON TABLE system_sms_log IS '短信日志';

DROP SEQUENCE IF EXISTS system_sms_log_seq;
CREATE SEQUENCE system_sms_log_seq
    START 1;

-- ----------------------------
-- Table structure for system_sms_template
-- ----------------------------
DROP TABLE IF EXISTS system_sms_template;
CREATE TABLE system_sms_template
(
    id              int8         NOT NULL,
    type            int2         NOT NULL,
    status          int2         NOT NULL,
    code            varchar(63)  NOT NULL,
    name            varchar(63)  NOT NULL,
    content         varchar(255) NOT NULL,
    params          varchar(255) NOT NULL,
    remark          varchar(255) NULL     DEFAULT NULL,
    api_template_id varchar(63)  NOT NULL,
    channel_id      int8         NOT NULL,
    channel_code    varchar(63)  NOT NULL,
    creator         varchar(64)  NULL     DEFAULT '',
    create_time     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater         varchar(64)  NULL     DEFAULT '',
    update_time     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted         int2         NOT NULL DEFAULT 0
);

ALTER TABLE system_sms_template
    ADD CONSTRAINT pk_system_sms_template PRIMARY KEY (id);

COMMENT ON COLUMN system_sms_template.id IS '编号';
COMMENT ON COLUMN system_sms_template.type IS '模板类型';
COMMENT ON COLUMN system_sms_template.status IS '开启状态';
COMMENT ON COLUMN system_sms_template.code IS '模板编码';
COMMENT ON COLUMN system_sms_template.name IS '模板名称';
COMMENT ON COLUMN system_sms_template.content IS '模板内容';
COMMENT ON COLUMN system_sms_template.params IS '参数数组';
COMMENT ON COLUMN system_sms_template.remark IS '备注';
COMMENT ON COLUMN system_sms_template.api_template_id IS '短信 API 的模板编号';
COMMENT ON COLUMN system_sms_template.channel_id IS '短信渠道编号';
COMMENT ON COLUMN system_sms_template.channel_code IS '短信渠道编码';
COMMENT ON COLUMN system_sms_template.creator IS '创建者';
COMMENT ON COLUMN system_sms_template.create_time IS '创建时间';
COMMENT ON COLUMN system_sms_template.updater IS '更新者';
COMMENT ON COLUMN system_sms_template.update_time IS '更新时间';
COMMENT ON COLUMN system_sms_template.deleted IS '是否删除';
COMMENT ON TABLE system_sms_template IS '短信模板';

-- ----------------------------
-- Records of system_sms_template
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (2, 1, 0, 'test_01', '测试验证码短信', '正在进行登录操作{operation}，您的验证码是{code}', '["operation","code"]', '测试备注', '4383920', 4, 'DEBUG_DING_TALK', '', '2021-03-31 10:49:38', '1', '2024-08-18 11:57:18', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (3, 1, 0, 'test_02', '公告通知', '您的验证码{code}，该验证码5分钟内有效，请勿泄漏于他人！', '["code"]', NULL, 'SMS_207945135', 2, 'ALIYUN', '', '2021-03-31 11:56:30', '1', '2021-04-10 01:22:02', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (6, 3, 0, 'test-01', '测试模板', '哈哈哈 {name}', '["name"]', 'f哈哈哈', '4383920', 4, 'DEBUG_DING_TALK', '1', '2021-04-10 01:07:21', '1', '2024-08-18 11:57:07', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (7, 3, 0, 'test-04', '测试下', '老鸡{name}，牛逼{code}', '["name","code"]', '哈哈哈哈', 'suibian', 7, 'DEBUG_DING_TALK', '1', '2021-04-13 00:29:53', '1', '2024-09-30 00:56:24', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (8, 1, 0, 'user-sms-login', '前台用户短信登录', '您的验证码是{code}', '["code"]', NULL, '4372216', 4, 'DEBUG_DING_TALK', '1', '2021-10-11 08:10:00', '1', '2024-08-18 11:57:06', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (9, 2, 0, 'bpm_task_assigned', '【工作流】任务被分配', '您收到了一条新的待办任务：{processInstanceName}-{taskName}，申请人：{startUserNickname}，处理链接：{detailUrl}', '["processInstanceName","taskName","startUserNickname","detailUrl"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-21 22:31:19', '1', '2022-01-22 00:03:36', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (10, 2, 0, 'bpm_process_instance_reject', '【工作流】流程被不通过', '您的流程被审批不通过：{processInstanceName}，原因：{reason}，查看链接：{detailUrl}', '["processInstanceName","reason","detailUrl"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-22 00:03:31', '1', '2022-05-01 12:33:14', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (11, 2, 0, 'bpm_process_instance_approve', '【工作流】流程被通过', '您的流程被审批通过：{processInstanceName}，查看链接：{detailUrl}', '["processInstanceName","detailUrl"]', NULL, 'suibian', 4, 'DEBUG_DING_TALK', '1', '2022-01-22 00:04:31', '1', '2022-03-27 20:32:21', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (12, 2, 0, 'demo', '演示模板', '我就是测试一下下', '[]', NULL, 'biubiubiu', 4, 'DEBUG_DING_TALK', '1', '2022-04-10 23:22:49', '1', '2024-08-18 11:57:04', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (14, 1, 0, 'user-update-mobile', '会员用户 - 修改手机', '您的验证码{code}，该验证码 5 分钟内有效，请勿泄漏于他人！', '["code"]', '', 'null', 4, 'DEBUG_DING_TALK', '1', '2023-08-19 18:58:01', '1', '2023-08-19 11:34:04', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (15, 1, 0, 'user-update-password', '会员用户 - 修改密码', '您的验证码{code}，该验证码 5 分钟内有效，请勿泄漏于他人！', '["code"]', '', 'null', 4, 'DEBUG_DING_TALK', '1', '2023-08-19 18:58:01', '1', '2023-08-19 11:34:18', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (16, 1, 0, 'user-reset-password', '会员用户 - 重置密码', '您的验证码{code}，该验证码 5 分钟内有效，请勿泄漏于他人！', '["code"]', '', 'null', 4, 'DEBUG_DING_TALK', '1', '2023-08-19 18:58:01', '1', '2023-12-02 22:35:27', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (17, 2, 0, 'bpm_task_timeout', '【工作流】任务审批超时', '您收到了一条超时的待办任务：{processInstanceName}-{taskName}，处理链接：{detailUrl}', '["processInstanceName","taskName","detailUrl"]', '', 'X', 4, 'DEBUG_DING_TALK', '1', '2024-08-16 21:59:15', '1', '2024-08-16 21:59:34', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (18, 1, 0, 'admin-reset-password', '后台用户 - 忘记密码', '您的验证码{code}，该验证码 5 分钟内有效，请勿泄漏于他人！', '["code"]', '', 'null', 4, 'DEBUG_DING_TALK', '1', '2025-03-16 14:19:34', '1', '2025-03-16 14:19:45', '0');
INSERT INTO system_sms_template (id, type, status, code, name, content, params, remark, api_template_id, channel_id, channel_code, creator, create_time, updater, update_time, deleted) VALUES (19, 1, 0, 'admin-sms-login', '后台用户短信登录', '您的验证码是{code}', '["code"]', '', '4372216', 4, 'DEBUG_DING_TALK', '1', '2025-04-08 09:36:03', '1', '2025-04-08 09:36:17', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_sms_template_seq;
CREATE SEQUENCE system_sms_template_seq
    START 20;

-- ----------------------------
-- Table structure for system_social_client
-- ----------------------------
DROP TABLE IF EXISTS system_social_client;
CREATE TABLE system_social_client
(
    id            int8         NOT NULL,
    name          varchar(255) NOT NULL,
    social_type   int2         NOT NULL,
    user_type     int2         NOT NULL,
    client_id     varchar(255) NOT NULL,
    client_secret varchar(2048) NOT NULL,
    public_key    varchar(2048) NULL     DEFAULT NULL,
    agent_id      varchar(255) NULL     DEFAULT NULL,
    status        int2         NOT NULL,
    creator       varchar(64)  NULL     DEFAULT '',
    create_time   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater       varchar(64)  NULL     DEFAULT '',
    update_time   timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted       int2         NOT NULL DEFAULT 0,
    tenant_id     int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_social_client
    ADD CONSTRAINT pk_system_social_client PRIMARY KEY (id);

COMMENT ON COLUMN system_social_client.id IS '编号';
COMMENT ON COLUMN system_social_client.name IS '应用名';
COMMENT ON COLUMN system_social_client.social_type IS '社交平台的类型';
COMMENT ON COLUMN system_social_client.user_type IS '用户类型';
COMMENT ON COLUMN system_social_client.client_id IS '客户端编号';
COMMENT ON COLUMN system_social_client.client_secret IS '客户端密钥';
COMMENT ON COLUMN system_social_client.public_key IS 'publicKey公钥';
COMMENT ON COLUMN system_social_client.agent_id IS '代理编号';
COMMENT ON COLUMN system_social_client.status IS '状态';
COMMENT ON COLUMN system_social_client.creator IS '创建者';
COMMENT ON COLUMN system_social_client.create_time IS '创建时间';
COMMENT ON COLUMN system_social_client.updater IS '更新者';
COMMENT ON COLUMN system_social_client.update_time IS '更新时间';
COMMENT ON COLUMN system_social_client.deleted IS '是否删除';
COMMENT ON COLUMN system_social_client.tenant_id IS '租户编号';
COMMENT ON TABLE system_social_client IS '社交客户端表';

-- ----------------------------
-- Records of system_social_client
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_social_client (id, name, social_type, user_type, client_id, client_secret, agent_id, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1, '钉钉', 20, 2, 'dingvrnreaje3yqvzhxg', 'i8E6iZyDvZj51JIb0tYsYfVQYOks9Cq1lgryEjFRqC79P3iJcrxEwT6Qk2QvLrLI', NULL, 0, '', '2023-10-18 11:21:18', '1', '2023-12-20 21:28:26', '1', 1);
INSERT INTO system_social_client (id, name, social_type, user_type, client_id, client_secret, agent_id, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2, '钉钉（王土豆）', 20, 2, 'dingtsu9hpepjkbmthhw', 'FP_bnSq_HAHKCSncmJjw5hxhnzs6vaVDSZZn3egj6rdqTQ_hu5tQVJyLMpgCakdP', NULL, 0, '', '2023-10-18 11:21:18', '', '2023-12-20 21:28:26', '1', 121);
INSERT INTO system_social_client (id, name, social_type, user_type, client_id, client_secret, agent_id, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3, '微信公众号', 31, 1, 'wx5b23ba7a5589ecbb', '2a7b3b20c537e52e74afd395eb85f61f', NULL, 0, '', '2023-10-18 16:07:46', '1', '2023-12-20 21:28:23', '1', 1);
INSERT INTO system_social_client (id, name, social_type, user_type, client_id, client_secret, agent_id, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (43, '微信小程序', 34, 1, 'wx63c280fe3248a3e7', '6f270509224a7ae1296bbf1c8cb97aed', NULL, 0, '', '2023-10-19 13:37:41', '1', '2023-12-20 21:28:25', '1', 1);
INSERT INTO system_social_client (id, name, social_type, user_type, client_id, client_secret, agent_id, status, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (44, '1', 10, 1, '2', '3', NULL, 0, '1', '2025-04-06 20:36:28', '1', '2025-04-06 20:43:12', '1', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_social_client_seq;
CREATE SEQUENCE system_social_client_seq
    START 45;

-- ----------------------------
-- Table structure for system_social_user
-- ----------------------------
DROP TABLE IF EXISTS system_social_user;
CREATE TABLE system_social_user
(
    id             int8          NOT NULL,
    type           int2          NOT NULL,
    openid         varchar(32)   NOT NULL,
    token          varchar(256)  NULL     DEFAULT NULL,
    raw_token_info varchar(1024) NOT NULL,
    nickname       varchar(32)   NOT NULL,
    avatar         varchar(255)  NULL     DEFAULT NULL,
    raw_user_info  varchar(1024) NOT NULL,
    code           varchar(256)  NOT NULL,
    state          varchar(256)  NULL     DEFAULT NULL,
    creator        varchar(64)   NULL     DEFAULT '',
    create_time    timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater        varchar(64)   NULL     DEFAULT '',
    update_time    timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted        int2          NOT NULL DEFAULT 0,
    tenant_id      int8          NOT NULL DEFAULT 0
);

ALTER TABLE system_social_user
    ADD CONSTRAINT pk_system_social_user PRIMARY KEY (id);

COMMENT ON COLUMN system_social_user.id IS '主键 ( 自增策略)';
COMMENT ON COLUMN system_social_user.type IS '社交平台的类型';
COMMENT ON COLUMN system_social_user.openid IS '社交 openid';
COMMENT ON COLUMN system_social_user.token IS '社交 token';
COMMENT ON COLUMN system_social_user.raw_token_info IS '原始 Token 数据，一般是 JSON 格式';
COMMENT ON COLUMN system_social_user.nickname IS '用户昵称';
COMMENT ON COLUMN system_social_user.avatar IS '用户头像';
COMMENT ON COLUMN system_social_user.raw_user_info IS '原始用户数据，一般是 JSON 格式';
COMMENT ON COLUMN system_social_user.code IS '最后一次的认证 code';
COMMENT ON COLUMN system_social_user.state IS '最后一次的认证 state';
COMMENT ON COLUMN system_social_user.creator IS '创建者';
COMMENT ON COLUMN system_social_user.create_time IS '创建时间';
COMMENT ON COLUMN system_social_user.updater IS '更新者';
COMMENT ON COLUMN system_social_user.update_time IS '更新时间';
COMMENT ON COLUMN system_social_user.deleted IS '是否删除';
COMMENT ON COLUMN system_social_user.tenant_id IS '租户编号';
COMMENT ON TABLE system_social_user IS '社交用户表';

DROP SEQUENCE IF EXISTS system_social_user_seq;
CREATE SEQUENCE system_social_user_seq
    START 1;

-- ----------------------------
-- Table structure for system_social_user_bind
-- ----------------------------
DROP TABLE IF EXISTS system_social_user_bind;
CREATE TABLE system_social_user_bind
(
    id             int8        NOT NULL,
    user_id        int8        NOT NULL,
    user_type      int2        NOT NULL,
    social_type    int2        NOT NULL,
    social_user_id int8        NOT NULL,
    creator        varchar(64) NULL     DEFAULT '',
    create_time    timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater        varchar(64) NULL     DEFAULT '',
    update_time    timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted        int2        NOT NULL DEFAULT 0,
    tenant_id      int8        NOT NULL DEFAULT 0
);

ALTER TABLE system_social_user_bind
    ADD CONSTRAINT pk_system_social_user_bind PRIMARY KEY (id);

COMMENT ON COLUMN system_social_user_bind.id IS '主键 ( 自增策略)';
COMMENT ON COLUMN system_social_user_bind.user_id IS '用户编号';
COMMENT ON COLUMN system_social_user_bind.user_type IS '用户类型';
COMMENT ON COLUMN system_social_user_bind.social_type IS '社交平台的类型';
COMMENT ON COLUMN system_social_user_bind.social_user_id IS '社交用户的编号';
COMMENT ON COLUMN system_social_user_bind.creator IS '创建者';
COMMENT ON COLUMN system_social_user_bind.create_time IS '创建时间';
COMMENT ON COLUMN system_social_user_bind.updater IS '更新者';
COMMENT ON COLUMN system_social_user_bind.update_time IS '更新时间';
COMMENT ON COLUMN system_social_user_bind.deleted IS '是否删除';
COMMENT ON COLUMN system_social_user_bind.tenant_id IS '租户编号';
COMMENT ON TABLE system_social_user_bind IS '社交绑定表';

DROP SEQUENCE IF EXISTS system_social_user_bind_seq;
CREATE SEQUENCE system_social_user_bind_seq
    START 1;

-- ----------------------------
-- Table structure for system_tenant
-- ----------------------------
DROP TABLE IF EXISTS system_tenant;
CREATE TABLE system_tenant
(
    id              int8         NOT NULL,
    name            varchar(30)  NOT NULL,
    contact_user_id int8         NULL     DEFAULT NULL,
    contact_name    varchar(30)  NOT NULL,
    contact_mobile  varchar(500) NULL     DEFAULT NULL,
    status          int2         NOT NULL DEFAULT 0,
    websites        varchar(256) NULL     DEFAULT '',
    package_id      int8         NOT NULL,
    expire_time     timestamp    NOT NULL,
    account_count   int4         NOT NULL,
    creator         varchar(64)  NULL     DEFAULT '',
    create_time     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater         varchar(64)  NULL     DEFAULT '',
    update_time     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted         int2         NOT NULL DEFAULT 0
);

ALTER TABLE system_tenant
    ADD CONSTRAINT pk_system_tenant PRIMARY KEY (id);

COMMENT ON COLUMN system_tenant.id IS '租户编号';
COMMENT ON COLUMN system_tenant.name IS '租户名';
COMMENT ON COLUMN system_tenant.contact_user_id IS '联系人的用户编号';
COMMENT ON COLUMN system_tenant.contact_name IS '联系人';
COMMENT ON COLUMN system_tenant.contact_mobile IS '联系手机';
COMMENT ON COLUMN system_tenant.status IS '租户状态（0正常 1停用）';
COMMENT ON COLUMN system_tenant.websites IS '绑定域名数组';
COMMENT ON COLUMN system_tenant.package_id IS '租户套餐编号';
COMMENT ON COLUMN system_tenant.expire_time IS '过期时间';
COMMENT ON COLUMN system_tenant.account_count IS '账号数量';
COMMENT ON COLUMN system_tenant.creator IS '创建者';
COMMENT ON COLUMN system_tenant.create_time IS '创建时间';
COMMENT ON COLUMN system_tenant.updater IS '更新者';
COMMENT ON COLUMN system_tenant.update_time IS '更新时间';
COMMENT ON COLUMN system_tenant.deleted IS '是否删除';
COMMENT ON TABLE system_tenant IS '租户表';

-- ----------------------------
-- Records of system_tenant
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_tenant (id, name, contact_user_id, contact_name, contact_mobile, status, websites, package_id, expire_time, account_count, creator, create_time, updater, update_time, deleted) VALUES (1, '密讯', NULL, '管理员', '17321315478', 0, 'xxx', 0, '2099-02-19 17:14:16', 9999, '1', '2021-01-05 17:03:47', '1', '2023-11-06 11:41:41', '0');
INSERT INTO system_tenant (id, name, contact_user_id, contact_name, contact_mobile, status, websites, package_id, expire_time, account_count, creator, create_time, updater, update_time, deleted) VALUES (121, '小租户', 110, '小王2', '15601691300', 0, 'xxx', 111, '2026-07-10 00:00:00', 30, '1', '2022-02-22 00:56:14', '1', '2025-04-03 21:33:01', '0');
INSERT INTO system_tenant (id, name, contact_user_id, contact_name, contact_mobile, status, websites, package_id, expire_time, account_count, creator, create_time, updater, update_time, deleted) VALUES (122, '测试租户', 113, '密讯', '15601691300', 0, 'xxx', 111, '2022-04-29 00:00:00', 50, '1', '2022-03-07 21:37:58', '1', '2024-09-22 12:10:50', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_tenant_seq;
CREATE SEQUENCE system_tenant_seq
    START 123;

-- ----------------------------
-- Table structure for system_tenant_package
-- ----------------------------
DROP TABLE IF EXISTS system_tenant_package;
CREATE TABLE system_tenant_package
(
    id          int8          NOT NULL,
    name        varchar(30)   NOT NULL,
    status      int2          NOT NULL DEFAULT 0,
    remark      varchar(256)  NULL     DEFAULT '',
    menu_ids    varchar(4096) NOT NULL,
    creator     varchar(64)   NULL     DEFAULT '',
    create_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)   NULL     DEFAULT '',
    update_time timestamp     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2          NOT NULL DEFAULT 0
);

ALTER TABLE system_tenant_package
    ADD CONSTRAINT pk_system_tenant_package PRIMARY KEY (id);

COMMENT ON COLUMN system_tenant_package.id IS '套餐编号';
COMMENT ON COLUMN system_tenant_package.name IS '套餐名';
COMMENT ON COLUMN system_tenant_package.status IS '租户状态（0正常 1停用）';
COMMENT ON COLUMN system_tenant_package.remark IS '备注';
COMMENT ON COLUMN system_tenant_package.menu_ids IS '关联的菜单编号';
COMMENT ON COLUMN system_tenant_package.creator IS '创建者';
COMMENT ON COLUMN system_tenant_package.create_time IS '创建时间';
COMMENT ON COLUMN system_tenant_package.updater IS '更新者';
COMMENT ON COLUMN system_tenant_package.update_time IS '更新时间';
COMMENT ON COLUMN system_tenant_package.deleted IS '是否删除';
COMMENT ON TABLE system_tenant_package IS '租户套餐表';

-- ----------------------------
-- Records of system_tenant_package
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_tenant_package (id, name, status, remark, menu_ids, creator, create_time, updater, update_time, deleted) VALUES (111, '普通套餐', 0, '小功能', '[1,2,5,1031,1032,1033,1034,1035,1036,1037,1038,1039,1050,1051,1052,1053,1054,1056,1057,1058,1059,1060,1063,1064,1065,1066,1067,1070,1075,1077,1078,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1118,1119,1120,100,101,102,103,106,107,110,111,112,113,1138,114,1139,115,1140,116,1141,1142,1143,2713,2714,2715,2716,2717,2718,2720,1185,2721,1186,2722,1187,2723,1188,2724,1189,2725,1190,2726,1191,2727,2472,1192,2728,1193,2729,1194,2730,1195,2731,1196,2732,1197,2733,2478,1198,2734,2479,1199,2735,2480,1200,2481,1201,2482,1202,2483,2739,2484,2740,2485,2486,2487,1207,2488,1208,2489,1209,2490,1210,2491,1211,2492,1212,2493,1213,2494,2495,1215,1216,2497,1217,1218,1219,1220,1221,1222,1224,1225,1226,1227,1228,1229,1237,1238,1239,1240,1241,1242,1243,2525,1255,1256,1001,1257,1002,1258,1003,1259,1004,1260,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020]', '1', '2022-02-22 00:54:00', '1', '2024-07-13 22:37:24', '0');
INSERT INTO system_tenant_package (id, name, status, remark, menu_ids, creator, create_time, updater, update_time, deleted) VALUES (112, '再来一个套餐', 0, '1234', '[1024,1,1025,1026,2,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1042,1043,1045,1046,1048,1050,1051,1052,1053,1054,1056,1057,1058,2083,1059,1060,1063,1064,1065,1066,1067,1070,1075,1077,1078,1082,1083,1084,1085,1086,1087,1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1100,1101,1102,1103,1104,1105,1106,2130,1107,2131,1108,2132,1109,2133,2134,2135,2136,2137,2138,2139,2140,2141,2142,2143,2144,2145,2146,2147,100,2148,101,2149,102,2150,103,2151,104,2152,105,106,107,108,109,110,111,112,113,1138,114,1139,115,1140,116,1141,1142,1143,2739,2740,1224,1225,1226,1227,1228,1229,1237,1238,1239,1240,1241,1242,1243,1255,1256,1257,1258,1259,1260,1261,1263,1264,1265,1266,1267,2447,2448,2449,2450,2451,2452,2453,2472,2478,2479,2480,2481,2482,2483,2484,2485,2486,2487,2488,2489,2490,2491,2492,2493,2494,2495,2497,2525,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,500,1013,501,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023]', '1', '2025-04-04 08:15:02', '1', '2025-04-04 08:15:21', '0');
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_tenant_package_seq;
CREATE SEQUENCE system_tenant_package_seq
    START 113;

-- ----------------------------
-- Table structure for system_user_post
-- ----------------------------
DROP TABLE IF EXISTS system_user_post;
CREATE TABLE system_user_post
(
    id          int8        NOT NULL,
    user_id     int8        NOT NULL DEFAULT 0,
    post_id     int8        NOT NULL DEFAULT 0,
    creator     varchar(64) NULL     DEFAULT '',
    create_time timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64) NULL     DEFAULT '',
    update_time timestamp   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2        NOT NULL DEFAULT 0,
    tenant_id   int8        NOT NULL DEFAULT 0
);

ALTER TABLE system_user_post
    ADD CONSTRAINT pk_system_user_post PRIMARY KEY (id);

COMMENT ON COLUMN system_user_post.id IS 'id';
COMMENT ON COLUMN system_user_post.user_id IS '用户ID';
COMMENT ON COLUMN system_user_post.post_id IS '岗位ID';
COMMENT ON COLUMN system_user_post.creator IS '创建者';
COMMENT ON COLUMN system_user_post.create_time IS '创建时间';
COMMENT ON COLUMN system_user_post.updater IS '更新者';
COMMENT ON COLUMN system_user_post.update_time IS '更新时间';
COMMENT ON COLUMN system_user_post.deleted IS '是否删除';
COMMENT ON COLUMN system_user_post.tenant_id IS '租户编号';
COMMENT ON TABLE system_user_post IS '用户岗位表';

-- ----------------------------
-- Records of system_user_post
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (112, 1, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', '0', 1);
INSERT INTO system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (113, 100, 1, 'admin', '2022-05-02 07:25:24', 'admin', '2022-05-02 07:25:24', '0', 1);
INSERT INTO system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (115, 104, 1, '1', '2022-05-16 19:36:28', '1', '2022-05-16 19:36:28', '0', 1);
INSERT INTO system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (116, 117, 2, '1', '2022-07-09 17:40:26', '1', '2022-07-09 17:40:26', '0', 1);
INSERT INTO system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (117, 118, 1, '1', '2022-07-09 17:44:44', '1', '2022-07-09 17:44:44', '0', 1);
INSERT INTO system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (119, 114, 5, '1', '2024-03-24 20:45:51', '1', '2024-03-24 20:45:51', '0', 1);
INSERT INTO system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (123, 115, 1, '1', '2024-04-04 09:37:14', '1', '2024-04-04 09:37:14', '0', 1);
INSERT INTO system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (124, 115, 2, '1', '2024-04-04 09:37:14', '1', '2024-04-04 09:37:14', '0', 1);
INSERT INTO system_user_post (id, user_id, post_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (125, 1, 2, '1', '2024-07-13 22:31:39', '1', '2024-07-13 22:31:39', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_user_post_seq;
CREATE SEQUENCE system_user_post_seq
    START 126;

-- ----------------------------
-- Table structure for system_user_role
-- ----------------------------
DROP TABLE IF EXISTS system_user_role;
CREATE TABLE system_user_role
(
    id          int8        NOT NULL,
    user_id     int8        NOT NULL,
    role_id     int8        NOT NULL,
    creator     varchar(64) NULL     DEFAULT '',
    create_time timestamp   NULL     DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64) NULL     DEFAULT '',
    update_time timestamp   NULL     DEFAULT CURRENT_TIMESTAMP,
    deleted     int2        NOT NULL DEFAULT 0,
    tenant_id   int8        NOT NULL DEFAULT 0
);

ALTER TABLE system_user_role
    ADD CONSTRAINT pk_system_user_role PRIMARY KEY (id);

COMMENT ON COLUMN system_user_role.id IS '自增编号';
COMMENT ON COLUMN system_user_role.user_id IS '用户ID';
COMMENT ON COLUMN system_user_role.role_id IS '角色ID';
COMMENT ON COLUMN system_user_role.creator IS '创建者';
COMMENT ON COLUMN system_user_role.create_time IS '创建时间';
COMMENT ON COLUMN system_user_role.updater IS '更新者';
COMMENT ON COLUMN system_user_role.update_time IS '更新时间';
COMMENT ON COLUMN system_user_role.deleted IS '是否删除';
COMMENT ON COLUMN system_user_role.tenant_id IS '租户编号';
COMMENT ON TABLE system_user_role IS '用户和角色关联表';

-- ----------------------------
-- Records of system_user_role
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1, 1, 1, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:17', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2, 2, 2, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:13', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4, 100, 101, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:13', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5, 100, 1, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:12', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6, 100, 2, '', '2022-01-11 13:19:45', '', '2022-05-12 12:35:11', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (10, 103, 1, '1', '2022-01-11 13:19:45', '1', '2022-01-11 13:19:45', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (14, 110, 109, '1', '2022-02-22 00:56:14', '1', '2022-02-22 00:56:14', '0', 121);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (15, 111, 110, '110', '2022-02-23 13:14:38', '110', '2022-02-23 13:14:38', '0', 121);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (16, 113, 111, '1', '2022-03-07 21:37:58', '1', '2022-03-07 21:37:58', '0', 122);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (18, 1, 2, '1', '2022-05-12 20:39:29', '1', '2022-05-12 20:39:29', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (22, 115, 2, '1', '2022-07-21 22:08:30', '1', '2022-07-21 22:08:30', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (35, 112, 1, '1', '2024-03-15 20:00:24', '1', '2024-03-15 20:00:24', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (36, 118, 1, '1', '2024-03-17 09:12:08', '1', '2024-03-17 09:12:08', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (38, 114, 101, '1', '2024-03-24 22:23:03', '1', '2024-03-24 22:23:03', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (46, 117, 1, '1', '2024-10-02 10:16:11', '1', '2024-10-02 10:16:11', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (47, 104, 2, '1', '2025-01-04 10:40:33', '1', '2025-01-04 10:40:33', '0', 1);
INSERT INTO system_user_role (id, user_id, role_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (48, 100, 155, '1', '2025-04-04 10:41:14', '1', '2025-04-04 10:41:14', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_user_role_seq;
CREATE SEQUENCE system_user_role_seq
    START 49;

-- ----------------------------
-- Table structure for system_users
-- ----------------------------
DROP TABLE IF EXISTS system_users;
CREATE TABLE system_users
(
    id          int8         NOT NULL,
    username    varchar(30)  NOT NULL,
    password    varchar(100) NULL     DEFAULT '',
    nickname    varchar(30)  NOT NULL,
    remark      varchar(500) NULL     DEFAULT NULL,
    dept_id     int8         NULL     DEFAULT NULL,
    post_ids    varchar(255) NULL     DEFAULT NULL,
    email       varchar(50)  NULL     DEFAULT '',
    mobile      varchar(11)  NULL     DEFAULT '',
    sex         int2         NULL     DEFAULT 0,
    avatar      varchar(512) NULL     DEFAULT '',
    status      int2         NOT NULL DEFAULT 0,
    login_ip    varchar(50)  NULL     DEFAULT '',
    login_date  timestamp    NULL     DEFAULT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0,
    tenant_id   int8         NOT NULL DEFAULT 0
);

ALTER TABLE system_users
    ADD CONSTRAINT pk_system_users PRIMARY KEY (id);

COMMENT ON COLUMN system_users.id IS '用户ID';
COMMENT ON COLUMN system_users.username IS '用户账号';
COMMENT ON COLUMN system_users.password IS '密码';
COMMENT ON COLUMN system_users.nickname IS '用户昵称';
COMMENT ON COLUMN system_users.remark IS '备注';
COMMENT ON COLUMN system_users.dept_id IS '部门ID';
COMMENT ON COLUMN system_users.post_ids IS '岗位编号数组';
COMMENT ON COLUMN system_users.email IS '用户邮箱';
COMMENT ON COLUMN system_users.mobile IS '手机号码';
COMMENT ON COLUMN system_users.sex IS '用户性别';
COMMENT ON COLUMN system_users.avatar IS '头像地址';
COMMENT ON COLUMN system_users.status IS '帐号状态（0正常 1停用）';
COMMENT ON COLUMN system_users.login_ip IS '最后登录IP';
COMMENT ON COLUMN system_users.login_date IS '最后登录时间';
COMMENT ON COLUMN system_users.creator IS '创建者';
COMMENT ON COLUMN system_users.create_time IS '创建时间';
COMMENT ON COLUMN system_users.updater IS '更新者';
COMMENT ON COLUMN system_users.update_time IS '更新时间';
COMMENT ON COLUMN system_users.deleted IS '是否删除';
COMMENT ON COLUMN system_users.tenant_id IS '租户编号';
COMMENT ON TABLE system_users IS '用户信息表';

-- ----------------------------
-- Records of system_users
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1, 'admin', '$2a$04$KljJDa/LK7QfDm0lF5OhuePhlPfjRH3tB2Wu351Uidz.oQGJXevPi', '密讯', '管理员', 103, '[1,2]', '11aoteman@126.com', '18818260277', 2, 'http://xxx/test/20250502/avatar_1746154660449.png', 0, '0:0:0:0:0:0:0:1', '2025-05-10 18:03:15', 'admin', '2021-01-05 17:03:47', NULL, '2025-05-10 18:03:15', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (100, 'mitedtsm', '$2a$04$h.aaPKgO.odHepnk5PCsWeEwKdojFWdTItxGKfx1r0e1CSeBzsTJ6', '密讯', '不要吓我', 104, '[1]', 'xxx', '15601691300', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2025-04-08 09:36:40', '', '2021-01-07 09:07:17', NULL, '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (103, 'yuanma', '$2a$04$fUBSmjKCPYAUmnMzOb6qE.eZCGPhHi1JmAKclODbfS/O7fHOl2bH6', '源码', NULL, 106, NULL, 'xxx', '15601701300', 0, NULL, 0, '0:0:0:0:0:0:0:1', '2024-08-11 17:48:12', '', '2021-01-13 23:50:35', NULL, '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (104, 'test', '$2a$04$BrwaYn303hjA/6TnXqdGoOLhyHOAA0bVrAFu6.1dJKycqKUnIoRz2', '测试号', NULL, 107, '[1,2]', '111@qq.com', '15601691200', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2025-03-28 20:01:16', '', '2021-01-21 02:13:53', NULL, '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (107, 'admin107', '$2a$10$dYOOBKMO93v/.ReCqzyFg.o67Tqk.bbc2bhrpyBGkIw9aypCtr2pm', '管理员', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '', NULL, '1', '2022-02-20 22:59:33', '1', '2025-04-21 14:23:08', '0', 118);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (108, 'admin108', '$2a$10$y6mfvKoNYL1GXWak8nYwVOH.kCWqjactkzdoIDgiKl93WN3Ejg.Lu', '管理员', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '', NULL, '1', '2022-02-20 23:00:50', '1', '2025-04-21 14:23:08', '0', 119);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (109, 'admin109', '$2a$10$JAqvH0tEc0I7dfDVBI7zyuB4E3j.uH6daIjV53.vUS6PknFkDJkuK', '管理员', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '', NULL, '1', '2022-02-20 23:11:50', '1', '2025-04-21 14:23:08', '0', 120);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (110, 'admin110', '$2a$10$mRMIYLDtRHlf6.9ipiqH1.Z.bh/R9dO9d5iHiGYPigi6r5KOoR2Wm', '小王', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '0:0:0:0:0:0:0:1', '2024-07-20 22:23:17', '1', '2022-02-22 00:56:14', NULL, '2025-04-21 14:23:08', '0', 121);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (111, 'test', '$2a$10$mRMIYLDtRHlf6.9ipiqH1.Z.bh/R9dO9d5iHiGYPigi6r5KOoR2Wm', '测试用户', NULL, NULL, '[]', '', '', 0, NULL, 0, '0:0:0:0:0:0:0:1', '2023-12-30 11:42:17', '110', '2022-02-23 13:14:33', NULL, '2025-04-21 14:23:08', '0', 121);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (112, 'newobject', '$2a$04$dB0z8Q819fJWz0hbaLe6B.VfHCjYgWx6LFfET5lyz3JwcqlyCkQ4C', '新对象', NULL, 100, '[]', '', '15601691235', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2024-03-16 23:11:38', '1', '2022-02-23 19:08:03', NULL, '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (113, 'aoteman', '$2a$10$0acJOIk2D25/oC87nyclE..0lzeu9DtQ/n3geP4fkun/zIVRhHJIO', '密讯1', NULL, NULL, NULL, '', '15601691300', 0, NULL, 0, '127.0.0.1', '2022-03-19 18:38:51', '1', '2022-03-07 21:37:58', '1', '2025-05-05 15:30:53', '0', 122);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (114, 'hrmgr', '$2a$10$TR4eybBioGRhBmDBWkqWLO6NIh3mzYa8KBKDDB5woiGYFVlRAi.fu', 'hr 小姐姐', NULL, NULL, '[5]', '', '15601691236', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2024-03-24 22:21:05', '1', '2022-03-19 21:50:58', NULL, '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (115, 'aotemane', '$2a$04$GcyP0Vyzb2F2Yni5PuIK9ueGxM0tkZGMtDwVRwrNbtMvorzbpNsV2', '阿呆', '11222', 102, '[1,2]', '7648@qq.com', '15601691229', 2, NULL, 0, '', NULL, '1', '2022-04-30 02:55:43', '1', '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (117, 'admin123', '$2a$04$sEtimsHu9YCkYY4/oqElHem2Ijc9ld20eYO6lN.g/21NfLUTDLB9W', '测试号02', '1111', 100, '[2]', '', '15601691234', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2024-10-02 10:16:20', '1', '2022-07-09 17:40:26', NULL, '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (118, 'goudan', '$2a$04$jth0yOj8cSJq84D6vrzusOHDwW/LpBfgBnQ6bfFlD8zNZfM632Ta2', '狗蛋', NULL, 103, '[1]', '', '15601691239', 1, NULL, 0, '0:0:0:0:0:0:0:1', '2024-03-17 09:10:27', '1', '2022-07-09 17:44:43', '1', '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (131, 'hh', '$2a$04$jyH9h6.gaw8mpOjPfHIpx.8as2Rzfcmdlj5rlJFwgCw4rsv/MTb2K', '呵呵', NULL, 100, '[]', '777@qq.com', '15601882312', 1, NULL, 0, '', NULL, '1', '2024-04-27 08:45:56', '1', '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (139, 'wwbwwb', '$2a$04$aOHoFbQU6zfBk/1Z9raF/ugTdhjNdx7culC1HhO0zvoczAnahCiMq', '小秃头', NULL, NULL, NULL, '', '', 0, NULL, 0, '0:0:0:0:0:0:0:1', '2024-09-10 21:03:58', NULL, '2024-09-10 21:03:58', NULL, '2025-04-21 14:23:08', '0', 1);
INSERT INTO system_users (id, username, password, nickname, remark, dept_id, post_ids, email, mobile, sex, avatar, status, login_ip, login_date, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (141, 'admin1', '$2a$04$oj6F6d7HrZ70kYVD3TNzEu.m3TPUzajOVuC66zdKna8KRerK1FmVa', '新用户', NULL, NULL, NULL, '', '', 0, '', 0, '0:0:0:0:0:0:0:1', '2025-04-08 13:09:07', '1', '2025-04-08 13:09:07', '1', '2025-04-08 13:09:07', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS system_users_seq;
CREATE SEQUENCE system_users_seq
    START 142;

-- ----------------------------
-- Table structure for mitedtsm_demo01_contact
-- ----------------------------
DROP TABLE IF EXISTS mitedtsm_demo01_contact;
CREATE TABLE mitedtsm_demo01_contact
(
    id          int8         NOT NULL,
    name        varchar(100) NULL     DEFAULT '',
    sex         int2         NOT NULL,
    birthday    timestamp    NOT NULL,
    description varchar(255) NOT NULL,
    avatar      varchar(512) NULL     DEFAULT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0,
    tenant_id   int8         NOT NULL DEFAULT 0
);

ALTER TABLE mitedtsm_demo01_contact
    ADD CONSTRAINT pk_mitedtsm_demo01_contact PRIMARY KEY (id);

COMMENT ON COLUMN mitedtsm_demo01_contact.id IS '编号';
COMMENT ON COLUMN mitedtsm_demo01_contact.name IS '名字';
COMMENT ON COLUMN mitedtsm_demo01_contact.sex IS '性别';
COMMENT ON COLUMN mitedtsm_demo01_contact.birthday IS '出生年';
COMMENT ON COLUMN mitedtsm_demo01_contact.description IS '简介';
COMMENT ON COLUMN mitedtsm_demo01_contact.avatar IS '头像';
COMMENT ON COLUMN mitedtsm_demo01_contact.creator IS '创建者';
COMMENT ON COLUMN mitedtsm_demo01_contact.create_time IS '创建时间';
COMMENT ON COLUMN mitedtsm_demo01_contact.updater IS '更新者';
COMMENT ON COLUMN mitedtsm_demo01_contact.update_time IS '更新时间';
COMMENT ON COLUMN mitedtsm_demo01_contact.deleted IS '是否删除';
COMMENT ON COLUMN mitedtsm_demo01_contact.tenant_id IS '租户编号';
COMMENT ON TABLE mitedtsm_demo01_contact IS '示例联系人表';

-- ----------------------------
-- Records of mitedtsm_demo01_contact
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO mitedtsm_demo01_contact (id, name, sex, birthday, description, avatar, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1, '土豆', 2, '2023-11-07 00:00:00', '<p>天蚕土豆！呀</p>', 'http://127.0.0.1:48080/admin-api/infra/file/4/get/46f8fa1a37db3f3960d8910ff2fe3962ab3b2db87cf2f8ccb4dc8145b8bdf237.jpeg', '1', '2023-11-15 23:34:30', '1', '2023-11-15 23:47:39', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS mitedtsm_demo01_contact_seq;
CREATE SEQUENCE mitedtsm_demo01_contact_seq
    START 2;

-- ----------------------------
-- Table structure for mitedtsm_demo02_category
-- ----------------------------
DROP TABLE IF EXISTS mitedtsm_demo02_category;
CREATE TABLE mitedtsm_demo02_category
(
    id          int8         NOT NULL,
    name        varchar(100) NULL     DEFAULT '',
    parent_id   int8         NOT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0,
    tenant_id   int8         NOT NULL DEFAULT 0
);

ALTER TABLE mitedtsm_demo02_category
    ADD CONSTRAINT pk_mitedtsm_demo02_category PRIMARY KEY (id);

COMMENT ON COLUMN mitedtsm_demo02_category.id IS '编号';
COMMENT ON COLUMN mitedtsm_demo02_category.name IS '名字';
COMMENT ON COLUMN mitedtsm_demo02_category.parent_id IS '父级编号';
COMMENT ON COLUMN mitedtsm_demo02_category.creator IS '创建者';
COMMENT ON COLUMN mitedtsm_demo02_category.create_time IS '创建时间';
COMMENT ON COLUMN mitedtsm_demo02_category.updater IS '更新者';
COMMENT ON COLUMN mitedtsm_demo02_category.update_time IS '更新时间';
COMMENT ON COLUMN mitedtsm_demo02_category.deleted IS '是否删除';
COMMENT ON COLUMN mitedtsm_demo02_category.tenant_id IS '租户编号';
COMMENT ON TABLE mitedtsm_demo02_category IS '示例分类表';

-- ----------------------------
-- Records of mitedtsm_demo02_category
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO mitedtsm_demo02_category (id, name, parent_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (1, '土豆', 0, '1', '2023-11-15 23:34:30', '1', '2023-11-16 20:24:23', '0', 1);
INSERT INTO mitedtsm_demo02_category (id, name, parent_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2, '番茄', 0, '1', '2023-11-16 20:24:00', '1', '2023-11-16 20:24:15', '0', 1);
INSERT INTO mitedtsm_demo02_category (id, name, parent_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3, '怪怪', 0, '1', '2023-11-16 20:24:32', '1', '2023-11-16 20:24:32', '0', 1);
INSERT INTO mitedtsm_demo02_category (id, name, parent_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (4, '小番茄', 2, '1', '2023-11-16 20:24:39', '1', '2023-11-16 20:24:39', '0', 1);
INSERT INTO mitedtsm_demo02_category (id, name, parent_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5, '大番茄', 2, '1', '2023-11-16 20:24:46', '1', '2023-11-16 20:24:46', '0', 1);
INSERT INTO mitedtsm_demo02_category (id, name, parent_id, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6, '11', 3, '1', '2023-11-24 19:29:34', '1', '2023-11-24 19:29:34', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS mitedtsm_demo02_category_seq;
CREATE SEQUENCE mitedtsm_demo02_category_seq
    START 7;

-- ----------------------------
-- Table structure for mitedtsm_demo03_course
-- ----------------------------
DROP TABLE IF EXISTS mitedtsm_demo03_course;
CREATE TABLE mitedtsm_demo03_course
(
    id          int8         NOT NULL,
    student_id  int8         NOT NULL,
    name        varchar(100) NULL     DEFAULT '',
    score       int2         NOT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0,
    tenant_id   int8         NOT NULL DEFAULT 0
);

ALTER TABLE mitedtsm_demo03_course
    ADD CONSTRAINT pk_mitedtsm_demo03_course PRIMARY KEY (id);

COMMENT ON COLUMN mitedtsm_demo03_course.id IS '编号';
COMMENT ON COLUMN mitedtsm_demo03_course.student_id IS '学生编号';
COMMENT ON COLUMN mitedtsm_demo03_course.name IS '名字';
COMMENT ON COLUMN mitedtsm_demo03_course.score IS '分数';
COMMENT ON COLUMN mitedtsm_demo03_course.creator IS '创建者';
COMMENT ON COLUMN mitedtsm_demo03_course.create_time IS '创建时间';
COMMENT ON COLUMN mitedtsm_demo03_course.updater IS '更新者';
COMMENT ON COLUMN mitedtsm_demo03_course.update_time IS '更新时间';
COMMENT ON COLUMN mitedtsm_demo03_course.deleted IS '是否删除';
COMMENT ON COLUMN mitedtsm_demo03_course.tenant_id IS '租户编号';
COMMENT ON TABLE mitedtsm_demo03_course IS '学生课程表';

-- ----------------------------
-- Records of mitedtsm_demo03_course
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2, 2, '语文', 66, '1', '2023-11-16 23:21:49', '1', '2024-09-17 10:55:30', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (3, 2, '数学', 22, '1', '2023-11-16 23:21:49', '1', '2024-09-17 10:55:30', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (6, 5, '体育', 23, '1', '2023-11-16 23:22:46', '1', '2023-11-16 15:44:40', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (7, 5, '计算机', 11, '1', '2023-11-16 23:22:46', '1', '2023-11-16 15:44:40', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (8, 5, '体育', 23, '1', '2023-11-16 23:22:46', '1', '2023-11-16 15:47:09', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (9, 5, '计算机', 11, '1', '2023-11-16 23:22:46', '1', '2023-11-16 15:47:09', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (10, 5, '体育', 23, '1', '2023-11-16 23:22:46', '1', '2024-09-17 10:55:28', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (11, 5, '计算机', 11, '1', '2023-11-16 23:22:46', '1', '2024-09-17 10:55:28', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (12, 2, '电脑', 33, '1', '2023-11-17 00:20:42', '1', '2023-11-16 16:20:45', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (13, 9, '滑雪', 12, '1', '2023-11-17 13:13:20', '1', '2024-09-17 10:55:26', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (14, 9, '滑雪', 12, '1', '2023-11-17 13:13:20', '1', '2024-09-17 10:55:49', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (15, 5, '体育', 23, '1', '2023-11-16 23:22:46', '1', '2024-09-17 18:55:29', '0', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (16, 5, '计算机', 11, '1', '2023-11-16 23:22:46', '1', '2024-09-17 18:55:29', '0', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (17, 2, '语文', 66, '1', '2023-11-16 23:21:49', '1', '2024-09-17 18:55:31', '0', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (18, 2, '数学', 22, '1', '2023-11-16 23:21:49', '1', '2024-09-17 18:55:31', '0', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (19, 9, '滑雪', 12, '1', '2023-11-17 13:13:20', '1', '2025-04-19 02:49:03', '1', 1);
INSERT INTO mitedtsm_demo03_course (id, student_id, name, score, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (20, 9, '滑雪', 12, '1', '2023-11-17 13:13:20', '1', '2025-04-19 10:49:04', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS mitedtsm_demo03_course_seq;
CREATE SEQUENCE mitedtsm_demo03_course_seq
    START 21;

-- ----------------------------
-- Table structure for mitedtsm_demo03_grade
-- ----------------------------
DROP TABLE IF EXISTS mitedtsm_demo03_grade;
CREATE TABLE mitedtsm_demo03_grade
(
    id          int8         NOT NULL,
    student_id  int8         NOT NULL,
    name        varchar(100) NULL     DEFAULT '',
    teacher     varchar(255) NOT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0,
    tenant_id   int8         NOT NULL DEFAULT 0
);

ALTER TABLE mitedtsm_demo03_grade
    ADD CONSTRAINT pk_mitedtsm_demo03_grade PRIMARY KEY (id);

COMMENT ON COLUMN mitedtsm_demo03_grade.id IS '编号';
COMMENT ON COLUMN mitedtsm_demo03_grade.student_id IS '学生编号';
COMMENT ON COLUMN mitedtsm_demo03_grade.name IS '名字';
COMMENT ON COLUMN mitedtsm_demo03_grade.teacher IS '班主任';
COMMENT ON COLUMN mitedtsm_demo03_grade.creator IS '创建者';
COMMENT ON COLUMN mitedtsm_demo03_grade.create_time IS '创建时间';
COMMENT ON COLUMN mitedtsm_demo03_grade.updater IS '更新者';
COMMENT ON COLUMN mitedtsm_demo03_grade.update_time IS '更新时间';
COMMENT ON COLUMN mitedtsm_demo03_grade.deleted IS '是否删除';
COMMENT ON COLUMN mitedtsm_demo03_grade.tenant_id IS '租户编号';
COMMENT ON TABLE mitedtsm_demo03_grade IS '学生班级表';

-- ----------------------------
-- Records of mitedtsm_demo03_grade
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO mitedtsm_demo03_grade (id, student_id, name, teacher, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (7, 2, '三年 2 班', '周杰伦', '1', '2023-11-16 23:21:49', '1', '2024-09-17 18:55:31', '0', 1);
INSERT INTO mitedtsm_demo03_grade (id, student_id, name, teacher, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (8, 5, '华为', '遥遥领先', '1', '2023-11-16 23:22:46', '1', '2024-09-17 18:55:29', '0', 1);
INSERT INTO mitedtsm_demo03_grade (id, student_id, name, teacher, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (9, 9, '小图', '小娃111', '1', '2023-11-17 13:10:23', '1', '2025-04-19 10:49:04', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS mitedtsm_demo03_grade_seq;
CREATE SEQUENCE mitedtsm_demo03_grade_seq
    START 10;

-- ----------------------------
-- Table structure for mitedtsm_demo03_student
-- ----------------------------
DROP TABLE IF EXISTS mitedtsm_demo03_student;
CREATE TABLE mitedtsm_demo03_student
(
    id          int8         NOT NULL,
    name        varchar(100) NULL     DEFAULT '',
    sex         int2         NOT NULL,
    birthday    timestamp    NOT NULL,
    description varchar(255) NOT NULL,
    creator     varchar(64)  NULL     DEFAULT '',
    create_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updater     varchar(64)  NULL     DEFAULT '',
    update_time timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted     int2         NOT NULL DEFAULT 0,
    tenant_id   int8         NOT NULL DEFAULT 0
);

ALTER TABLE mitedtsm_demo03_student
    ADD CONSTRAINT pk_mitedtsm_demo03_student PRIMARY KEY (id);

COMMENT ON COLUMN mitedtsm_demo03_student.id IS '编号';
COMMENT ON COLUMN mitedtsm_demo03_student.name IS '名字';
COMMENT ON COLUMN mitedtsm_demo03_student.sex IS '性别';
COMMENT ON COLUMN mitedtsm_demo03_student.birthday IS '出生日期';
COMMENT ON COLUMN mitedtsm_demo03_student.description IS '简介';
COMMENT ON COLUMN mitedtsm_demo03_student.creator IS '创建者';
COMMENT ON COLUMN mitedtsm_demo03_student.create_time IS '创建时间';
COMMENT ON COLUMN mitedtsm_demo03_student.updater IS '更新者';
COMMENT ON COLUMN mitedtsm_demo03_student.update_time IS '更新时间';
COMMENT ON COLUMN mitedtsm_demo03_student.deleted IS '是否删除';
COMMENT ON COLUMN mitedtsm_demo03_student.tenant_id IS '租户编号';
COMMENT ON TABLE mitedtsm_demo03_student IS '学生表';

-- ----------------------------
-- Records of mitedtsm_demo03_student
-- ----------------------------
-- @formatter:off
BEGIN;
INSERT INTO mitedtsm_demo03_student (id, name, sex, birthday, description, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (2, '小白', 1, '2023-11-16 00:00:00', '<p>厉害</p>', '1', '2023-11-16 23:21:49', '1', '2024-09-17 18:55:31', '0', 1);
INSERT INTO mitedtsm_demo03_student (id, name, sex, birthday, description, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (5, '大黑', 2, '2023-11-13 00:00:00', '<p>你在教我做事?</p>', '1', '2023-11-16 23:22:46', '1', '2024-09-17 18:55:29', '0', 1);
INSERT INTO mitedtsm_demo03_student (id, name, sex, birthday, description, creator, create_time, updater, update_time, deleted, tenant_id) VALUES (9, '小花', 1, '2023-11-07 00:00:00', '<p>哈哈哈</p>', '1', '2023-11-17 00:04:47', '1', '2025-04-19 10:49:04', '0', 1);
COMMIT;
-- @formatter:on

DROP SEQUENCE IF EXISTS mitedtsm_demo03_student_seq;
CREATE SEQUENCE mitedtsm_demo03_student_seq
    START 10;

