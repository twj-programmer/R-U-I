<!-- 作者：23计科4班 黄金戈 -->

# develop 分支完整部署与数据库同步指南

## 1. 文档说明

本文用于指导其他组员在 Windows 电脑上拉取并运行 R-U-I 项目的 `develop` 分支，同时正确部署数据库、CRM 阶段 2 增量 SQL、合同审批流程和回款审批流程。

- GitHub 仓库：<https://github.com/twj-programmer/R-U-I>
- 目标分支：`develop`
- 本文核对提交：`3cb0cc3746c6dc5f27fbefc9af9c4c4b8e72b0bb`
- 默认部署方式：Docker Compose 本地或局域网部署
- 默认数据库：`mitedtsm_database`

> 重要：Git 只同步源码、配置和 SQL 文件，不同步本机 Docker Volume 中的 MySQL 数据、Flowable 流程实例、Redis 数据和 RabbitMQ 数据。仅拉取代码并不能保证两台电脑的运行数据库完全相同。

## 2. Git 与数据库会同步什么

| 内容 | 拉取 Git 后是否自动获得 | 处理方式 |
|---|---|---|
| Java、Vue、SQL、Docker Compose 配置 | 是 | 拉取 `develop` |
| `database/base/` 基础数据库脚本 | 是 | 全新 MySQL Volume 首次启动时自动执行 |
| `database/new/` 正向增量 SQL | 是 | 全新数据库自动执行；已有数据库需要人工升级 |
| MySQL Docker Volume 中的业务数据 | 否 | 使用完整备份与恢复 |
| Flowable 流程模型和流程实例 | 否 | 发布流程模型，或完整迁移包含 `ACT_*` 表的数据库 |
| 本机用户、租户、菜单和数据权限变化 | 否 | 通过数据库备份迁移，或在目标数据库重新配置 |
| `target/`、`dist-prod/`、Mall H5 构建产物 | 否 | 在目标电脑重新构建 |
| `Web/.env.local` 中的个人 IP | 否，不应提交 | 生产部署使用同源 Nginx 代理，不需要写死个人 IP |

数据库中的普通业务数据不同是正常的；数据库表结构、字典、权限或流程定义不同会导致功能报错。

## 3. 部署方式选择

开始前先选择一种数据库方案。

### 方案 A：全新数据库初始化（推荐）

适用于目标电脑没有需要保留的数据。数据库根据仓库中的 `database/base/` 和 `database/new/` 自动创建，之后再发布合同和回款审批流程。

优点：环境干净，最容易复现。缺点：不会包含其他电脑上新增的客户、合同、回款和审批历史。

### 方案 B：升级已有数据库

适用于目标电脑已经运行过旧版项目，需要保留现有数据。必须先备份，然后人工执行本阶段新增的正向 SQL。

优点：保留本机数据。缺点：需要确认哪些增量脚本已经执行，不能重复执行非幂等脚本。

### 方案 C：完整复制已配置数据库

适用于要求目标电脑和提供方电脑具有相同的业务数据、字典、权限、Flowable 模型和审批历史。需要传递完整 MySQL 备份文件，不能只复制 CRM 表。

> 完整数据库备份可能包含用户、密码哈希、手机号和测试业务数据，只能在小组授权范围内传递，禁止上传到公开 Git 仓库。

## 4. 环境要求

目标电脑需要安装：

- Git
- JDK 17
- Maven 3.9 或兼容版本
- Node.js 20 或 22 LTS（项目最低要求 Node.js 16）
- pnpm 8.6 或更高版本
- Docker Desktop，并启用 Linux Containers
- HBuilderX，用于构建 Mall 商城 H5

在 PowerShell 中执行：

```powershell
git --version
java -version
mvn -version
node --version
pnpm.cmd --version
docker version
docker compose version
```

如果 `docker version` 只有客户端信息或提示无法连接，请先启动 Docker Desktop，等待 Docker Engine 正常运行。

建议资源：

- 内存至少 16 GB，Docker Desktop 分配至少 6 GB
- 可用磁盘空间至少 20 GB
- 首次构建和拉取镜像时需要联网

## 5. 拉取 develop 分支

在计划存放项目的父目录执行：

```powershell
git clone --branch develop --single-branch https://github.com/twj-programmer/R-U-I.git
Set-Location R-U-I
git branch --show-current
git log -1 --oneline
```

预期结果：

- 当前分支为 `develop`
- 最新提交至少包含 `3cb0cc37`

已经克隆过仓库时执行：

```powershell
git status -sb
git switch develop
git pull --ff-only origin develop
```

如果 `git pull --ff-only` 提示本地修改冲突，不要使用 `git reset --hard`。先提交、暂存或备份本地修改，再处理分支同步。

## 6. 检查端口

当前 Compose 默认端口：

| 服务 | 宿主机端口 | 绑定范围 |
|---|---:|---|
| Web 管理后台 | 80 | `0.0.0.0`，允许本机和局域网访问 |
| Mall 商城 | 81 | `0.0.0.0`，允许本机和局域网访问 |
| Server 后端 | 8080 | `0.0.0.0`，允许本机和局域网访问 |
| MySQL | 3306 | `127.0.0.1`，仅本机 |
| Redis | 6379 | `127.0.0.1`，仅本机 |
| RabbitMQ | 5672、15672 | `127.0.0.1`，仅本机 |
| TDengine | 6030、6041、6043-6049 | `127.0.0.1`，仅本机 |

检查端口占用：

```powershell
Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
  Where-Object LocalPort -In 80,81,3306,5672,6379,8080,15672,6030,6041 |
  Select-Object LocalAddress,LocalPort,OwningProcess
```

如需修改 Web、Mall 或 Server 端口，编辑 `docker-compose/.env` 中的 `WEB_PORT`、`MALL_PORT`、`SERVER_PORT`。不要修改 MySQL 数据库名，除非同步调整后端 Docker Profile 的数据库连接。

## 7. 构建后端和前端

所有命令均从仓库根目录执行。

### 7.1 构建 Server

```powershell
Push-Location Server
mvn clean package -DskipTests
Pop-Location

Test-Path Server/mitedtsm-server/target/mitedtsm-server.jar
```

最后一条应返回 `True`。

### 7.2 构建 InitService

```powershell
Push-Location InitService
mvn clean package -DskipTests
Pop-Location

Test-Path InitService/target/mitedtsm-init-service.jar
```

最后一条应返回 `True`。`InitService` 用于初始化 TDengine，运行结束后退出码为 0 属于正常现象。

### 7.3 构建 Web 管理后台

```powershell
Push-Location Web
pnpm.cmd install --frozen-lockfile
pnpm.cmd build:prod
Pop-Location

Test-Path Web/dist-prod/index.html
```

最后一条应返回 `True`。生产构建使用同源 `/admin-api` 代理，不需要将个人局域网 IP 写入 `Web/.env.local`。

如果锁文件检查失败，应先核对 `pnpm-lock.yaml` 是否被错误修改。临时本地验证可以执行 `pnpm.cmd install`，但不要未经确认提交自动修改的锁文件。

### 7.4 构建 Mall 商城 H5

`MallFrontend/package.json` 当前没有稳定的命令行 H5 构建脚本，使用 HBuilderX：

1. 使用 HBuilderX 打开仓库中的 `MallFrontend`。
2. 如提示缺少依赖，在 `MallFrontend` 中执行 `pnpm.cmd install`。
3. 选择“发行 → 网站-H5手机版”。
4. 完成后检查：

```powershell
Test-Path MallFrontend/unpackage/dist/build/web/index.html
```

必须返回 `True`。如果本次只测试 CRM 管理后台，可以暂不启动 `mall` 服务。

## 8. 方案 A：全新数据库初始化

### 8.1 确认没有需要保留的数据

查看 Compose 状态和 Volume：

```powershell
Push-Location docker-compose
docker compose ps
docker volume ls
Pop-Location
```

如果本机已有同名项目数据，`docker compose down -v` 会删除 MySQL、Redis、RabbitMQ 和 TDengine Volume，属于不可逆操作。只有完成备份并确认不需要旧数据时才能执行：

```powershell
Push-Location docker-compose
docker compose down -v
Pop-Location
```

### 8.2 校验并启动全部服务

```powershell
Push-Location docker-compose

docker compose --env-file .env config --quiet
docker compose --env-file .env up -d --build
docker compose --env-file .env ps

Pop-Location
```

首次启动顺序：

1. MySQL、Redis、RabbitMQ、TDengine 启动并通过健康检查。
2. MySQL 在空 Volume 中执行 `database/base/` 和 `database/new/` 的正向 SQL。
3. `init-service` 创建 TDengine 数据库并以退出码 0 结束。
4. Server 启动并创建 Flowable 引擎表。
5. Web 和 Mall 启动。

> `database/new/*_rollback.sql` 是人工回退脚本，初始化脚本会跳过，禁止在正常部署时执行。

### 8.3 检查初始化日志

```powershell
Push-Location docker-compose
docker compose logs --no-color mysql
docker compose logs --no-color init-service
docker compose logs --no-color server --tail 200
Pop-Location
```

预期：

- MySQL 日志包含初始化完成信息。
- `mitedtsm-init-service` 为 `Exited (0)`。
- Server 日志没有新的致命异常。

### 8.4 核对关键数据库对象

打开 MySQL 客户端：

```powershell
docker exec -it mitedtsm-mysql sh -lc 'mysql --default-character-set=utf8mb4 -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE"'
```

输入以下 SQL：

```sql
SELECT COUNT(*) AS table_count
FROM information_schema.tables
WHERE table_schema = DATABASE();

SHOW TABLES LIKE 'crm_high_seas_record';
SHOW TABLES LIKE 'crm_customer_owner_history';

SELECT table_name, column_name, extra
FROM information_schema.columns
WHERE table_schema = DATABASE()
  AND table_name IN ('crm_high_seas_record', 'crm_customer_owner_history')
  AND column_name = 'id';

SELECT column_name
FROM information_schema.columns
WHERE table_schema = DATABASE()
  AND table_name = 'crm_customer_pool_config'
  AND column_name IN ('receive_limit_per_day', 'receive_cooldown_days');

SELECT dict_label, dict_value, status
FROM system_dict_data
WHERE dict_type = 'crm_business_lose_reason'
ORDER BY sort;
```

关键验收：

- 表数量约 323 张或更多；以关键表、字段存在为最终判断。
- 两张客户历史表的 `id` 都包含 `auto_increment`。
- 客户公海配置包含每日领取上限和冷却天数字段。
- 输单原因显示正常中文，不应出现乱码。

输入 `exit` 退出 MySQL。

## 9. 方案 B：升级已有数据库

### 9.1 先备份

在仓库根目录执行：

```powershell
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
New-Item -ItemType Directory -Force -Path backup | Out-Null

docker exec mitedtsm-mysql sh -lc 'mysqldump --single-transaction --routines --triggers --events --default-character-set=utf8mb4 -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" > /tmp/pre-upgrade.sql'
docker cp mitedtsm-mysql:/tmp/pre-upgrade.sql ".\backup\mitedtsm-pre-upgrade-$stamp.sql"
```

确认备份文件不是 0 字节：

```powershell
Get-Item ".\backup\mitedtsm-pre-upgrade-$stamp.sql" | Select-Object FullName,Length
```

不要把数据库备份提交到 Git。

### 9.2 执行 CRM 阶段 2 正向迁移

已有 MySQL Volume 不会再次触发 `/docker-entrypoint-initdb.d/`，因此需要人工执行新脚本。以下脚本从仓库根目录运行，并明确排除所有 `_rollback.sql`：

```powershell
$migrations = @(
  'database/new/20260716_d2_business_lose_reason_dict.sql',
  'database/new/20260716_d2_business_state_machine.sql',
  'database/new/20260716_d2_customer_duplicate_permission.sql',
  'database/new/20260716_d2_customer_pool_history.sql',
  'database/new/20260716_d2_customer_pool_receive_rules.sql',
  'database/new/20260716_d2_statistics_customer_export_permission.sql'
)

foreach ($sqlFile in $migrations) {
  if (-not (Test-Path $sqlFile)) {
    throw "找不到迁移文件：$sqlFile"
  }
  Write-Host "执行迁移：$sqlFile"
  docker cp $sqlFile mitedtsm-mysql:/tmp/migration.sql
  if ($LASTEXITCODE -ne 0) { throw "复制迁移失败：$sqlFile" }

  docker exec mitedtsm-mysql sh -lc 'mysql --default-character-set=utf8mb4 -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < /tmp/migration.sql'
  if ($LASTEXITCODE -ne 0) { throw "执行迁移失败：$sqlFile" }
}
```

如果数据库更旧或已由其他组员执行过部分脚本，不应盲目重复执行全部 `database/new/`。先核对表、字段和脚本幂等性，再补缺失迁移。

### 9.3 恢复备份的方法

仅在升级失败且确认需要回退时执行。先停止 Server，避免恢复期间继续写入：

```powershell
Push-Location docker-compose
docker compose stop server
Pop-Location

docker cp .\backup\要恢复的备份.sql mitedtsm-mysql:/tmp/restore.sql
docker exec mitedtsm-mysql sh -lc 'mysql --default-character-set=utf8mb4 -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < /tmp/restore.sql'

Push-Location docker-compose
docker compose start server
Pop-Location
```

## 10. 方案 C：完整复制已配置数据库

如果要求目标电脑与提供方电脑拥有完全相同的 CRM 数据和审批历史，必须导出整个 `mitedtsm_database`，包括：

- CRM、系统、权限、字典数据
- `bpm_*` 流程元数据
- Flowable 的 `ACT_RE_*`、`ACT_RU_*`、`ACT_HI_*`、`ACT_GE_*` 表

### 10.1 在提供方电脑导出

```powershell
Push-Location docker-compose
docker compose stop server
Pop-Location

docker exec mitedtsm-mysql sh -lc 'mysqldump --single-transaction --routines --triggers --events --default-character-set=utf8mb4 --add-drop-table -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" > /tmp/mitedtsm-full.sql'
docker cp mitedtsm-mysql:/tmp/mitedtsm-full.sql .\mitedtsm-full.sql

Push-Location docker-compose
docker compose start server
Pop-Location
```

将 `mitedtsm-full.sql` 通过受控方式传给组员，不要上传到 GitHub。

### 10.2 在目标电脑恢复

目标电脑先完成代码构建，然后只启动 MySQL：

```powershell
Push-Location docker-compose
docker compose up -d mysql
docker compose ps mysql
Pop-Location
```

等待 MySQL 健康后执行：

```powershell
docker cp .\mitedtsm-full.sql mitedtsm-mysql:/tmp/mitedtsm-full.sql
docker exec mitedtsm-mysql sh -lc 'mysql --default-character-set=utf8mb4 -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < /tmp/mitedtsm-full.sql'
```

然后启动其余服务：

```powershell
Push-Location docker-compose
docker compose up -d --build
docker compose ps
Pop-Location
```

完整恢复后，如果 `ACT_RE_PROCDEF` 已包含 `crm-contract-audit` 和 `crm-receivable-audit`，不需要重复发布流程。

## 11. 发布合同和回款审批流程

### 11.1 为什么必须发布

合同和回款代码只保存流程 Key：

- 合同：`crm-contract-audit`
- 回款：`crm-receivable-audit`

Flowable 模型存放在运行数据库中，不属于 Git 文件。全新初始化或只导入基础 SQL 后，如果没有发布这两个流程，点击“提交审核”会提示“流程不存在”。

### 11.2 使用 PowerShell 自动创建并发布

确认 Server 健康后，在仓库根目录打开 PowerShell，执行下面脚本。脚本只调用项目公开管理接口，不直接插入 Flowable 内部表。

```powershell
$ApiBase = 'http://127.0.0.1/admin-api'
$TenantId = '1'
$Username = Read-Host '管理员用户名（默认 admin）'
if ([string]::IsNullOrWhiteSpace($Username)) { $Username = 'admin' }

$securePassword = Read-Host '管理员密码' -AsSecureString
$passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
try {
  $Password = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPointer)
} finally {
  [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($passwordPointer)
}

$loginHeaders = @{
  'tenant-id'   = $TenantId
  'Content-Type' = 'application/json'
}
$loginBody = @{
  username = $Username
  password = $Password
  captchaVerification = ''
} | ConvertTo-Json

$login = Invoke-RestMethod `
  -Uri "$ApiBase/system/auth/login" `
  -Method Post `
  -Headers $loginHeaders `
  -Body $loginBody

Remove-Variable Password

if ($login.code -ne 0) {
  throw "登录失败：$($login.msg)"
}

$approverUserId = [long]$login.data.userId
$headers = @{
  'tenant-id'    = $TenantId
  'Authorization' = "Bearer $($login.data.accessToken)"
  'Content-Type' = 'application/json'
}

function Ensure-CrmApprovalModel {
  param(
    [Parameter(Mandatory = $true)][string]$Key,
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)][string]$TaskId,
    [Parameter(Mandatory = $true)][string]$TaskName,
    [Parameter(Mandatory = $true)][string]$FormPath
  )

  $bpmnXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xmlns:flowable="http://flowable.org/bpmn"
             targetNamespace="http://meession.com/bpm">
  <process id="$Key" name="$Name" isExecutable="true">
    <startEvent id="StartEvent" name="开始" />
    <sequenceFlow id="flow-start-approve" sourceRef="StartEvent" targetRef="$TaskId" />
    <userTask id="$TaskId" name="$TaskName"
              flowable:candidateStrategy="30"
              flowable:candidateParam="$approverUserId" />
    <sequenceFlow id="flow-approve-end" sourceRef="$TaskId" targetRef="EndEvent" />
    <endEvent id="EndEvent" name="结束" />
  </process>
</definitions>
"@

  $payload = [ordered]@{
    key = $Key
    name = $Name
    category = 'TEST'
    description = "$Name（CRM 阶段 2）"
    type = 10
    formType = 20
    formCustomCreatePath = $FormPath
    formCustomViewPath = $FormPath
    visible = $true
    startUserIds = @()
    startDeptIds = @()
    managerUserIds = @($approverUserId)
    allowCancelRunningProcess = $true
    allowWithdrawTask = $false
    bpmnXml = $bpmnXml
  }

  $modelList = Invoke-RestMethod `
    -Uri "$ApiBase/bpm/model/list" `
    -Method Get `
    -Headers $headers

  if ($modelList.code -ne 0) {
    throw "读取流程模型失败：$($modelList.msg)"
  }

  $existing = @($modelList.data) |
    Where-Object { $_.key -eq $Key } |
    Select-Object -First 1

  if ($existing) {
    $modelId = [string]$existing.id
    $payload['id'] = $modelId
    $update = Invoke-RestMethod `
      -Uri "$ApiBase/bpm/model/update" `
      -Method Put `
      -Headers $headers `
      -Body ($payload | ConvertTo-Json -Depth 20)
    if ($update.code -ne 0) {
      throw "更新 $Key 失败：$($update.msg)"
    }
  } else {
    $create = Invoke-RestMethod `
      -Uri "$ApiBase/bpm/model/create" `
      -Method Post `
      -Headers $headers `
      -Body ($payload | ConvertTo-Json -Depth 20)
    if ($create.code -ne 0) {
      throw "创建 $Key 失败：$($create.msg)"
    }
    $modelId = if ($create.data -is [string]) {
      $create.data
    } else {
      [string]$create.data.id
    }
  }

  $deploy = Invoke-RestMethod `
    -Uri "$ApiBase/bpm/model/deploy?id=$modelId" `
    -Method Post `
    -Headers $headers
  if ($deploy.code -ne 0) {
    throw "发布 $Key 失败：$($deploy.msg)"
  }

  $definition = Invoke-RestMethod `
    -Uri "$ApiBase/bpm/process-definition/get?key=$Key" `
    -Method Get `
    -Headers $headers
  if ($definition.code -ne 0 -or -not $definition.data.id) {
    throw "发布后未找到流程定义：$Key"
  }

  Write-Host "发布成功：$Key -> $($definition.data.id)"
}

Ensure-CrmApprovalModel `
  -Key 'crm-contract-audit' `
  -Name 'CRM合同审批' `
  -TaskId 'contract-approve' `
  -TaskName '合同审批' `
  -FormPath '/crm/contract/detail/index'

Ensure-CrmApprovalModel `
  -Key 'crm-receivable-audit' `
  -Name 'CRM回款审批' `
  -TaskId 'receivable-approve' `
  -TaskName '回款审批' `
  -FormPath '/crm/receivable/detail/index'
```

默认数据库中的管理员一般为 `admin / admin123`。如果密码已修改，使用实际密码。脚本默认使用当前登录管理员作为审批人；需要多人审批时，应在“工作流程 → 流程管理 → 流程模型”中修改审批节点后重新发布。

如果提示分类不存在，先在“工作流程 → 流程管理 → 流程分类”确认存在编码 `TEST` 的分类，或将脚本中的 `category = 'TEST'` 修改为目标数据库已有的分类编码。

### 11.3 核对流程定义

进入 MySQL：

```powershell
docker exec -it mitedtsm-mysql sh -lc 'mysql --default-character-set=utf8mb4 -uroot -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE"'
```

执行：

```sql
SELECT ID_, KEY_, NAME_, VERSION_, TENANT_ID_
FROM ACT_RE_PROCDEF
WHERE KEY_ IN ('crm-contract-audit', 'crm-receivable-audit')
ORDER BY KEY_, VERSION_;
```

两个 Key 都至少应返回一条记录。

## 12. 清理旧演示数据中的失效流程 ID

基础 CRM 数据可能包含旧环境的 `process_instance_id`，但没有对应的 Flowable 历史表数据。点击这类记录的“查看审批”会提示“流程实例不存在”。

先查询，不要直接修改：

```sql
SELECT 'contract' AS biz_type, c.id, c.name AS biz_name,
       c.audit_status, c.process_instance_id
FROM crm_contract c
LEFT JOIN ACT_HI_PROCINST h ON h.ID_ = c.process_instance_id
WHERE c.process_instance_id IS NOT NULL AND h.ID_ IS NULL
UNION ALL
SELECT 'receivable' AS biz_type, r.id, r.no AS biz_name,
       r.audit_status, r.process_instance_id
FROM crm_receivable r
LEFT JOIN ACT_HI_PROCINST h ON h.ID_ = r.process_instance_id
WHERE r.process_instance_id IS NOT NULL AND h.ID_ IS NULL;
```

如果确认这些是无法恢复的旧演示实例，执行以下清理：

```sql
START TRANSACTION;

UPDATE crm_contract c
LEFT JOIN ACT_HI_PROCINST h ON h.ID_ = c.process_instance_id
SET c.audit_status = CASE WHEN c.audit_status = 10 THEN 0 ELSE c.audit_status END,
    c.process_instance_id = NULL
WHERE c.process_instance_id IS NOT NULL
  AND h.ID_ IS NULL;

UPDATE crm_receivable r
LEFT JOIN ACT_HI_PROCINST h ON h.ID_ = r.process_instance_id
SET r.audit_status = CASE WHEN r.audit_status = 10 THEN 0 ELSE r.audit_status END,
    r.process_instance_id = NULL
WHERE r.process_instance_id IS NOT NULL
  AND h.ID_ IS NULL;

COMMIT;
```

处理规则：

- 卡在审批中的孤儿数据从状态 10 恢复为状态 0，可重新提交。
- 已审批完成的数据保留原状态，只移除无效流程 ID，因此不再展示错误入口。
- 不伪造不存在的历史审批记录。

完整数据库恢复且 `ACT_HI_PROCINST` 中存在对应实例时，上述 SQL 不会清理有效流程 ID。

## 13. 启动和验证

### 13.1 启动全部服务

```powershell
Push-Location docker-compose
docker compose up -d --build
docker compose ps
Pop-Location
```

如只验证 CRM 管理后台，可以不启动 Mall：

```powershell
Push-Location docker-compose
docker compose up -d mysql redis rabbitmq tdengine init-service server web
Pop-Location
```

### 13.2 HTTP 健康检查

```powershell
$health = Invoke-RestMethod http://127.0.0.1:8080/actuator/health
$health.status

(Invoke-WebRequest http://127.0.0.1 -UseBasicParsing).StatusCode
(Invoke-WebRequest http://127.0.0.1:81 -UseBasicParsing).StatusCode
```

预期：

- Server 状态为 `UP`
- Web 返回 HTTP 200
- 已构建并启动 Mall 时，Mall 返回 HTTP 200

本机访问地址：

- 管理后台：<http://127.0.0.1>
- 商城前端：<http://127.0.0.1:81>
- 后端健康检查：<http://127.0.0.1:8080/actuator/health>
- RabbitMQ 管理页：<http://127.0.0.1:15672>

### 13.3 CRM 功能验收

登录管理后台后至少执行以下检查：

1. `CRM → 客户 → 客户详情`：显示“公海记录”和“负责人历史”，负责人和操作人名称正常。
2. `CRM → 客户公海`：领取、放入公海、负责人历史可以正常记录。
3. `CRM → 商机`：产品关联、报价金额、阶段流转、输单原因和跟进记录正常。
4. `CRM → 合同`：能够新增；未提交数据可以点击“提交审核”；新流程可以点击“查看审批”。
5. `CRM → 回款`：能够新增；未提交数据可以点击“提交审核”；新流程可以点击“查看审批”。
6. 合同和回款操作列按钮可以分别点击，不应被溢出气泡遮挡。

## 14. 局域网访问

当前 Compose 只向局域网开放 Web、Mall 和 Server，MySQL、Redis、RabbitMQ、TDengine 仍只绑定 `127.0.0.1`。

### 14.1 获取部署电脑 IPv4

```powershell
Get-NetIPAddress -AddressFamily IPv4 |
  Where-Object {
    $_.IPAddress -notlike '127.*' -and
    $_.IPAddress -notlike '169.254.*'
  } |
  Select-Object InterfaceAlias,IPAddress,PrefixLength
```

部署电脑和访问电脑必须连接同一交换机或网线网络，并处在相同子网。

### 14.2 配置 Windows 防火墙

以管理员身份打开 PowerShell：

```powershell
New-NetFirewallRule `
  -DisplayName 'R-U-I Web LAN' `
  -Direction Inbound `
  -Action Allow `
  -Protocol TCP `
  -LocalPort 80,81,8080 `
  -RemoteAddress LocalSubnet
```

不需要向局域网开放 3306、6379、5672、15672 和 TDengine 端口。

### 14.3 从另一台电脑验证

假设部署电脑 IPv4 为 `172.22.118.230`：

- 管理后台：`http://172.22.118.230`
- 商城前端：`http://172.22.118.230:81`
- 后端健康检查：`http://172.22.118.230:8080/actuator/health`

先测试网络：

```powershell
Test-NetConnection 172.22.118.230 -Port 80
Test-NetConnection 172.22.118.230 -Port 8080
```

不要直接照抄示例 IP，应替换为部署电脑实际 IPv4。

## 15. 更新代码后的标准流程

后续组长更新 `develop` 后，按以下顺序更新：

```powershell
git status -sb
git switch develop
git pull --ff-only origin develop
```

检查新增 SQL：

```powershell
git diff --name-only 'HEAD@{1}' HEAD -- database/new
```

然后：

1. 备份已有数据库。
2. 只执行新增加且尚未应用的正向 SQL。
3. 重新构建 Server、InitService 和 Web。
4. 执行 `docker compose up -d --build`。
5. 核对流程定义和 CRM 定向功能。

不要在有未提交修改时直接覆盖文件，也不要在没有备份时执行 `docker compose down -v`。

## 16. 常见问题

### 16.1 点击提交审核提示“流程不存在”

原因：目标数据库没有发布 `crm-contract-audit` 或 `crm-receivable-audit`。

处理：执行第 11 节脚本，并查询 `ACT_RE_PROCDEF`。

### 16.2 点击查看审批提示“流程实例不存在”

原因：业务表保存了另一个数据库中的流程实例 ID，但当前数据库没有对应 `ACT_HI_PROCINST` 记录。

处理：如果需要真实历史，恢复完整数据库；如果只是旧演示数据，按第 12 节清理孤儿 ID。

### 16.3 已拉取 SQL，但数据库没有新表或字段

原因：MySQL Volume 已存在，Docker 首次初始化脚本不会重复执行。

处理：先备份，再按第 9 节执行新增正向迁移；不要通过反复重启容器等待脚本自动执行。

### 16.4 中文字典乱码

确认 MySQL 服务器和客户端使用 `utf8mb4`。本项目初始化脚本已经使用：

```text
--default-character-set=utf8mb4
```

如果旧数据已经乱码，需要重新导入正确编码的数据，单纯修改字符集不会自动修复已经损坏的文本。

### 16.5 PowerShell 禁止执行 pnpm.ps1

将 `pnpm` 改为：

```powershell
pnpm.cmd install --frozen-lockfile
pnpm.cmd build:prod
```

### 16.6 80 端口被占用

查询占用进程：

```powershell
Get-NetTCPConnection -LocalPort 80 -State Listen -ErrorAction SilentlyContinue |
  Select-Object LocalAddress,LocalPort,OwningProcess
```

停止不需要的进程，或修改 `docker-compose/.env` 中的 `WEB_PORT`。

### 16.7 InitService 显示 Exited (0)

这是正常结果，表示初始化任务成功完成；只有非 0 退出码才属于失败。

### 16.8 Web 返回 502

查看后端和 Nginx 日志：

```powershell
Push-Location docker-compose
docker compose logs --tail 200 server
docker compose logs --tail 100 web
Pop-Location
```

确认 Server 健康接口能从本机访问，并确认 `web.conf` 将 `/admin-api` 转发到 `server:8080`。

## 17. 最终验收清单

- [ ] 当前分支为 `develop`，代码已拉到预期提交。
- [ ] Server JAR、InitService JAR、Web 和 Mall 构建产物存在。
- [ ] Docker Compose 配置校验通过。
- [ ] MySQL、Redis、RabbitMQ、TDengine 和 Server 健康。
- [ ] InitService 以状态码 0 结束。
- [ ] CRM 阶段 2 正向 SQL 已执行，未执行任何回滚脚本。
- [ ] 客户历史表主键具有 `auto_increment`。
- [ ] 商机输单原因中文正常。
- [ ] `crm-contract-audit` 已发布。
- [ ] `crm-receivable-audit` 已发布。
- [ ] 新合同能够提交并查看审批。
- [ ] 新回款能够提交并查看审批。
- [ ] 旧演示数据不存在失效的流程入口。
- [ ] Web、Mall、后端健康检查均返回成功。
- [ ] 如需局域网访问，目标电脑已通过实际 IPv4 和端口验证。
