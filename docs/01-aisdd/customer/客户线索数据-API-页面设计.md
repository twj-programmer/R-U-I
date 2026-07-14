# 客户线索数据/API/页面设计

---

## 文档信息

| 项目 | 内容 |
|------|------|
| 文档编号 | PKG-01-DESIGN-001 |
| 文档名称 | 客户线索数据/API/页面设计 |
| 所属任务包 | PKG-01 客户线索包 |
| 负责人员 | 刘焘玮 |
| 创建日期 | 2026-07-14 |
| 版本号 | V1.3 |

---

## 1. 数据设计

### 1.1 新增数据表

#### 1.1.1 crm_high_seas_record（公海记录表）

```sql
CREATE TABLE IF NOT EXISTS `crm_high_seas_record` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `customer_id` BIGINT NOT NULL COMMENT '客户ID',
    `action_type` VARCHAR(20) NOT NULL COMMENT '操作类型(AUTO_DROP/DROP_IN/PICK_UP)',
    `from_user_id` BIGINT NULL COMMENT '原归属人ID',
    `to_user_id` BIGINT NULL COMMENT '新归属人ID',
    `reason` VARCHAR(200) NULL COMMENT '操作原因',
    `action_time` DATETIME NOT NULL COMMENT '操作时间',
    `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (`id`),
    INDEX `idx_customer_id` (`customer_id`),
    INDEX `idx_action_time` (`action_time`),
    INDEX `idx_to_user_id` (`to_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公海记录表';
```

#### 1.1.2 crm_customer_owner_history（客户归属历史表）

```sql
CREATE TABLE IF NOT EXISTS `crm_customer_owner_history` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键',
    `customer_id` BIGINT NOT NULL COMMENT '客户ID',
    `old_owner_user_id` BIGINT NULL COMMENT '原归属人ID',
    `new_owner_user_id` BIGINT NULL COMMENT '新归属人ID',
    `change_type` VARCHAR(20) NOT NULL COMMENT '变更类型(ASSIGN/TRANSFER/PICK_UP/AUTO_DROP)',
    `change_reason` VARCHAR(200) NULL COMMENT '变更原因',
    `change_time` DATETIME NOT NULL COMMENT '变更时间',
    `operator_id` BIGINT NOT NULL COMMENT '操作人ID',
    `tenant_id` BIGINT NOT NULL COMMENT '租户ID',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
    PRIMARY KEY (`id`),
    INDEX `idx_customer_id` (`customer_id`),
    INDEX `idx_change_time` (`change_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户归属历史表';
```

### 1.2 数据对象设计

#### 1.2.1 CrmHighSeasRecordDO

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 主键 |
| customerId | Long | 客户ID |
| actionType | String | 操作类型(AUTO_DROP/DROP_IN/PICK_UP) |
| fromUserId | Long | 原归属人ID |
| toUserId | Long | 新归属人ID |
| reason | String | 操作原因 |
| actionTime | LocalDateTime | 操作时间 |
| tenantId | Long | 租户ID |
| createTime | LocalDateTime | 创建时间 |
| updateTime | LocalDateTime | 更新时间 |
| deleted | Integer | 逻辑删除 |

#### 1.2.2 CrmCustomerOwnerHistoryDO

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 主键 |
| customerId | Long | 客户ID |
| oldOwnerUserId | Long | 原归属人ID |
| newOwnerUserId | Long | 新归属人ID |
| changeType | String | 变更类型(ASSIGN/TRANSFER/PICK_UP/AUTO_DROP) |
| changeReason | String | 变更原因 |
| changeTime | LocalDateTime | 变更时间 |
| operatorId | Long | 操作人ID |
| tenantId | Long | 租户ID |
| createTime | LocalDateTime | 创建时间 |
| updateTime | LocalDateTime | 更新时间 |
| deleted | Integer | 逻辑删除 |

### 1.3 枚举设计

#### 1.3.1 HighSeasActionTypeEnum（公海操作类型）

| 值 | 说明 |
|----|------|
| AUTO_DROP | 自动掉入 |
| DROP_IN | 手动移入 |
| PICK_UP | 领取 |

#### 1.3.2 OwnerChangeTypeEnum（归属变更类型）

| 值 | 说明 |
|----|------|
| ASSIGN | 分配 |
| TRANSFER | 转移 |
| PICK_UP | 领取 |
| AUTO_DROP | 自动掉入（归属变为空） |

### 1.4 请求/响应VO设计

#### 1.4.1 CrmCustomerDuplicateCheckReqVO

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| name | String | 是 | 客户名称 |
| mobile | String | 否 | 手机号 |
| excludeCustomerId | Long | 否 | 排除的客户ID（编辑时使用） |

#### 1.4.2 CrmCustomerDuplicateCheckRespVO

| 字段 | 类型 | 说明 |
|------|------|------|
| hasDuplicate | Boolean | 是否存在相似客户 |
| duplicates | List<CrmCustomerDuplicateItemVO> | 相似客户列表 |

#### 1.4.3 CrmCustomerDuplicateItemVO

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 客户ID |
| name | String | 客户名称 |
| mobile | String | 手机号 |
| similarity | BigDecimal | 相似度(0-1) |
| ownerUserId | Long | 归属人ID |
| ownerUserName | String | 归属人名称 |
| createTime | LocalDateTime | 创建时间 |

#### 1.4.4 CrmHighSeasRecordPageReqVO

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pageNo | Integer | 是 | 页码 |
| pageSize | Integer | 是 | 每页数量 |
| customerId | Long | 否 | 客户ID |
| actionType | String | 否 | 操作类型 |
| startTime | String | 否 | 开始时间 |
| endTime | String | 否 | 结束时间 |

#### 1.4.5 CrmHighSeasRecordRespVO

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 主键 |
| customerId | Long | 客户ID |
| customerName | String | 客户名称 |
| actionType | String | 操作类型 |
| actionTypeName | String | 操作类型名称 |
| fromUserId | Long | 原归属人ID |
| fromUserName | String | 原归属人名称 |
| toUserId | Long | 新归属人ID |
| toUserName | String | 新归属人名称 |
| reason | String | 操作原因 |
| actionTime | LocalDateTime | 操作时间 |
| createTime | LocalDateTime | 创建时间 |

#### 1.4.6 CrmCustomerOwnerHistoryPageReqVO

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pageNo | Integer | 是 | 页码 |
| pageSize | Integer | 是 | 每页数量 |
| customerId | Long | 否 | 客户ID |
| changeType | String | 否 | 变更类型 |
| startTime | String | 否 | 开始时间 |
| endTime | String | 否 | 结束时间 |

#### 1.4.7 CrmCustomerOwnerHistoryRespVO

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 主键 |
| customerId | Long | 客户ID |
| oldOwnerUserId | Long | 原归属人ID |
| oldOwnerUserName | String | 原归属人名称 |
| newOwnerUserId | Long | 新归属人ID |
| newOwnerUserName | String | 新归属人名称 |
| changeType | String | 变更类型 |
| changeTypeName | String | 变更类型名称 |
| changeReason | String | 变更原因 |
| changeTime | LocalDateTime | 变更时间 |
| operatorId | Long | 操作人ID |
| operatorName | String | 操作人名称 |

#### 1.4.8 CrmCustomerCreateRespVO（扩展）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | Long | 客户ID |
| hasDuplicate | Boolean | 是否存在相似客户 |
| duplicates | List<CrmCustomerDuplicateItemVO> | 相似客户列表 |

### 1.5 错误码定义

| 错误码 | 错误信息 | 说明 |
|--------|----------|------|
| 1_021_001 | 今日领取已达上限 | 每日领取数量超过配置的上限 |
| 1_021_002 | 30天内不可重复领取同一客户 | 客户在30天内已被当前用户领取过 |
| 1_021_003 | 客户已被他人领取 | 并发领取时客户已被其他用户领取 |
| 1_021_004 | 客户有活跃商机，无法移入公海 | 客户存在进行中的商机 |
| 1_021_005 | 无权限操作该客户 | 当前用户无权限操作指定客户 |

### 1.6 数据迁移策略

#### 1.6.1 公海记录表数据迁移

**迁移时机**：新表创建后，首次启动时自动执行

**迁移逻辑**：

```
1. 查询所有客户记录
2. 对于in_sea=1（当前在公海）的客户：
   a. 判断是否有公海记录 → 无则插入
   b. 插入记录类型：
      - owner_user_id为空且in_sea=1：AUTO_DROP（自动掉入）
      - owner_user_id为空且in_sea=1：DROP_IN（手动移入，需判断）
3. 对于in_sea=0（不在公海）的客户：
   a. 暂不迁移，后续操作时自动记录
```

**迁移脚本**：

```sql
-- 迁移当前在公海的客户记录
INSERT INTO crm_high_seas_record (customer_id, action_type, from_user_id, to_user_id, reason, action_time, tenant_id)
SELECT 
    id AS customer_id,
    'AUTO_DROP' AS action_type,
    owner_user_id AS from_user_id,
    NULL AS to_user_id,
    '系统初始化迁移' AS reason,
    create_time AS action_time,
    tenant_id
FROM crm_customer 
WHERE in_sea = 1 AND deleted = 0
AND NOT EXISTS (SELECT 1 FROM crm_high_seas_record r WHERE r.customer_id = crm_customer.id);
```

#### 1.6.2 归属历史表数据迁移

**迁移时机**：新表创建后，首次启动时自动执行

**迁移逻辑**：

```
1. 查询所有客户记录
2. 对于有归属人的客户（owner_user_id不为空）：
   a. 判断是否有归属历史记录 → 无则插入初始记录
   b. 插入记录类型：ASSIGN（分配）
   c. 操作人：创建人或系统用户
3. 对于无归属人但在公海的客户：
   a. 插入AUTO_DROP类型记录
```

**迁移脚本**：

```sql
-- 迁移有归属人的客户初始归属记录
INSERT INTO crm_customer_owner_history (customer_id, old_owner_user_id, new_owner_user_id, change_type, change_reason, change_time, operator_id, tenant_id)
SELECT 
    id AS customer_id,
    NULL AS old_owner_user_id,
    owner_user_id AS new_owner_user_id,
    'ASSIGN' AS change_type,
    '系统初始化迁移' AS change_reason,
    create_time AS change_time,
    creator_id AS operator_id,
    tenant_id
FROM crm_customer 
WHERE owner_user_id IS NOT NULL AND deleted = 0
AND NOT EXISTS (SELECT 1 FROM crm_customer_owner_history h WHERE h.customer_id = crm_customer.id);

-- 迁移无归属人但在公海的客户记录
INSERT INTO crm_customer_owner_history (customer_id, old_owner_user_id, new_owner_user_id, change_type, change_reason, change_time, operator_id, tenant_id)
SELECT 
    id AS customer_id,
    owner_user_id AS old_owner_user_id,
    NULL AS new_owner_user_id,
    'AUTO_DROP' AS change_type,
    '系统初始化迁移' AS change_reason,
    create_time AS change_time,
    creator_id AS operator_id,
    tenant_id
FROM crm_customer 
WHERE in_sea = 1 AND owner_user_id IS NULL AND deleted = 0
AND NOT EXISTS (SELECT 1 FROM crm_customer_owner_history h WHERE h.customer_id = crm_customer.id);
```

---

## 2. API设计

### 2.1 公海记录API

| API路径 | HTTP方法 | 说明 | 权限 |
|---------|----------|------|------|
| `/crm/high-seas-record/page` | GET | 公海记录分页查询 | `crm:high-seas-record:query` |
| `/crm/high-seas-record/{id}` | GET | 查询单条公海记录 | `crm:high-seas-record:query` |
| `/crm/high-seas-record/list-by-customer` | GET | 按客户查询公海记录列表 | `crm:high-seas-record:query` |

#### 2.1.1 GET /crm/high-seas-record/page

**请求参数**：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pageNo | Integer | 是 | 页码 |
| pageSize | Integer | 是 | 每页数量 |
| customerId | Long | 否 | 客户ID |
| actionType | String | 否 | 操作类型(AUTO_DROP/DROP_IN/PICK_UP) |
| startTime | String | 否 | 开始时间(yyyy-MM-dd HH:mm:ss) |
| endTime | String | 否 | 结束时间(yyyy-MM-dd HH:mm:ss) |

**响应参数**：

```json
{
  "code": 0,
  "data": {
    "list": [
      {
        "id": 1,
        "customerId": 100,
        "customerName": "客户名称",
        "actionType": "AUTO_DROP",
        "actionTypeName": "自动掉入",
        "fromUserId": 10,
        "fromUserName": "张三",
        "toUserId": null,
        "toUserName": null,
        "reason": "超过30天未跟进",
        "actionTime": "2026-07-14 02:00:00",
        "createTime": "2026-07-14 02:00:00"
      }
    ],
    "total": 100,
    "pageNo": 1,
    "pageSize": 10
  }
}
```

#### 2.1.2 GET /crm/high-seas-record/{id}

**请求参数**：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Long | 是 | 公海记录ID（路径参数） |

**响应参数**：

```json
{
  "code": 0,
  "data": {
    "id": 1,
    "customerId": 100,
    "customerName": "客户名称",
    "actionType": "AUTO_DROP",
    "actionTypeName": "自动掉入",
    "fromUserId": 10,
    "fromUserName": "张三",
    "toUserId": null,
    "toUserName": null,
    "reason": "超过30天未跟进",
    "actionTime": "2026-07-14 02:00:00",
    "createTime": "2026-07-14 02:00:00"
  }
}
```

#### 2.1.3 GET /crm/high-seas-record/list-by-customer

**请求参数**：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| customerId | Long | 是 | 客户ID |

**响应参数**：

```json
{
  "code": 0,
  "data": [
    {
      "id": 1,
      "customerId": 100,
      "actionType": "AUTO_DROP",
      "actionTypeName": "自动掉入",
      "fromUserId": 10,
      "toUserId": null,
      "reason": "超过30天未跟进",
      "actionTime": "2026-07-14 02:00:00"
    }
  ]
}
```

### 2.2 客户查重API

| API路径 | HTTP方法 | 说明 | 权限 |
|---------|----------|------|------|
| `/crm/customer/check-duplicate` | POST | 客户查重 | `crm:customer:check-duplicate` |

#### 2.2.1 POST /crm/customer/check-duplicate

**请求参数**：

```json
{
  "name": "客户名称",
  "mobile": "13800138000",
  "excludeCustomerId": null
}
```

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| name | String | 是 | 客户名称 |
| mobile | String | 否 | 手机号 |
| excludeCustomerId | Long | 否 | 排除的客户ID（编辑时使用） |

**响应参数**：

```json
{
  "code": 0,
  "data": {
    "hasDuplicate": true,
    "duplicates": [
      {
        "id": 123,
        "name": "相似客户名称",
        "mobile": "13800138000",
        "similarity": 0.85,
        "ownerUserId": 10,
        "ownerUserName": "张三",
        "createTime": "2026-07-10 10:00:00"
      }
    ]
  }
}
```

### 2.3 归属历史API

| API路径 | HTTP方法 | 说明 | 权限 |
|---------|----------|------|------|
| `/crm/customer-owner-history/list` | GET | 按客户查询归属历史 | `crm:customer-owner-history:query` |
| `/crm/customer-owner-history/page` | GET | 归属历史分页查询 | `crm:customer-owner-history:query` |

#### 2.3.1 GET /crm/customer-owner-history/list

**请求参数**：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| customerId | Long | 是 | 客户ID |

**响应参数**：

```json
{
  "code": 0,
  "data": [
    {
      "id": 1,
      "customerId": 100,
      "oldOwnerUserId": 10,
      "oldOwnerUserName": "张三",
      "newOwnerUserId": 20,
      "newOwnerUserName": "李四",
      "changeType": "TRANSFER",
      "changeTypeName": "转移",
      "changeReason": "部门调整",
      "changeTime": "2026-07-14 10:00:00",
      "operatorId": 30,
      "operatorName": "王五"
    }
  ]
}
```

#### 2.3.2 GET /crm/customer-owner-history/page

**请求参数**：

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| pageNo | Integer | 是 | 页码 |
| pageSize | Integer | 是 | 每页数量 |
| customerId | Long | 否 | 客户ID |
| changeType | String | 否 | 变更类型(ASSIGN/TRANSFER/PICK_UP/AUTO_DROP) |
| startTime | String | 否 | 开始时间(yyyy-MM-dd HH:mm:ss) |
| endTime | String | 否 | 结束时间(yyyy-MM-dd HH:mm:ss) |

**响应参数**：

```json
{
  "code": 0,
  "data": {
    "list": [
      {
        "id": 1,
        "customerId": 100,
        "oldOwnerUserId": 10,
        "oldOwnerUserName": "张三",
        "newOwnerUserId": 20,
        "newOwnerUserName": "李四",
        "changeType": "TRANSFER",
        "changeTypeName": "转移",
        "changeReason": "部门调整",
        "changeTime": "2026-07-14 10:00:00",
        "operatorId": 30,
        "operatorName": "王五"
      }
    ],
    "total": 50,
    "pageNo": 1,
    "pageSize": 10
  }
}
```

### 2.4 定时任务设计（GAP-001）

#### 2.4.1 CrmCustomerAutoDropPoolJob

**任务名称**：客户自动掉入公海任务

**执行时间**：每日凌晨2:00（可配置）

**触发方式**：Spring `@Scheduled` 注解或 XXL-JOB

**任务类设计**：

| 类名 | 方法名 | 说明 |
|------|--------|------|
| CrmCustomerAutoDropPoolJob | execute() | 执行自动掉入公海逻辑 |
| CrmCustomerAutoDropPoolJob | executeByTenant(Long tenantId) | 按租户执行自动掉入 |

**执行逻辑**：

```
1. 获取公海配置（保护期天数）
2. 查询所有租户列表
3. 遍历租户，按租户执行：
   a. 查询超过保护期且未跟进的客户
   b. 过滤已成交/已锁定客户（保护条件）
   c. 分批处理客户（每批500条）
   d. 更新客户状态（in_sea=1, owner_user_id=NULL）
   e. 插入公海记录（AUTO_DROP类型）
   f. 插入归属历史（AUTO_DROP类型）
   g. 发布领域事件通知原归属人
```

**通知机制**：

| 通知方式 | 说明 |
|----------|------|
| 站内信 | 发送到原归属人消息中心 |
| 邮件 | 可选，配置开启后发送邮件通知 |

**领域事件**：

| 事件名称 | 说明 | 触发时机 |
|----------|------|----------|
| CustomerDroppedToPoolEvent | 客户自动掉入公海 | 定时任务执行完成后 |

### 2.5 现有API扩展设计

#### 2.5.1 POST /crm/customer/receive（扩展）

**原接口功能**：从公海领取客户

**扩展功能**：

| 扩展点 | 说明 | 实现方式 |
|--------|------|----------|
| 每日领取上限校验 | 每日领取数量≤10（可配置） | 在原有逻辑前增加校验 |
| 防重复领取校验 | 30天内不可重复领取同一客户 | 查询公海记录判断 |
| 并发控制 | 乐观锁+分布式锁 | 更新时校验version字段 |

**新增校验逻辑**：

```
1. 查询今日已领取数量 → 超过上限则返回错误(1_021_001)
2. 查询30天内是否领取过该客户 → 已领取则返回错误(1_021_002)
3. 使用Redisson分布式锁锁定客户ID
4. 查询客户当前version和状态
5. 更新客户归属（带version条件）→ 更新失败则返回错误(1_021_003)
6. 释放分布式锁
7. 插入公海记录（PICK_UP类型）
8. 插入归属历史（PICK_UP类型）
```

**请求参数**：（保持原有参数不变）

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| ids | List<Long> | 是 | 客户ID列表 |

**响应参数**：（保持原有参数不变）

```json
{
  "code": 0,
  "data": {
    "successCount": 1,
    "failCount": 0,
    "failMessages": []
  }
}
```

**错误码**：

| 错误码 | 说明 |
|--------|------|
| 1_021_001 | 今日领取已达上限 |
| 1_021_002 | 30天内不可重复领取同一客户 |
| 1_021_003 | 客户已被他人领取 |

#### 2.5.2 POST /crm/customer/put-pool（扩展）

**原接口功能**：将客户放入公海

**扩展功能**：

| 扩展点 | 说明 | 实现方式 |
|--------|------|----------|
| 活跃商机校验 | 有进行中商机时禁止移入 | 查询客户关联商机状态 |
| 销售经理权限 | 可移入下属客户 | 检查用户与客户归属人的层级关系 |
| 通知机制 | 移入后通知原归属人 | 发布领域事件，消息中心处理 |

**新增校验逻辑**：

```
1. 查询客户下是否有进行中商机 → 有则返回错误(1_021_004)
2. 检查操作权限：
   - 本人客户：直接操作
   - 下属客户（销售经理）：允许操作
   - 其他客户：返回错误(1_021_005)
3. 更新客户状态（in_sea=1, owner_user_id=NULL）
4. 插入公海记录（DROP_IN类型）
5. 插入归属历史（AUTO_DROP类型）
6. 发布领域事件通知原归属人
```

**请求参数**：（保持原有参数不变）

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| id | Long | 是 | 客户ID |

**响应参数**：（保持原有参数不变）

```json
{
  "code": 0,
  "data": null
}
```

**错误码**：

| 错误码 | 说明 |
|--------|------|
| 1_021_004 | 客户有活跃商机，无法移入公海 |
| 1_021_005 | 无权限操作该客户 |

#### 2.5.3 POST /crm/customer/create（扩展）

**原接口功能**：创建客户

**扩展功能**：

| 扩展点 | 说明 | 实现方式 |
|--------|------|----------|
| 创建时查重 | 自动检测相似客户 | 创建前调用查重服务 |

**新增逻辑**：

```
1. 调用查重服务检查相似客户
2. 有相似客户时：
   - 返回相似客户信息（hasDuplicate=true）
   - 前端弹出确认提示
   - 用户确认后继续创建
3. 无相似客户时：
   - 直接创建客户
   - 返回hasDuplicate=false
```

**请求参数**：（保持原有参数不变）

**响应参数**：（扩展原有响应，增加相似客户信息）

```json
{
  "code": 0,
  "data": {
    "id": 100,
    "hasDuplicate": true,
    "duplicates": [
      {
        "id": 123,
        "name": "相似客户名称",
        "mobile": "13800138000",
        "similarity": 0.85,
        "ownerUserName": "张三"
      }
    ]
  }
}
```

---

## 3. 页面设计

### 3.1 客户查重弹窗

#### 3.1.1 组件名称

`CustomerDuplicateCheckModal.vue`

#### 3.1.2 功能说明

- 创建客户时，输入名称+手机后自动触发查重
- 显示相似客户列表，包含相似度、归属人等信息
- 用户可选择继续创建或取消

#### 3.1.3 界面设计

```
┌─────────────────────────────────────────┐
│         客户查重确认                      │
├─────────────────────────────────────────┤
│  检测到以下相似客户：                     │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ 名称          │ 相似度 │ 归属人   │   │
│  ├──────────────────────────────────┤   │
│  │ 相似客户A     │ 90%    │ 张三     │   │
│  │ 相似客户B     │ 85%    │ 李四     │   │
│  └──────────────────────────────────┘   │
│                                         │
│  是否继续创建？                          │
│                                         │
│         [取消]          [继续创建]       │
└─────────────────────────────────────────┘
```

#### 3.1.4 交互逻辑

1. 用户在客户表单输入名称和手机后，失去焦点时自动调用 `/crm/customer/check-duplicate` 接口
2. 若返回 `hasDuplicate=true`，弹出确认弹窗显示相似客户列表
3. 用户点击"继续创建"，提交表单到 `/crm/customer/create`
4. 用户点击"取消"，关闭弹窗停留在表单页面

#### 3.1.5 前端API定义

```typescript
// frontend/api/duplicate-check.ts
export const checkDuplicate = async (data: {
  name: string
  mobile?: string
  excludeCustomerId?: number
}) => {
  return await request.post({ url: '/crm/customer/check-duplicate', data })
}
```

### 3.2 归属历史Tab

#### 3.2.1 组件名称

`OwnerHistoryTab.vue`

#### 3.2.2 功能说明

- 在客户详情页添加"归属历史"Tab
- 显示客户归属变更历史，按时间倒序排列
- 显示变更前后的归属人、变更类型、变更原因和操作人

#### 3.2.3 界面设计

```
┌────────────────────────────────────────────────────────────┐
│  基本信息 | 联系人 | 归属历史 | 跟进记录 | 相关商机        │
├────────────────────────────────────────────────────────────┤
│                                                           │
│  ┌────────────────────────────────────────────────────┐    │
│  │ 变更时间       │ 变更类型 | 原归属人 | 新归属人 | 操作人│    │
│  ├────────────────────────────────────────────────────┤    │
│  │ 2026-07-14    │ 转移     │ 张三     │ 李四     │ 王五 │    │
│  │ 2026-07-10    │ 分配     │ -        │ 张三     │ 赵六 │    │
│  │ 2026-07-05    │ 领取     │ 公海     │ 张三     │ 张三 │    │
│  └────────────────────────────────────────────────────┘    │
│                                                           │
└────────────────────────────────────────────────────────────┘
```

#### 3.2.4 交互逻辑

1. 客户详情页加载时，自动调用 `/crm/customer-owner-history/list?customerId={id}` 接口
2. 返回数据按 `changeTime` 倒序排列显示
3. 变更类型使用标签展示：分配(蓝色)、转移(橙色)、领取(绿色)、自动掉入(灰色)
4. 原归属人或新归属人为空时显示"-"或"公海"

#### 3.2.5 前端API定义

```typescript
// frontend/api/owner-history.ts
export const getOwnerHistoryList = async (customerId: number) => {
  return await request.get({ url: '/crm/customer-owner-history/list', params: { customerId } })
}

export const getOwnerHistoryPage = async (params: {
  pageNo: number
  pageSize: number
  customerId?: number
  changeType?: string
  startTime?: string
  endTime?: string
}) => {
  return await request.get({ url: '/crm/customer-owner-history/page', params })
}
```

### 3.3 公海记录页面（扩展）

#### 3.3.1 页面位置

`Web/src/views/crm/customer/pool/index.vue`

#### 3.3.2 扩展功能

在公海池页面增加操作日志Tab：

```
┌────────────────────────────────────────────────────────────┐
│  公海客户列表 | 操作日志                                   │
├────────────────────────────────────────────────────────────┤
│                                                           │
│  操作日志Tab内容：                                         │
│  ┌────────────────────────────────────────────────────┐    │
│  │ 客户名称 | 操作类型 | 操作人 | 操作时间 | 原因       │    │
│  ├────────────────────────────────────────────────────┤    │
│  │ 客户A    │ 自动掉入 | 系统   │ 02:00    │ 超30天未跟进│    │
│  │ 客户B    │ 领取     │ 张三   │ 10:30    │ -          │    │
│  └────────────────────────────────────────────────────┘    │
│                                                           │
└────────────────────────────────────────────────────────────┘
```

#### 3.3.3 前端API定义

```typescript
// frontend/api/pool.ts
export const getHighSeasRecordPage = async (params: {
  pageNo: number
  pageSize: number
  customerId?: number
  actionType?: string
  startTime?: string
  endTime?: string
}) => {
  return await request.get({ url: '/crm/high-seas-record/page', params })
}

export const getHighSeasRecordByCustomer = async (customerId: number) => {
  return await request.get({ url: '/crm/high-seas-record/list-by-customer', params: { customerId } })
}

export const getHighSeasRecordById = async (id: number) => {
  return await request.get({ url: `/crm/high-seas-record/${id}` })
}
```

---

## 4. 权限设计

### 4.1 权限点定义

| 权限标识 | 说明 | 所属模块 |
|----------|------|----------|
| `crm:customer:check-duplicate` | 客户查重 | 客户管理 |
| `crm:high-seas-record:query` | 公海记录查询 | 公海管理 |
| `crm:customer-owner-history:query` | 归属历史查询 | 客户管理 |

### 4.2 权限分配

| 角色 | 权限 |
|------|------|
| 系统管理员 | 全部权限 |
| 销售经理 | `crm:customer:check-duplicate`, `crm:high-seas-record:query`, `crm:customer-owner-history:query` |
| 销售代表 | `crm:customer:check-duplicate`, `crm:high-seas-record:query`, `crm:customer-owner-history:query` |

### 4.3 数据权限

| 模块 | 数据权限规则 |
|------|-------------|
| 公海记录 | 只能查看本租户数据 |
| 归属历史 | 只能查看本租户数据 |

---

## 5. 测试设计

### 5.1 单元测试

#### 5.1.1 CrmHighSeasRecordServiceTest

| 测试用例 | 说明 |
|----------|------|
| testCreateRecord_AutoDrop | 创建自动掉入记录 |
| testCreateRecord_DropIn | 创建手动移入记录 |
| testCreateRecord_PickUp | 创建领取记录 |
| testQueryByCustomerId | 按客户ID查询记录 |
| testQueryPage | 分页查询记录 |

#### 5.1.2 CrmCustomerOwnerHistoryServiceTest

| 测试用例 | 说明 |
|----------|------|
| testCreateHistory_Assign | 创建分配记录 |
| testCreateHistory_Transfer | 创建转移记录 |
| testCreateHistory_PickUp | 创建领取记录 |
| testCreateHistory_AutoDrop | 创建自动掉入记录 |
| testQueryByCustomerId | 按客户ID查询历史 |

#### 5.1.3 CrmCustomerDuplicateCheckServiceTest

| 测试用例 | 说明 |
|----------|------|
| testCheckDuplicate_ExactMatch | 名称完全相同+手机相同 |
| testCheckDuplicate_NameSimilar | 名称相似度80%+手机相同 |
| testCheckDuplicate_NameSimilarLow | 名称相似度70%+手机相同（不提示） |
| testCheckDuplicate_OnlyNameMatch | 名称完全相同，手机不同 |
| testCheckDuplicate_ExcludeCurrent | 排除当前客户（编辑场景） |
| testCheckDuplicate_NoMatch | 无相似客户 |

#### 5.1.4 CrmCustomerAutoDropPoolJobTest

| 测试用例 | 说明 |
|----------|------|
| testExecute_NormalDrop | 正常掉入公海 |
| testExecute_WithinProtection | 保护期内不掉入 |
| testExecute_ProtectedCustomer | 已成交客户不掉入 |

### 5.2 接口测试

| 测试用例 | API | 说明 |
|----------|-----|------|
| IT-01 | POST /crm/customer/check-duplicate | 正常查重 |
| IT-02 | POST /crm/customer/check-duplicate | 无相似客户 |
| IT-03 | POST /crm/customer/check-duplicate | 缺少必填参数 |
| IT-04 | GET /crm/high-seas-record/page | 分页查询公海记录 |
| IT-05 | GET /crm/high-seas-record/{id} | 查询单条记录 |
| IT-06 | GET /crm/high-seas-record/list-by-customer | 按客户查询 |
| IT-07 | GET /crm/customer-owner-history/list | 查询归属历史 |
| IT-08 | GET /crm/customer-owner-history/page | 分页查询归属历史 |
| IT-09 | POST /crm/customer/receive | 正常领取 |
| IT-10 | POST /crm/customer/receive | 今日领取已达上限 |
| IT-11 | POST /crm/customer/receive | 30天内重复领取 |
| IT-12 | POST /crm/customer/put-pool | 正常移入公海 |
| IT-13 | POST /crm/customer/put-pool | 有活跃商机禁止移入 |
| IT-14 | POST /crm/customer/put-pool | 无权限操作 |

### 5.3 功能测试

| 测试用例 | 模块 | 说明 |
|----------|------|------|
| FT-01 | 客户查重 | 创建客户时检测到相似客户，弹出确认框 |
| FT-02 | 客户查重 | 创建客户时无相似客户，直接创建 |
| FT-03 | 客户查重 | 确认后继续创建相似客户 |
| FT-04 | 归属历史 | 客户分配后产生归属历史记录 |
| FT-05 | 归属历史 | 客户转移后产生归属历史记录 |
| FT-06 | 归属历史 | 客户领取后产生归属历史记录 |
| FT-07 | 归属历史 | 客户自动掉入公海后产生归属历史记录 |
| FT-08 | 公海记录 | 客户自动掉入公海产生记录 |
| FT-09 | 公海记录 | 客户领取产生记录 |
| FT-10 | 公海记录 | 客户手动移入公海产生记录 |

---

## 6. 代码组织

### 6.1 代码独立性设计

为确保新增代码与本体开发源码尽可能独立，采用以下设计策略：

| 策略 | 应用场景 | 说明 |
|------|----------|------|
| 独立模块 | 公海记录、归属历史、客户查重 | 新增独立的DO/Mapper/Service/Controller，不修改现有代码 |
| AOP切面增强 | 领取客户、放入公海 | 通过切面在现有方法执行前后插入扩展逻辑，不修改原方法 |
| 事件监听 | 客户归属变更 | 发布领域事件，由独立监听器记录归属历史 |
| 独立Controller | 公海记录查询、归属历史查询 | 新增独立Controller，不侵入现有Controller |
| 包装模式 | 定时任务 | 包装现有定时任务，添加记录逻辑 |

#### 6.1.1 AOP切面增强设计

**切面类**：`CrmCustomerOperationAspect.java`

| 切入点 | 注解 | 增强逻辑 |
|--------|------|----------|
| `receiveCustomer()` | `@Pointcut("execution(* com.meession.etm.module.crm.service.customer.CrmCustomerService.receiveCustomer(..))")` | 领取前校验每日上限和防重复，领取后记录公海记录和归属历史 |
| `putCustomerPool(Long)` | `@Pointcut("execution(* com.meession.etm.module.crm.service.customer.CrmCustomerService.putCustomerPool(Long))")` | 放入前校验活跃商机，放入后记录公海记录和归属历史 |

**执行顺序**：

```
领取客户流程：
1. AOP前置通知 → 校验每日领取上限 → 校验30天内是否重复领取 → 加分布式锁
2. 执行原有receiveCustomer()方法
3. AOP后置通知 → 释放分布式锁 → 插入公海记录(PICK_UP) → 插入归属历史(PICK_UP)

放入公海流程：
1. AOP前置通知 → 校验客户是否有活跃商机 → 校验操作权限
2. 执行原有putCustomerPool()方法
3. AOP后置通知 → 插入公海记录(DROP_IN) → 插入归属历史(AUTO_DROP) → 发布通知事件
```

#### 6.1.2 事件监听设计

**领域事件**：

| 事件名称 | 触发时机 | 监听器 |
|----------|----------|--------|
| `CrmCustomerOwnerChangedEvent` | 客户归属变更时 | `CrmCustomerOwnerHistoryListener` |
| `CrmCustomerDroppedToPoolEvent` | 客户掉入公海时 | `CrmCustomerDropPoolNotifyListener` |

**监听器职责**：

| 监听器 | 职责 |
|--------|------|
| `CrmCustomerOwnerHistoryListener` | 监听归属变更事件，插入归属历史记录 |
| `CrmCustomerDropPoolNotifyListener` | 监听掉入公海事件，发送站内信/邮件通知 |

#### 6.1.3 定时任务包装设计

**包装类**：`CrmCustomerAutoDropPoolJobWrapper.java`

```
包装逻辑：
1. 调用原有CrmCustomerAutoPutPoolJob.execute()方法
2. 获取掉入公海的客户数量
3. 遍历客户记录，插入公海记录(AUTO_DROP)和归属历史(AUTO_DROP)
4. 发布CrmCustomerDroppedToPoolEvent事件
5. 返回执行结果
```

#### 6.1.4 配置类设计

**配置类**：`CrmCustomerExtensionConfiguration.java`

**配置项**：

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| crm.customer.extension.enable | Boolean | true | 是否启用扩展功能 |
| crm.customer.extension.pool.daily-receive-limit | Integer | 10 | 每日领取上限 |
| crm.customer.extension.pool.receive-cool-down-days | Integer | 30 | 重复领取冷却天数 |
| crm.customer.extension.pool.protection-days | Integer | 30 | 公海保护期天数 |
| crm.customer.extension.duplicate-check.similarity-threshold | BigDecimal | 0.8 | 相似度阈值(0-1) |
| crm.customer.extension.duplicate-check.enable-mobile-exact-match | Boolean | true | 是否启用手机号精确匹配 |
| crm.customer.extension.notify.enable | Boolean | true | 是否启用通知 |
| crm.customer.extension.notify.email.enable | Boolean | false | 是否启用邮件通知 |

**配置文件示例**：

```yaml
crm:
  customer:
    extension:
      enable: true
      pool:
        daily-receive-limit: 10
        receive-cool-down-days: 30
        protection-days: 30
      duplicate-check:
        similarity-threshold: 0.8
        enable-mobile-exact-match: true
      notify:
        enable: true
        email:
          enable: false
```

#### 6.1.5 缓存策略

| 缓存项 | 缓存Key | 过期时间 | 说明 |
|--------|---------|----------|------|
| 每日领取数量 | `crm:customer:receive:daily:{userId}:{date}` | 24小时 | 记录每日领取次数 |
| 重复领取冷却 | `crm:customer:receive:cool-down:{userId}:{customerId}` | 30天 | 记录30天内领取记录 |
| 客户查重结果 | `crm:customer:duplicate:{nameHash}:{mobileHash}` | 5分钟 | 缓存查重结果 |

**缓存操作策略**：

```
领取客户流程缓存操作：
1. 前置通知：查询缓存（每日领取数量、重复领取冷却）
2. 领取成功：更新缓存（增加每日领取数量、设置冷却缓存）
3. 领取失败：不更新缓存

客户查重缓存操作：
1. 查询缓存 → 命中则直接返回
2. 未命中 → 执行数据库查询 → 更新缓存 → 返回结果
```

#### 6.1.6 全局异常处理

**异常处理类**：`CrmCustomerExtensionExceptionHandler.java`

**处理的异常类型**：

| 异常类型 | HTTP状态码 | 错误码 | 说明 |
|----------|-----------|--------|------|
| `CrmCustomerReceiveLimitException` | 400 | 1_021_001 | 每日领取已达上限 |
| `CrmCustomerReceiveCoolDownException` | 400 | 1_021_002 | 30天内不可重复领取 |
| `CrmCustomerAlreadyReceivedException` | 400 | 1_021_003 | 客户已被他人领取 |
| `CrmCustomerActiveBusinessException` | 400 | 1_021_004 | 客户有活跃商机 |
| `CrmCustomerPermissionDeniedException` | 403 | 1_021_005 | 无权限操作 |

**异常响应格式**：

```json
{
  "code": 1_021_001,
  "message": "今日领取已达上限",
  "data": null
}
```

### 6.2 后端代码结构

```
PKG-01/backend/
├── pool/                                    # 公海模块
│   ├── CrmHighSeasRecordDO.java             # 公海记录DO
│   ├── CrmHighSeasRecordMapper.java         # 公海记录Mapper接口
│   ├── CrmHighSeasRecordMapper.xml          # 公海记录Mapper XML
│   ├── CrmHighSeasRecordService.java        # 公海记录Service接口
│   ├── CrmHighSeasRecordServiceImpl.java    # 公海记录Service实现
│   ├── CrmHighSeasRecordController.java     # 公海记录Controller
│   ├── CrmCustomerAutoDropPoolJobWrapper.java # 定时任务包装类（不修改原有Job）
│   ├── HighSeasActionTypeEnum.java          # 操作类型枚举
│   └── bo/                                  # BO层
│       └── CrmHighSeasRecordCreateBO.java   # 创建公海记录BO
├── duplicate-check/                         # 客户查重模块
│   ├── CrmCustomerDuplicateCheckService.java        # 查重Service接口
│   ├── CrmCustomerDuplicateCheckServiceImpl.java    # 查重Service实现
│   ├── CrmCustomerDuplicateCheckController.java     # 查重Controller（独立接口）
│   ├── CrmCustomerDuplicateCheckReqVO.java         # 查重请求VO
│   ├── CrmCustomerDuplicateCheckRespVO.java        # 查重响应VO
│   └── bo/                                          # BO层
│       └── CrmCustomerDuplicateCheckBO.java        # 查重BO
├── owner-history/                           # 归属历史模块
│   ├── CrmCustomerOwnerHistoryDO.java             # 归属历史DO
│   ├── CrmCustomerOwnerHistoryMapper.java         # 归属历史Mapper接口
│   ├── CrmCustomerOwnerHistoryMapper.xml          # 归属历史Mapper XML
│   ├── CrmCustomerOwnerHistoryService.java        # 归属历史Service接口
│   ├── CrmCustomerOwnerHistoryServiceImpl.java    # 归属历史Service实现
│   ├── CrmCustomerOwnerHistoryController.java     # 归属历史Controller（独立接口）
│   ├── OwnerChangeTypeEnum.java                   # 变更类型枚举
│   └── bo/                                        # BO层
│       └── CrmCustomerOwnerHistoryCreateBO.java   # 创建归属历史BO
├── aspect/                                  # AOP切面（不修改原有Service）
│   └── CrmCustomerOperationAspect.java           # 客户操作切面增强（领取/放入公海）
├── event/                                   # 领域事件（解耦）
│   ├── CrmCustomerOwnerChangedEvent.java          # 客户归属变更事件
│   ├── CrmCustomerDroppedToPoolEvent.java         # 客户掉入公海事件
│   └── listener/                                # 事件监听器
│       ├── CrmCustomerOwnerHistoryListener.java   # 归属历史记录监听器
│       └── CrmCustomerDropPoolNotifyListener.java # 掉入公海通知监听器
├── config/                                  # 配置类
│   ├── CrmCustomerExtensionConfiguration.java     # 扩展功能配置（开关控制）
│   └── CrmCustomerExtensionProperties.java        # 配置属性类（@ConfigurationProperties）
├── exception/                               # 自定义异常
│   ├── CrmCustomerReceiveLimitException.java      # 每日领取上限异常
│   ├── CrmCustomerReceiveCoolDownException.java   # 重复领取冷却异常
│   ├── CrmCustomerAlreadyReceivedException.java   # 客户已被领取异常
│   ├── CrmCustomerActiveBusinessException.java    # 活跃商机异常
│   ├── CrmCustomerPermissionDeniedException.java  # 权限拒绝异常
│   └── CrmCustomerExtensionExceptionHandler.java  # 全局异常处理器
└── migration/                               # 数据迁移
    └── CrmCustomerExtensionDataMigration.java     # 数据迁移组件（首次启动自动执行）
```

### 6.3 前端代码结构

```
PKG-01/frontend/
├── api/                                     # API接口定义
│   ├── pool.ts                              # 公海模块API
│   ├── duplicate-check.ts                   # 查重模块API
│   └── owner-history.ts                     # 归属历史模块API
└── components/                              # 组件
    ├── CustomerDuplicateCheckModal.vue      # 客户线索查重弹窗
    └── OwnerHistoryTab.vue                  # 归属历史Tab
```

### 6.4 SQL脚本结构

```
PKG-01/sql/
└── ddl/                                     # DDL语句
    ├── crm_high_seas_record.sql             # 公海记录表DDL
    └── crm_customer_owner_history.sql       # 归属历史表DDL
```

---

## 7. 差距项设计对照表

| GAP | 差距项 | 数据设计 | API设计 | 页面设计 | 测试设计 |
|-----|--------|----------|----------|----------|----------|
| GAP-001 | 客户自动掉入公海（定时任务） | ✅ crm_high_seas_record | ✅ CrmCustomerAutoDropPoolJobWrapper | ✅ 公海记录页面 | ✅ 单元测试 |
| GAP-002 | 从公海领取客户（含领取上限） | ✅ crm_high_seas_record | ✅ 扩展receive接口 | ✅ 公海记录页面 | ✅ 接口测试 |
| GAP-003 | 手动移入公海 | ✅ crm_high_seas_record | ✅ 扩展put-pool接口 | ✅ 公海记录页面 | ✅ 接口测试 |
| GAP-004 | 客户查重（名称模糊+手机精确） | ✅ 查重VO | ✅ /crm/customer/check-duplicate | ✅ CustomerDuplicateCheckModal | ✅ 单元测试 |
| GAP-005 | 创建客户时查重提示 | ✅ 查重VO | ✅ 扩展create接口 | ✅ CustomerDuplicateCheckModal | ✅ 功能测试 |
| GAP-006 | 公海记录表 | ✅ crm_high_seas_record | ✅ high-seas-record API | ✅ 公海记录页面 | ✅ 单元测试 |
| GAP-007 | 归属历史查询 | ✅ crm_customer_owner_history | ✅ customer-owner-history API | ✅ OwnerHistoryTab | ✅ 单元测试 |

---

> **文档版本**: V1.3  
> **创建人**: 刘焘玮  
> **创建日期**: 2026-07-14  
> **修订说明**: 新增数据迁移策略（公海记录和归属历史的初始化迁移脚本）；完善配置类设计（8个可配置项+YAML示例）；新增缓存策略（3个缓存项+操作策略）；新增全局异常处理（5个自定义异常+统一响应格式）；完善后端代码结构（新增Mapper XML、BO层、异常类、数据迁移组件）；修正差距项对照表GAP-001描述为包装类