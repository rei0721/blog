---
title: vue指令安装时参数带-d与不带-d
published: 2025-09-12
description: vue指令安装时参数带-d与不带-d
image: ''
tags: [vue,vue-cli,vue-cli-args]
category: vue
draft: false 
lang: zh-CN
---


## 📌 `pnpm add` 的两个常见参数

| 命令                              | 说明                                       |
| ------------------------------- | ---------------------------------------- |
| `pnpm add 包名`                   | 安装到 **生产依赖 (dependencies)**，打包上线时也会带上    |
| `pnpm add -D 包名` 或 `--save-dev` | 安装到 **开发依赖 (devDependencies)**，只在开发/构建时用 |

---

## 📦 为什么有些包用 `-D`，有些不用？

这取决于**这个包是否会在「运行时」被用户使用**：

---

### 🟢 运行时依赖（不加 `-D`）

> 会在项目实际运行中被使用

这些库的代码会被打进你的最终应用里：

* `pinia`：状态管理，运行时使用
* `@pinia/nuxt`：Nuxt 模块，在 Nuxt 启动时注入运行
* `pinia-plugin-persistedstate`：在浏览器中持久化 store，运行时执行

所以：

```bash
pnpm add pinia @pinia/nuxt pinia-plugin-persistedstate
```

---

### 🟡 开发时依赖（要 `-D`）

> 只在开发、构建、编译阶段用，不会打包进产物

* `unocss` / `@unocss/nuxt`：是原子化 CSS 引擎，只在开发构建时生成样式，运行时不会执行 JS 逻辑

所以：

```bash
pnpm add -D unocss @unocss/nuxt
```

---

## ✅ 总结记忆法

* **运行时使用 → 不加 `-D`**
* **只在开发构建用 → 加 `-D`**