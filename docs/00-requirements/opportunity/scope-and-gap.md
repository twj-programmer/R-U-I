<!-- 23计科4班 黄金戈 -->

# GAP-006 阶段 0：范围与差异核验

## 1. 基本信息

| 项目 | 内容 |
|---|---|
| 任务编号 | GAP-006 |
| 开发包 | PKG-02 商机产品 |
| 负责人 | 黄金戈（HJG） |
| 阶段 | 阶段 0：核验与需求 |
| 日期 | 2026-07-14 上午 |
| 阶段产出 | 商机产品缺口清单 |
| 当前判定 | 改进功能，不重新建设商机域 |

## 2. 本阶段范围

本阶段核验以下现有能力，并确认是否存在重复建模风险：

1. 商机 CRUD、详情、权限和负责人数据范围。
2. 商机阶段组、阶段配置、阶段流转和输单原因。
3. 报价的产品行、价格、数量、折扣和汇总金额。
4. 产品主数据及商机产品关联。
5. 跟进记录与商机的关联和联动更新。

本阶段只形成事实基线、缺口和后续设计输入，不实施业务代码，不新增表、实体、接口或页面。

## 3. 采用的事实口径

旧版 `Proj-Docs-v-6/03-Gap-Analysis/01-Gap-Analysis.md` 曾把商机 CRUD、阶段和跟进记录判为“无/新建”。该结论与当前源码和最新版分工计划冲突，因此只能视为历史假设。

本次按以下优先级采用证据：

1. 当前仓库源码和初始化 SQL。
2. 最新《全 CRM 差异补齐任务分工与 Git 协同开发计划》。
3. 实际执行的测试结果。
4. 旧 GAP 文档仅用于定位待核验项。

## 4. 现有能力与 GAP 矩阵

| 能力 | 当前证据 | 阶段 0 判定 | 后续需确认或补齐 |
|---|---|---|---|
| 商机 | `CrmBusinessDO`、`crm_business`、`CrmBusinessController`、`CrmBusinessServiceImpl`、`Web/src/views/crm/business` | 已有完整基础承载，直接复用 | 删除商机后的产品行和跟进记录保留策略；补完整 CRUD/权限测试 |
| 阶段与输单 | `CrmBusinessStatusTypeDO`、`CrmBusinessStatusDO`、状态配置页面、`updateBusinessStatus` | 已有阶段组、阶段、前向流转、赢单/输单和输单原因 | 赢单率 0～100 范围；是否允许跳级、回退、重新打开；输单原因是否字典化 |
| 报价与金额 | `CrmBusinessProductDO`、`crm_business_product`、商机产品表单、服务端金额计算 | 已有“产品行 + 折扣 + 汇总金额”的核心表达 | 是否需要报价单号、版本、审批、有效期和历史版本；未确认前不得建立独立报价模型 |
| 产品关联 | `CrmProductDO`、`crm_product`、`CrmBusinessProductDO` | 已复用 CRM 产品主数据和商机产品关系 | 同一商机是否允许重复产品；禁用产品处理；产品被历史商机引用时的删除规则 |
| 跟进记录 | `CrmFollowUpRecordDO`、`crm_follow_up_record`、通用跟进表单和 `bizType/bizId` | 已有通用跟进模型并可关联商机 | 新增跟进的事务边界；业务类型和关联 ID 校验；是否允许编辑跟进 |

## 5. 关键代码与数据证据

### 5.1 后端模型

- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/dataobject/business/CrmBusinessDO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/dataobject/business/CrmBusinessProductDO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/dataobject/business/CrmBusinessStatusDO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/dataobject/business/CrmBusinessStatusTypeDO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/dataobject/product/CrmProductDO.java`
- `Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/dal/dataobject/followup/CrmFollowUpRecordDO.java`

### 5.2 前端和 API

- `Web/src/api/crm/business/index.ts`
- `Web/src/api/crm/followup/index.ts`
- `Web/src/views/crm/business/index.vue`
- `Web/src/views/crm/business/BusinessForm.vue`
- `Web/src/views/crm/business/BusinessUpdateStatusForm.vue`
- `Web/src/views/crm/business/components/BusinessProductForm.vue`
- `Web/src/views/crm/business/detail/index.vue`
- `Web/src/views/crm/followup/FollowUpRecordForm.vue`

### 5.3 数据库和权限

- `database/base/crm-2024-09-30.sql` 已包含 `crm_business`、`crm_business_product`、`crm_business_status`、`crm_business_status_type`、`crm_follow_up_record`、`crm_product`。
- `database/base/ruoyi-vue-pro.sql` 已包含商机与阶段配置菜单及 `crm:business:*`、`crm:business-status:*` 权限。

## 6. 不可重复建模结论

| 禁止新建 | 必须复用 |
|---|---|
| `Opportunity`、`BusinessOpportunity` 或第二套商机表 | `CrmBusinessDO` / `crm_business` |
| 第二套阶段或阶段组模型 | `CrmBusinessStatusDO`、`CrmBusinessStatusTypeDO` |
| 重复的商机产品/报价明细表 | `CrmBusinessProductDO` / `crm_business_product` |
| PKG-02 内复制的产品主数据 | `CrmProductDO` / `crm_product` |
| 商机专用重复跟进表 | `CrmFollowUpRecordDO` / `crm_follow_up_record` |
| 第二套商机 API 和页面 | `/crm/business/**`、`Web/src/views/crm/business` |

独立报价子能力只有在原型明确要求报价单号、多版本、审批、有效期或历史版本，且当前模型无法表达时，才可进入 AISDD 设计和技术评审。

## 7. 已确认风险

1. 商机产品列表当前未明确阻止重复 `productId`，数据库也没有对应唯一约束。
2. 删除产品时未见商机引用保护，需要确认停用、禁止删除或快照策略。
3. 删除商机时未显式说明产品行和跟进记录的处理规则。
4. 跟进新增包含“插入记录 + 更新主对象/关联对象”，未见显式事务。
5. 跟进业务类型和关联 ID 的合法性校验不足。
6. 阶段赢单率缺少 0～100 范围校验。
7. CRM DO 使用 `BaseDO`，而表中存在 `tenant_id`；需技术负责人核验租户插件与最新版 `TenantBaseDO` 约束的一致性。

## 8. 实际验证结果

| 验证项 | 状态 | 证据 |
|---|---|---|
| `CrmBusinessValidationTest` | 已通过 | 6 项通过，0 Failure，0 Error，0 Skipped |
| 全量前端 TypeScript 检查 | 未通过 | 提高 Node 堆到 8 GB 后完整执行，共 1164 行 `error TS...`；其中匹配 `src/api/crm/` 或 `src/views/crm/` 的错误 107 行，计数命令见 `acceptance-criteria.md` |
| 浏览器页面操作 | 未运行 | 未启动完整前后端环境 |
| 商机接口联调 | 未运行 | 未启动 Server、数据库和登录环境 |
| 数据库初始化实测 | 未运行 | 本阶段只核验初始化 SQL 内容 |

前端失败属于仓库当前基线问题；本阶段没有修改业务源码，不能把它归因为 GAP-006 新改动，也不能写成验证通过。

## 9. 阶段 0 结论

GAP-006 已完成“现有能力核验、真实缺口识别和不可重复建模确认”。下一阶段必须先冻结报价边界、状态规则、产品引用、跟进事务和多租户口径，再在现有 CRM 模型上实施最小改进。
