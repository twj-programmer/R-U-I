<!-- 23计科4班 黄金戈 -->

# GAP-006 阶段 0：验收标准与证据

## 1. 阶段 0 Definition of Done

阶段 0 完成必须同时满足：

- [x] 明确 GAP-006 负责人、开发包、范围、依赖和优先级。
- [x] 核验商机、阶段、报价、产品和跟进的数据库、后端与前端现状。
- [x] 纠正旧 GAP 文档与当前源码冲突。
- [x] 将需求类型判定为复用、改进、待确认新增子能力或无法验证。
- [x] 明确禁止新建的同义模型、表、接口和页面。
- [x] 输出真实缺口、风险和阶段 1 设计输入。
- [x] 实际运行已有后端目标测试并记录结果。
- [x] 区分已通过、未通过、未运行和无法验证。
- [x] 将产物存入仓库 `docs/00-requirements/`。

## 2. GAP-006 阶段 0 验收标准

| 编号 | 验收标准 | 结果 | 证据 |
|---|---|---|---|
| AC-S0-01 | 五项能力均有明确判定 | 通过 | `scope-and-gap.md` 第 4 节 |
| AC-S0-02 | 每项判定包含可追溯代码或数据证据 | 通过 | `scope-and-gap.md` 第 5 节 |
| AC-S0-03 | 确认整体属于改进，不重建商机域 | 通过 | 现有 DO、表、接口、页面均已定位 |
| AC-S0-04 | 报价模型边界表述准确 | 通过 | 当前由产品行、折扣和汇总金额承载；独立报价待原型证明 |
| AC-S0-05 | 禁止重复建模清单完整 | 通过 | `scope-and-gap.md` 第 6 节 |
| AC-S0-06 | HJG 与公共能力/其他成员边界明确 | 通过 | `domain-ownership.md` |
| AC-S0-07 | User Story 覆盖阶段、输单、金额、产品、跟进 | 通过 | `epic-user-stories.md` |
| AC-S0-08 | 未把未运行项目写成通过 | 通过 | 本文件第 3 节 |
| AC-S0-09 | 业务源码未在阶段 0 被修改 | 通过 | 本次只新增需求文档 |

## 3. 实际测试与验证状态

| 验证项 | 状态 | 结果 |
|---|---|---|
| 后端 `CrmBusinessValidationTest` | 已通过 | 6 项通过；Failures 0、Errors 0、Skipped 0 |
| 前端 `vue-tsc --noEmit` | 未通过 | 8 GB Node 堆下完成；共 1164 行 `error TS...`，其中 `src/api/crm/` 或 `src/views/crm/` 107 行 |
| 浏览器商机页面操作 | 未运行 | 未启动完整前后端环境 |
| 商机接口联调 | 未运行 | 未启动 Server、数据库和登录环境 |
| 数据库初始化实测 | 未运行 | 只核验初始化 SQL 文件 |
| 组内交叉测试 | 未运行 | 尚未进入交叉测试阶段 |

后端有效命令：

```powershell
cd D:\codex\Internship\product\product\Server
mvn -pl mitedtsm-module-crm -am -Dtest=CrmBusinessValidationTest "-Dsurefire.failIfNoSpecifiedTests=false" test
```

前端有效命令：

```powershell
cd D:\codex\Internship\product\product\Web
$env:NODE_OPTIONS='--max_old_space_size=8192'
pnpm.cmd ts:check
```

前端检查已经能够完整执行，因此不再标记为“无法验证”；当前正确状态是“未通过”。现有错误属于仓库基线，其中商机、阶段和跟进页面也存在类型错误，需要在后续改动前建立基线并按任务范围收敛。

统计口径和可复算命令如下。`TOTAL_TS_ERRORS` 统计输出中符合 `error TS<数字>:` 的行；`CRM_TS_ERRORS` 在这些行中继续匹配 `src/api/crm/` 或 `src/views/crm/`：

```powershell
$env:NODE_OPTIONS='--max_old_space_size=8192'
$out = & pnpm.cmd ts:check 2>&1
$exit = $LASTEXITCODE
$lines = @($out | ForEach-Object { $_.ToString() })
$errors = @($lines | Where-Object { $_ -match 'error TS\d+:' })
$crm = @($errors | Where-Object { $_ -match 'src[\\/](api|views)[\\/]crm[\\/]' })
Write-Output "EXIT=$exit"
Write-Output "TOTAL_TS_ERRORS=$($errors.Count)"
Write-Output "CRM_TS_ERRORS=$($crm.Count)"
```

本次实测输出为 `EXIT=2`、`TOTAL_TS_ERRORS=1164`、`CRM_TS_ERRORS=107`。完整错误输出未纳入需求文档，避免提交大体积临时日志；后续复测应使用同一命令和口径。

## 4. 阶段 1 准入条件

进入 AISDD 设计前必须确认：

- [ ] 报价仅使用产品行和汇总金额，还是需要独立报价单、版本、审批和有效期。
- [ ] 阶段是否允许跳级、回退或终态重新打开。
- [ ] 输单原因使用自由文本还是业务字典。
- [ ] 同一商机是否允许重复产品行。
- [ ] 产品停用、删除及历史报价展示规则。
- [ ] 商机删除后产品行和跟进记录的保留规则。
- [ ] 跟进是否允许编辑，以及新增联动的事务和合法性校验。
- [ ] `BaseDO + tenant_id + 租户插件` 是否符合最新版多租户规范。
- [ ] 前端存量类型错误的处理策略和 GAP-006 基线范围。

## 5. 后续开发验收底线

后续每一项改进必须：

1. 能追溯到已确认的 GAP 或 User Story。
2. 在现有模型上做最小修改，不建立平行模型。
3. 同步后端校验、前端提示、权限和异常边界。
4. 增加单元测试，并实际执行相关检查。
5. 数据库改动以 `database/new` 增量 SQL 提交。
6. 报告修改文件、验证命令、验证结果和剩余风险。
7. 通过本人自测后，再由指定组员进行交叉测试。

## 6. 阶段 0 签署结论

GAP-006 阶段 0 文档产物已具备提交条件。当前阶段只证明现有能力、差异和设计输入已经核验完成，不代表 GAP-006 业务改进、浏览器联调或 UAT 已完成。
