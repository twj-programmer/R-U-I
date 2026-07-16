# D2-REC-01 存量对齐报告

> **成员**：唐文军
> **任务**：D2-REC-01 回款审批口径与回归验证
> **分支**：`feature/finance`
> **基线**：V1.5（`origin/docs`），代码基线 `origin/develop@c1cfd98`
> **核验日期**：2026-07-16

## 1. 分支状态

- 1 个提交，基于最新 `origin/develop@c1cfd98`
- 7 个文件，+438/-7 行
- 无超范围改动

## 2. 逐文件对齐

### 2.1 已符合并保留

| 文件 | 内容 | 判定 |
|---|---|---|
| `ReceivableDetailsInfo.vue` | 回款详情页新增 `auditStatus` dict-tag（0/10/20/30/40） | ✅ 五态页面回归 |
| `backlog/components/common.ts` | `AUDIT_STATUS` 新增 `{value:40, label:'已取消'}` | ✅ 五态筛选补全 |
| `zh-CN/crm.ts` | 补 `ownerUserId: '负责人'`、`auditCancelled: '已取消'` | ✅ i18n补缺，未删除既有键 |
| `en/crm.ts` | 补 `ownerUserId: 'Owner'`、`auditCancelled: 'Cancelled'` | ✅ i18n补缺 |
| `zh-CN/dialog.ts` | 新建，`confirm: '确定'`, `cancel: '取消'` | ✅ `index.ts`早已导入 |
| `en/dialog.ts` | 新建，`confirm: 'Confirm'`, `cancel: 'Cancel'` | ✅ `index.ts`早已导入 |
| `CrmReceivableServiceTest.java` | 24个回款五态流转单元测试 | ✅ 见§3测试结果 |

### 2.2 缺失

| 项目 | 说明 |
|---|---|
| `.http` 接口验证文件 | 待后续补充 |
| 空 `process_instance_id` 容错检查 | 待后续补充 |
| OA/BPM 联调清单 | 等待 D2-APR-01 合入 |

### 2.3 冲突 / 超出范围

**无。** 已砍掉：
- 回款计划状态枚举/字段/DDL/字典/错误码
- 逾期定时任务
- pom.xml 依赖
- Service/Listener 中计划状态联动代码

### 2.4 已知阻塞

| 阻塞项 | 说明 |
|---|---|
| D2-APR-01 未合入 | `CrmAuditStatusUtils` BPM CANCEL(4)→CRM 40 映射错误，回款取消场景测试预期失败 |

## 3. 接口契约

无新增接口。现有回款接口不变：

| 方法 | 路径 | 权限 |
|---|---|---|
| GET | `/crm/receivable/page` | `crm:receivable:query` |
| GET | `/crm/receivable/get` | `crm:receivable:query` |
| POST | `/crm/receivable/create` | `crm:receivable:create` |
| PUT | `/crm/receivable/update` | `crm:receivable:update` |
| DELETE | `/crm/receivable/delete` | `crm:receivable:delete` |
| PUT | `/crm/receivable/submit` | `crm:receivable:update` |

审批五态：0=草稿 / 10=审批中 / 20=审批通过 / 30=审批拒绝 / 40=已取消

## 4. SQL

本任务无新增数据库迁移。

## 5. 测试结果

```bash
cd Server && mvn test -pl mitedtsm-module-crm -Dtest="CrmReceivableServiceTest"
```

| 测试组 | 通过 | 失败 | 说明 |
|---|---|---|---|
| FiveStateEnumTest | 7 | 0 | 五态枚举值、无状态4/5 |
| CreateReceivableTest | 1 | 0 | 初始状态 DRAFT(0) |
| SubmitReceivableTest | 4 | 0 | BPM mock + audit_status=10 + processInstanceId |
| DeleteReceivableTest | 4 | 0 | 终态保护 |
| UpdateReceivableTest | 3 | 0 | 状态编辑约束 |
| AuditStatusCallbackTest | 4 | 1 | BPM CANCEL→4 非40，D2-APR-01待修复 |
| **合计** | **23** | **1** | 取消映射阻塞于D2-APR-01 |

## 6. 未验证风险

| 风险 | 说明 |
|---|---|
| D2-APR-01 | BPM取消映射bug，阻塞完整五态验证 |
| CRM测试底座 | 当前为Mockito单测，非BaseDbUnitTest集成测试 |
| 跨租户/并发/权限 | 需Spring Security + Tenant上下文，Mockito无法覆盖 |
| OA/BPM待办联调 | 需D2-APR-01合入+完整BPM环境 |
