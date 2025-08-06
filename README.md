# AI Meeting Notes API

基于阿里云语音识别和DeepSeek AI的智能会议记录系统后端API。

## 项目概述

本项目是一个智能会议记录系统的后端API，主要功能包括：

- 🎤 **语音转文字**：集成阿里云语音识别服务，支持实时语音转文字
- 🤖 **AI智能分析**：使用DeepSeek AI进行会议内容分析和总结
- 📱 **微信小程序支持**：为微信小程序提供API接口
- 🔒 **安全认证**：支持微信小程序用户认证
- 📊 **数据管理**：会议记录的存储和管理

## 技术栈

- **后端框架**：Go + Gin
- **语音识别**：阿里云语音识别服务
- **AI分析**：DeepSeek API
- **容器化**：Docker + Docker Compose
- **反向代理**：Nginx
- **开发工具**：VS Code + Go扩展

## 快速开始

### 环境要求

- Go 1.21+
- Docker & Docker Compose
- Make（可选，用于简化命令）

### 1. 克隆项目

```bash
git clone https://github.com/longkedev/ai-meeting-notes.git
cd ai-meeting-notes
```

### 2. 环境配置

复制环境变量文件并配置：

```bash
cp .env.development .env
```

编辑 `.env` 文件，填入实际的API密钥：

```bash
# 阿里云语音识别配置
ALIYUN_ACCESS_KEY_ID=your_access_key_id
ALIYUN_ACCESS_KEY_SECRET=your_access_key_secret

# DeepSeek API配置
DEEPSEEK_API_KEY=your_deepseek_api_key

# 微信小程序配置
WECHAT_APP_ID=your_wechat_app_id
WECHAT_APP_SECRET=your_wechat_app_secret
```

### 3. 安装依赖

```bash
# 使用 Make
make deps

# 或者直接使用 Go
cd backend && go mod download
```

### 4. 启动开发环境

#### 方式一：直接运行（推荐开发时使用）

```bash
# 使用 Make
make dev

# 或者直接使用 Go
cd backend && go run main.go
```

#### 方式二：Docker Compose（推荐测试时使用）

```bash
# 使用 Make
make up

# 或者直接使用 Docker Compose
docker-compose up -d
```

### 5. 验证服务

```bash
# 健康检查
curl http://localhost:8080/health

# 或使用 Make
make health
```

## 开发指南

### 项目结构

```
.
├── backend/                 # Go后端代码
│   ├── internal/            # 内部包
│   │   ├── config/         # 配置管理
│   │   ├── handlers/       # HTTP处理器
│   │   ├── middleware/     # 中间件
│   │   ├── models/         # 数据模型
│   │   ├── services/       # 业务逻辑
│   │   └── utils/          # 工具函数
│   ├── main.go             # 程序入口
│   ├── go.mod              # Go模块文件
│   └── Dockerfile          # Docker构建文件
├── nginx/                   # Nginx配置
├── .vscode/                # VS Code配置
├── docker-compose.yml      # Docker Compose配置
├── Makefile               # Make命令
└── README.md              # 项目说明
```

### 常用命令

```bash
# 开发
make dev                    # 启动开发服务器
make dev-watch             # 启动热重载开发服务器

# 构建
make build                 # 构建Go应用
make docker-build          # 构建Docker镜像

# 测试
make test                  # 运行测试
make test-coverage         # 运行测试并生成覆盖率报告

# 代码质量
make lint                  # 代码检查
make fmt                   # 格式化代码

# Docker
make up                    # 启动所有服务
make down                  # 停止所有服务
make logs                  # 查看日志

# 工具
make install-tools         # 安装开发工具
make clean                 # 清理构建文件
```

### VS Code 开发

项目已配置好VS Code开发环境：

1. 打开项目文件夹
2. 安装推荐的扩展（会自动提示）
3. 使用 `F5` 启动调试
4. 使用 `Ctrl+Shift+P` 运行任务

### API 文档

启动服务后，API文档将在以下地址可用：

- 开发环境：http://localhost:8080/docs
- 健康检查：http://localhost:8080/health

### 环境变量说明

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `SERVER_PORT` | 服务器端口 | 8080 |
| `GIN_MODE` | Gin运行模式 | debug |
| `LOG_LEVEL` | 日志级别 | debug |
| `ALIYUN_ACCESS_KEY_ID` | 阿里云访问密钥ID | - |
| `ALIYUN_ACCESS_KEY_SECRET` | 阿里云访问密钥 | - |
| `DEEPSEEK_API_KEY` | DeepSeek API密钥 | - |
| `WECHAT_APP_ID` | 微信小程序AppID | - |
| `WECHAT_APP_SECRET` | 微信小程序密钥 | - |

## 部署

### 生产环境部署

1. 配置生产环境变量：
   ```bash
   cp .env.production .env
   # 编辑 .env 文件，填入生产环境配置
   ```

2. 构建和部署：
   ```bash
   make deploy
   ```

3. 启动服务：
   ```bash
   docker-compose -f docker-compose.yml up -d
   ```

### Docker 部署

```bash
# 构建镜像
docker build -t ai-meeting-notes:latest ./backend

# 运行容器
docker run -d \
  --name ai-meeting-notes \
  -p 8080:8080 \
  --env-file .env.production \
  ai-meeting-notes:latest
```

## 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 联系方式

如有问题或建议，请通过以下方式联系：

- 提交 Issue
- 发送邮件到：[your-email@example.com]

## 更新日志

### v1.0.0 (2024-01-XX)

- ✨ 初始版本发布
- 🎤 集成阿里云语音识别
- 🤖 集成DeepSeek AI分析
- 📱 支持微信小程序API
- 🐳 Docker容器化支持
- 🔧 完整的开发环境配置
