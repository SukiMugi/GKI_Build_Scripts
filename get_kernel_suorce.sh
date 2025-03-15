#!/bin/bash

# 提示用户输入 KMI
read -p "请输入你的 KMI，例如 android15-6.6: " KMI
# 提示用户输入内核安全补丁日期
read -p "请输入你想要的内核安全补丁日期，例如 2025-03: " PATCH_DATE

# 组合目录名称
KERNEL_DIR="${KMI}-${PATCH_DATE}"

# 删除旧目录，创建目录并进入
rm rf "$KERNEL_DIR"
mkdir "$KERNEL_DIR" && cd "$KERNEL_DIR"

# 更新软件包并安装必要的软件
sudo apt update && sudo apt install repo vim wget default-jdk git -y

# 配置 Git 用户信息
git config --global user.email "example@example.com"
git config --global user.name "example"

# 初始化 repo 并同步代码
repo init --depth=1 --u https://android.googlesource.com/kernel/manifest -b common-${KMI}-${PATCH_DATE} --repo-rev=v2.16
repo --trace sync -c -j$(nproc --all) --no-tags --fail-fast

