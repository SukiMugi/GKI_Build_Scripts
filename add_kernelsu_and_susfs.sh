#!/bin/bash

# 还原内核源码
repo --trace sync -c -j$(nproc --all) --no-tags --fail-fast
rm -rf kernel_patches
rm -rf SUSFS
# 提示用户输入 KMI
read -p "请输入你的 KMI，例如 android15-6.6: " KMI

# 克隆 SUSFS 和其他补丁
git clone --recursive https://gitlab.com/simonpunk/susfs4ksu -b gki-${KMI} SUSFS --depth=1
git clone https://github.com/TheWildJames/kernel_patches.git --depth=1

# 复制补丁和相关文件
cp ./kernel_patches/69_hide_stuff.patch ./common
cp ./kernel_patches/hooks/new_hooks.patch ./common
cp ./SUSFS/kernel_patches/50_add_susfs_in_gki-${KMI}.patch ./common/
cp ./SUSFS/kernel_patches/fs/* ./common/fs/
cp ./SUSFS/kernel_patches/include/linux/* ./common/include/linux/

# 应用补丁
cd common
patch -p1 < 50_add_susfs_in_gki-${KMI}.patch
patch -p1 -F 3 < 69_hide_stuff.patch
patch -p1 -F 3 < new_hooks.patch

# 添加SukiSU
curl -LSs "https://raw.githubusercontent.com/ShirkNeko/KernelSU/refs/heads/susfs-dev/kernel/setup.sh" | bash -s susfs-dev

# 修改 gki_defconfig，添加 KSU 相关配置
cat >> ./arch/arm64/configs/gki_defconfig <<EOF
CONFIG_KSU=y
CONFIG_KSU_WITH_KPROBES=n
CONFIG_KSU_VFS=y
CONFIG_KSU_SUSFS=y
CONFIG_KSU_SUSFS_SUS_SU=n
CONFIG_KSU_SUSFS_HAS_MAGIC_MOUNT=y
CONFIG_KSU_SUSFS_SUS_PATH=y
CONFIG_KSU_SUSFS_SUS_MOUNT=y
CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT=y
CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT=y
CONFIG_KSU_SUSFS_SUS_KSTAT=n
CONFIG_KSU_SUSFS_SUS_OVERLAYFS=n
CONFIG_KSU_SUSFS_TRY_UMOUNT=y
CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT=y
CONFIG_KSU_SUSFS_SPOOF_UNAME=y
CONFIG_KSU_SUSFS_ENABLE_LOG=n
CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y
CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y
CONFIG_KSU_SUSFS_OPEN_REDIRECT=y
EOF

# 退回上级目录
cd ..