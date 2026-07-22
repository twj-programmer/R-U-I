# 财务域 阶段 1 —— AISDD 详细设计

> **负责人**：唐文军（feature/finance）
> **设计范围**：回款计划执行状态机、逾期检测、定时提醒、金额校验、偏差提示
> **对应阶段 0 缺口**：FIN-GAP-01 ~ FIN-GAP-05
> **基线日期**：2026-07-14
> **设计依据**：《07-财务域阶段0-基线核验与缺口清单》、《15-全CRM差异补齐任务分工与Git协同开发计划》、《EDIT_GUIDE_BY_3031.md》
> **设计原则**：在现有模块最小修改，不建立平行模型，优先复用现有 BPM/权限/操作日志/编号生成

---

## 1. 领域设计（DDD）

### 1.1 回款计划状态机（FIN-GAP-01）

#### 1.1.1 状态定义

```
┌──────────┐                     ┌──────────┐
│  PENDING │──────────────────→  │  PARTIAL │
│  待回款   │   首笔回款审批通过    │  部分回款  │
│   (0)    │                     │   (1)    │
└────┬─────┘                     └────┬─────┘
     │ returnTime 过期               │ returnTime 过期
     │ + 无回款                      │ + 回款金额 < 计划金额
     ▼                               ▼
┌──────────┐                     ┌──────────┐  回款金额 >= 计划金额  ┌───────────┐
│ OVERDUE  │── 首笔回款审批通过 ──→│ OVERDUE  │─────────────────→  │ COMPLETED │
│  已逾期   │                     │  已逾期   │                     │  已回款    │
│   (3)    │                     │   (3)    │                     │   (2)     │
└──────────┘                     └──────────┘                     └───────────┘
                                                                        ▲
     PENDING ──────────── 回款金额 >= 计划金额 ────────────────────────→  ┘
     PARTIAL ───────────── 回款金额 >= 计划金额 ────────────────────────→  ┘
```

#### 1.1.2 状态枚举

```java
// 新建文件：Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/enums/receivable/
// CrmReceivablePlanStatusEnum.java

public enum CrmReceivablePlanStatusEnum implements ArrayValuable<Integer> {
    PENDING(0, "待回款"),
    PARTIAL(1, "部分回款"),
    COMPLETED(2, "已回款"),
    OVERDUE(3, "已逾期");

    public static final Integer[] ARRAYS = Arrays.stream(values())
        .map(CrmReceivablePlanStatusEnum::getStatus).toArray(Integer[]::new);

    private final Integer status;
    private final String name;
}
```

#### 1.1.3 状态流转规则

| 触发事件 | 前置状态 | 目标状态 | 条件 |
|---|---|---|---|
| 首笔回款审批通过 | PENDING / OVERDUE | PARTIAL | 审批通过的回款金额 < 计划金额 |
| 首笔回款审批通过 | PENDING / OVERDUE | COMPLETED | 审批通过的回款金额 >= 计划金额 |
| 后续回款审批通过 | PARTIAL / OVERDUE | PARTIAL | 累计审批通过的回款金额 < 计划金额 |
| 后续回款审批通过 | PARTIAL / OVERDUE | COMPLETED | 累计审批通过的回款金额 >= 计划金额 |
| 定时任务扫描 | PENDING / PARTIAL | OVERDUE | returnTime < NOW() 且 状态未完成 |
| 回款被删除/拒绝 | PARTIAL / COMPLETED / OVERDUE | 重新计算 | 根据剩余审批通过回款金额重新判定 |

#### 1.1.4 现有 remindType 与状态映射

| 现有 remindType | 常量 | 状态匹配 |
|---|---|---|
| 待回款 (1) | `REMIND_TYPE_NEEDED` | status IN (PENDING, PARTIAL, OVERDUE) AND receivable_id IS NULL（或无审批通过回款）AND remindTime <= today |
| 已逾期 (2) | `REMIND_TYPE_EXPIRED` | status = OVERDUE |
| 已回款 (3) | `REMIND_TYPE_RECEIVED` | status = COMPLETED |

---

### 1.2 领域服务设计

#### 1.2.1 回款计划状态更新服务

在 `CrmReceivablePlanServiceImpl` 中新增方法：

```java
/**
 * 重新计算并更新回款计划状态
 * 触发时机：回款审批通过、回款删除、回款审批拒绝
 */
private void recalculatePlanStatus(Long planId);

/**
 * 按合同 ID 重新计算其下所有回款计划状态
 * 触发时机：合同下任意一笔回款状态变更
 */
private void recalculatePlanStatusByContractId(Long contractId);
```

#### 1.2.2 回款计划金额校验服务

在 `CrmReceivablePlanServiceImpl.createReceivablePlan()` / `updateReceivablePlan()` 中新增：

```java
/**
 * 校验合同下所有回款计划金额合计不超过合同总额
 */
private void validatePlanTotalPriceNotExceedContract(Long contractId, BigDecimal newPrice, Long excludePlanId);
```

#### 1.2.3 逾期检测定时任务

新建文件：

```
Server/mitedtsm-module-crm/src/main/java/com/meession/etm/module/crm/job/receivable/
    CrmReceivablePlanOverdueJob.java
```

---

## 2. 数据库设计

### 2.1 表变更：crm_receivable_plan

```sql
-- 文件：database/new/new-receivable-plan-status.sql

-- 1. 新增执行状态字段
ALTER TABLE `crm_receivable_plan`
    ADD COLUMN `status` tinyint NOT NULL DEFAULT 0
    COMMENT '执行状态：0-待回款 1-部分回款 2-已回款 3-已逾期'
    AFTER `receivable_id`;

-- 2. 为现有数据初始化状态
-- 有回款关联 → 判断是否完全回款（简化处理：有 receivableId 的标记为已回款）
UPDATE `crm_receivable_plan` SET `status` = 2 WHERE `receivable_id` IS NOT NULL;
-- 回款日期已过且无回款 → 已逾期
UPDATE `crm_receivable_plan` SET `status` = 3
WHERE `receivable_id` IS NULL AND `return_time` < NOW();
-- 其余保持默认值 0（待回款）

-- 3. 新增字典数据（如项目使用字典表管理状态）
INSERT INTO `system_dict_type` (`name`, `type`, `status`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`)
VALUES ('CRM 回款计划执行状态', 'crm_receivable_plan_status', 0, 'CRM 回款计划执行状态（待回款/部分回款/已回款/已逾期）', '1', NOW(), '1', NOW(), 0);

SET @dict_type_id = LAST_INSERT_ID();

INSERT INTO `system_dict_data` (`dict_type`, `label`, `value`, `status`, `sort`, `remark`, `creator`, `create_time`, `updater`, `update_time`, `deleted`) VALUES
('crm_receivable_plan_status', '待回款', '0', 0, 0, '回款计划尚未到期', '1', NOW(), '1', NOW(), 0),
('crm_receivable_plan_status', '部分回款', '1', 0, 1, '已收到部分回款', '1', NOW(), '1', NOW(), 0),
('crm_receivable_plan_status', '已回款', '2', 0, 2, '回款已完全到账', '1', NOW(), '1', NOW(), 0),
('crm_receivable_plan_status', '已逾期', '3', 0, 3, '回款计划已逾期', '1', NOW(), '1', NOW(), 0);
```

### 2.2 DO 变更

```java
// CrmReceivablePlanDO.java 新增字段

/**
 * 执行状态
 *
 * 枚举 {@link CrmReceivablePlanStatusEnum}
 */
private Integer status;
```

---

## 3. API 设计

### 3.1 回款计划 API 变更

| 方法 | 路径 | 变更类型 | 说明 |
|---|---|---|---|
| POST | `/crm/receivable-plan/create` | **改进** | 新增：各期金额合计校验；初始化 status=0 |
| PUT | `/crm/receivable-plan/update` | **改进** | 新增：各期金额合计校验（排除自身） |
| DELETE | `/crm/receivable-plan/delete` | **改进** | 新增：已关联审批通过回款时禁止删除 |
| GET | `/crm/receivable-plan/page` | **改进** | 响应新增 status 字段；逾期筛选改为按 status=OVERDUE |
| GET | `/crm/receivable-plan/get` | **改进** | 响应新增 status 字段 |
| GET | `/crm/receivable-plan/remind-count` | **改进** | 查询条件改为 status IN (PENDING, PARTIAL, OVERDUE) AND remindTime <= NOW() |
| — | 无新端点 | — | — |

### 3.2 回款 API（关联影响）

| 方法 | 路径 | 变更类型 | 说明 |
|---|---|---|---|
| POST | `/crm/receivable/create` | **改进** | 新增：审批通过后触发关联计划状态重算 |
| DELETE | `/crm/receivable/delete` | **改进** | 新增：删除后触发关联计划状态重算 |

### 3.3 回款审批监听器变更

`CrmReceivableStatusListener.onEvent()` 在审批结果回调后，增加回款计划状态重算调用。

### 3.4 定时任务 API（infra_job 体系）

| 任务标识 | 说明 | cron 建议 |
|---|---|---|
| `crmReceivablePlanOverdueJob` | 扫描逾期回款计划并更新状态 | `0 0 1 * * ?`（每天凌晨1点） |

---

## 4. 后端 Service 层详细设计

### 4.1 CrmReceivablePlanServiceImpl 变更点

```
createReceivablePlan()
  + validatePlanTotalPriceNotExceedContract(contractId, price, null)  ← 新增

updateReceivablePlan()
  + validatePlanTotalPriceNotExceedContract(contractId, price, planId)  ← 新增

deleteReceivablePlan()
  + 校验：如果 receivableId 关联的回款审批状态为 APPROVE，禁止删除  ← 增强
  + 删除成功后，无需额外动作（因计划被删，合同金额释放）

updateReceivablePlanReceivableId() (现有方法，由回款创建/审批回调触发)
  + 新增：调用 recalculatePlanStatus(planId)  ← 增强

新增方法：
  recalculatePlanStatus(Long planId)
    1. 查询计划的所有关联审批通过回款金额合计
    2. 与计划金额比较 → 判定新状态
    3. updateById(planId, newStatus)

  validatePlanTotalPriceNotExceedContract(Long contractId, BigDecimal newPrice, Long excludePlanId)
    1. 查询合同 totalPrice
    2. SUM(同合同所有计划 price, 排除 excludePlanId) + newPrice
    3. 若 > contract.totalPrice → throw RECEIVABLE_PLAN_TOTAL_EXCEEDS_CONTRACT
```

### 4.2 CrmReceivableServiceImpl 变更点

```
createReceivable()
  + 创建成功后，调用 receivablePlanService.recalculatePlanStatus(planId)  ← 增强

deleteReceivable()
  + 删除成功后，调用 receivablePlanService.recalculatePlanStatus(deletedPlanId)  ← 增强
```

### 4.3 CrmReceivableStatusListener 变更点

```
onEvent(BpmProcessInstanceStatusEvent event)
  + 现有：updateReceivableAuditStatus
  + 新增：根据 receivable.planId，调用 recalculatePlanStatus(planId)  ← 增强
```

### 4.4 新增定时任务：CrmReceivablePlanOverdueJob

```java
@Component
public class CrmReceivablePlanOverdueJob implements JobHandler {

    @Resource
    private CrmReceivablePlanMapper receivablePlanMapper;

    @Override
    @TenantJob
    public String execute(String param) {
        // 1. 查询所有 returnTime < NOW() AND status IN (0, 1) 的计划
        //    — 即待回款或部分回款但已过计划回款日期
        LocalDateTime now = LocalDateTime.now();
        List<CrmReceivablePlanDO> overduePlans = receivablePlanMapper
            .selectList(new LambdaQueryWrapperX<CrmReceivablePlanDO>()
                .in(CrmReceivablePlanDO::getStatus, Arrays.asList(
                    CrmReceivablePlanStatusEnum.PENDING.getStatus(),
                    CrmReceivablePlanStatusEnum.PARTIAL.getStatus()))
                .lt(CrmReceivablePlanDO::getReturnTime, now));

        // 2. 批量更新 status → OVERDUE
        int count = 0;
        for (CrmReceivablePlanDO plan : overduePlans) {
            receivablePlanMapper.updateById(
                new CrmReceivablePlanDO().setId(plan.getId())
                    .setStatus(CrmReceivablePlanStatusEnum.OVERDUE.getStatus()));
            count++;
        }

        return String.format("标记逾期回款计划 %s 个", count);
    }
}
```

### 4.5 新增错误码

```java
// ErrorCodeConstants.java 新增：

// 回款计划 1_020_005_xxx 范围
ErrorCode RECEIVABLE_PLAN_TOTAL_EXCEEDS_CONTRACT =
    new ErrorCode(1_020_005_001, "回款计划金额合计({})超过合同总额({})，剩余可分配：{} 元");
ErrorCode RECEIVABLE_PLAN_DELETE_FAIL_HAS_APPROVED_RECEIVABLE =
    new ErrorCode(1_020_005_002, "删除回款计划失败，原因：已关联审批通过的回款");
ErrorCode RECEIVABLE_PLAN_STATUS_NOT_ALLOW_DELETE =
    new ErrorCode(1_020_005_003, "删除回款计划失败，原因：当前状态不允许删除");
```

---

## 5. 前端设计

### 5.1 回款计划列表页（plan/index.vue）

**变更**：新增"执行状态"列

```
现有列：客户 | 合同编号 | 期数 | 金额 | 回款日期 | 提醒天数 | 提醒日期 | 回款方式 | 备注 | 负责人 | 回款金额 | 回款日期 | 未回金额 | 更新 | 创建 | 创建人 | 操作
                                                                    ↑
新增列：客户 | 合同编号 | 期数 | 金额 | 回款日期 | 【执行状态】 | 提醒天数 | 提醒日期 | ...
```

- 状态标签使用 `<dict-tag>` 组件，字典类型 `CRM_RECEIVABLE_PLAN_STATUS`
- 逾期状态（OVERDUE/已逾期）使用红色高亮标签

### 5.2 回款计划详情页（plan/detail/ReceivablePlanDetailsInfo.vue）

**变更**：新增"执行状态"字段展示

### 5.3 回款计划表单（plan/ReceivablePlanForm.vue）

**增强**：当各期金额合计接近合同总额时，前端给出提示
- 选择合同后，前端实时计算已存各期金额合计 + 当前输入金额
- 若超过合同总额 → 显示红色错误提示，阻止提交
- 若接近（>= 90%合同总额）→ 显示黄色警告

### 5.4 回款表单（ReceivableForm.vue）

**FIN-GAP-05 偏差提示**：
- 当用户关联回款计划后，实际回款金额与计划金额偏差 > 20% 时显示 warning
- warning 文本：「实际回款金额与计划金额偏差 X%，请确认」
- 不阻断提交，仅提示

### 5.5 回款计划提醒待办（backlog/components/ReceivablePlanRemindList.vue）

**变更**：新增"逾期状态"列

```
现有列：客户 | 合同编号 | 期数 | 金额 | 回款日期 | 提醒天数 | 提醒日期 | 回款方式 | 备注 | 负责人 | 回款金额 | 回款日期 | 未回金额 | 更新 | 创建 | 创建人 | 操作
新增列：客户 | 合同编号 | 期数 | 【执行状态】 | 金额 | 回款日期 | 提醒天数 | ...
```

### 5.6 前端 API 接口变更

```typescript
// Web/src/api/crm/receivable/plan/index.ts

export interface ReceivablePlanVO {
  // ... existing fields ...
  status: number  // 新增：执行状态
}
```

### 5.7 国际化文本

需在 `Web/src/locales/zh-CN/crm.ts` 和 `Web/src/locales/en/crm.ts` 中新增：

```typescript
// zh-CN
receivablePlan: {
  status: '执行状态',
  statusPending: '待回款',
  statusPartial: '部分回款',
  statusCompleted: '已回款',
  statusOverdue: '已逾期',
  priceDeviationWarning: '实际回款金额与计划金额偏差 {percent}%，请确认',
  planTotalExceedContract: '各期金额合计不能超过合同总额，剩余可分配 {amount} 元',
  // ... existing ...
}

// en
receivablePlan: {
  status: 'Status',
  statusPending: 'Pending',
  statusPartial: 'Partial',
  statusCompleted: 'Completed',
  statusOverdue: 'Overdue',
  priceDeviationWarning: 'Actual amount deviates {percent}% from planned amount',
  planTotalExceedContract: 'Total plan amount cannot exceed contract total. Remaining: {amount}',
  // ... existing ...
}
```

---

## 6. 权限设计

### 6.1 菜单/按钮权限

回款计划状态变更**不新增**权限点，复用现有权限：

| 操作 | 所需权限 |
|---|---|
| 查看回款计划状态 | `crm:receivable-plan:query`（已有） |
| 创建/编辑回款计划（含金额校验） | `crm:receivable-plan:create` / `crm:receivable-plan:update`（已有） |
| 删除回款计划（含约束增强） | `crm:receivable-plan:delete`（已有） |
| 定时任务执行（逾期扫描） | 系统级 infra_job 权限（由系统自动触发，不暴露给前端用户） |

### 6.2 数据权限

- 回款计划状态变更不突破现有 `CrmPermission` 权限体系
- 逾期定时任务需在 `@TenantJob` 注解下执行，保证每个租户独立扫描
- 回款计划列表/详情的数据范围遵循现有 OWNER/WRITE/READ 权限

---

## 7. 测试设计

### 7.1 单元测试（开发者自测）

#### 7.1.1 回款计划状态机测试

| 编号 | 场景 | 前置状态 | 触发动作 | 期望状态 |
|---|---|---|---|---|
| UT-FIN-01 | 创建回款计划 | — | createReceivablePlan() | status = PENDING(0) |
| UT-FIN-02 | 首笔回款审批通过（金额 < 计划） | PENDING | approve receivable(price=plan*0.5) | PARTIAL(1) |
| UT-FIN-03 | 首笔回款审批通过（金额 >= 计划） | PENDING | approve receivable(price=plan) | COMPLETED(2) |
| UT-FIN-04 | 追加回款至完全回款 | PARTIAL | approve receivable(price=remaining) | COMPLETED(2) |
| UT-FIN-05 | 回款日期过期，无回款 | PENDING | overdueJob.execute() | OVERDUE(3) |
| UT-FIN-06 | 回款日期过期，部分回款 | PARTIAL | overdueJob.execute() | OVERDUE(3) |
| UT-FIN-07 | 逾期后收到回款（金额 < 计划） | OVERDUE | approve receivable(price=plan*0.5) | PARTIAL(1) |
| UT-FIN-08 | 逾期后收到回款（金额 >= 计划） | OVERDUE | approve receivable(price=plan) | COMPLETED(2) |
| UT-FIN-09 | 删除回款 → 状态回退 | COMPLETED | deleteReceivable() → recalculate | PARTIAL or PENDING |
| UT-FIN-10 | 审批拒绝 → 状态不变 | PENDING | reject receivable | PENDING（不变） |

#### 7.1.2 金额校验测试

| 编号 | 场景 | 期望 |
|---|---|---|
| UT-FIN-11 | 各期合计 = 合同总额 | 创建成功 |
| UT-FIN-12 | 各期合计 < 合同总额 | 创建成功 |
| UT-FIN-13 | 各期合计 > 合同总额 | 抛出 `RECEIVABLE_PLAN_TOTAL_EXCEEDS_CONTRACT` |
| UT-FIN-14 | 更新计划金额时排除自身后校验 | 更新成功（排除自身后合计 ≤ 合同总额） |
| UT-FIN-15 | 无合同（异常防护） | 抛出明确业务异常 |

#### 7.1.3 定时任务测试

| 编号 | 场景 | 期望 |
|---|---|---|
| UT-FIN-16 | 无逾期计划 | execute() 返回 "标记逾期回款计划 0 个" |
| UT-FIN-17 | 1 个 PENDING + returnTime < NOW() | 状态变更为 OVERDUE(3) |
| UT-FIN-18 | 1 个 PARTIAL + returnTime < NOW() | 状态变更为 OVERDUE(3) |
| UT-FIN-19 | 1 个 COMPLETED + returnTime < NOW() | 状态不变（COMPLETED 不标记逾期） |
| UT-FIN-20 | 1 个 PENDING + returnTime > NOW()（未来） | 状态不变（未到期不标记） |
| UT-FIN-21 | 跨租户场景 | @TenantJob 保证独立扫描 |

### 7.2 接口测试（自测）

| 编号 | 接口 | 测试内容 |
|---|---|---|
| API-FIN-01 | `GET /crm/receivable-plan/page` | 响应包含 status 字段，筛选 remindType=2 返回 status=OVERDUE 记录 |
| API-FIN-02 | `GET /crm/receivable-plan/get` | 响应包含 status 字段 |
| API-FIN-03 | `POST /crm/receivable-plan/create` | 金额合计超限返回错误码 `1_020_005_001` |
| API-FIN-04 | `DELETE /crm/receivable-plan/delete` | 已关联审批通过回款时返回错误码 `1_020_005_002` |
| API-FIN-05 | `GET /crm/receivable-plan/remind-count` | 状态为 OVERDUE 且 remindTime <= NOW() 的计划被计入提醒数 |

### 7.3 集成测试（端到端主链）

| 编号 | 场景 | 验证点 |
|---|---|---|
| INT-FIN-01 | 合同→回款计划→回款→审批通过→计划状态更新 | 全链路状态正确 |
| INT-FIN-02 | 创建多期计划→各期部分回款→状态为 PARTIAL→完全回款→COMPLETED | 多期场景验证 |
| INT-FIN-03 | 回款计划逾期→定时任务标记 OVERDUE→用户仍可创建回款→状态回到 PARTIAL | 逾期后恢复验证 |
| INT-FIN-04 | 回款审批拒绝→计划状态不变 | 拒绝场景验证 |

---

## 8. 文件变更清单

### 8.1 新建文件

| 文件 | 路径 | 说明 |
|---|---|---|
| `CrmReceivablePlanStatusEnum.java` | `Server/.../crm/enums/receivable/` | 回款计划执行状态枚举 |
| `CrmReceivablePlanOverdueJob.java` | `Server/.../crm/job/receivable/` | 逾期定时任务 |
| `new-receivable-plan-status.sql` | `database/new/` | 增量 DDL + 字典数据 |

### 8.2 修改文件（后端）

| 文件 | 变更内容 |
|---|---|
| `CrmReceivablePlanDO.java` | 新增 `status` 字段 |
| `CrmReceivablePlanServiceImpl.java` | 新增状态重算方法、金额校验方法；增强 create/update/delete |
| `CrmReceivablePlanMapper.java` | `selectPage()` 中 remindType 筛选适配新状态字段；新增按状态查询方法 |
| `CrmReceivableServiceImpl.java` | create/delete 增加状态重算调用 |
| `CrmReceivableStatusListener.java` | 审批回调增加状态重算调用 |
| `ErrorCodeConstants.java` | 新增 3 个回款计划错误码 |

### 8.3 修改文件（前端）

| 文件 | 变更内容 |
|---|---|
| `Web/src/views/crm/receivable/plan/index.vue` | 新增"执行状态"列 |
| `Web/src/views/crm/receivable/plan/detail/ReceivablePlanDetailsInfo.vue` | 新增"执行状态"展示 |
| `Web/src/views/crm/receivable/plan/ReceivablePlanForm.vue` | 新增合同总额实时校验 + 接近上限提示 |
| `Web/src/views/crm/receivable/ReceivableForm.vue` | 新增回款金额 vs 计划金额偏差提示 |
| `Web/src/views/crm/backlog/components/ReceivablePlanRemindList.vue` | 新增逾期状态列 |
| `Web/src/api/crm/receivable/plan/index.ts` | `ReceivablePlanVO` 新增 status 字段 |
| `Web/src/locales/zh-CN/crm.ts` | 新增回款计划状态相关 i18n key |
| `Web/src/locales/en/crm.ts` | 同上（英文） |

---

## 9. 依赖与影响分析

### 9.1 上游依赖

| 依赖 | 负责方 | 接口约定 | 风险 |
|---|---|---|---|
| 合同审批状态 | 李祖豪 | 回款创建前校验 `contract.auditStatus = APPROVE` | 低——现有逻辑不变 |
| BPM 审批回调 | 基础设施 | `BpmProcessInstanceStatusEvent` 事件触发 Listener | 低——现有模式已验证 |
| 定时任务框架 | 基础设施 | `JobHandler` + `@TenantJob` | 低——参考 `CrmCustomerAutoPutPoolJob` 实现 |
| 数据权限 | 基础设施 | `CrmPermission` 注解 | 低——不突破现有权限体系 |

### 9.2 下游影响（对其他人的模块）

| 影响范围 | 负责方 | 影响说明 | 措施 |
|---|---|---|---|
| 统计模块（PKG-05） | 姚昱竹 | 回款计划新增 status 字段，统计按回款负责人汇总时不受影响 | 回款金额统计逻辑不变 |
| 交叉测试 | 待安排 | 回款计划状态变更需纳入交叉测试 | 阶段 3 前与组长确认交叉测试人 |
| 合同域（PKG-03） | 李祖豪 | 无影响，不修改合同表/DO | — |

---

## 10. 风险与处理规则

| 编号 | 风险 | 概率 | 影响 | 处理规则 |
|---|---|---|---|---|
| RISK-01 | 逾期状态与实际回款状态不一致（并发） | 低 | 中 | 状态重算加数据库行锁或乐观锁；定时任务与用户操作错峰执行 |
| RISK-02 | 定时任务大量扫描性能问题 | 低 | 低 | 回款计划数量小（< 10000），单次扫描毫秒级；必要时加索引 |
| RISK-03 | 历史数据 status=0 的兼容 | 中 | 低 | 增量 SQL 已处理：有 receivableId → COMPLETED；returnTime 过期 → OVERDUE；其余 PENDING |
| RISK-04 | 删除回款导致计划状态回退到错误状态 | 低 | 中 | 状态重算方法基于实际审批通过回款金额重新判定，与删除无关 |
| RISK-05 | 前端字典未注册导致状态标签不显示 | 低 | 低 | 增量 SQL 中已写入 system_dict_data |

---

## 11. 开发实施顺序

```
第一步：枚举 + DO + SQL（基础设施）
  1. 创建 CrmReceivablePlanStatusEnum.java
  2. CrmReceivablePlanDO 新增 status 字段
  3. 编写并执行 new-receivable-plan-status.sql
  4. ErrorCodeConstants 新增错误码

第二步：后端 Service 层（核心逻辑）
  5. CrmReceivablePlanServiceImpl 新增 recalculatePlanStatus()、validatePlanTotalPriceNotExceedContract()
  6. CrmReceivablePlanServiceImpl 增强 create/update/delete
  7. CrmReceivableServiceImpl 增强 create/delete（调用状态重算）
  8. CrmReceivableStatusListener 增强（审批回调调用状态重算）
  9. CrmReceivablePlanMapper 适配 remindType 筛选

第三步：定时任务
  10. 创建 CrmReceivablePlanOverdueJob.java
  11. 在 infra_job 中注册任务（或通过 XXL-Job / 内置 Quartz 调度）

第四步：前端
  12. 更新 ReceivablePlanVO TypeScript 接口
  13. 回款计划列表/详情/待办组件新增 status 列
  14. 回款计划表单新增合同总额校验前端提示
  15. 回款表单新增偏差提示
  16. 国际化文本新增

第五步：单元测试 + 自测
  17. 编写回款计划状态机单元测试
  18. 编写金额校验单元测试
  19. 编写定时任务单元测试
  20. 开发者接口自测 + 前端自测
```

---

## 12. 与阶段 0 的追踪关系

| 阶段 0 缺口 | 阶段 1 设计覆盖 | 设计产出 |
|---|---|---|
| FIN-GAP-01 状态机 | §1.1 状态机设计、§2.1 DDL、§4.1 Service | 枚举 + 状态流转规则 + recalculatePlanStatus |
| FIN-GAP-02 逾期检测 | §1.1 状态 OVERDUE、§4.4 定时任务 | overdueJob 扫描 + 状态标记 |
| FIN-GAP-03 定时提醒 | §4.4 CrmReceivablePlanOverdueJob | 定时任务类（复用现有 remind 查询） |
| FIN-GAP-04 金额合计划校验 | §4.1 validatePlanTotalPriceNotExceedContract | 后端校验 + 前端提示 |
| FIN-GAP-05 偏差提示 | §5.4 ReceivableForm.vue 增强 | 前端 warning 提示 |
| FIN-GAP-07 删除约束 | §4.1 deleteReceivablePlan 增强 | 审批通过回款关联约束 |

---

## 13. 阶段 1 完成检查表

| 检查项 | 标准 | 状态 |
|---|---|---|
| 状态机设计 | 每个状态有进入/离开条件；状态流转有触发事件 | ✅ 已完成 |
| 数据库变更 | 增量 SQL 可独立执行、可幂等、含字典数据 | ✅ 已设计 |
| API 变更 | 不新增端点，不改签名，仅增强响应字段和校验 | ✅ 已设计 |
| 权限设计 | 不新增权限点，复用现有 | ✅ 已确认 |
| 前端变更 | 列表/详情/表单/待办组件变更清单完整 | ✅ 已设计 |
| 单元测试 | 21 个测试用例覆盖状态机、金额校验、定时任务 | ✅ 已设计 |
| 接口测试 | 5 个接口测试覆盖关键 API 变更 | ✅ 已设计 |
| 集成测试 | 4 个端到端场景覆盖主链 | ✅ 已设计 |
| 文件清单 | 新建 3 个文件、修改 13 个文件，全部列出 | ✅ 已列出 |
| 依赖分析 | 上下游依赖、风险评估已覆盖 | ✅ 已完成 |
| 不需要修改的文件 | 合同域、BPM 框架、权限框架明确不修改 | ✅ 已确认 |

---

> **下一步（阶段 2）**：设计评审通过后，按 §11 "开发实施顺序"进入编码。唐文军返岗后在 `feature/finance` 分支上开发，先完成步骤 1-9（后端），再完成步骤 10-16（前端+定时任务），最后步骤 17-20（测试）。

---

*2026-07-14*
