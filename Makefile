# AI Meeting Notes API - Makefile

# 变量定义
APP_NAME := ai-meeting-notes
DOCKER_IMAGE := $(APP_NAME):latest
DOCKER_COMPOSE_FILE := docker-compose.yml
BACKEND_DIR := ./backend
GO_FILES := $(shell find $(BACKEND_DIR) -name '*.go' -type f)

# 默认目标
.DEFAULT_GOAL := help

# 帮助信息
.PHONY: help
help: ## 显示帮助信息
	@echo "AI Meeting Notes API - 可用命令:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# 开发环境
.PHONY: dev
dev: ## 启动开发环境
	@echo "启动开发环境..."
	cd $(BACKEND_DIR) && go run main.go

.PHONY: dev-watch
dev-watch: ## 启动开发环境（热重载）
	@echo "启动开发环境（热重载）..."
	@if command -v air > /dev/null; then \
		cd $(BACKEND_DIR) && air; \
	else \
		echo "请先安装 air: go install github.com/cosmtrek/air@latest"; \
	fi

# 构建
.PHONY: build
build: ## 构建Go应用
	@echo "构建Go应用..."
	cd $(BACKEND_DIR) && go build -o ../bin/$(APP_NAME) main.go

.PHONY: build-linux
build-linux: ## 构建Linux版本
	@echo "构建Linux版本..."
	cd $(BACKEND_DIR) && GOOS=linux GOARCH=amd64 go build -o ../bin/$(APP_NAME)-linux main.go

# 测试
.PHONY: test
test: ## 运行测试
	@echo "运行测试..."
	cd $(BACKEND_DIR) && go test -v -race ./...

.PHONY: test-coverage
test-coverage: ## 运行测试并生成覆盖率报告
	@echo "运行测试并生成覆盖率报告..."
	cd $(BACKEND_DIR) && go test -v -race -coverprofile=coverage.out ./...
	cd $(BACKEND_DIR) && go tool cover -html=coverage.out -o coverage.html
	@echo "覆盖率报告已生成: backend/coverage.html"

# 代码质量
.PHONY: lint
lint: ## 运行代码检查
	@echo "运行代码检查..."
	@if command -v golangci-lint > /dev/null; then \
		cd $(BACKEND_DIR) && golangci-lint run --fast; \
	else \
		echo "请先安装 golangci-lint"; \
	fi

.PHONY: fmt
fmt: ## 格式化代码
	@echo "格式化代码..."
	cd $(BACKEND_DIR) && go fmt ./...
	cd $(BACKEND_DIR) && goimports -w .

.PHONY: vet
vet: ## 运行go vet
	@echo "运行go vet..."
	cd $(BACKEND_DIR) && go vet ./...

# Docker
.PHONY: docker-build
docker-build: ## 构建Docker镜像
	@echo "构建Docker镜像..."
	docker build -t $(DOCKER_IMAGE) $(BACKEND_DIR)

.PHONY: docker-run
docker-run: ## 运行Docker容器
	@echo "运行Docker容器..."
	docker run -p 8080:8080 --env-file .env.development $(DOCKER_IMAGE)

# Docker Compose
.PHONY: up
up: ## 启动所有服务
	@echo "启动所有服务..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

.PHONY: down
down: ## 停止所有服务
	@echo "停止所有服务..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) down

.PHONY: logs
logs: ## 查看服务日志
	@echo "查看服务日志..."
	docker-compose -f $(DOCKER_COMPOSE_FILE) logs -f

.PHONY: restart
restart: down up ## 重启所有服务

# 依赖管理
.PHONY: deps
deps: ## 安装依赖
	@echo "安装Go依赖..."
	cd $(BACKEND_DIR) && go mod download
	cd $(BACKEND_DIR) && go mod tidy

.PHONY: deps-update
deps-update: ## 更新依赖
	@echo "更新Go依赖..."
	cd $(BACKEND_DIR) && go get -u ./...
	cd $(BACKEND_DIR) && go mod tidy

# 清理
.PHONY: clean
clean: ## 清理构建文件
	@echo "清理构建文件..."
	rm -rf bin/
	rm -rf $(BACKEND_DIR)/coverage.out
	rm -rf $(BACKEND_DIR)/coverage.html
	docker system prune -f

# 初始化
.PHONY: init
init: ## 初始化开发环境
	@echo "初始化开发环境..."
	mkdir -p bin logs
	cd $(BACKEND_DIR) && go mod download
	@echo "开发环境初始化完成！"

# 健康检查
.PHONY: health
health: ## 检查服务健康状态
	@echo "检查服务健康状态..."
	@curl -f http://localhost:8080/health || echo "服务未运行"

# 生产部署
.PHONY: deploy
deploy: build-linux docker-build ## 准备生产部署
	@echo "生产部署准备完成"

# 开发工具安装
.PHONY: install-tools
install-tools: ## 安装开发工具
	@echo "安装开发工具..."
	go install github.com/cosmtrek/air@latest
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	go install golang.org/x/tools/cmd/goimports@latest
	@echo "开发工具安装完成"
