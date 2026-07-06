# vmall_home

华为商城首页的 Spring Boot + HarmonyOS 仿写 Demo，含 AI 智能导购。

## 项目结构

```
vmall_home/
├── src/                    # Spring Boot 后端
├── HarmonyApp/             # HarmonyOS 前端
└── pom.xml
```

## 启动后端

### 1. 数据库

创建 MySQL 数据库，执行 `src/main/resources/sql/` 下的建表脚本。

### 2. 配置

```bash
cp src/main/resources/application-local.example.yml src/main/resources/application-local.yml
```

修改 `application-local.yml` 中的数据库连接、用户名密码和 DeepSeek API Key。

### 3. 运行

```bash
./mvnw spring-boot:run
```

后端默认启动在 `http://localhost:8080`。

## 启动前端（HarmonyOS）

### 1. 配置 API 地址

```bash
# 复制 ApiConfig.example.ets 为 ApiConfig.ets
cp HarmonyApp/entry/src/main/ets/api/ApiConfig.example.ets HarmonyApp/entry/src/main/ets/api/ApiConfig.ets
```

修改 `ApiConfig.ets` 中的 `API_BASE_URL` 为后端实际地址。

### 2. 运行

用 DevEco Studio 打开 `HarmonyApp/` 目录，连接模拟器或真机，点击运行。

## 技术栈

- **后端**: Spring Boot 3.5, MyBatis, MySQL, Spring AI (DeepSeek)
- **前端**: HarmonyOS NEXT (API 21, ArkTS)
