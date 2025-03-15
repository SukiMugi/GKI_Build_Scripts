#!/bin/bash

# 提示用户输入内核后缀名（可选）
read -p "请输入你想要的内核后缀名（直接回车将使用默认值）: " KERNEL_SUFFIX

# 去除不必要的校验，保护等
rm -rf ./common/android/abi_gki_protected_exports_*
sed -i 's/check_defconfig//' ./common/build.config.gki

# 去除dirty，maybe等字样
sed -i 's/-dirty//' ./common/scripts/setlocalversion
sed -i "/stable_scmversion_cmd/s/-maybe-dirty//g" ./build/kernel/kleaf/impl/stamp.bzl

# 自定义内核后缀名（仅在用户输入了后缀名时执行）
if [[ -n "$KERNEL_SUFFIX" ]]; then
    sed -i "\$s|echo \"\$res\"|echo \"-${KERNEL_SUFFIX}\"|" ./common/scripts/setlocalversion
    sed -i "s/\${file_localversion}\${config_localversion}\${LOCALVERSION}\${scm_version}/-${KERNEL_SUFFIX}/g" ./common/scripts/setlocalversion
fi