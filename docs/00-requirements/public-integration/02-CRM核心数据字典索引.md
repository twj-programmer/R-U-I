<!-- 作者：23软4 姚昱竹 -->

# CRM 核心数据字典索引

> 当前角色：度量专员  
> 基线日期：2026-07-14  
> 数据源：`database/base/crm-2024-09-30.sql` 与当前 CRM DataObject  
> 定位：这是评审和测试使用的核心字段索引；最终数据库发布前仍需以实际初始化库 `information_schema` 复核

## 1. 通用字段

| 字段 | 含义 | 统一规则 |
|---|---|---|
| `id` | 主键 | bigint，自增或业务生成，不允许复用 |
| `tenant_id` | 租户编号 | 所有查询、统计、导出和测试数据必须隔离 |
| `deleted` | 逻辑删除 | `0` 有效，`1` 删除；统计默认排除删除数据 |
| `creator`/`updater` | 创建/更新用户 | 用于审计，不等同于业务负责人 |
| `create_time`/`update_time` | 创建/更新时间 | 测试数据必须可控制时间，以覆盖跨日、月、年 |
| `owner_user_id` | 业务负责人 | 人员维度统计和数据权限的核心字段 |

## 2. 主业务表

| 表 | 业务含义 | 主键和关键外键 | 核心状态/金额/时间字段 | 主要统计用途 |
|---|---|---|---|---|
| `crm_clue` | 销售线索 | `id`，`customer_id`，`owner_user_id` | `transform_status`、`follow_up_status`、`create_time` | 新增线索、转化、跟进 |
| `crm_customer` | 客户 | `id`，`owner_user_id` | `deal_status`、`lock_status`、`owner_time`、`create_time` | 新增/成交客户、画像、公海 |
| `crm_contact` | 联系人 | `id`，`customer_id`，`owner_user_id` | `master`、`contact_last_time`、`create_time` | 联系人排行、客户关系 |
| `crm_business` | 商机 | `id`，`customer_id`，`status_type_id`，`status_id`，`owner_user_id` | `end_status`、`deal_time`、`total_price`、`create_time` | 漏斗、赢单率、金额 |
| `crm_contract` | 合同 | `id`，`customer_id`，`business_id`，`owner_user_id` | `audit_status`、`order_date`、`start_time`、`end_time`、`total_price` | 合同数量/金额、成交周期 |
| `crm_receivable` | 回款 | `id`，`plan_id`，`customer_id`，`contract_id`，`owner_user_id` | `audit_status`、`return_time`、`return_type`、`price` | 回款金额、回款排行 |
| `crm_receivable_plan` | 回款计划 | `id`，`customer_id`，`contract_id`，`receivable_id`，`owner_user_id` | `period`、`return_time`、`price`、`remind_time` | 计划金额、逾期、提醒 |
| `crm_product` | 产品 | `id`，`category_id`，`owner_user_id` | `no`、`unit`、`price`、`status` | 产品销量、产品维度成交周期 |
| `crm_follow_up_record` | 跟进记录 | `id`，`biz_type`+`biz_id` | `type`、`next_time`、`create_time` | 跟进次数、去重跟进客户 |

## 3. 关联和配置表

| 表 | 关系/用途 | 关键字段 | 完整性要求 |
|---|---|---|---|
| `crm_business_product` | 商机与产品明细 | `business_id`、`product_id`、`count`、`business_price`、`total_price` | `total_price = business_price × count` |
| `crm_contract_product` | 合同与产品明细 | `contract_id`、`product_id`、`count`、`contract_price`、`total_price` | 产品销量应对 `count` 求和 |
| `crm_contact_business` | 联系人与商机多对多 | `contact_id`、`business_id` | 组合关系不得重复 |
| `crm_permission` | CRM 业务对象成员权限 | `biz_type`、`biz_id`、`user_id`、`level` | 同一对象/用户权限需唯一；不能跨租户 |
| `crm_business_status_type` | 商机状态组 | `id`、`name`、`dept_ids` | 部门范围必须能解析 |
| `crm_business_status` | 商机阶段 | `type_id`、`name`、`percent`、`sort` | `percent` 0–100，排序稳定 |
| `crm_product_category` | 产品分类树 | `id`、`parent_id`、`name` | 不允许循环父子关系 |
| `crm_customer_limit_config` | 客户领取/拥有上限 | `type`、`user_ids`、`dept_ids`、`max_count` | 用户与部门范围不能冲突 |
| `crm_customer_pool_config` | 公海规则 | `enabled`、`contact_expire_days`、`deal_expire_days`、`notify_days` | 天数非负，关闭时规则不生效 |
| `crm_contract_config` | 合同到期提醒 | `notify_enabled`、`notify_days` | 天数非负 |

## 4. 关键枚举和字典

| 字典 | 字段 | 当前含义 | 测试数据要求 |
|---|---|---|---|
| 审批状态 | `audit_status` | 未提交、审批中、审批通过、审批不通过等，以 `CrmAuditStatusEnum` 为准 | 每种状态至少一条，统计只计通过 |
| 商机结束状态 | `end_status` | 赢单、输单、无效；空值表示未结束 | 四类均需覆盖 |
| 跟进业务类型 | `biz_type` | 线索、客户、联系人、商机、合同等业务对象 | 至少覆盖客户和商机 |
| 跟进方式 | `type` | 电话、拜访、邮件等系统字典值 | 每种有效字典值及一个非法值 |
| 客户来源 | `source` | 系统 CRM 客户来源字典 | 每个值、空值、失效值 |
| 客户级别 | `level` | 系统 CRM 客户级别字典 | 每个值和空值 |
| 所属行业 | `industry_id` | 系统 CRM 行业字典 | 每个值和空值 |
| 地区 | `area_id` | 系统地区树编号 | 省/市/区、空值、无效编号 |
| 回款方式 | `return_type` | 系统回款方式字典 | 正常值、空值、非法值 |
| 产品单位 | `unit` | 系统产品单位字典 | 正常值、失效值 |

## 5. 核心业务关系

```text
线索 crm_clue
  └─转化→ 客户 crm_customer
             ├─联系人 crm_contact
             ├─商机 crm_business ─产品明细→ crm_business_product
             │                    └─联系人关系→ crm_contact_business
             └─合同 crm_contract ─产品明细→ crm_contract_product
                       ├─回款计划 crm_receivable_plan
                       └─回款 crm_receivable

任一业务对象 ─成员权限→ crm_permission
任一可跟进业务对象 ─跟进记录→ crm_follow_up_record
```

## 6. 数据质量规则

| 编号 | 规则 | 校验方式 |
|---|---|---|
| DQ-01 | 合同、回款、计划的客户和合同关系必须存在且属于同一租户 | 外键关系查询 |
| DQ-02 | 金额不得为负；是否允许 0 由业务确认 | API 校验 + SQL 抽查 |
| DQ-03 | `owner_user_id` 必须为有效用户且符合部门/权限范围 | 用户表关联 |
| DQ-04 | 审批通过记录必须具备业务日期和金额 | 状态条件查询 |
| DQ-05 | 商机/合同产品明细合计应与主表金额规则一致 | 主从表金额比对 |
| DQ-06 | 回款累计不得违反合同金额和超额回款规则 | 合同维度汇总 |
| DQ-07 | 已删除记录不得进入页面统计或导出 | 删除前后对比 |
| DQ-08 | 不同租户使用相同业务编号时仍必须完全隔离 | 双租户测试 |

## 7. 当前结构待确认项

| 编号 | 现状 | 风险 |
|---|---|---|
| DD-R01 | 基线 SQL 中 `crm_contact.owner_user_id` 为 `varchar(256)`，当前 Java DO 为 `Long` | 初始化库与代码类型可能不一致 |
| DD-R02 | 基线 SQL 中部分 `area_id` 为 bigint，Java DO 使用 Integer | 极端编号范围和映射需确认 |
| DD-R03 | 基线 SQL 中联系人 `qq` 为 int，Java DO 为 Long；线索/客户又为 String | 导入和导出格式可能不一致 |
| DD-R04 | 业务表没有数据库外键约束，关系完整性依赖应用层 | AI 数据直接写库时容易产生孤儿数据 |
| DD-R05 | 当前 DataObject 与 2024 基线 SQL 的演进缺少集中迁移说明 | 最终字典需从实际初始化库反向核对 |

## 8. 数据字典确认栏

| 模块 | 业务确认人 | 技术确认人 | 数据库实测版本/提交号 | 结论 |
|---|---|---|---|---|
| 客户/线索/联系人 |  |  |  |  |
| 商机/产品 |  |  |  |  |
| 合同/审批 |  |  |  |  |
| 回款/回款计划 |  |  |  |  |
| 统计/导出 | 姚昱竹 |  |  |  |
