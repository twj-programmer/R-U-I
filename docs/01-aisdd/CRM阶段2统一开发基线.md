# CRM 阶段 2 统一开发基线

**版本**：V1.5
**生效日期**：2026-07-16  
**状态**：已裁决，作为阶段 2 开发、测试与评审的唯一基线  
**适用范围**：客户、线索、商机、合同、回款及其与 BPM/OA 的接口边界  
**实现基线提交**：`origin/develop` / `feature/oa` = `a4970167605db4020422813a2f62066dad22999e`

---

## 1. 使用规则与证据等级

1. 本文覆盖阶段 0、阶段 1 设计及测试文档中与当前实现冲突的表述；发生冲突时，以本文为准。
2. `origin/develop@a497016` 是开发分支的起点；`origin/docs` 仅提供需求与设计证据，不得直接作为代码分支。
3. 所有新增表、字段、接口、权限、错误码必须先在本文的“阶段 2 增量任务”登记，再实现；禁止新建平行 CRM 实体或为文档措辞重复造接口。
4. “已实现”仅指在上述代码基线中已核验的能力；“阶段 2 新增”在代码、SQL、测试均完成并验收前，均不得宣传为已完成。

### 1.1 主要核验来源

| 来源 | 已核验结论 |
|---|---|
| `Server/.../CrmAuditStatusEnum.java` | 当前审批枚举只有 `0/10/20/30/40`。 |
| `CrmContractServiceImpl.java`、`CrmReceivableServiceImpl.java` | 提交审批会直接写入状态 `10`。 |
| `CrmBusinessEndStatusEnum.java`、`CrmBusinessServiceImpl.java` | 商机终态为整数 `1/2/3`；进行中由 `endStatus=null` 和 `statusId` 共同表达。 |
| `CrmClueController.java`、`CrmClueServiceImpl.java` | 线索转客户已实现为 `PUT /crm/clue/transform`。 |
| `CrmCustomerServiceImpl.java` | 创建客户未执行查重；公海以 `owner_user_id=NULL` 表示，不存在 `in_sea` 字段。 |
| `database/base/crm-2024-09-30.sql` | 当前无公海记录、客户归属历史表，也无阶段 1 设计中的商机增量字段。 |
| `origin/docs` 阶段 1 文档 | 代表待实现设计，含多处与当前代码不一致的状态、接口和权限表述。 |

---

## 2. 最终统一契约

### 2.1 审批状态（合同、回款；营销如接入 BPM 时复用）

| 值 | 名称 | 含义 | 允许来源 |
|---:|---|---|---|
| 0 | 草稿 | 已创建，尚未提交 BPM | 创建、被驳回后按原业务规则编辑 |
| 10 | 审批中 | 已创建 BPM 实例，等待流程完成 | 提交审批 |
| 20 | 审批通过 | BPM 回调通过 | BPM 回调 |
| 30 | 审批驳回 | BPM 回调驳回 | BPM 回调 |
| 40 | 已取消 | 已撤回或已取消流程 | 撤回/取消流程 |

**裁决**：不新增、不存储状态 `5=待审批`。`0` 与 `10` 已分别覆盖“未提交”和“已进入审批流程”；增加 `5` 会使前端、BPM 回调、查询条件和历史数据出现重复语义。

**统一字段**：继续使用 `audit_status`、`process_instance_id`；禁止新增同义的 `approval_status`。

### 2.2 商机状态

| 类型 | 字段和值 | 规则 |
|---|---|---|
| 进行中 | `end_status = NULL`，`status_id` 指向现有阶段配置 | 阶段名称和顺序由 `crm_business_status` 配置，不新增 `ACTIVE` 字符串枚举。 |
| 赢单 | `end_status = 1` | 终态，不得再更新状态。 |
| 输单 | `end_status = 2` | 终态；阶段 2 必须校验输单原因。 |
| 无效 | `end_status = 3` | 终态，不得再更新状态。 |

**统一接口**：仅使用 `PUT /crm/business/update-status`。请求中 `statusId` 与 `endStatus` 必须且只能提交一个；不得新增 `/crm/business/win`、`/crm/business/lose`。

**阶段 2 必修修复**：当前 `CrmBusinessUpdateStatusReqVO` 只校验“至少填一个”，而服务层会同时写入两个字段。必须改为互斥校验，并在服务层再次防御性校验；任一终态商机拒绝后续状态、报价和产品行修改。

### 2.3 线索转化

| 项目 | 统一结论 |
|---|---|
| 正式接口 | `PUT /crm/clue/transform` |
| 行为 | 由 `transformClue` 创建客户、回写线索转化状态与客户 ID，并复制跟进记录。 |
| 废弃表述 | `/crm/clue/convert` 不存在，不新增兼容接口。 |

### 2.4 客户公海

| 项目 | 统一规则 |
|---|---|
| 当前公海判定 | `owner_user_id IS NULL`；不新增 `in_sea` 字段。 |
| 移入公海 | 继续使用 `PUT /crm/customer/put-pool`。阶段 2 增加“存在进行中商机时禁止移入”的校验。 |
| 领取公海客户 | 继续使用现有领取接口；阶段 2 增加每日领取上限与同客户冷却期校验。 |
| 默认规则 | 每租户每日上限 10 条；同一用户领取同一客户冷却 30 天。配置未设置时使用默认值。 |
| 并发要求 | 领取和移入操作必须在事务内执行；以条件更新/版本控制保证同一客户不会被并发重复领取。 |

### 2.5 客户查重

| 项目 | 统一规则 |
|---|---|
| 阶段 2 新接口 | `POST /crm/customer/check-duplicate` |
| 权限 | `crm:customer:check-duplicate` |
| 输入 | `name` 必填；`mobile` 可选；更新场景另传 `excludeId`。 |
| 强重复 | 同一租户内，标准化后的手机号精确相同。 |
| 疑似重复 | 同一租户内，标准化后的名称相似度大于等于 0.80。 |
| 输出 | `hasDuplicate`、匹配类型、相似度、脱敏后的候选客户基本信息。 |
| 创建行为 | 查重只提示，不阻断 `POST /crm/customer/create`；用户明确选择“继续创建”后仍可提交。创建接口不得依赖前端已查重。 |

### 2.6 权限口径

| 场景 | 正式权限 |
|---|---|
| 既有客户、商机、合同、回款查询 | 继续使用既有 `*:query` 权限。 |
| 移入公海 | 保持既有 `crm:customer:update`，并保留服务层数据权限校验。 |
| 合同提交审批 | 保持既有 `crm:contract:update`。 |
| 回款提交审批 | 保持既有 `crm:receivable:update`。 |
| 新增客户查重 | `crm:customer:check-duplicate`。 |
| 新增公海记录查询 | `crm:high-seas-record:query`。 |
| 新增归属历史查询 | `crm:customer-owner-history:query`。 |

**裁决**：不为既有提交动作新增 `*:submit` 权限，以免角色、菜单和已有调用失配；仅对新增、独立查询或独立业务能力新增权限。

### 2.7 响应字段

`poolDay` 是响应层计算值：由公海配置与客户最后跟进/成交相关时间计算后写入 `CrmCustomerRespVO`，不在 `CrmCustomerDO` 和数据库表中存储。文档中 `pool_day` 为 DO/表字段的描述失效。

---

## 3. 阶段 2 增量任务与验收

### D2-CUS-01：客户查重

- **输入**：名称、可选手机号、可选排除客户 ID。
- **输出**：强重复或疑似重复候选列表；不得返回跨租户数据或完整敏感手机号。
- **验收**：手机号相同、名称相似度边界 0.80、无匹配、排除自身、跨租户隔离均有单元与接口测试。

### D2-CUS-02：公海与归属历史

新增表：

1. `crm_high_seas_record`：记录移入、领取、自动移入等公海动作，至少包含客户 ID、动作类型、变更前/后负责人、原因、操作人、动作时间、租户及审计字段。
2. `crm_customer_owner_history`：记录分配、转移、领取、自动移入等负责人变更，至少包含客户 ID、旧/新负责人、变更类型、原因、操作人、变更时间、租户及审计字段。

新增查询接口：

- `GET /crm/high-seas-record/page`
- `GET /crm/high-seas-record/{id}`
- `GET /crm/high-seas-record/list-by-customer`
- `GET /crm/customer-owner-history/list`
- `GET /crm/customer-owner-history/page`

**验收**：手动移入、领取、自动移入、客户转移四类动作均落一条可按租户和客户查询的历史；历史写入失败时业务操作整体回滚；迁移脚本可重复执行且不重复造历史。

### D2-CUS-03：公海领取规则

- 每租户每日默认上限 10 条；配置优先于默认值。
- 同一用户对同一客户 30 天内不得再次领取。
- 被锁定、已成交、已有负责人或存在进行中商机的客户，按相应规则拒绝领取或移入。
- 不使用阶段 1 文档中“仅靠 AOP 包装”的实现限定；可在服务层实现，前提是事务、数据权限、日志和历史记录均完整。

**验收**：上限边界、第 11 次领取、30 天边界、并发领取、跨租户、失败回滚均有自动化测试。

### D2-BIZ-01：商机状态机与输单原因

- 修复 `statusId/endStatus` 互斥校验。
- 进行中状态只能在同一状态组按既定顺序流转；禁止回退和终态重开。
- `endStatus=2` 时 `loseReasonCode` 必填，说明最多 500 字；赢单、无效时不得携带输单原因。
- 新增 `version`、`lose_reason_code` 等字段前，先提交增量 SQL、回滚 SQL 和历史数据归一方案；不得改写 `database/base` 历史建表文件来代替迁移。

**验收**：双填/空填参数、终态保护、输单原因、版本冲突、金额和产品行事务回滚均有单元与接口测试。

### D2-CON-01：合同审批口径整理

- 代码不增加状态 `5`，不新增 `approval_status`。
- 文档、接口测试和前端枚举统一为本文 2.1 的五种状态。
- 合同提交仍由 `/crm/contract/submit` 负责；OA 仅聚合待办与执行 BPM 审批动作。

### D2-REC-01：回款审批口径整理

- 回款继续复用相同五态 `audit_status`。
- 回款域原先未完成的业务规则、数据字典和页面设计不因本文而自动进入开发；须另有已评审需求后立项。

---

## 4. 明确废弃或更正的旧表述

| 旧表述 | 处理 |
|---|---|
| 审批状态含 `5=待审批` | 废弃，统一为五态模型。 |
| 商机 `ACTIVE/WON/LOST/INVALID` 字符串枚举 | 废弃，使用 `statusId + endStatus` 整数模型。 |
| `/crm/business/win`、`/crm/business/lose` | 废弃，统一到 `/crm/business/update-status`。 |
| `/crm/clue/convert` | 更正为 `/crm/clue/transform`。 |
| `pool_day` 是数据库字段 | 废弃；它是响应层计算字段。 |
| `in_sea` 是当前客户表字段 | 废弃；当前公海以 `owner_user_id=NULL` 表示。 |
| 已有 `read`、`put-pool`、`submit` 专用权限 | 更正为现有 `query`、`update` 权限；仅新增能力使用新权限。 |
| 阶段 1 文档列出的表/API 已实现 | 更正为“阶段 2 待实现”，除非本文明确标为既有能力。 |

---

## 5. 交付物、分工边界与完成定义

### 5.1 每个增量任务必须提交

1. 后端实现和对应 DTO/DO/Mapper/Service/Controller。
2. 增量 SQL 与回滚 SQL；文件名、执行顺序、影响表必须写入变更说明。
3. 单元测试与接口测试，覆盖正常、边界、权限、租户隔离和并发/事务场景。
4. 前端调用、权限点、枚举显示与错误提示的联调证据。
5. 本文对应任务状态、实现提交号和验证结果的更新。

### 5.2 合并门槛

- 从最新 `origin/develop` 创建功能分支；不得从 `docs` 分支开发代码。
- 不允许未评审 SQL、未声明接口变更或未补测试的 CRM 变更合并。
- 有跨域影响的状态、字段、权限改动，必须同时由对应开发与测试负责人复核。
- 数据库变更在空数据卷的 Compose 环境完成一次完整初始化验证后，方可标记完成。

### 5.3 当前状态

| 范围 | 状态 |
|---|---|
| 统一接口、状态、权限裁决 | 已完成，见本文第 2 节。 |
| 客户查重、公海历史、领取限制 | 待开发。 |
| 商机状态机、输单原因、乐观锁 | 待开发。 |
| 合同/回款文档与测试口径同步 | 待更新。 |
| CRM 自动化测试、数据库空卷验证 | 待新增/待执行。 |

---

## 6. 变更控制

本文生效后，任何人如需改变接口路径、状态码、表字段、权限名或跨域事件，必须先提交“变更原因、影响对象、迁移方案、回滚方案、测试用例”，经技术与测试复核后再更新本文和代码。未登记的变更不得作为阶段 2 开发依据。

---

## 7. 补充裁决（V1.1，2026-07-16 起强制执行）

本节补足第 3 节任务实施所需的字段、算法、并发和迁移细节。它与前文具有同等效力；前文未明确之处以本节为准。不得再以“待确认”为由自行改变本节契约。

### 7.1 D2-CUS-01 客户查重算法与输出

1. **手机号标准化**：去除所有非数字字符；标准化结果为空时不参与强重复判断。
2. **名称标准化**：将全角字符转半角、去除首尾空白、统一为小写、移除空白和 Unicode 标点后比较；不得将名称翻译、拼音化或使用外部服务。
3. **名称相似度**：使用标准化名称的 Levenshtein 相似度，公式为 `1 - distance / max(lengthA, lengthB)`；任一标准化名称为空时相似度为 `0`；相似度 `>= 0.80` 为疑似重复。
4. **候选范围**：仅查询当前租户、未删除客户；`excludeId` 非空时排除该客户。
5. **返回契约**：HTTP 成功响应的 `data` 固定为 `{ hasDuplicate: boolean, candidates: DuplicateCandidate[] }`；`DuplicateCandidate` 固定包含 `id`、`name`、`mobileMasked`、`matchType`（`STRONG` 或 `SUSPECT`）、`similarity`。手机号仅按“保留前 3 位和后 4 位，中间用 `****` 代替”的规则脱敏；没有手机号返回 `null`。没有候选时必须返回 `hasDuplicate=false` 与空数组，不得返回 `null`。
6. **排序**：强重复优先；同一类型按相似度降序、客户 ID 降序。查重仅提示，不阻断创建或更新。

### 7.2 D2-CUS-02 公海与负责人历史数据模型

两个新表均使用 `TenantBaseDO` 的租户与审计字段，业务时间字段使用 UTC 无关的数据库 `DATETIME`，并由应用写入当前时间。

#### 7.2.1 `crm_high_seas_record`

| 字段 | 类型 | 规则 |
|---|---|---|
| `id` | BIGINT | 主键 |
| `customer_id` | BIGINT | 非空，当前租户客户 ID |
| `action_type` | VARCHAR(32) | 仅允许 `MANUAL_PUT`、`AUTO_PUT`、`RECEIVE` |
| `before_owner_user_id` | BIGINT | 可空 |
| `after_owner_user_id` | BIGINT | 可空 |
| `reason` | VARCHAR(500) | 可空 |
| `operator_user_id` | BIGINT | 非空；自动移入记录系统任务执行用户 |
| `action_time` | DATETIME | 非空 |

索引：`idx_tenant_customer_time (tenant_id, customer_id, action_time)`、`idx_tenant_operator_time (tenant_id, operator_user_id, action_time)`。

#### 7.2.2 `crm_customer_owner_history`

| 字段 | 类型 | 规则 |
|---|---|---|
| `id` | BIGINT | 主键 |
| `customer_id` | BIGINT | 非空，当前租户客户 ID |
| `change_type` | VARCHAR(32) | 仅允许 `ASSIGN`、`TRANSFER`、`RECEIVE`、`MANUAL_PUT`、`AUTO_PUT` |
| `old_owner_user_id` | BIGINT | 可空 |
| `new_owner_user_id` | BIGINT | 可空 |
| `reason` | VARCHAR(500) | 可空 |
| `operator_user_id` | BIGINT | 非空；自动移入记录系统任务执行用户 |
| `change_time` | DATETIME | 非空 |

索引：`idx_tenant_customer_time (tenant_id, customer_id, change_time)`、`idx_tenant_new_owner_time (tenant_id, new_owner_user_id, change_time)`。

#### 7.2.3 写入、迁移与回滚

1. 事件映射固定为：手动移入=`MANUAL_PUT`（两表各一条）、自动移入=`AUTO_PUT`（两表各一条）、领取=`RECEIVE`（两表各一条）、分配=`ASSIGN`（仅负责人历史）、转移=`TRANSFER`（仅负责人历史）。不得复用错误的事件类型。
2. 自动移入的 `operator_user_id` 固定写入 `0`，并在接口展示时显示为“系统”；不得查询、校验或创建 ID 为 `0` 的后台用户。手工动作使用当前登录用户 ID。
3. 客户负责人更新、数据权限变更、联系人负责人同步与两类历史写入必须处于同一事务；任一历史写入失败时业务整体回滚。
4. 本期不伪造上线前历史。增量 SQL 只创建表和索引；运行时记录只从部署后新动作开始。
5. 正向迁移文件使用 `20260716_d2_customer_pool_history.sql`，回滚文件使用 `20260716_d2_customer_pool_history_rollback.sql`。正向脚本必须可重复执行；回滚删除本任务创建的表，不修改 `database/base`。

#### 7.2.4 历史查询接口、权限与展示

1. 固定新增五个接口：`GET /crm/high-seas-record/page`、`GET /crm/high-seas-record/{id}`、`GET /crm/high-seas-record/list-by-customer?customerId={id}`、`GET /crm/customer-owner-history/page`、`GET /crm/customer-owner-history/list?customerId={id}`；不得改名或额外新增平行接口。
2. 两个 `page` 接口固定接收 `customerId`、对应类型（`actionType` 或 `changeType`）、`beginTime`、`endTime`、`pageNo`、`pageSize`；`list` 接口只接收 `customerId`。所有时间均按服务端 `DATETIME` 解释，`beginTime` 与 `endTime` 均为闭区间；`beginTime > endTime` 必须校验失败。
3. 返回记录固定包含本节表字段及 `operatorUserName`、`beforeOwnerUserName`/`afterOwnerUserName` 或 `oldOwnerUserName`/`newOwnerUserName`。用户 ID 为 `0` 时名称固定为“系统”；不存在的非零用户名称返回 `null`，不得伪造。
4. 权限固定为 `crm:high-seas-record:query` 和 `crm:customer-owner-history:query`，并分别由对应查询接口校验；前端仅在已有客户详情页以“公海记录”“负责人历史”两个页签展示，不新增顶级菜单。迁移 SQL 使用 `permission='crm:customer:query'` 的现有客户菜单作为父级，创建两个隐藏的按钮权限；找不到或匹配多条父菜单时迁移失败，不得猜测菜单 ID。

### 7.3 D2-CUS-03 公海领取配置、并发与限制

1. 在现有 `crm_customer_pool_config` 增加可空字段：
   - `receive_limit_per_day INT NULL`：每用户、每租户每日领取上限；为空时使用 `10`；非空时必须大于 `0`。
   - `receive_cooldown_days INT NULL`：同一用户重复领取同一客户的冷却天数；为空时使用 `30`；非空时必须大于 `0`。
2. 现有保存接口和前端配置页扩展上述两个字段；不得新建平行配置表或平行配置接口。
3. 配置记录以 `tenant_id` 唯一：迁移先检查每个租户至多一条记录，再新增 `uk_tenant_id (tenant_id)`；发现重复记录时迁移必须失败并报告租户 ID，禁止静默删除或合并。运行时缺少配置时，以当前租户插入默认记录（`10`、`30`）后重新查询并加锁；并发插入遇到唯一键冲突时重新查询并加锁。
4. 每日计数以当前租户、当前领取用户、`crm_high_seas_record.action_type='RECEIVE'` 和自然日 `[00:00:00, 次日 00:00:00)` 为准。
5. 冷却判断以当前租户、当前领取用户、当前客户最后一条 `RECEIVE` 公海记录的 `action_time` 为准；`action_time >= 当前时间 - cooldownDays` 时拒绝。
6. 移入公海前，若存在同租户、未删除且 `end_status IS NULL` 的商机，必须拒绝；不得以“商机总数”代替进行中商机判断。
7. 领取操作在事务内执行：先对当前租户公海配置记录执行行锁，再校验限额和冷却期，最后以 `id=? AND owner_user_id IS NULL AND deleted=0` 执行条件更新。条件更新影响行数不为 `1` 时视为并发领取失败，后续权限和历史均不得写入。
8. 新增错误码及数值固定为：`CUSTOMER_RECEIVE_EXCEED_DAILY_LIMIT=1_020_006_016`、`CUSTOMER_RECEIVE_COOLDOWN=1_020_006_017`、`CUSTOMER_PUT_POOL_FAIL_ACTIVE_BUSINESS=1_020_006_018`、`CUSTOMER_RECEIVE_CONCURRENT_CONFLICT=1_020_006_019`；不得复用或另行分配。测试必须同时断言错误码名称和数值。
9. 本任务迁移正向文件为 `20260716_d2_customer_pool_receive_rules.sql`，回滚文件为 `20260716_d2_customer_pool_receive_rules_rollback.sql`；回滚按相反顺序删除 `uk_tenant_id` 和本任务新增字段，不删除既有公海配置数据。

### 7.4 D2-BIZ-01 商机状态、乐观锁和历史数据

1. `crm_business` 增加：
   - `version INT NOT NULL DEFAULT 0`；
   - `lose_reason_code VARCHAR(64) NULL`。
   继续复用既有 `end_remark` 作为输单说明，最大 500 字；不新建平行说明字段。
2. 历史数据归一：所有既有记录的 `version` 初始化为 `0`；既有 `end_status=2` 且没有输单原因的记录保持 `lose_reason_code=NULL`，不得虚构业务事实。新的输单状态更新才强制填写原因。
3. `PUT /crm/business/update-status` 请求必须携带当前 `version`；`statusId` 与 `endStatus` 必须且只能出现一个。
4. 进行中状态只允许同一状态组内向更高排序值前进；不允许回退。`end_status` 为 `1`、`2`、`3` 后，不允许更新状态、商机基本信息、报价或产品行。
5. `endStatus=2` 时 `loseReasonCode` 必填、`endRemark` 可选且不超过 500 字；`endStatus=1` 或 `3` 时不得携带 `loseReasonCode`。
6. 状态更新采用 `id + tenant_id + version` 条件更新，成功后 `version=version+1`。影响行数为 `0` 时返回 `BUSINESS_UPDATE_VERSION_CONFLICT=1_020_002_004`，提示“商机数据已被他人更新，请刷新后重试”；不得复用或另行分配。
7. 本任务迁移正向文件为 `20260716_d2_business_state_machine.sql`，回滚文件为 `20260716_d2_business_state_machine_rollback.sql`。回滚删除本任务新增字段；不得改写 `database/base`。

### 7.5 V1.2 补充任务契约

#### 7.5.1 D2-MKT-01 商机输单原因配置

1. 复用既有系统字典类型与数据管理能力；不得新建 CRM 平行配置表、CRM 配置 Controller 或 CRM 配置页面。既有 `/crm/business-status/**` 与 `crm_customer_source` 均为已实现能力，本任务不得重复实现。
2. 新增唯一字典类型常量 `crm_business_lose_reason`，显示名称固定为“CRM 商机输单原因”。服务端 `DictTypeConstants` 与前端 `DICT_TYPE` 必须使用完全相同的字符串。
3. 初始启用数据固定为：`COMPETITOR`=竞品原因、`PRICE`=价格原因、`REQUIREMENT_MISMATCH`=需求不匹配、`BUDGET`=预算不足、`TIMING`=时机不符、`OTHER`=其他；排序依次为 1 至 6。允许管理员通过既有系统字典页面维护标签、排序和启停，但不得变更代码值。
4. `D2-BIZ-01` 在新的输单状态更新中必须调用既有 `DictDataApi.validateDictDataList("crm_business_lose_reason", ...)` 校验该值为启用字典数据；字典任务不得修改商机服务、状态接口或商机前端表单。
5. 本任务正向迁移为 `20260716_d2_business_lose_reason_dict.sql`，回滚为 `20260716_d2_business_lose_reason_dict_rollback.sql`。正向脚本按字典类型与代码值幂等插入；回滚前必须确认 `crm_business` 中没有未删除记录引用任一输单原因，否则停止回滚并报告引用数量，禁止丢失历史含义。
6. 主责文件仅限 CRM 字典类型常量、前端字典类型常量、增量/回滚 SQL、任务自身测试与说明；不得修改 `CrmBusinessServiceImpl`、`CrmBusinessController`、商机状态表单或系统通用字典 Controller。

#### 7.5.2 D2-QA-01 CRM 测试底座

1. 当前 CRM 模块有 `application-unit-test.yaml`，但缺少其引用的 `src/test/resources/sql/create_tables.sql` 与任何 CRM Java 测试类。本任务负责补齐可重复执行的 H2 测试启动基础，不新增任何生产接口、字段、权限、生产迁移或 `database/base` 修改。
2. 固定交付物为：`src/test/resources/sql/create_tables.sql`、`src/test/resources/sql/clean.sql`、`src/test/java/**/support/CrmTestDataFactory.java`、`src/test/java/**/support/CrmTestSupportTest.java` 及测试运行说明。公共 SQL 只包含启动所有阶段 2 测试所必需的最小公共表；每个业务任务把自己的表与测试数据放在以任务编号命名的独立 `@Sql` 脚本中。
3. 统一测试基类为既有 `BaseDbUnitTest` 或 `BaseDbAndRedisUnitTest`；不得引入 Testcontainers、外部数据库、真实 Redis、网络依赖或改变 Maven 依赖。`clean.sql` 只清理 H2 内存测试表，不得触及开发数据库。
4. 文件所有权：本任务独占 `src/test/java/**/support/**` 与 `src/test/resources/sql/create_tables.sql`、`clean.sql`；其他任务分别拥有以自身任务编号命名的测试类和 SQL。公共测试底座变更必须由 `feature/workorder` 处理，避免测试资源冲突。
5. 验收为：在干净环境执行 CRM 模块测试时，测试上下文能加载；连续运行两次无表已存在、脏数据或依赖外部服务失败；测试数据工厂自身有正常、空值和租户隔离断言。业务任务的测试不能以此任务替代。

#### 7.5.3 D2-STAT-01 客户转化明细导出

1. 已有客户、漏斗、绩效、画像和排行统计查询接口均继续保留；不得新建平行统计表、平行统计 Controller 或重复查询接口。本任务仅新增 `GET /crm/statistics-customer/export-contract-summary`。
2. 导出接口复用 `CrmStatisticsCustomerReqVO`，只接收既有 `deptId`、`userId`、`interval`、`times` 参数；必须复用 `getContractSummary` 的服务逻辑与数据权限结果，不得直连 Mapper 绕过租户、部门或负责人范围。
3. 接口返回 XLSX 下载流，文件名固定为 `客户转化明细_yyyyMMddHHmmss.xlsx`。列顺序固定为：客户名称、首次合同名称、合同金额、回款金额、客户类型、客户来源、负责人、创建人、创建时间、签约时间。空值导出为空单元格，不得以 0、当前用户或虚构日期替代。
4. 新增且仅新增权限 `crm:statistics-customer:export`；前端导出按钮仅位于既有客户转化率页面，并以此权限控制。迁移 SQL 使用现有 `crm:statistics-customer:query` 菜单作为父级创建隐藏按钮权限；父菜单不存在或多条匹配时迁移失败，不得猜测菜单 ID。
5. 本任务正向迁移为 `20260716_d2_statistics_customer_export_permission.sql`，回滚为 `20260716_d2_statistics_customer_export_permission_rollback.sql`；回滚只删除精确权限 `crm:statistics-customer:export`，不删除已有统计菜单或数据。
6. 验收覆盖：有权限导出、无权限拒绝、空数据导出、日期边界、部门/负责人数据范围、跨租户隔离、导出内容与既有 `get-contract-summary` 同条件结果一致。不得用前端筛选替代后端数据权限。

---

## 8. 阶段 2 任务归属、分支和文件所有权

每个任务只能由指定主责分支修改；其他分支不得触及其拥有的后端、SQL 或前端文件。需要修复时通过缺陷记录反馈给主责分支，避免跨分支直接改同一文件。

| 任务 | 主责分支 | 主责范围 | 禁止触碰范围 |
|---|---|---|---|
| `D2-CUS-01` | `feature/customer` | 客户查重接口、DTO、服务、Mapper、前端调用、权限、测试 | 公海历史、领取限制 SQL 与服务逻辑 |
| `D2-CUS-02` | `feature/customer` | 两类历史表、DO/Mapper/查询接口、历史写入、历史前端查询、SQL 与回滚 | 领取限额与冷却规则 |
| `D2-CUS-03` | `feature/order` | 公海配置扩展、领取/移入规则、并发保护、SQL 与回滚 | 客户查重算法 |
| `D2-BIZ-01` | `feature/opportunity` | 商机状态机、版本、输单原因、前端调用、SQL 与回滚 | 合同/回款审批状态与接口 |
| `D2-APR-01` | `feature/order` | 合同/回款共用审批状态转换、提交并发保护、提交数据权限、共享五态前端枚举与对应测试 | 新接口、字段、状态、权限、错误码、BPM 补偿接口、合同/回款业务字段 |
| `D2-CON-01` | `feature/oa` | 合同审批文档、合同页五态展示、审批详情空流程号保护、OA 待办联调证据 | 共享审批服务、回款服务、审批字段、BPM 状态模型 |
| `D2-REC-01` | `feature/finance` | 回款页面五态回归、接口测试及经另行立项的业务规则 | 共享审批服务、未评审的回款新字段、接口或状态 |
| `D2-MKT-01` | `feature/marketing` | 输单原因系统字典常量、初始数据 SQL、回滚、任务测试与说明 | 商机服务、状态接口、商机表单、既有阶段/客户来源配置 |
| `D2-QA-01` | `feature/workorder` | CRM 公共测试底座、测试数据工厂、公共 H2 SQL、测试运行说明 | 生产业务代码、生产 SQL、其他任务的测试类和任务 SQL |
| `D2-STAT-01` | `feature/public-integration` | 客户转化明细导出、导出按钮、权限 SQL、测试 | 已有统计查询接口、统计表、客户/商机/合同核心服务 |

合并顺序：先合入 `D2-QA-01`；随后 `D2-APR-01` 必须先于 `D2-CON-01`、`D2-REC-01` 合入；`D2-CUS-01`、`D2-CUS-02`、`D2-STAT-01` 与 `D2-MKT-01` 可并行；`D2-MKT-01` 合入后实施依赖其字典校验的 `D2-BIZ-01`；`D2-CUS-02` 完成后实施 `D2-CUS-03`。`feature/order` 上的 `D2-CUS-03` 与 `D2-APR-01` 必须拆分为独立提交；`D2-CUS-03` 只在 `D2-CUS-02` 合入后合并，`D2-APR-01` 只在 `D2-QA-01` 合入后合并。

---

## 9. 统一测试接口边界（TDD Seams）

测试必须通过以下公开边界验证行为，不得以直接修改数据库或测试私有方法代替：

| 任务 | 后端公开边界 | 前端/接口边界 |
|---|---|---|
| `D2-CUS-01` | `POST /crm/customer/check-duplicate` | 客户创建/编辑页查重提示 |
| `D2-CUS-02` | 5 个历史查询接口及移入、领取、自动移入、转移操作 | 客户详情历史列表 |
| `D2-CUS-03` | `PUT /crm/customer/put-pool`、`PUT /crm/customer/receive` | 公海领取与配置页 |
| `D2-BIZ-01` | `PUT /crm/business/update-status`、既有商机/产品更新接口 | 商机状态弹窗、报价和产品明细页 |
| `D2-APR-01` | `PUT /crm/contract/submit`、`PUT /crm/receivable/submit`、BPM 待办/审批/撤回接口 | 合同与回款待办列表的共享五态枚举 |
| `D2-CON-01` | `PUT /crm/contract/submit`、BPM 待办接口 | CRM 待办与审批详情 |
| `D2-REC-01` | `PUT /crm/receivable/submit`、BPM 待办接口 | CRM 待办与回款审批详情 |
| `D2-MKT-01` | 既有系统字典管理接口、`DictDataApi.validateDictDataList` | 商机输单原因下拉数据 |
| `D2-QA-01` | CRM Maven 测试上下文、公共 H2 SQL、测试数据工厂 | 各业务任务可重复执行的测试环境 |
| `D2-STAT-01` | `GET /crm/statistics-customer/export-contract-summary` | 客户转化率页面导出按钮 |

每个任务至少包含：正常、边界、无权限、跨租户、并发与事务回滚测试。没有可执行测试和真实结果的任务不得进入交叉测试。

---

## 10. 实施与变更流程

1. 主责分支必须从最新 `origin/develop` 同步后开始；不得从 `docs` 分支开发。
2. 开发前先读取本文件对应任务、已拥有文件和测试边界；发现契约不完整时，只能提交“基线补充提案”，不得猜测实现。
3. 每项数据库迁移必须同时提交正向 SQL、回滚 SQL、执行顺序和空数据卷验证记录。
4. 完成代码后，主责开发者提交：修改清单、接口契约、SQL 执行/回滚方式、测试命令和结果、已知风险。
5. 交叉测试人不得直接在被测分支修复；发现问题后由主责分支修复，原测试人复测。
6. 未经本基线登记的接口、字段、状态、权限、错误码或跨域事件不得合入 `develop`。

---

## 11. V1.5 最终冻结裁决（2026-07-16 起强制执行）

本节是对 V1.2 的补充和更正；与此前任何任务表、阶段 0/1 设计或口头说明冲突时，以本节为准。发布 V1.5 后，V1.2、V1.3、V1.4 均不再作为开发依据。

### 11.1 唯一实施依据与历史文档隔离

1. 唯一实施依据是本文件 V1.5。开发前，所有成员必须拉取最新 `origin/docs` 并完整阅读本文件；代码只能从最新 `origin/develop` 创建或同步功能分支。
2. 下列文件为历史设计记录，禁止作为接口、字段、状态、权限或 SQL 的实现依据：
   - `docs/01-aisdd/oa/01-AISDD-设计文档-王文渊-OA待办审批.md`
   - `docs/01-aisdd/order/GAP-007-阶段1-DDD设计方案.md`
   - `docs/01-aisdd/order/GAP-007-阶段1-BPM方案.md`
   - `docs/01-aisdd/阶段1设计汇总与评审记录.md`
3. 上述历史文档中出现的 `approval_status`、状态 `5`、`/oa/**` 平行接口、`crm:contract:approve` 等均不得实现。历史文档保留只为追溯，不删除、不改写其正文。

### 11.2 D2-APR-01：共享审批安全收口

**目标**：修复合同与回款共用审批桥接的状态错误、并发重复提交和提交越权风险；不改变任何公开接口契约。

1. BPM 结果到 CRM 审批状态的唯一映射为：BPM `2 -> 20`、`3 -> 30`、`4 -> 40`。CRM 只允许 `0、10、20、30、40`；不得把 BPM 的 `4` 直接保存为 CRM 状态。
2. `PUT /crm/contract/submit` 与 `PUT /crm/receivable/submit` 保持现有路径、参数、权限标识和响应不变。两个服务方法均必须复用既有 CRM 数据权限机制，权限等级为 `WRITE`；无权访问时不得创建 BPM 流程。
3. 两个提交流程都必须先以“记录 ID + 当前租户 + audit_status=0”为条件原子更新为 `10`。更新行数为 `0` 时，抛出各自既有的“非草稿不可提交”错误；只有更新成功的请求可以创建 BPM 流程。
4. 原子状态抢占、创建 BPM 流程、写入 `process_instance_id` 必须在同一事务中；创建流程或保存流程号失败时，数据库事务必须回滚到草稿状态。不得新增 BPM 撤销/补偿 API；当前内部 BPM API 未登记此能力。
5. 该任务不新增数据库字段、迁移 SQL、Controller、VO、前端路由、菜单权限、错误码或状态码。允许改动范围仅限共享审批工具类、合同/回款提交服务及 Mapper 条件更新、共享待办五态枚举/文案和它们的测试。
6. 验收必须覆盖：合同和回款各自的正常提交、重复提交、两并发请求仅一个成功、无 CRM WRITE 权限、跨租户、BPM 创建异常事务回滚、审批通过、驳回、撤回后状态为 `40`。测试只通过公开 HTTP 接口和 BPM 公开接口观察结果。

### 11.3 合同与回款页面边界

1. `D2-CON-01` 只处理合同页面展示与联调证据：五态文案、草稿无 `process_instance_id` 时不得进入审批详情、合同待办与 BPM 待办结果一致。不得修改合同提交服务或共享状态工具类。
2. `D2-REC-01` 只处理回款页面五态回归和接口测试。不得修改共享状态工具类、合同服务或新增回款接口/字段。
3. 共享待办组件的五态枚举与本地化文案由 `D2-APR-01` 统一维护，合同与回款任务不得各自复制枚举或文案。

### 11.4 集成前数据与环境门槛

1. 演示/集成数据库必须先完成既有基础建表和所需增量 SQL；当前本机开发容器尚未加载 `crm_contract` 表，不能据此判断历史审批数据状态。
2. 在真实集成库执行只读盘点：分别按 `crm_contract.audit_status`、`crm_receivable.audit_status` 分组统计。若任一表存在 `audit_status=4`，停止发布，单独提交数据修复提案、回滚方式和验证记录；不得静默修改历史数据。
3. CRM 单元测试底座当前缺少 `classpath:/sql/create_tables.sql`，因此 `D2-QA-01` 是所有 CRM 行为测试的合并前置。Java/Maven 与前端测试运行环境未在当前工作站核验可用前，不得宣称测试已通过。

### 11.5 冻结后的变更规则

1. V1.5 发布后，成员发现缺少接口或契约时必须提交“基线补充申请”，内容至少包括：任务编号、现有公开边界、缺失原因、影响文件、替代方案和测试影响；在基线更新前不得修改代码。
2. 基线补充只能由统一维护者在 `docs` 分支发布新版本后生效；任何功能分支内的 README、注释或 AI 对话均不能改变本契约。
3. 每个合并请求必须声明：读取的基线版本、任务编号、文件所有权、测试命令和结果；缺少其中任一项不得合入 `develop`。

---

## 12. V1.4 统计导出字段与无回款裁决（2026-07-16 起强制执行）

本节仅细化 `D2-STAT-01`；与第 7.5.3 节或任何旧描述冲突时，以本节为准。

1. 导出列“客户类型”更正为“客户行业”。数据只取既有 `CrmStatisticsCustomerContractSummaryRespVO.industryId`，按既有字典类型 `crm_customer_industry` 导出字典名称；不得新增“客户类型”字段、VO 属性、数据库列或接口参数。
2. 导出列“客户来源”只取既有 `source`，按既有字典类型 `crm_customer_source` 导出字典名称。行业或来源编号为 `null` 时导出空单元格；编号非空但无法解析字典名称时导出原始编号，禁止伪造标签或静默替换为其他值。
3. “无回款”统一定义为：在同一合同下不存在未删除的 `crm_receivable` 记录，或其 `price` 为 `null`。`getContractSummary` 和导出文件均必须将该回款金额展示为数值 `0.00`，不得留空；这条规则只适用于金额列，不改变其他空值列的空单元格规则。
4. 为兑现第 3 条，`D2-STAT-01` 获准修正既有 `selectContractSummary` 的 SQL 实现，但不得改变已有 `GET /crm/statistics-customer/get-contract-summary` 的路径、参数、VO 或权限。`receivable.deleted = 0` 必须放入 `LEFT JOIN ... ON` 条件，保留 `IFNULL(receivable.price, 0)`；不得在 `WHERE` 中过滤 `receivable.deleted` 而把无回款合同排除。
5. 导出必须复用修正后的 `getContractSummary` 服务逻辑与数据权限结果，不得另写 Mapper 查询。导出与接口在相同筛选条件下的行集合、行业/来源编号和回款金额必须一致；导出仅将行业、来源编号转换为字典名称。
6. `D2-STAT-01` 验收新增：行业/来源字典名称、行业/来源为空、字典未解析保留原始编号、无回款 `0.00`、已回款金额、空数据、权限拒绝、部门/负责人数据范围与租户隔离。不得以 Excel 前端格式化或前端筛选替代后端语义。

---

## 13. V1.5 人员、分支、依赖与交叉测试冻结（2026-07-16 起强制执行）

本节以《全CRM差异补齐任务分工与Git协同开发计划》第 4、5、6 节的人员职责、领域分支和交叉测试表为来源，补正此前任务表中“技术任务”与“人员归属”混用的问题。与第 8 节此前的分支归属冲突时，以本节和第 8 节已更新的行共同为准。

### 13.1 人员与唯一任务归属

| 成员 | 领域分支 | 阶段 2 唯一主责任务 | 说明 |
|---|---|---|---|
| 王文渊 | `feature/oa` | `D2-CON-01` 合同页五态展示、CRM 待办/审批入口与 OA/BPM 联调 | 不负责共享审批服务、回款服务或审批状态转换。 |
| 曾皓冲 | `feature/marketing` | `D2-MKT-01` 商机输单原因字典与配置 | 不修改商机状态服务或表单。 |
| 姚昱竹 | `feature/public-integration` | `D2-STAT-01` 统计导出 | 执行第 12 节的客户行业、来源和无回款裁决。 |
| 李祖豪 | `feature/order` | `D2-CUS-03` 公海规则/权限；`D2-APR-01` 合同与回款共享审批安全；Git 集成 | 两项任务必须分提交、分评审、分合并。 |
| 安炳琨 | `feature/workorder` | `D2-QA-01` CRM 测试底座、测试数据和自动化组织 | 是所有 CRM 行为测试的合并前置。 |
| 刘焘玮 | `feature/customer` | `D2-CUS-01` 客户查重；`D2-CUS-02` 公海与负责人历史 | 两项可分别提交；不得实现 `D2-CUS-03` 的限额/冷却规则。 |
| 唐文军 | `feature/finance` | `D2-REC-01` 回款页面回归及返岗后确认的回款、回款计划、余额和逾期任务 | 请假期间不代开发、不合并、不进入交叉测试环；返岗后方可开始。 |
| 黄金戈 | `feature/opportunity` | `D2-BIZ-01` 商机状态机、输单、报价、产品和跟进 | 必须等待 `D2-MKT-01` 的输单原因字典合入。 |

### 13.2 开发、测试与合并依赖

| 任务 | 可以开始的条件 | 测试/合并前置 | 后续消费者 |
|---|---|---|---|
| `D2-QA-01` | 无 | 无，必须最先合入 | 所有 CRM 任务 |
| `D2-CUS-01` | 已读 V1.5 | `D2-QA-01` | 客户主链集成 |
| `D2-CUS-02` | 已读 V1.5 | `D2-QA-01` | `D2-CUS-03` |
| `D2-CUS-03` | `D2-CUS-02` 已合入 | `D2-QA-01`、`D2-CUS-02` | 客户公海主链集成 |
| `D2-MKT-01` | 已读 V1.5 | `D2-QA-01` | `D2-BIZ-01` |
| `D2-BIZ-01` | 可只读核验和准备 | `D2-QA-01`、`D2-MKT-01` | 合同/回款主链集成 |
| `D2-APR-01` | 已读 V1.5 | `D2-QA-01` | `D2-CON-01`、`D2-REC-01` |
| `D2-CON-01` | 可做页面范围内的独立修正 | `D2-QA-01`、`D2-APR-01` | OA/BPM、合同主链集成 |
| `D2-REC-01` | 唐文军返岗后 | `D2-QA-01`、`D2-APR-01`、唐文军返岗 | 回款、统计和端到端验收 |
| `D2-STAT-01` | 已读 V1.5 | `D2-QA-01`；最终口径验收依赖合同/回款集成数据 | UAT、演示统计 |

“可以开始”只允许只读核验、任务范围内编码或页面准备；未满足“测试/合并前置”时，不得宣称测试通过、发起合并或合入 `develop`。

### 13.3 唯一交叉测试环

以下环替代任何与之不一致的旧文字描述；每位未请假成员只承担一个固定交叉测试包，测试人不得在被测分支直接修改业务代码。

| 编号 | 开发者与被测包 | 交叉测试人 | 最低验证重点 |
|---|---|---|---|
| `CT-01` | 王文渊：OA/待办审批入口（`D2-CON-01`） | 黄金戈 | 待办生成、跳转、权限、合同审批状态同步 |
| `CT-02` | 曾皓冲：配置字典（`D2-MKT-01`） | 王文渊 | 字典生效、非法配置、权限、前端展示 |
| `CT-03` | 姚昱竹：统计导出（`D2-STAT-01`） | 曾皓冲 | 指标口径、筛选、空数据、数据权限 |
| `CT-04` | 李祖豪：公海规则/共享审批（`D2-CUS-03`、`D2-APR-01`） | 姚昱竹 | 领取上限、归属、越权、审批状态、流程轨迹 |
| `CT-05` | 安炳琨：测试底座/自动化（`D2-QA-01`） | 李祖豪 | 脚本可执行、测试数据隔离、日志可追溯 |
| `CT-06` | 刘焘玮：客户查重/归属历史（`D2-CUS-01`、`D2-CUS-02`） | 安炳琨 | 客户、关联、查重、归属历史、公海关联 |
| `CT-07` | 黄金戈：商机产品（`D2-BIZ-01`） | 刘焘玮 | 阶段、输单、报价、金额、产品、跟进 |

唐文军请假期间不进入交叉测试环；返岗后的财务交叉测试由项目经理和质量专员另行登记后才能执行。

### 13.4 全组执行流程

1. 每人先同步 `origin/docs` 的 V1.5，再从最新 `origin/develop` 同步自己的功能分支；记录基线版本和起始提交。
2. 完成只读对齐报告后，在本人任务/文件范围内开发并自测；发现未登记契约时提交“基线补充申请”。
3. 安炳琨先合入 `D2-QA-01`；其余任务在此前可准备，但不能进行 CRM 行为测试或合并。
4. 按第 13.2 节依赖完成任务测试；开发者提交修改清单、接口契约、SQL/回滚、测试命令/结果和风险。
5. 按第 13.3 节执行独立交叉测试；发现缺陷由原开发者在自己的分支修复，原测试人拉取新提交复测。
6. 李祖豪只在前置、交叉测试和评审均通过后按依赖合入 `develop`；不得跨领域代开发或直接改他人业务文件。
7. P0 主链按“客户/线索 → 商机/报价 → 合同审批 → 回款 → 待办/统计”集成；回款在唐文军返岗前不作为完成项或演示通过项。
8. 最终在干净集成环境、Docker Compose 和教师机依次复测主链、权限、异常、日志、统计及 UAT；本机临时数据修改不得代替迁移或初始化 SQL。
