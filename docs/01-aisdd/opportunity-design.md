<!-- 23计科4班 黄金戈 -->

# GAP-006 商机报价 AISDD 设计

## 1. 文档信息

| 项目 | 内容 |
|---|---|
| 任务编号 | GAP-006 |
| 开发包 | PKG-02 商机产品 |
| 负责人 | 黄金戈（HJG） |
| 阶段 | 阶段 1：AISDD 设计 |
| 日期 | 2026-07-14 下午 |
| 设计范围 | 状态流转、输单原因、报价金额、接口、事务并发和测试 |
| 当前状态 | 设计完成，待技术评审、测试评审和字典配置确认 |

## 2. 设计结论

本次设计在现有 CRM 商机模型上做最小增量改进，不建立第二套商机、阶段、报价、产品或跟进模型。

1. 商机状态由“进行中阶段”和“赢单、输单、无效”三个终态组成。
2. 进行中阶段允许在同一状态组内向前跳转，禁止同阶段提交、回退和跨组流转。
3. 任一进行中阶段均可转为终态；终态不可直接修改、回退或重新打开。
4. 输单采用“字典编码 + 补充说明”，使原因可统计、说明可审计。
5. 报价继续复用 `crm_business_product` 产品行和 `crm_business` 汇总金额，不新增 `Quote` 或 `Quotation` 表。
6. 产品原价、行金额、产品合计、优惠金额和商机总额全部由服务端生成，客户端金额不作为可信输入。
7. 状态和报价写入使用事务及乐观锁，防止并发覆盖与产品行半成功。
8. 本文只完成设计，不代表业务代码、接口联调、浏览器测试或交叉测试已经完成。

## 3. 依据与当前基线

本文源码核验基线为仓库 `docs` 分支提交 `a202214b`。后续若目标代码发生变化，应重新核对缺口、接口和测试现状，不能直接沿用本文的“当前实现”结论。

### 3.1 复用对象

| 能力 | 复用对象 |
|---|---|
| 商机 | `CrmBusinessDO`、`crm_business`、`/crm/business/**` |
| 状态组与阶段 | `CrmBusinessStatusTypeDO`、`CrmBusinessStatusDO` |
| 报价产品行 | `CrmBusinessProductDO`、`crm_business_product` |
| 产品主数据 | `CrmProductDO`、`crm_product` |
| 跟进记录 | `CrmFollowUpRecordDO`、`crm_follow_up_record` |
| 前端页面 | `Web/src/views/crm/business/**`、`Web/src/views/crm/followup/**` |

### 3.2 已核验的实现缺口

| 编号 | 当前实现 | 本设计处理 |
|---|---|---|
| D-01 | 状态请求只校验 `statusId`、`endStatus` 至少一个有值，两者可同时提交 | 改为严格二选一 |
| D-02 | 状态服务允许回退，且没有明确终态重开规则 | 引入可验证的状态流转矩阵 |
| D-03 | `endRemark` 已存在于表、DO 和响应中，但状态服务未保存 | 接通输单原因与终态说明 |
| D-04 | 状态和报价更新没有并发版本控制 | 增加 `version` 乐观锁 |
| D-05 | 产品原价和部分金额由客户端提交，服务端可被伪造数据影响 | 产品原价取产品主数据，所有金额服务端重算 |
| D-06 | 产品数量前端允许 3 位小数，后端请求却使用 `Integer` | 统一为 `BigDecimal`，最多 3 位小数 |
| D-07 | 折扣、数量、价格、重复产品缺少完整边界校验 | 冻结数值和唯一性规则 |
| D-08 | 跟进记录先插入再联动更新主对象，缺少事务 | 同一事务提交或整体回滚 |
| D-09 | `end_status` 历史种子中可能出现 `0`，但运行枚举只定义 1、2、3 | 增量脚本将历史 `0` 归一为 `NULL` |
| D-10 | `docs@a202214b` 的 CRM 模块没有 Java 业务单元测试 | 新建测试基线和测试矩阵 |

> 说明：本地实验分支曾有 6 项验证测试，但该实现和测试尚未合入当前 `docs`/目标代码基线，不能作为本阶段已交付代码或已通过回归测试的证据。

## 4. 范围与非目标

### 4.1 本次范围

- 商机进行中阶段与终态流转规则。
- 输单原因的存储、校验、展示和字典依赖。
- 商机产品行、优惠比例和汇总金额规则。
- 状态更新、报价更新和跟进创建的接口契约。
- 事务、并发、权限、租户和错误码设计。
- 后端单元测试、接口测试、前端页面测试和交叉测试设计。

### 4.2 非目标

- 不建立独立报价单、报价编号、报价审批、有效期或多版本历史。
- 不建立第二套商机、阶段、产品或跟进表。
- 不在本任务中实现终态重新打开；未来如需要，应使用独立权限、独立接口和审计记录。
- 不负责创建输单原因字典值；字典编码和选项由公共配置负责人确认。
- 不把财务应收、回款或开票规则并入商机报价。
- 不把本设计文档标记为功能开发完成或测试通过。

## 5. 状态流转设计

### 5.1 状态模型

| 状态 | 数据表达 | 含义 |
|---|---|---|
| `ACTIVE` | `statusId != null` 且 `endStatus == null` | 商机处于某个进行中阶段 |
| `WON` | `endStatus == 1` | 赢单终态 |
| `LOST` | `endStatus == 2` | 输单终态 |
| `INVALID` | `endStatus == 3` | 无效终态 |

进入终态后保留最后一个 `statusId`，用于复盘“在哪个阶段结束”，不将其清空。

### 5.2 状态不变量

1. 创建商机时必须选择一个有效状态组，初始阶段取该组排序最小且未逻辑删除的阶段；当前阶段模型没有独立启停字段，“有效阶段”统一指 `deleted = 0`。
2. 进行中商机必须存在有效 `statusId`，并且该阶段属于商机当前状态组。
3. 更新状态时 `statusId` 与 `endStatus` 必须且只能提交一个。
4. 阶段前进只允许目标阶段 `sort > 当前阶段.sort`，允许跨过中间阶段。
5. 禁止目标阶段等于当前阶段、目标阶段排序更小或属于其他状态组。
6. 任一进行中阶段均可进入 `WON`、`LOST` 或 `INVALID`。
7. 终态不可通过普通状态接口再次修改；重新打开属于独立的未来需求。
8. 同阶段重复提交返回现有“阶段相同”业务错误，不产生版本号变化。
9. 状态组已被商机使用后，阶段排序和阶段归属不得无审计地修改，以免破坏历史流转判断。
10. 阶段赢单率统一为 0～100 的百分数；DO、VO 和数据库字段类型应统一为 `BigDecimal`。

### 5.3 流转矩阵

| 当前状态 | 目标状态 | 是否允许 | 结果 |
|---|---|---|---|
| `ACTIVE(S1)` | 同组 `ACTIVE(S2)`，且 `S2.sort > S1.sort` | 是 | 更新 `statusId`，终态字段保持空 |
| `ACTIVE(S1)` | `ACTIVE(S1)` | 否 | `BUSINESS_UPDATE_STATUS_FAIL_STATUS_EQUALS` |
| `ACTIVE(S2)` | 同组更早阶段 `ACTIVE(S1)` | 否 | 阶段流转不允许 |
| `ACTIVE` | 其他状态组的阶段 | 否 | 阶段流转不允许 |
| `ACTIVE` | `WON` | 是 | 请求不得携带原因字段；成功后原因字段为空 |
| `ACTIVE` | `LOST` | 是 | 设置输单终态，并保存输单原因 |
| `ACTIVE` | `INVALID` | 是 | 设置无效终态，可保存无效说明 |
| 任一终态 | 任一阶段或终态 | 否 | `BUSINESS_UPDATE_STATUS_FAIL_END_STATUS` |

### 5.4 并发规则

`crm_business` 增加非空整数 `version`，默认值为 `0`。状态请求携带调用方最后读取且大于等于 `0` 的版本号。Mapper 对阶段前进和终态流转使用两条不同的条件更新，避免终态请求把最后阶段清空：

```sql
-- 进行中阶段前进
UPDATE crm_business
SET status_id = ?, version = version + 1
WHERE id = ?
  AND version = ?
  AND end_status IS NULL
  AND deleted = 0;

-- 进入终态；故意不更新 status_id
UPDATE crm_business
SET end_status = ?, lose_reason_code = ?, end_remark = ?,
    version = version + 1
WHERE id = ?
  AND version = ?
  AND end_status IS NULL
  AND deleted = 0;
```

租户条件由项目租户插件追加。受影响行数为 `0` 时重新读取商机：

- 商机不存在：返回商机不存在。
- 商机已结束：返回终态不可变更。
- 版本不同：返回版本冲突，前端刷新后由用户重新确认。

状态校验和条件更新位于同一个 `@Transactional` 事务中。

### 5.5 历史数据迁移

`docs@a202214b` 的 `database/base/crm-2024-09-30.sql` 至少存在 ID 5、6 的未删除商机满足 `end_status IS NULL AND status_id IS NULL`。增量迁移不能只处理 `end_status = 0`，必须按以下顺序执行：

1. 将历史 `end_status = 0` 归一为 `NULL`。
2. 审计进行中商机的空阶段、阶段不存在和阶段跨状态组问题。
3. 状态组存在且含有效阶段时，将异常进行中商机回填到该组排序最小的未删除阶段，并记录受影响 ID。
4. 状态组不存在或没有有效阶段时停止自动迁移，输出 ID 交由业务负责人确认，禁止随意构造阶段。
5. 迁移后执行不变量检查，要求未删除的进行中商机均有同组有效阶段。
6. 历史终态若缺少最后阶段，不做无法证明的回填，查询和报表标记为“历史阶段未知”；所有新终态流转必须保留最后阶段。

## 6. 输单原因设计

### 6.1 字段与字典

| 字段 | 类型 | 规则 |
|---|---|---|
| `loseReasonCode` | `String(64)` | 输单时必填；必须是启用的输单原因字典编码 |
| `endRemark` | `String(500)` | 输单时可选补充说明；无效时可选无效说明；保存前 `trim` |

建议公共字典类型使用 `crm_business_lose_reason`。具体字典值不在本文虚构，由曾皓冲负责的公共字典/配置工作确认后写入初始化或增量 SQL。

### 6.2 终态字段规则

| 终态 | `loseReasonCode` | `endRemark` |
|---|---|---|
| 赢单 `1` | 不得提交；成功写入时服务端置空 | 不得提交；成功写入时服务端置空 |
| 输单 `2` | 必填且必须启用 | 可选，最多 500 字符 |
| 无效 `3` | 不得提交；成功写入时服务端置空 | 可选，最多 500 字符 |

采用严格请求策略：赢单携带任一原因字段、无效携带 `loseReasonCode`、输单缺少有效原因编码时均返回参数或业务错误，不静默接受多余字段。服务端成功写入赢单或无效时显式清理不适用字段，不能保留上一次原因。历史输单数据无法可靠推断原因时，`lose_reason_code` 保持空，不伪造迁移值；报表应将其归入“历史未分类”。

## 7. 报价与金额设计

### 7.1 报价边界

当前原型只要求“商机中的产品行、优惠和汇总金额”，因此：

- 一份商机只有一组当前产品报价行。
- 报价随商机更新，不提供报价单号、审批、有效期或历史版本。
- 商机处于进行中状态时可以更新或清空产品行；进入终态后报价只读。
- 报价命令中的 `version`、`discountPercent` 和 `products` 均为必填；`products = []` 是清空报价的唯一表达，字段缺失或 `null` 均拒绝。
- 如后续原型明确要求多版本报价，必须另行评审，不能在本任务中预建模型。

### 7.2 输入、快照与计算字段

| 字段 | 来源 | 校验/处理 |
|---|---|---|
| `productId` | 客户端 | 必填；产品必须存在；新加入的产品必须启用；同一请求不可重复 |
| `productPrice` | 服务端产品主数据 | 从 `CrmProductDO.price` 读取并保存快照，不接受客户端决定 |
| `businessPrice` | 客户端 | 必填，`> 0`，最多 2 位小数 |
| `count` | 客户端 | 必填，`> 0`，最多 3 位小数，后端统一为 `BigDecimal` |
| `totalPrice`（产品行） | 服务端 | 按公式计算，客户端值忽略或从写请求移除 |
| `discountPercent` | 客户端 | 0～100，最多 2 位小数 |
| `totalProductPrice` | 服务端 | 产品行金额之和 |
| `discountAmount` | 服务端 | 产品合计乘优惠比例 |
| `totalPrice`（商机） | 服务端 | 产品合计减优惠金额 |

同一商机不允许出现重复 `productId`。服务层先用集合去重，再批量读取产品和现有产品行，按新增、保留、修改、删除四种情况校验。数据库暂不直接增加 `(business_id, product_id, deleted)` 唯一索引，因为逻辑删除后重复添加会与历史删除记录冲突；若需要数据库硬约束，必须先完成历史数据清理并单独评审索引方案。

`discountAmount` 是由产品合计、优惠比例推导出的响应字段，不新增数据库列；`totalProductPrice`、`discountPercent` 和商机 `totalPrice` 继续保存到现有商机字段中。只有商机创建和报价命令调用统一金额计算组件，普通资料更新不得重算或清空报价。

### 7.3 金额公式

统一使用 `RoundingMode.HALF_UP`，每个产品行先保留 2 位小数，再汇总：

```text
lineTotal = round(businessPrice × count, 2)
totalProductPrice = Σ lineTotal
discountAmount = round(totalProductPrice × discountPercent ÷ 100, 2)
totalPrice = totalProductPrice - discountAmount
```

`discountPercent` 保持当前代码的“优惠减免百分比”语义：

- `0`：不减免，实付 100%。
- `20`：减免 20%，实付 80%。
- `100`：全部减免，实付 0。

前端标签应显示为“优惠比例（%）”或“减免比例（%）”，避免把 `20` 误解为“打 2 折”。

示例：单价 100.00、数量 3、优惠比例 20，则产品合计 300.00、优惠金额 60.00、商机总额 240.00。

### 7.4 精度与溢出

1. 金额响应固定为 2 位小数。
2. 请求使用 `BigDecimal`，禁止先转 `double` 再计算。
3. 数据库现有金额列为 `decimal(24,6)`，写入前必须检查计算结果整数位不超过 18 位。
4. 负数、超精度、超范围或计算后溢出的请求整体失败，不保存部分产品行。
5. 空产品列表表示清空当前报价，产品合计、优惠金额和总额均为 `0.00`。

### 7.5 产品生命周期

- 新增或更新报价时，只能选择存在且启用的产品。
- 已保存的产品行保留 `productPrice` 快照；产品后续改价不反向修改已存在的产品行。新加入的产品才读取当时的主数据价格作为新快照。
- 产品后续停用不影响历史报价展示，但不能再被新报价选择。
- 活动商机中已存在而后被停用的产品允许原样保留或删除；原样保留时复用已保存的产品原价快照，且 `businessPrice`、`count` 不得修改。停用产品不能新加入报价。
- 被商机产品行引用的产品不得直接删除；删除策略由产品模块实现时补充引用检查。

## 8. 接口设计

外部路径以 `/admin-api` 为前缀，Controller 内部路径保持 `/crm/business`。

写接口职责必须拆开，避免旧通用更新绕过终态和乐观锁：

| 接口 | 可写内容 | 报价规则 |
|---|---|---|
| `POST /crm/business/create` | 商机基础资料，可同时提交初始 `discountPercent` 和 `products` | 服务端读取产品原价并使用统一金额组件；产品行为空时金额为 0 |
| `PUT /crm/business/update` | 商机基础资料和 `version` | 使用 `id + version` 条件更新并令版本加一，返回最新版本；不修改报价 |
| `PUT /crm/business/update-quotation` | `id`、`version`、`discountPercent`、`products` | 报价写入的唯一更新入口，终态不可调用 |

现有共用的 `CrmBusinessSaveReqVO` 应拆分为创建 VO 和普通更新 VO。创建 VO 的产品行不再接受 `productPrice`，普通更新 VO 不再接受任何报价字段。

普通资料更新与报价更新是两个独立保存动作。前端不得在一次“保存”点击中串行调用两个接口，否则第一个请求令版本加一后，第二个请求会使用旧版本并形成部分成功。如果产品要求一次保存基础资料和报价，应另增服务层组合命令，在同一事务内完成两部分写入；本次设计默认使用两个独立按钮，并在每次成功后用响应的新版本刷新页面状态。

### 8.1 状态更新

保留并增强现有接口：

```http
PUT /admin-api/crm/business/update-status
```

所需功能权限为 `crm:business:update`，实际 HTTP `Authorization` 头仍按项目登录令牌规范传递，不能把权限标识当作令牌。

进行中阶段请求：

```json
{
  "id": 1001,
  "version": 3,
  "statusId": 22
}
```

输单请求：

```json
{
  "id": 1001,
  "version": 3,
  "endStatus": 2,
  "loseReasonCode": "REASON_CODE_FROM_DICT",
  "endRemark": "客户本期预算取消"
}
```

响应返回最新状态快照，避免前端继续使用旧版本：

```json
{
  "code": 0,
  "data": {
    "id": 1001,
    "version": 4,
    "statusId": 21,
    "endStatus": 2,
    "loseReasonCode": "REASON_CODE_FROM_DICT",
    "endRemark": "客户本期预算取消"
  }
}
```

### 8.2 报价更新

新增商机子命令接口，但不新增报价领域实体：

```http
PUT /admin-api/crm/business/update-quotation
```

所需功能权限为 `crm:business:update`。

请求只包含业务输入，不包含可信金额结果：

```json
{
  "id": 1001,
  "version": 4,
  "discountPercent": 20,
  "products": [
    {
      "productId": 3001,
      "businessPrice": 100.00,
      "count": 3
    }
  ]
}
```

`version`、`discountPercent`、`products` 均使用 `@NotNull`；产品列表元素使用级联校验且不得为 `null`。`products: []` 表示清空，缺失或 `null` 不等价于清空。

响应返回服务端计算快照：

```json
{
  "code": 0,
  "data": {
    "id": 1001,
    "version": 5,
    "totalProductPrice": 300.00,
    "discountPercent": 20.00,
    "discountAmount": 60.00,
    "totalPrice": 240.00,
    "products": [
      {
        "productId": 3001,
        "productPrice": 120.00,
        "businessPrice": 100.00,
        "count": 3.000,
        "totalPrice": 300.00
      }
    ]
  }
}
```

### 8.3 查询接口

- `GET /admin-api/crm/business/get?id={id}` 返回 `version`、终态原因、报价汇总和产品行快照。
- `GET /admin-api/crm/business-status/status-simple-list?typeId={typeId}` 只返回指定状态组未逻辑删除的阶段，并按 `sort` 升序。
- `GET /admin-api/crm/product/simple-list` 供报价选择启用产品；历史报价展示不依赖该下拉接口。
- 输单原因使用项目统一字典查询接口，不建立商机私有字典接口。

### 8.4 跟进记录接口

继续复用：

```http
POST /admin-api/crm/follow-up-record/create
```

服务端必须校验 `bizType` 与 `bizId` 匹配、商机和关联对象存在且属于当前租户。插入跟进记录、更新商机最后跟进时间和更新关联对象必须位于同一事务；任一步失败整体回滚。本阶段不新建商机专用跟进接口。

### 8.5 错误码预留

以下编号应在开发前由技术负责人检查冲突后落库；现有错误码继续复用。

| 建议常量 | 建议编号 | 场景 |
|---|---:|---|
| `BUSINESS_STATUS_REQUEST_CONFLICT` | `1_020_002_004` | `statusId` 与 `endStatus` 未严格二选一 |
| `BUSINESS_STATUS_TRANSITION_NOT_ALLOWED` | `1_020_002_005` | 回退、跨组或非法流转 |
| `BUSINESS_LOSE_REASON_REQUIRED` | `1_020_002_006` | 输单原因缺失 |
| `BUSINESS_LOSE_REASON_INVALID` | `1_020_002_007` | 原因字典不存在或已停用 |
| `BUSINESS_VERSION_CONFLICT` | `1_020_002_008` | 乐观锁版本冲突 |
| `BUSINESS_QUOTE_PRODUCT_DUPLICATE` | `1_020_002_009` | 报价存在重复产品 |
| `BUSINESS_QUOTE_AMOUNT_INVALID` | `1_020_002_010` | 金额、数量、折扣或计算结果非法 |

同时应修复已发现的商机阶段错误码重复定义，避免两个语义共用同一编号。

### 8.6 权限、租户与审计

1. 状态和报价更新复用 `crm:business:update` 权限及 `CrmPermissionLevelEnum.WRITE` 数据权限。
2. 查询复用 `crm:business:query` 和现有数据范围。
3. 产品、状态、商机和跟进的所有关联校验都必须在当前租户范围内执行。
4. 客户端不得提交或覆盖 `tenantId`、`creator`、`updater`、汇总金额和产品原价快照。
5. 状态、原因和报价更新保留项目现有操作日志；如项目审计要求更高，再增加变更前后快照日志。

## 9. 事务与服务流程

### 9.1 状态更新流程

1. 校验请求字段、终态字段组合和版本号。
2. 按数据权限读取商机当前快照。
3. 校验当前不是终态。
4. 阶段流转时读取当前和目标阶段，校验状态组、排序和未逻辑删除状态。
5. 终态流转时校验输单原因字典和说明字段。
6. 使用 `id + version + end_status IS NULL` 条件更新并令版本加一。
7. 返回最新状态快照；任一步失败回滚。

### 9.2 报价更新流程

1. 校验折扣、产品行、数量、业务单价和重复产品。
2. 读取现有产品行并批量读取当前租户内产品：新增产品必须启用；已有停用产品只能原样保留或删除；已有产品复用其产品原价快照。
3. 使用 `BigDecimal` 逐行计算并汇总，校验精度和溢出。
4. 使用 `id + version + end_status IS NULL` 条件更新商机金额并令版本加一。
5. 删除当前商机的有效产品行，再批量插入新快照。
6. 父表更新和产品行替换位于同一个 `@Transactional` 事务。
7. 返回服务端计算后的最新报价快照。

若并发请求携带相同旧版本，只允许一个请求成功；另一个请求返回版本冲突，不得覆盖成功请求的产品行。

现有商机创建和通用更新接口不得成为绕过报价规则的入口：创建商机若同时提交产品行，必须复用同一套产品校验和金额计算服务；通用更新接口应移除可直接写入的产品原价及汇总金额字段，报价修改统一进入 `update-quotation` 命令。

## 10. 前端交互设计

### 10.1 状态弹窗

- 展示当前阶段、可向前阶段和三个终态，当前阶段及更早阶段不可选。
- 选择“输单”时显示必填的输单原因下拉框和可选的补充说明。
- 选择“无效”时显示可选说明；选择“赢单”时不显示原因字段。
- 提交前显示“当前状态 → 目标状态”的二次确认。
- 请求携带详情中的 `version`；版本冲突时提示“商机已被其他人更新，请刷新后重试”。
- 终态详情只读，不显示普通状态修改入口。

### 10.2 报价表单

- 产品下拉只列出启用产品；已保存但已停用的产品行以“已停用”标记只读展示，只允许保留或删除。
- 同一产品再次选择时立即提示并阻止提交。
- 数量输入最多 3 位小数，业务单价和优惠比例最多 2 位小数。
- 前端金额只作即时预览，保存后以响应中的服务端金额覆盖预览值。
- 优惠比例控件范围固定为 0～100，标签明确其为“减免比例”。
- 终态商机的报价表单不可编辑。
- 商机基础资料和报价分别保存；任一保存成功后立即更新页面中的 `version`，不在前端把两个写接口拼成一次提交。

## 11. Docker 影响设计

本功能不新增服务、端口、镜像、环境变量或中间件，预计不修改 `docker-compose/docker-compose.yml`、现有 Dockerfile 和 `Server/mitedtsm-server/src/main/resources/application-docker.yaml`。影响仅来自数据库增量字段与历史数据归一：

| 项目 | 影响结论 | 执行动作 |
|---|---|---|
| 后端/前端镜像 | 无镜像结构变化 | 按现有构建流程重新打包即可 |
| Compose 服务编排 | 无新增服务、端口、网络或数据卷 | 不修改 `docker-compose/docker-compose.yml` |
| 应用环境变量 | 无新增配置项 | 不修改 `.env` 和 `application-docker.yaml` |
| 已有数据库升级 | 有影响 | 在 `database/new` 执行版本号、输单原因和历史数据归一增量 SQL |
| 全新 Docker 数据库 | 有影响 | 李祖豪核验 `docker-compose/init/init-mysql.sh` 固定 SQL 清单和初始化顺序，确保新增字段进入全新库 |
| 回滚 | 有数据结构影响 | 增量脚本提供可评审的回滚说明；生产数据不得直接删除原因或版本字段 |

`docker-compose/init/init-mysql.sh` 不会自动执行 `database/new` 的全部脚本，因此不能只把 SQL 放入 `database/new` 就宣称容器初始化已覆盖。阶段 6 必须在空数据卷下启动 Compose，并实际核验新表结构、字典、状态更新和报价更新。

## 12. 测试设计

### 12.1 测试状态口径

| 项目 | 当前状态 | 说明 |
|---|---|---|
| 本文静态设计检查 | 已完成 | 已对照任务书、阶段 0 文档和当前源代码 |
| CRM Java 单元测试 | 未运行/待新增 | `docs@a202214b` 缺少对应 `src/test/java` 用例 |
| 接口联调 | 未运行 | 未启动完整后端、数据库和登录环境 |
| 浏览器页面测试 | 未运行 | 本阶段未实现前端代码 |
| 组内交叉测试 CT-07 | 未运行 | 应在实现和自测通过后交由刘焘玮执行 |

### 12.2 后端单元测试矩阵

| 编号 | 场景 | 预期结果 | 优先级 |
|---|---|---|---|
| UT-S-01 | 同组从较早阶段前进到较晚阶段 | 成功，版本加一 | P0 |
| UT-S-02 | 前进时跳过中间阶段 | 成功，版本加一 | P0 |
| UT-S-03 | 提交当前相同阶段 | 返回阶段相同错误，数据不变 | P0 |
| UT-S-04 | 回退到更早阶段 | 返回流转不允许 | P0 |
| UT-S-05 | 流转到其他状态组阶段 | 返回流转不允许 | P0 |
| UT-S-06 | `statusId`、`endStatus` 同时提交或同时为空 | 参数校验失败 | P0 |
| UT-S-07 | 任一进行中阶段进入赢单 | 成功，原因字段为空且最后 `statusId` 保留 | P0 |
| UT-S-08 | 输单未提交原因、原因空白或字典停用 | 失败且数据不变 | P0 |
| UT-S-09 | 输单原因有效并带 500 字说明 | 成功并可回读，最后 `statusId` 保留 | P0 |
| UT-S-10 | 说明超过 500 字 | 参数校验失败 | P1 |
| UT-S-11 | 终态再次更新状态 | 返回终态不可变更 | P0 |
| UT-S-12 | 相同版本并发更新 | 仅一个成功，另一个版本冲突 | P0 |
| UT-S-13 | 赢单携带原因字段或无效携带输单原因编码 | 严格拒绝，数据不变 | P0 |
| UT-S-14 | 进入无效终态并提交合法说明 | 成功，输单原因编码为空且最后阶段保留 | P1 |
| UT-S-15 | 迁移后仍有进行中商机缺阶段或阶段跨组 | 不变量检查失败并阻止发布 | P0 |
| UT-Q-01 | 单价 100、数量 3、优惠 20 | 汇总为 300.00、60.00、240.00 | P0 |
| UT-Q-02 | 小数乘法触发 HALF_UP | 逐行 2 位舍入后再汇总 | P0 |
| UT-Q-03 | 优惠比例 0 和 100 | 总额分别为产品合计和 0.00 | P0 |
| UT-Q-04 | 优惠小于 0、大于 100 或超 2 位小数 | 拒绝 | P0 |
| UT-Q-05 | 数量为 0、负数或超 3 位小数 | 拒绝 | P0 |
| UT-Q-06 | 业务单价为 0、负数或超 2 位小数 | 拒绝 | P0 |
| UT-Q-07 | 同一请求包含重复产品 | 拒绝且不写入 | P0 |
| UT-Q-08 | 产品不存在或新加入的产品已停用 | 拒绝且不写入 | P0 |
| UT-Q-09 | 客户端伪造产品原价和汇总金额 | 服务端忽略并按主数据重算 | P0 |
| UT-Q-10 | 计算结果超过数据库范围 | 整体失败，无部分数据 | P1 |
| UT-Q-11 | 清空产品列表 | 产品行清空，三个金额为 0.00 | P1 |
| UT-Q-12 | 产品行插入异常 | 父表金额和产品行整体回滚 | P0 |
| UT-Q-13 | 两个相同版本并发更新报价 | 仅一个成功，产品行不混合 | P0 |
| UT-Q-14 | 已有产品改价后原样保留该产品行 | 继续使用原产品原价快照 | P1 |
| UT-Q-15 | 已有产品停用后原样保留或删除 | 两种操作均成功 | P0 |
| UT-Q-16 | 修改已有停用产品的单价或数量 | 拒绝且报价不变 | P0 |
| UT-Q-17 | `products` 或 `discountPercent` 缺失/为 `null` | 参数校验失败；仅空数组表示清空 | P0 |
| UT-B-01 | 普通资料更新使用旧版本 | 返回版本冲突，基础资料和报价均不变 | P0 |
| UT-B-02 | 普通资料更新与报价更新使用相同版本并发提交 | 仅一个成功，另一个版本冲突 | P0 |
| UT-B-03 | 普通资料更新成功 | 版本加一，所有报价字段和产品行保持不变 | P0 |
| UT-F-01 | 跟进插入后商机联动失败 | 跟进记录和联动更新整体回滚 | P0 |
| UT-T-01 | 跨租户商机、阶段或产品 ID | 按不存在或无权限处理 | P0 |

建议落点：

- `CrmBusinessServiceImplTest`：状态机、输单原因、金额、事务、乐观锁。
- `CrmBusinessStatusServiceImplTest`：赢单率边界、阶段排序和已使用状态组保护。
- `CrmProductServiceImplTest`：停用产品和已引用产品删除保护。
- `CrmFollowUpRecordServiceImplTest`：关联校验和事务回滚。

### 12.3 接口与页面测试

| 编号 | 层级 | 场景 | 预期结果 |
|---|---|---|---|
| API-01 | 参数校验 | 状态目标双填、空填、非法终态值 | HTTP 业务响应为参数错误 |
| API-02 | 权限 | 无 `crm:business:update` 更新状态或报价 | 拒绝访问 |
| API-03 | 数据权限 | 非负责人且无写权限修改商机 | 拒绝访问 |
| API-04 | 并发 | 使用旧 `version` 提交 | 返回版本冲突，不覆盖数据 |
| API-05 | 查询 | 状态或报价更新后重新查询 | 状态、版本、原因和金额一致 |
| API-06 | 兼容边界 | 旧通用更新接口提交产品或金额字段 | 不得修改报价，提示改用报价命令 |
| API-07 | 终态保护 | 对终态商机调用报价命令 | 拒绝且金额、产品行不变 |
| UI-01 | 状态弹窗 | 选择输单 | 原因下拉必填、说明可选 |
| UI-02 | 状态弹窗 | 选择赢单或无效 | 原因字段按规则显示和清理 |
| UI-03 | 报价表格 | 重复产品、非法数量、非法价格 | 前端即时提示且不能提交 |
| UI-04 | 金额预览 | 修改数量、单价、优惠 | 预览正确，保存后使用服务端结果 |
| UI-05 | 终态详情 | 打开已结束商机 | 状态和报价入口只读 |
| UI-06 | 兼容性 | Chrome、Edge 常用分辨率 | 表格、弹窗和错误提示可用 |

### 12.4 建议验证命令

实现后执行以下定向测试；实际类名以最终代码为准：

```powershell
cd Server
mvn -pl mitedtsm-module-crm -am `
  -Dtest=CrmBusinessServiceImplTest,CrmBusinessStatusServiceImplTest,CrmProductServiceImplTest,CrmFollowUpRecordServiceImplTest `
  "-Dsurefire.failIfNoSpecifiedTests=false" test
```

前端在修复本任务涉及的存量类型错误后执行：

```powershell
cd Web
$env:NODE_OPTIONS='--max_old_space_size=8192'
pnpm.cmd ts:check
```

测试报告必须分别记录“已通过、未通过、未运行、无法验证”，不得把本地实验测试或全仓存量错误写成本功能已通过或本功能新增失败。

## 13. 实施顺序与文件落点

### 13.1 阶段 2：商机与产品

1. 在 `database/new` 增加 `version`、`lose_reason_code` 和历史 `end_status=0` 归一脚本。
2. 调整 `CrmBusinessDO`、状态 DO、请求/响应 VO 的类型与字段。
3. 增加状态流转校验、字典校验、条件更新和错误码。
4. 增加报价命令 VO、服务端产品快照、金额计算和产品去重。
5. 给状态和报价更新增加事务、权限和租户验证。
6. 实现状态、金额、并发与事务单元测试并实际执行。

### 13.2 阶段 3：报价与跟进联动

1. 接入前端状态弹窗的输单原因和版本号。
2. 修正报价数量、价格、优惠比例类型和边界，接入服务端报价响应。
3. 将跟进记录插入及商机联动纳入事务并补关联校验。
4. 完成接口联调、浏览器页面测试和回归测试。
5. 由刘焘玮执行 CT-07 商机/产品交叉测试。
6. 按评审规则提交技术评审和测试评审证据。

### 13.3 预计修改文件

后端主要涉及：

- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/dataobject/business/CrmBusinessDO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/dataobject/business/CrmBusinessProductDO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/dataobject/business/CrmBusinessStatusDO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/controller/admin/business/vo/business/CrmBusinessSaveReqVO.java`（现有共用 VO，拆分后移除）
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/controller/admin/business/vo/business/CrmBusinessCreateReqVO.java`（新增，含服务端可信边界后的初始产品输入）
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/controller/admin/business/vo/business/CrmBusinessUpdateReqVO.java`（新增，仅基础资料和版本）
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/controller/admin/business/vo/business/CrmBusinessUpdateStatusReqVO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/controller/admin/business/vo/business/CrmBusinessUpdateQuotationReqVO.java`（新增）
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/controller/admin/business/vo/business/CrmBusinessQuotationRespVO.java`（新增）
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/controller/admin/business/vo/business/CrmBusinessRespVO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/controller/admin/business/CrmBusinessController.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/service/business/CrmBusinessService.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/service/business/CrmBusinessServiceImpl.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/mysql/business/CrmBusinessMapper.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/service/followup/CrmFollowUpRecordServiceImpl.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/enums/ErrorCodeConstants.java`
- `database/new/crm-business-opportunity-upgrade.sql`（新增，最终文件名按仓库迁移命名规范确认）

前端主要涉及：

- `Web/src/api/crm/business/index.ts`
- `Web/src/views/crm/business/BusinessUpdateStatusForm.vue`
- `Web/src/views/crm/business/BusinessForm.vue`
- `Web/src/views/crm/business/components/BusinessProductForm.vue`
- `Web/src/views/crm/business/detail/index.vue`

测试主要涉及：

- `Server/mitedtsm-module-crm/src/test/java/com/meession/etm/module/crm/service/business/CrmBusinessServiceImplTest.java`
- `Server/mitedtsm-module-crm/src/test/java/com/meession/etm/module/crm/service/business/CrmBusinessStatusServiceImplTest.java`
- `Server/mitedtsm-module-crm/src/test/java/com/meession/etm/module/crm/service/product/CrmProductServiceImplTest.java`
- `Server/mitedtsm-module-crm/src/test/java/com/meession/etm/module/crm/service/followup/CrmFollowUpRecordServiceImplTest.java`

## 14. 验收标准

- [x] 已明确进行中阶段、终态、跳级、回退、跨组和重开规则。
- [x] 已明确输单原因的数据结构、终态组合和字典依赖。
- [x] 已明确不建立独立报价模型。
- [x] 已明确产品快照、金额公式、舍入、精度和服务端可信边界。
- [x] 已明确状态和报价接口契约、权限、租户、事务与并发策略。
- [x] 已形成后端、接口、页面、权限、并发和多租户测试矩阵。
- [x] 已明确 Docker 镜像、Compose、环境变量、数据库初始化和空数据卷验证影响。
- [x] 已区分设计完成、代码未实现和测试未运行。
- [ ] 曾皓冲确认输单原因字典类型及字典值。
- [ ] 李祖豪完成技术设计评审并确认错误码、乐观锁和增量 SQL。
- [ ] 安炳琨完成测试设计评审。
- [ ] 后续实现、自测和 CT-07 交叉测试完成。

## 15. 风险与评审重点

1. `discountPercent` 当前语义是“减免比例”，与口语中的“打几折”相反，前后端文案必须统一。
2. `version` 引入后，所有会覆盖状态、报价或商机核心字段的写接口都应携带版本，否则仍可能发生丢更新。
3. 历史 `end_status=0` 若不归一，会与 `NULL` 表示进行中的规则冲突，并可能触发枚举解析异常。
4. 输单原因字典值尚待公共配置负责人确认，代码中不得硬编码或虚构选项。
5. `docs@a202214b` 缺少 CRM Java 业务测试，实施阶段必须先补测试基础设施和数据脚本。
6. 前端全量类型检查存在存量错误，回归报告应同时给出全量结果和 GAP-006 涉及文件的定向结果。
7. 报价产品行采用删除后重建策略时，必须依靠事务和版本锁，避免并发请求形成混合产品行。

## 16. 阶段 1 设计结论

GAP-006 的状态流转、输单原因、金额规则、接口、事务并发和测试设计已经形成可实施基线。后续开发必须复用现有 CRM 商机、阶段、产品、产品行和跟进模型，先完成字典、技术和测试评审，再按阶段 2、阶段 3 顺序实现和验证。
