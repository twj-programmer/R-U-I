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
| 回滚不得删除历史权限 | 已修复。正向迁移只给本次新建菜单写入 `creator/updater=D2-STAT-01`；回滚只删除该标记菜单及其角色关联 | V1.5 7.5.3；自动化 SQL 契约测试；隔离 MySQL 实际执行 |
| 撤销既有 `getContractSummary` 查询语义修改 | 未撤销。V1.5 第 12.4 条明确授权本任务把 `receivable.deleted=0` 移入 `LEFT JOIN ... ON` 并保留 `IFNULL(...,0)` | 最新 `origin/docs@b3219e0` V1.5 第 12 节优先于旧表述 |
| 确认客户行业/类型、无回款空值/0 | 已按唯一口径保留：列名为“客户行业”，取 `industryId`；客户来源取 `source`；无回款为数值 `0.00` | V1.5 第 12.1 至 12.3 条 |
| HTTP/AOP、公开边界、范围、并发/事务测试 | 已补 Spring MVC HTTP + `@PreAuthorize` AOP、有权/无权公开边界、部门/负责人、租户、并发和失败无半文件测试 | CRM 定向测试 17/17；CRM 全量测试 69/69 |

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

隔离 MySQL 实际验证：

- 历史权限场景：`historical_menu=1`、`historical_role_link=1`，回滚后均保留；
- 本迁移新建场景：`migration_menu=0`、`migration_role_link=0`，回滚后均删除；
- 父菜单：`parent_menu=1`，回滚后保留；
- 验证使用的临时数据库已删除，未操作开发库业务数据或 Docker 数据卷。

## 4. 自动化与构建结果

### 4.1 D2-STAT-01 定向测试

```powershell
mvn -pl mitedtsm-module-crm "-Dtest=CrmStatisticsCustomerExportContractTest,CrmStatisticsCustomerExportDataTest,CrmStatisticsCustomerExportSecurityTest,CrmStatisticsCustomerServiceImplTest" "-Dsurefire.failIfNoSpecifiedTests=false" test
```

结果：17 个测试，0 失败，0 错误，0 跳过。

覆盖：

- Spring MVC 的公开 GET 路径；
- `@PreAuthorize` AOP：仅有查询权限、没有导出权限时业务码为 403，服务不执行；
- 有导出权限时返回 XLSX；
- 10 列顺序、行业/来源字典名称、空值和未解析编号回退；
- 无回款 `0.00`、已回款、已删除回款仍保留合同；
- 指定负责人、部门展开、租户隔离、日期范围；
- 8 个并发导出响应互不污染；
- 查询异常时不写出半个工作簿；
- Mapper 保持只读，不存在新增业务写事务，因此业务事务回滚不适用。

### 4.2 CRM 模块全量测试

```powershell
mvn -pl mitedtsm-module-crm test
```

结果：69 个测试，0 失败，0 错误，0 跳过。

### 4.3 前端生产构建

```powershell
$env:CI='true'
pnpm run build:prod
```

结果：构建成功。

## 5. 本地运行 HTTP 补充验证与风险

- 匿名请求实际运行中的 `/admin-api/crm/statistics-customer/export-contract-summary`：业务码 401；
- 管理员请求：HTTP 200，返回 4671 字节 XLSX；
- 当前运行容器仍是整改前构建镜像，响应中没有新代码预设的下载头，因此该容器结果不能作为最新提交的响应头验收证据；下载头已由自动化测试覆盖，复审环境应基于本提交重新构建服务后再做一次真实账号联调；
- 本机没有可登录且已有活动令牌的低权限测试账号，本次未修改账号、密码或角色来制造证据；已由 Spring MVC + Method Security 自动化测试覆盖“已认证但无 export 权限”的 AOP 拒绝。
- CT-03 仍由曾皓冲独立执行；本报告不宣称已经完成交叉测试或允许合入 `develop`。
