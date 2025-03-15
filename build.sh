#!/bin/bash

# 提示用户输入 KMI
read -p "请输入你的 KMI，例如 android15-6.6: " KMI

# 判断 KMI 版本并执行构建
if [[ "$KMI" == *"android12"* || "$KMI" == *"android13"* ]]; then
    LTO=thin BUILD_CONFIG=common/build.config.gki.aarch64 build/build.sh
else
    LTO=thin BUILD_CONFIG=common/build.config.gki.aarch64 build/build.sh
fi