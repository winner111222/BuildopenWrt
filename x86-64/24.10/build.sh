#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting 99-custom.sh at $(date)" >> $LOGFILE
echo "编译固件大小为: $PROFILE MB"
echo "Include Docker: $INCLUDE_DOCKER"

echo "Create pppoe-settings"
mkdir -p  /home/build/immortalwrt/files/etc/config

# 创建pppoe配置文件 yml传入环境变量ENABLE_PPPOE等 写入配置文件 供99-custom.sh读取
cat << EOF > /home/build/immortalwrt/files/etc/config/pppoe-settings
enable_pppoe=${ENABLE_PPPOE}
pppoe_account=${PPPOE_ACCOUNT}
pppoe_password=${PPPOE_PASSWORD}
EOF

echo "cat pppoe-settings"
cat /home/build/immortalwrt/files/etc/config/pppoe-settings
# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - 开始编译..."



# 定义所需安装的包列表 下列插件你都可以自行删减
PACKAGES=""
PACKAGES="$PACKAGES curl"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES base-files
PACKAGES="$PACKAGES block-mount
PACKAGES="$PACKAGES ca-bundle
PACKAGES="$PACKAGES default-settings-chn
PACKAGES="$PACKAGES dnsmasq-full
PACKAGES="$PACKAGES dropbear
PACKAGES="$PACKAGES fdisk
PACKAGES="$PACKAGES firewall4
PACKAGES="$PACKAGES fstools
PACKAGES="$PACKAGES grub2-bios-setup
PACKAGES="$PACKAGES i915-firmware-dmc
PACKAGES="$PACKAGES kmod-8139cp
PACKAGES="$PACKAGES kmod-8139too
PACKAGES="$PACKAGES kmod-button-hotplug
PACKAGES="$PACKAGES kmod-e1000e
PACKAGES="$PACKAGES kmod-fs-f2fs
PACKAGES="$PACKAGES kmod-i40e
PACKAGES="$PACKAGES kmod-igb
PACKAGES="$PACKAGES kmod-igbvf
PACKAGES="$PACKAGES kmod-igc
PACKAGES="$PACKAGES kmod-ixgbe
PACKAGES="$PACKAGES kmod-ixgbevf
PACKAGES="$PACKAGES kmod-nf-nathelper
PACKAGES="$PACKAGES kmod-nf-nathelper-extra
PACKAGES="$PACKAGES kmod-nft-offload
PACKAGES="$PACKAGES kmod-pcnet32
PACKAGES="$PACKAGES kmod-r8101
PACKAGES="$PACKAGES kmod-r8125
PACKAGES="$PACKAGES kmod-r8126
PACKAGES="$PACKAGES kmod-r8168
PACKAGES="$PACKAGES kmod-tulip
PACKAGES="$PACKAGES kmod-usb-hid
PACKAGES="$PACKAGES kmod-usb-net
PACKAGES="$PACKAGES kmod-usb-net-asix
PACKAGES="$PACKAGES kmod-usb-net-asix-ax88179
PACKAGES="$PACKAGES kmod-usb-net-rtl8150
PACKAGES="$PACKAGES kmod-usb-net-rtl8152-vendor
PACKAGES="$PACKAGES kmod-vmxnet3
PACKAGES="$PACKAGES libc
PACKAGES="$PACKAGES libgcc
PACKAGES="$PACKAGES libustream-openssl
PACKAGES="$PACKAGES logd
PACKAGES="$PACKAGES luci-app-package-manager
PACKAGES="$PACKAGES luci-compat
PACKAGES="$PACKAGES luci-lib-base
PACKAGES="$PACKAGES luci-lib-ipkg
PACKAGES="$PACKAGES luci-light
PACKAGES="$PACKAGES mkf2fs
PACKAGES="$PACKAGES mtd
PACKAGES="$PACKAGES netifd
PACKAGES="$PACKAGES nftables
PACKAGES="$PACKAGES odhcp6c
PACKAGES="$PACKAGES odhcpd-ipv6only
PACKAGES="$PACKAGES opkg
PACKAGES="$PACKAGES partx-utils
PACKAGES="$PACKAGES ppp
PACKAGES="$PACKAGES ppp-mod-pppoe
PACKAGES="$PACKAGES procd-ujail
PACKAGES="$PACKAGES uci
PACKAGES="$PACKAGES uclient-fetch
PACKAGES="$PACKAGES urandom-seed
PACKAGES="$PACKAGES urngd
PACKAGES="$PACKAGES kmod-amazon-ena
PACKAGES="$PACKAGES kmod-amd-xgbe
PACKAGES="$PACKAGES kmod-bnx2
PACKAGES="$PACKAGES kmod-e1000
PACKAGES="$PACKAGES kmod-dwmac-intel
PACKAGES="$PACKAGES kmod-forcedeth
PACKAGES="$PACKAGES kmod-fs-vfat
PACKAGES="$PACKAGES kmod-tg3
PACKAGES="$PACKAGES kmod-drm-i915
PACKAGES="$PACKAGES luci-i18n-autoreboot-zh-cn
PACKAGES="$PACKAGES luci-theme-argon
PACKAGES="$PACKAGES grub2
PACKAGES="$PACKAGES grub2-efi
PACKAGES="$PACKAGES ip6tables-extra
PACKAGES="$PACKAGES ip6tables-mod-nat
PACKAGES="$PACKAGES kmod-lib-lzo
PACKAGES="$PACKAGES zoneinfo-asia
PACKAGES="$PACKAGES luci-app-ipsec-vpnd
# 服务——FileBrowser 用户名admin 密码admin
PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn"
PACKAGES="$PACKAGES luci-app-argon-config"
PACKAGES="$PACKAGES luci-i18n-argon-config-zh-cn"
#24.10
PACKAGES="$PACKAGES luci-i18n-passwall-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"
PACKAGES="$PACKAGES luci-i18n-ddns-zh-cn
PACKAGES="$PACKAGES ddns-scripts-dnspod
PACKAGES="$PACKAGES luci-i18n-vlmcsd-zh-cn
PACKAGES="$PACKAGES luci-i18n-msd_lite-zh-cn
PACKAGES="$PACKAGES luci-i18n-uhttpd-zh-cn
PACKAGES="$PACKAGES luci-i18n-upnp-zh-cn
PACKAGES="$PACKAGES luci-i18n-attendedsysupgrade-zh-cn
PACKAGES="$PACKAGES luci-i18n-ddns-go-zh-cn
PACKAGES="$PACKAGES openssh-sftp-server
PACKAGES="$PACKAGES luci-app-openclash
PACKAGES="$PACKAGES luci-app-ddns
PACKAGES="$PACKAGES luci-app-ddns-go
PACKAGES="$PACKAGES luci-app-docker
PACKAGES="$PACKAGES luci-app-dockerman
PACKAGES="$PACKAGES luci-app-openvpn
PACKAGES="$PACKAGES luci-app-openvpn-server

# 增加几个必备组件 方便用户安装iStore
PACKAGES="$PACKAGES fdisk"
PACKAGES="$PACKAGES script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"

# 判断是否需要编译 Docker 插件
if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
    echo "Adding package: luci-i18n-dockerman-zh-cn"
fi

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE="generic" PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$PROFILE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
