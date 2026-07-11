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

## 环境要求

完整本地部署需要：

- Docker Desktop，启用 Linux 容器。
- Docker Compose v2 或更高版本。

进行源码开发时还需要：

- JDK 17。
- Maven 3.9 或兼容版本。
- Node.js 16 或更高版本。
- pnpm 8.6 或更高版本。
- HBuilderX，用于重新构建 Mall 多端项目。

## 本地部署

### 1. 创建本地环境配置

```powershell
Copy-Item docker-compose/.env.example docker-compose/.env
```

首次启动前，请修改 `.env` 中的数据库密码。真实 `.env` 不应提交到 Git。

### 2. 准备构建产物

后端：

```powershell
cd Server
mvn clean package -DskipTests
cd ..
```

管理后台：

```powershell
cd Web
pnpm install
pnpm run build:prod
cd ..
```

商城 H5 需要在 HBuilderX 中选择“发行 -> 网站 H5”，生成目录为：

```text
MallFrontend/unpackage/dist/build/web
```

### 3. 启动完整环境

```powershell
cd docker-compose
docker compose --env-file .env up -d --build
docker compose ps
```

所有宿主端口均绑定到 `127.0.0.1`，只允许本机访问。

### 4. 本地访问地址

| 服务 | 地址 |
|---|---|
| Web 管理后台 | http://127.0.0.1 |
| Mall 商城 | http://127.0.0.1:3000 |
| Server 健康检查 | http://127.0.0.1:8080/actuator/health |
| RabbitMQ 管理页 | http://127.0.0.1:15672 |

### 5. 停止服务

```powershell
docker compose down
```

该命令会保留数据库卷。`docker compose down -v` 会删除数据库、缓存和时序数据卷，仅应在明确需要完全重置且已经备份数据时使用。

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

