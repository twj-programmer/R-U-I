# D2-STAT-01 客户转化明细导出整改与测试报告

> 成员：姚昱竹
> 任务：D2-STAT-01 统计导出
> 分支：`feature/public-integration`
> 唯一基线：`origin/docs`《CRM阶段2统一开发基线》V1.5
> 同步代码基线：`origin/develop@1077878866333afdd865d8afcffdbe54f4b2dec3`
> 状态：组长反馈已整改，待复审与 CT-03

## 1. 反馈处理结论

| 反馈 | 处理结论 | 依据/证据 |
|---|---|---|
| 回滚不得删除历史权限 | 已修复。正向迁移只给本次新建菜单写入 `creator/updater=D2-STAT-01`；回滚只删除该标记菜单及其角色关联 | V1.5 7.5.3；自动化 SQL 契约测试；隔离 MySQL 实际执行待独立复核 |
| 撤销既有 `getContractSummary` 查询语义修改 | 未撤销。V1.5 第 12.4 条明确授权本任务把 `receivable.deleted=0` 移入 `LEFT JOIN ... ON` 并保留 `IFNULL(...,0)` | 最新 `origin/docs@b3219e0` V1.5 第 12 节优先于旧表述 |
| 确认客户行业/类型、无回款空值/0 | 已按唯一口径保留：列名为“客户行业”，取 `industryId`；客户来源取 `source`；无回款为数值 `0.00` | V1.5 第 12.1 至 12.3 条 |
| HTTP/AOP、公开边界、范围、并发/事务测试 | 已补 Spring MVC HTTP + `@PreAuthorize` AOP；新增真实 Service + H2 的公开 GET 导出测试，覆盖负责人、部门展开、日期、租户隔离、空数据和导出后无写入副作用 | 本次 D2-STAT 定向测试；只读导出不存在业务写事务，正式 CT-03 仍需独立复测 |

## 2. 接口契约

- 路径：`GET /crm/statistics-customer/export-contract-summary`
- 权限：`crm:statistics-customer:export`
- 参数：复用 `CrmStatisticsCustomerReqVO` 的 `deptId`、`userId`、`interval`、`times`
- 数据来源：只调用既有 `CrmStatisticsCustomerService#getContractSummary`，不新增平行 Mapper 查询
- 输出：XLSX，文件名 `客户转化明细_yyyyMMddHHmmss.xlsx`
- 列：客户名称、首次合同名称、合同金额、回款金额、客户行业、客户来源、负责人、创建人、创建时间、签约时间

## 3. SQL 与回滚

执行顺序：

1. 正向执行 `database/new/20260716_d2_statistics_customer_export_permission.sql`；
2. 如需回滚，执行 `database/new/20260716_d2_statistics_customer_export_permission_rollback.sql`。

保护规则：

- 部署前已有 `crm:statistics-customer:export` 时，正向脚本不改写其创建标记；
- 回滚只匹配 `permission='crm:statistics-customer:export' AND creator='D2-STAT-01'`；
- 角色关联仅按上述菜单 ID 删除；既有统计菜单、历史同名权限和业务数据不删除。

隔离 MySQL 实际验证：待 CT-03 独立复核。本分支已自动化校验 SQL 的父菜单唯一性、迁移创建标记和回滚精确删除条件，但未把隔离 MySQL 实际执行作为本次已完成证据。

## 4. 自动化与构建结果

### 4.1 D2-STAT-01 定向测试

```powershell
cd Server
mvn -B -ntp -pl mitedtsm-module-crm "-Dtest=CrmStatisticsCustomerExportContractTest,CrmStatisticsCustomerExportDataTest,CrmStatisticsCustomerExportSecurityTest,CrmStatisticsCustomerExportHttpIntegrationTest,CrmStatisticsCustomerServiceImplTest" test
```

结果：20 个测试，0 失败，0 错误，0 跳过。

覆盖：

- Spring MVC 的公开 GET 路径，真实统计 Service、H2 数据和 XLSX 响应；
- `@PreAuthorize` AOP：仅有查询权限、没有导出权限时业务码为 403，服务不执行；
- 有导出权限时返回 XLSX；
- 10 列顺序、行业/来源字典名称、空值和未解析编号回退；
- 无回款 `0.00`、已回款、已删除回款仍保留合同；
- 指定负责人、部门展开、租户隔离、日期范围、空数据和导出后无写入副作用；
- 8 个并发导出响应互不污染；
- 查询异常时不写出半个工作簿；
- Mapper 保持只读；本次以导出前后客户、合同、回款记录计数不变验证无写入副作用。只读导出“事务回滚”如何记录仍以正式 CT-03 复测结论为准。

### 4.2 CRM 模块全量测试

```powershell
mvn -pl mitedtsm-module-crm test
```

本次未重新执行 CRM 模块全量测试，不能作为本次提交的验证结论。

### 4.3 前端生产构建

```powershell
$env:CI='true'
pnpm run build:prod
```

本次未重新执行前端生产构建，不能作为本次提交的验证结论。

## 5. 本地运行 HTTP 补充验证与风险

- 匿名请求实际运行中的 `/admin-api/crm/statistics-customer/export-contract-summary`：业务码 401；
- 管理员请求：HTTP 200，返回 4671 字节 XLSX；
- 当前运行容器仍是整改前构建镜像，响应中没有新代码预设的下载头，因此该容器结果不能作为最新提交的响应头验收证据；下载头已由自动化测试覆盖，复审环境应基于本提交重新构建服务后再做一次真实账号联调；
- 本机没有可登录且已有活动令牌的低权限测试账号，本次未修改账号、密码或角色来制造证据；已由 Spring MVC + Method Security 自动化测试覆盖“已认证但无 export 权限”的 AOP 拒绝。
- CT-03 仍由曾皓冲独立执行；本报告不宣称已经完成交叉测试或允许合入 `develop`。
