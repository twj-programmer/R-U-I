# R-U-I 企业级一体化业务平台

R-U-I 是第六组课程实习项目代码。本仓库采用前后端分离和后端多模块架构，包含 Vue 3 管理后台、uni-app 商城、Spring Boot 后端，以及 MySQL、Redis、RabbitMQ、TDengine 等本地基础设施。

当前交付目标是完整的本地运行环境，不要求公网域名、云服务器或线上部署。源码中的外部 AI、微信、地图和在线支付等扩展能力需要相应第三方服务，在纯离线环境下不属于基础验收范围。

## 核心功能

- 系统管理：用户、角色、部门、岗位、菜单、权限、租户、字典、日志、邮件和短信。
- 商城系统：商品、分类、购物车、订单、营销、会员、积分、售后和运营统计。
- CRM：线索、客户、联系人、商机、合同、回款、跟进和销售统计。
- ERP：产品、采购、销售、库存、仓库和财务。
- BPM：流程模型、表单设计、审批实例和待办任务。
- IoT：产品、设备、物模型、数据规则、告警、OTA 和 TDengine 时序数据。
- 扩展模块：AI、支付、微信公众号、报表和可视化大屏。

商城代码支持 H5、App 和微信小程序等 uni-app 目标；当前 Docker Compose 本地交付使用 H5 Web 构建产物。

## 系统架构

```text
Web 管理后台 ── /admin-api ──┐
                              ├── Nginx ── Spring Boot ── MySQL
Mall 商城端 ─── /app-api ─────┘                     ├── Redis
                                                    ├── RabbitMQ
                                                    └── TDengine
```

后端业务模块采用统一的 `Controller -> Service -> Mapper` 分层，管理端菜单和路由根据用户角色动态加载。

## 技术栈

| 部分 | 主要技术 |
|---|---|
| Web 管理端 | Vue 3.5、TypeScript、Vite 5、Element Plus、Pinia、Vue Router、Axios |
| Mall 商城端 | uni-app、Vue 3、Pinia、luch-request、HBuilderX |
| Server 后端 | Java 17、Spring Boot 3.5.9、Maven、Spring Security、MyBatis Plus、Flowable |
| 基础设施 | MySQL 8、Redis 6、RabbitMQ 3、TDengine 3、Nginx、Docker Compose |

## 项目目录

| 目录 | 说明 |
|---|---|
| `Web/` | Vue 3 管理后台源码 |
| `MallFrontend/` | uni-app 商城源码 |
| `Server/` | Maven 父工程、框架层和业务模块 |
| `Server/mitedtsm-server/` | 后端启动入口和环境配置 |
| `InitService/` | TDengine 数据库初始化程序 |
| `database/base/` | 基础数据库脚本 |
| `database/new/` | 增量数据库脚本 |
| `database/replace-en/` | 部分基础数据英文替换脚本 |
| `dev/` | 本地开发基础设施编排 |
| `docker-compose/` | 完整本地部署编排、Dockerfile 和 Nginx 配置 |
| `docs/` | 项目结构、开发和国际化文档 |
| `uploads/` | 本地运行时上传目录，不提交运行数据 |

`docker-images/` 中的离线镜像归档、`target/`、`node_modules/` 和前端构建产物均可重新生成，因此不纳入源码仓库。

## 本地部署（Windows）

下面的命令默认在 Windows PowerShell 中执行。仓库不包含 `target/`、`dist-prod/`、`unpackage/` 和 Docker 离线镜像，首次部署必须先生成构建产物。

> 第一次安装 Maven、pnpm 依赖和拉取 Docker 基础镜像需要联网；依赖和镜像准备完成后，项目的本地基础功能不依赖公网运行。

### 1. 安装并检查环境

需要安装：

- Git。
- JDK 17。
- Maven 3.9 或兼容版本。
- Node.js 16 或更高版本，推荐 Node.js 20/22 LTS。
- pnpm 8.6 或更高版本。
- Docker Desktop，并启用 Linux Containers。
- HBuilderX，用于构建 Mall 商城 H5。

在 PowerShell 中检查：

```powershell
git --version
java -version
mvn -version
node --version
pnpm --version
docker version
docker compose version
```

如果 PowerShell 执行策略阻止 `pnpm.ps1`，后续命令可将 `pnpm` 替换为 `pnpm.cmd`。启动前请确认 Docker Desktop 已正常运行，建议为 Docker 分配至少 6 GB 内存。

### 2. 克隆 `huang` 分支

```powershell
git clone -b huang https://github.com/twj-programmer/R-U-I.git
Set-Location R-U-I
git branch --show-current
```

最后一条命令应输出 `huang`。后续命令均从仓库根目录 `R-U-I` 执行。

### 3. 检查本地配置和端口

完整编排使用 [docker-compose/.env](docker-compose/.env)。默认端口为：

| 服务 | 本机端口 |
|---|---:|
| Web | 80 |
| Mall | 3000 |
| Server | 8080 |
| MySQL | 3306 |
| Redis | 6379 |
| RabbitMQ | 5672、15672 |
| TDengine | 6030、6041、6043-6049 |

检查常用端口是否被占用：

```powershell
Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
  Where-Object LocalPort -In 80,3000,3306,5672,6379,8080,15672,6030,6041 |
  Select-Object LocalAddress,LocalPort,OwningProcess
```

Web、Mall 和 Server 的宿主端口可在 `.env` 中修改。基础设施端口当前写在 `docker-compose.yml` 中，如有冲突，应先停止占用端口的旧服务。所有项目端口均绑定到 `127.0.0.1`，只允许本机访问。

首次运行建议保留仓库中的本地开发默认配置。若修改 MySQL 密码，还必须同步修改后端 Docker profile 的主库和从库密码，否则 Server 无法连接数据库。

### 4. 构建 Server 后端

```powershell
Push-Location Server
mvn clean package -DskipTests
Pop-Location

Test-Path Server/mitedtsm-server/target/mitedtsm-server.jar
```

最后一条命令必须返回 `True`。首次 Maven 构建需要下载依赖，耗时取决于网络和本地缓存。

### 5. 构建 InitService

```powershell
Push-Location InitService
mvn clean package -DskipTests
Pop-Location

Test-Path InitService/target/mitedtsm-init-service.jar
```

最后一条命令必须返回 `True`。InitService 用于创建和验证 TDengine 数据库。

### 6. 构建 Web 管理后台

团队统一使用 pnpm，不要在同一次构建中混用 npm 和 pnpm：

```powershell
Push-Location Web
pnpm install --frozen-lockfile
pnpm run build:prod
Pop-Location

Test-Path Web/dist-prod/index.html
```

最后一条命令必须返回 `True`。如果 `--frozen-lockfile` 因锁文件不一致而失败，应先确认锁文件变化；临时本地验证可以改用 `pnpm install`，但不要在未确认时提交自动修改的锁文件。

### 7. 构建 Mall 商城 H5

`MallFrontend/package.json` 当前没有 H5 命令行构建脚本，必须使用 HBuilderX：

1. 打开 HBuilderX。
2. 选择“文件 -> 导入 -> 从本地目录导入”。
3. 选择仓库中的 `MallFrontend` 文件夹。
4. 等待依赖识别完成；如提示安装依赖，在 `MallFrontend` 中执行 `pnpm install`。
5. 选择“发行 -> 网站-H5手机版”。
6. 不需要配置公网域名，完成构建。

构建完成后回到 PowerShell 检查：

```powershell
Test-Path MallFrontend/unpackage/dist/build/web/index.html
```

必须返回 `True`。Docker 中的 Mall Nginx 会挂载该目录。

### 8. 校验并启动 Docker Compose

```powershell
Push-Location docker-compose

docker compose --env-file .env config --quiet
docker compose --env-file .env up -d --build
docker compose --env-file .env ps

Pop-Location
```

启动依赖顺序为：

1. MySQL、Redis、RabbitMQ、TDengine 健康。
2. InitService 创建 TDengine 数据库并正常退出。
3. Server 启动并通过健康检查。
4. Web 和 Mall 启动。

`mitedtsm-init-service` 显示 `Exited (0)` 是正常结果，表示初始化已成功完成，不是服务故障。

### 9. 验证部署结果

```powershell
Invoke-RestMethod http://127.0.0.1:8080/actuator/health
(Invoke-WebRequest http://127.0.0.1 -UseBasicParsing).StatusCode
(Invoke-WebRequest http://127.0.0.1:3000 -UseBasicParsing).StatusCode
```

预期结果：

- 健康接口返回 `status = UP`。
- Web 和 Mall 都返回 HTTP `200`。
- 管理接口或商城接口在未登录时可能返回未授权，这是正常的；出现 `502 Bad Gateway` 才表示 Nginx 无法连接 Server。

本地访问地址：

| 服务 | 地址 |
|---|---|
| Web 管理后台 | http://127.0.0.1 |
| Mall 商城 | http://127.0.0.1:3000 |
| Server 健康检查 | http://127.0.0.1:8080/actuator/health |
| RabbitMQ 管理页 | http://127.0.0.1:15672 |

### 10. 查看日志和常见故障

```powershell
Push-Location docker-compose

docker compose ps
docker compose logs --tail 200 mysql
docker compose logs --tail 200 init-service
docker compose logs --tail 200 server
docker compose logs --tail 200 web mall

Pop-Location
```

常见问题：

- `docker` 命令不存在：启动 Docker Desktop，等待 Engine 就绪后重新打开终端。
- Docker 构建提示找不到 Server Jar：重新执行第 4 步；找不到 InitService Jar：重新执行第 5 步，并确认对应的 `Test-Path` 返回 `True`。
- Web 或 Mall 页面不存在：重新生成对应前端构建目录。
- Server `unhealthy`：依次检查 MySQL、InitService 和 Server 日志。
- Web/Mall 返回 502：通常是 Server 尚未健康或启动失败。
- 容器名称或端口冲突：运行 `docker ps -a` 查找旧容器，确认数据不再需要后再处理冲突。
- SQL 修改后没有自动执行：MySQL 初始化脚本只在空数据卷第一次创建时运行，不会在每次启动时重复执行。

### 11. 代码修改后的重新部署

- Server 或 InitService 修改后：重新执行 Maven 构建，再运行 `docker compose up -d --build`。
- Web 修改后：重新执行 `pnpm run build:prod`，然后执行 `docker compose restart web`。
- Mall 修改后：使用 HBuilderX 重新发行 H5，然后执行 `docker compose restart mall`。

### 12. 停止、恢复和删除容器

在 `docker-compose` 目录执行：

```powershell
docker compose stop   # 暂停容器，保留容器和数据
docker compose start  # 恢复已暂停的容器
docker compose down   # 删除容器和网络，保留命名数据卷
```

> **数据警告：** 不要在日常更新中执行 `docker compose down -v`，也不要随意执行 `docker volume prune`。这些命令会删除 MySQL、Redis、RabbitMQ 和 TDengine 数据卷。只有在明确需要完全重置且已经备份数据时才能使用。

## 本地源码开发

1. 在 `dev/` 中使用 Docker Compose 启动 MySQL、Redis、RabbitMQ、TDengine 和 InitService。
2. 在 IDEA 或其他 Java IDE 中启动 `Server/mitedtsm-server`。
3. 在 `Web/` 执行 `pnpm install` 和 `pnpm dev`。
4. 使用 HBuilderX 将 `MallFrontend/` 运行到浏览器。

## 当前验证状态

已完成验证：

- MySQL、Redis、RabbitMQ、TDengine 容器健康。
- MySQL 基础数据库脚本和 TDengine 初始化成功。
- Spring Boot 健康检查返回 HTTP 200。
- Web 和 Mall 首页返回 HTTP 200。
- `/admin-api` 与 `/app-api` 的 Nginx 代理链路可用。
- Mall 商品分类接口能够读取初始化数据。

尚未逐项完成运行验收：

- 登录、角色权限和租户隔离的完整流程。
- 商品写入、购物车、下单、支付和售后全链路。
- CRM、ERP、BPM、AI 和 IoT 的所有业务状态流转。
- 依赖外部服务的 AI、微信、地图和在线支付功能。

## 安全说明

- 不要提交真实 `.env`、第三方 API Key、微信密钥、数据库数据卷或上传文件。
- 后端第三方服务凭据应通过环境变量注入，配置文件只保留占位符。
- 如果任何密钥曾经公开，应立即在对应服务中吊销并轮换。
- 公开部署前必须修改默认口令，并重新评估网络暴露、HTTPS、跨域和访问控制策略。

## 相关文档

- `docs/develop/README_STRUCTURE.md`：系统结构与模块说明。
- `EDIT_GUIDE_BY_3031.md`：功能修改入口说明。
- `docs/language/LANGUAGE_ADD_GUIDE.md`：国际化扩展说明。

