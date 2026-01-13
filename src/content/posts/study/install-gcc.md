---
title: 安装 GCC
published: 2026-01-13
description: '安装 GCC'
image: ''
tags: [gcc, 安装, windows, linux, macos]
category: 'gcc'
draft: false 
lang: ''
---


# 一、Windows 安装 GCC（推荐：MSYS2 / MinGW-w64）

在 Windows 上，真正可用的 GCC 来自 **MinGW-w64**。最干净、可维护性最强的方式是通过 **MSYS2**。

## 1️⃣ 下载 MSYS2

打开：

> [https://www.msys2.org](https://www.msys2.org)

下载 `msys2-x86_64-*.exe` 并安装（一路 Next 即可）

安装完成后，启动：

> **MSYS2 UCRT64** 或 **MSYS2 MinGW64**

---

## 2️⃣ 更新 MSYS2

在 MSYS2 终端中执行：

```bash
pacman -Syu
```

关闭窗口 → 重新打开 MSYS2 → 再执行一次：

```bash
pacman -Syu
```

---

## 3️⃣ 安装 GCC（MinGW-w64 版本）

如果你用的是 **MinGW64 终端**：

```bash
pacman -S mingw-w64-x86_64-gcc
```

如果是 **UCRT64 终端**：

```bash
pacman -S mingw-w64-ucrt-x86_64-gcc
```

---

## 4️⃣ 添加到 Windows PATH

找到安装目录，例如：

```
C:\msys64\mingw64\bin
```

或

```
C:\msys64\ucrt64\bin
```

把它加入 Windows 环境变量 PATH。

然后在 Windows CMD / PowerShell 中测试：

```bash
gcc --version
```

如果输出版本号，说明安装成功。

---

## 5️⃣ 测试 GCC

创建 `test.c`

```c
#include <stdio.h>

int main() {
    printf("GCC works!\n");
    return 0;
}
```

编译并运行：

```bash
gcc test.c -o test
test
```

---

# 二、Linux 安装 GCC

## Ubuntu / Debian

```bash
sudo apt update
sudo apt install build-essential
```

验证：

```bash
gcc --version
```

---

## CentOS / Rocky / Alma

```bash
sudo dnf groupinstall "Development Tools"
```

---

# 三、macOS 安装 GCC（本质是 clang）

macOS 使用的是 LLVM clang，但行为与 gcc 兼容。

```bash
xcode-select --install
```

安装完成后：

```bash
gcc --version
```

---

# 四、你为什么需要 GCC（与你的 Go 开发强相关）

你现在在做 Go 基础设施、Gin、gRPC、Redis、数据库、Nginx 类服务，这些场景中 **GCC 是隐性刚需**：

| 场景                 | 是否需要 GCC |
| ------------------ | -------- |
| cgo                | 必须       |
| sqlite / rocksdb   | 必须       |
| OpenSSL / zlib     | 必须       |
| Kafka / librdkafka | 必须       |
| gin + sqlite       | 必须       |
| 跨平台编译              | 必须       |

如果你要做类似你规划的 **Go HTTP Server / Nginx-like framework / Infra toolkit**，没有 GCC 会大量报错。

---

# 五、不要用这些方案（踩坑提醒）

❌ TDM-GCC
❌ 老版 MinGW
❌ Dev-C++ 内置 GCC
❌ Visual Studio C 编译器（和 GCC ABI 不兼容）

这些都会在 Go + cgo + OpenSSL + SQLite + Kafka 时爆炸。

---

# 六、结论

如果你是 Windows + Go 后端开发者，**唯一正确选择是：**

> MSYS2 + MinGW-w64 GCC

这是企业级 Go 项目在 Windows 上的标准编译环境。
