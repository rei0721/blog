---
title: Git 发布规范
published: 2026-01-13
description: 'Git 发布规范'
image: ''
tags: [git, 发布规范, semver, conventional commits, git flow]
category: 'git'
draft: false 
lang: ''
---

# Git 发布规范（企业级工程实践）

> 本文介绍一套在中大型项目中被广泛使用的 Git 发布规范，结合
> **Git Flow + Conventional Commits + SemVer**
> 用于构建可维护、可回滚、可自动化发布的软件工程体系。

这套规范适用于：

* Go 后端服务
* 前端 Web 项目
* 基础设施库（RBAC、HTTP Server、Cache、ORM、SDK 等）
* 开源项目

---

## 一、为什么需要发布规范

没有发布规范的项目通常会出现：

* 版本号混乱（v1、v1.1_final、v1_fix）
* 不知道哪些提交已经上线
* 线上 Bug 无法快速回滚
* API 被破坏却无感知

发布规范的目标是：

* 每一次上线都是可追溯的
* 每一个版本都有明确语义
* 自动生成 changelog
* 自动触发 CI/CD

---

## 二、核心组成

本规范由三部分组成：

| 组件                   | 作用    |
| -------------------- | ----- |
| Git Flow             | 分支管理  |
| SemVer               | 版本号规则 |
| Conventional Commits | 提交规范  |

三者结合后，就形成了一套可自动化的发布体系。

---

## 三、分支模型（Git Flow）

标准分支如下：

```
main        # 生产环境代码
develop     # 开发主分支
feature/*   # 功能开发
release/*   # 发版准备
hotfix/*    # 线上紧急修复
```

### 分支职责

| 分支      | 说明          |
| ------- | ----------- |
| main    | 永远是可上线状态    |
| develop | 所有新功能集成     |
| feature | 一个功能一个分支    |
| release | 冻结版本，只修 bug |
| hotfix  | 修复线上问题      |

---

## 四、版本号规则（SemVer）

格式：

```
MAJOR.MINOR.PATCH
```

示例：

```
v1.0.0
v1.2.3
v2.0.0
```

含义：

| 字段    | 含义          |
| ----- | ----------- |
| MAJOR | 不兼容的 API 变更 |
| MINOR | 新功能（兼容）     |
| PATCH | Bug 修复      |

---

## 五、Commit Message 规范

格式：

```
<type>(<scope>): <subject>
```

示例：

```
feat(auth): add jwt refresh token
fix(cache): prevent redis deadlock
refactor(repo): simplify repository layer
```

---

### 常用 type

| type     | 含义     | 影响版本  |
| -------- | ------ | ----- |
| feat     | 新功能    | MINOR |
| fix      | Bug 修复 | PATCH |
| perf     | 性能优化   | PATCH |
| refactor | 重构     | 无     |
| docs     | 文档     | 无     |
| test     | 测试     | 无     |
| build    | 构建系统   | 无     |
| ci       | CI 配置  | 无     |
| chore    | 杂项     | 无     |

---

### 破坏性变更

```
feat(auth)!: change jwt payload structure
```

或

```
BREAKING CHANGE: token format updated
```

这会触发 MAJOR 版本升级。

---

## 六、标准发布流程

### 1. 开发功能

```bash
git checkout develop
git checkout -b feature/login
git commit -m "feat(auth): implement login"
git push
```

---

### 2. 发版冻结

```bash
git checkout develop
git checkout -b release/1.2.0
```

只允许修 bug：

```bash
git commit -m "fix(auth): correct token expiry"
```

---

### 3. 发布到生产

```bash
git checkout main
git merge release/1.2.0
git tag v1.2.0
git push origin main --tags
```

同步回 develop：

```bash
git checkout develop
git merge release/1.2.0
```

---

## 七、线上紧急修复（Hotfix）

```bash
git checkout main
git checkout -b hotfix/1.2.1
git commit -m "fix(cache): avoid nil pointer"
git checkout main
git merge hotfix/1.2.1
git tag v1.2.1
git push --tags
git checkout develop
git merge hotfix/1.2.1
```

---

## 八、自动化发布

使用此规范，可以直接接入：

* semantic-release
* GitHub Actions
* GitLab CI

自动完成：

* 计算版本号
* 生成 CHANGELOG
* 打 tag
* 发布 GitHub Release
* 发布 Go Module / npm 包

---

## 九、结论

> Git 发布规范是区分“写代码”和“做工程”的分水岭。

如果你在做的是：

* API Server
* 基础库
* 框架
* 团队项目

你必须使用这一套规范。
