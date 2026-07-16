<!-- 23计科4班 黄金戈 -->

# D2-BIZ-01 阶段 2 整改与验证报告

## 1. 基线与状态

| 项目 | 内容 |
|---|---|
| 任务 | D2-BIZ-01：商机状态机、输单、报价、产品和跟进 |
| 开发分支 | `feature/opportunity` |
| 唯一需求基线 | `origin/docs@b3219e0a` 的《CRM阶段2统一开发基线》V1.5 |
| 代码基线 | `origin/develop@a4970167` |
| 整改前提交 | `6f992b44` |
| 当前状态 | 本地整改与预检完成；等待 D2-QA-01、D2-MKT-01 和提交确认 |

本报告只记录 V1.5 范围内的本地整改和预检结果。D2-QA-01、D2-MKT-01 尚未满足前置条件，因此不宣称 CRM 完整行为测试通过，也不申请合入 `develop`。

## 2. 审查问题整改结果

| 审查项 | 整改结果 |
|---|---|
| 固定错误码错误 | 使用 `BUSINESS_UPDATE_VERSION_CONFLICT=1_020_002_004`，提示固定为“商机数据已被他人更新，请刷新后重试” |
| SQL 文件名错误、无独立回滚 | 改为固定正向/回滚文件名，并完成正向与回滚的重复执行验证 |
| 输单原因自行遍历字典 | 改为 `DictDataApi.validateDictDataList("crm_business_lose_reason", ...)` |
| 新增未登记报价接口 | 删除 `PUT /crm/business/update-quotation` 及配套前后端 VO/API，报价与产品继续使用既有 `/crm/business/update` |
| 越过 D2-MKT-01 文件所有权 | 撤销 `DictTypeConstants` 中由本分支新增的输单原因常量，等待 D2-MKT-01 合入 |
| SQL 超出契约 | 删除 `crm_business_status.percent` 类型修改、阶段回填和其他历史状态改写，只保留两个冻结字段 |
| 测试结论超前 | 将结果明确标记为本地预检；完整测试、租户隔离和交叉测试仍为阻塞项 |

## 3. 保留并收敛的实现

### 3.1 商机状态机

- `PUT /crm/business/update-status` 是唯一状态更新接口。
- 请求必须携带 `version`，并且 `statusId` 与 `endStatus` 必须且只能提交一个；VO 和 Service 均进行校验。
- 进行中阶段只允许在同一状态组内向更高排序值流转；禁止同阶段、回退、跨组和终态重开。
- 输单时 `loseReasonCode` 必填，并通过既有系统字典 API 校验；赢单、无效不得携带输单原因；结束说明最多 500 字。
- 状态 Mapper 使用 `id + version + end_status IS NULL` 条件更新，MyBatis 租户插件补充 `tenant_id` 条件；成功后执行 `version = version + 1`。
- 影响行数为 0 且记录仍存在时返回冻结的版本冲突错误。

### 3.2 报价与产品

- 不新建报价表或平行接口，创建和编辑继续复用 `CrmBusinessSaveReqVO` 及既有商机保存接口。
- 编辑请求携带当前 `version`，既有 `/crm/business/update` 使用乐观锁更新基本资料、汇总金额和产品行。
- 产品行接收已有行 `id`，避免编辑时无条件删除并重建全部产品行。
- 新增产品的原价从产品主数据读取；已有产品保留原价快照，不信任客户端伪造的 `productPrice`。
- 同一商机禁止重复产品；业务单价、数量、折扣及金额范围在 VO 与服务端校验。
- 行金额按 `businessPrice × count` 计算并 `HALF_UP` 保留 2 位；商机金额由服务端汇总。
- 商机更新、金额更新和产品行增删改位于同一事务；终态商机在产品写入前被拒绝。

### 3.3 跟进联动

- 继续复用既有 `POST /crm/follow-up-record/create` 和既有商机跟进更新边界，不新建跟进模型或接口。
- 跟进记录插入及关联业务最近/下次跟进信息更新处于同一事务。

## 4. 对外接口契约

| 方法与路径 | 权限 | 本任务约束 |
|---|---|---|
| `POST /crm/business/create` | `crm:business:create` | 服务端确定初始阶段和 `version=0`，校验并计算产品及金额 |
| `PUT /crm/business/update` | `crm:business:update` | 复用既有边界；更新时携带 `id`、`version`、基本资料、折扣和产品行；终态禁止更新 |
| `PUT /crm/business/update-status` | `crm:business:update` | 携带 `id`、`version` 及 `statusId/endStatus` 二选一；执行阶段、终态、字典和并发校验 |
| `POST /crm/follow-up-record/create` | 既有 CRM 数据权限 | 复用既有跟进请求和联动逻辑 |

本次未新增权限、状态、跨域事件或平行接口。

## 5. 数据库迁移与回滚

执行顺序：完成基础建表后，先执行正向脚本，再启动包含本任务代码的应用。

- 正向：`database/new/20260716_d2_business_state_machine.sql`
- 回滚：`database/new/20260716_d2_business_state_machine_rollback.sql`
- 新增字段：`crm_business.version INT NOT NULL DEFAULT 0`
- 新增字段：`crm_business.lose_reason_code VARCHAR(64) NULL`
- 历史数据：既有版本归一为 0；既有输单但无原因的记录保持 `NULL`，不虚构业务事实。

### 5.1 本地 SQL 实际验证

验证环境：Docker MySQL 容器 `mitedtsm-mysql`，数据库 `mitedtsm_database`，验证前 321 张表、14 条商机记录。执行前建立临时备份，验证完成后恢复原 `version/lose_reason_code` 值并删除临时表。

| 步骤 | 结果 |
|---|---|
| 正向脚本连续执行 2 次 | 成功；字段已存在时安全跳过；记录数 14、版本和 5、非空输单原因数 0 均未改变 |
| 回滚脚本连续执行 2 次 | 成功；首次删除字段，第二次安全跳过；两个任务字段数量为 0 |
| 回滚后重新正向 | 成功；字段恢复为 `version:int:NOT NULL`、`lose_reason_code:varchar(64):NULL` |
| 恢复验证前数据 | 成功；记录数、版本和、非空输单原因数与验证前一致 |
| 验证后运行状态 | 后端健康检查 HTTP 200，管理前端 HTTP 200 |

回滚会删除任务字段，正式环境执行前必须停用依赖这些字段的应用并完成备份。

## 6. 本地预检结果

### 6.1 后端

```powershell
cd Server
mvn -pl mitedtsm-module-crm -am -DskipTests compile
mvn -pl mitedtsm-module-crm -am `
  '-Dtest=CrmBusinessServiceImplTest,CrmFollowUpRecordServiceImplTest' `
  '-Dsurefire.failIfNoSpecifiedTests=false' test
```

- 编译：成功，CRM 模块 251 个生产源文件完成编译。
- 定向 Mock 测试：成功，11 项，失败 0、错误 0、跳过 0。
- 已覆盖：双填/空填、向前流转、禁止回退、输单字典边界、状态及保存版本冲突、终态保护、既有保存边界产品快照和金额、跟进事务注解与商机关联调用。

以上仅为本地 Mock 预检，不替代 D2-QA-01 提供的公共 H2 测试底座、租户隔离 SQL 断言、接口测试和事务真实回滚测试。

### 6.2 前端

```powershell
cd Web
.\node_modules\.bin\eslint.cmd `
  src/api/crm/business/index.ts `
  src/views/crm/business/BusinessForm.vue `
  src/views/crm/business/BusinessUpdateStatusForm.vue `
  src/views/crm/business/components/BusinessProductForm.vue `
  src/views/crm/business/detail/BusinessDetailsInfo.vue `
  src/views/crm/business/detail/index.vue
pnpm.cmd build:dev
```

- 本任务相关文件 ESLint：成功。
- Vite `build:dev`：成功。
- 全仓 `vue-tsc --noEmit`：未通过。默认 4 GB 堆首先内存溢出；提高到 8 GB 后运行完成，但仓库商城、BPM、支付、系统等既有模块仍有大量类型错误。因此本报告不把全量类型检查标记为通过。

## 7. 前端页面位置

| 修改部分 | 前端页面位置 |
|---|---|
| 状态组与初始阶段 | CRM → 商机 → 新增，上半部分“商机状态组” |
| 基础资料、报价和产品统一保存 | 商机新增/编辑弹窗底部“确定”按钮，调用既有保存接口 |
| 产品关联与金额计算 | 新增/编辑商机 →“产品列表”页签，包括产品原价、业务单价、数量、合计和折扣 |
| 阶段向前流转 | 商机详情右上角 →“变更商机状态”弹窗 |
| 输单原因、输单说明 | 状态弹窗中选择“输单”后显示 |
| 终态只读保护 | 终态商机详情右上角隐藏“编辑”和“变更状态”按钮，后端同时拒绝绕过页面的写入 |
| 终态结果展示 | 商机详情 →“基本信息”，显示终态、输单原因和结束说明 |
| 跟进记录联动 | 商机详情 →“跟进记录”页签 → 新建跟进 |
| 版本冲突 | 编辑保存或变更状态时触发，旧版本提交提示刷新 |

## 8. 阻塞项与后续动作

1. 等待 D2-QA-01 修正并合入，随后同步最新 `origin/develop`，补做公共 H2 底座上的租户隔离、接口、并发和事务真实回滚测试。
2. 等待 D2-MKT-01 修正并合入，随后同步最新 `origin/develop`，确认共享字典常量与六个初始字典值，再做输单接口联调。
3. 由刘焘玮执行 CT-07 交叉测试，覆盖阶段、输单、报价、金额、产品和跟进。
4. 以上前置未完成前，只能提交本功能分支供复核，不得合入 `develop`，不得宣称完整测试通过。

## 9. 2026-07-16 集成复核补充

- 已同步 `origin/develop@87a5945`；D2-QA-01 与 D2-MKT-01 的合并前置已满足。
- PR #5 的冲突仅涉及 D2-QA-01 所有的公共 `create_tables.sql`、`clean.sql`。合并时保留 `develop` 版本；D2-BIZ-01 改为使用私有 `d2-business-state-machine-test.sql` 为 H2 测试补充任务字段，不再占用公共测试脚本。
- 已执行：

  ```powershell
  cd Server
  mvn -B -ntp -pl mitedtsm-module-crm -am `
    '-Dtest=CrmBusinessServiceImplTest,CrmBusinessMapperDbTest,CrmBusinessControllerTest,DictTypeConstantsTest,BusinessLoseReasonMigrationSqlContractTest' `
    '-Dsurefire.failIfNoSpecifiedTests=false' test
  ```

- 结果：17 项测试通过，0 失败、0 错误、0 跳过。`CrmBusinessControllerTest` 通过 MockMvc 覆盖 `PUT /crm/business/update-status` 的正常 HTTP 调用与双填参数拒绝，并断言既有 `crm:business:update` 权限契约；其余测试覆盖输单原因、版本冲突、跨租户条件更新、两并发请求单赢家和真实事务回滚。
- 前端全量 `pnpm ts:check` 使用 8 GB Node 堆执行；商机 API 与本任务的 5 个 Vue 文件均未出现在错误列表中。全仓仍有 7,616 个既有自动导入缺失错误，均在本任务范围外，故全量检查不标记为通过。CT-07 交叉测试仍需按 V1.5 由指定人员独立执行。

## 10. 王文渊 AI 辅助集成预验与 CT-07 状态

- 预验执行人：王文渊（AI 辅助）；执行日期：2026-07-16。
- 最新定向验证命令：

  ```powershell
  cd Server
  mvn -B -ntp -pl mitedtsm-module-crm `
    '-Dtest=CrmBusinessServiceImplTest,CrmBusinessMapperDbTest,CrmBusinessControllerTest,CrmBusinessControllerSecurityTest,DictTypeConstantsTest,BusinessLoseReasonMigrationSqlContractTest' test
  ```

- 结果：19 项通过，0 失败、0 错误、0 跳过。覆盖状态互斥、前进阶段、输单原因、版本冲突、跨租户、并发单赢家、金额与产品行真实事务回滚、HTTP 参数校验及无权限拒绝。
- CT-07 状态：**AI 辅助集成预验通过，待刘焘玮按 V1.5 对最新 develop 独立复测并登记正式结论。** 本预验不替代指定交叉测试人的独立确认。
