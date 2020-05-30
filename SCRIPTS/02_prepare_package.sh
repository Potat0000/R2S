#!/bin/bash
clear
rm -f ./feeds.conf.default
wget https://raw.githubusercontent.com/openwrt/openwrt/openwrt-19.07/feeds.conf.default
#remove annoying snapshot tag
sed -i 's,SNAPSHOT,,g' include/version.mk
sed -i 's,snapshots,,g' package/base-files/image-config.in
#更新feed
./scripts/feeds update -a && ./scripts/feeds install -a
#arpbind
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-arpbind package/lean/luci-app-arpbind
#O3
sed -i 's/Os/O3/g' include/target.mk
sed -i 's/O2/O3/g' ./rules.mk
#Adbyby
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-adbyby-plus package/lean/luci-app-adbyby-plus
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/adbyby package/lean/coremark/adbyby
#AutoCore
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lean/autocore package/lean/autocore
sed -i "s,@TARGET_x86 ,,g" package/lean/autocore/Makefile
rm -rf ./package/lean/autocore/files/cpuinfo
wget -P package/lean/autocore/files https://raw.githubusercontent.com/QiuSimons/Others/master/cpuinfo
rm -rf ./package/lean/autocore/files/rpcd_10_system.js
wget -P package/lean/autocore/files https://raw.githubusercontent.com/QiuSimons/Others/master/rpcd_10_system.js
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lean/coremark package/lean/coremark
sed -i 's,-DMULTIT,-Ofast -DMULTIT,g' package/lean/coremark/Makefile
#R2S刷机
svn co https://github.com/songchenwen/nanopi-r2s/trunk/luci-app-r2sflasher package/new/luci-app-r2sflasher
sed -i 's/"luci.fs"/"luci.sys".net/g' package/new/luci-app-r2sflasher/luasrc/model/cbi/r2sflasher/flash.lua
#登录保护
git clone -b openwrt-19.07 --single-branch https://github.com/NateLol/luci-app-beardropper package/new/luci-app-beardropper
sed -i 's/"luci.fs"/"luci.sys".net/g' package/new/luci-app-beardropper/files/luasrc/model/cbi/bearDropper/setting.lua
#迅雷快鸟
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-xlnetacc package/lean/luci-app-xlnetacc
#DDNS
rm -rf ./feeds/packages/net/ddns-scripts
rm -rf ./feeds/luci/applications/luci-app-ddns
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_aliyun package/lean/ddns-scripts_aliyun
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_dnspod package/lean/ddns-scripts_dnspod
svn co https://github.com/openwrt/packages/branches/openwrt-18.06/net/ddns-scripts feeds/packages/net/ddns-scripts
svn co https://github.com/openwrt/luci/branches/openwrt-18.06/applications/luci-app-ddns feeds/luci/applications/luci-app-ddns
#Pandownload
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/lean/pandownload-fake-server package/lean/pandownload-fake-server
#网易云解锁
git clone -b master --single-branch https://github.com/project-openwrt/luci-app-unblockneteasemusic package/new/UnblockNeteaseMusic
#irqbalance
sed -i 's/0/1/g' feeds/packages/utils/irqbalance/files/irqbalance.config
#定时重启
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-autoreboot package/lean/luci-app-autoreboot
#主题
git clone -b master --single-branch https://github.com/QiuSimons/Luci-argon-19 package/new/luci-theme-argon
#git clone -b master --single-branch https://github.com/jerrykuku/luci-theme-argon package/new/luci-theme-argon
#AdGuard
git clone -b master --single-branch https://github.com/rufengsuixing/luci-app-adguardhome package/new/luci-app-adguardhome
#SSRP
svn co https://github.com/fw876/helloworld/trunk/luci-app-ssr-plus package/lean/luci-app-ssr-plus
rm -rf ./package/lean/luci-app-ssr-plus/luasrc/view/shadowsocksr/ssrurl.htm
wget -P package/lean/luci-app-ssr-plus/luasrc/view/shadowsocksr https://raw.githubusercontent.com/QiuSimons/Others/master/luci-app-ssr-plus/luasrc/view/shadowsocksr/ssrurl.htm
#rm -rf ./package/lean/luci-app-ssr-plus/root/etc/init.d/shadowsocksr
#wget -P package/lean/luci-app-ssr-plus/root/etc/init.d https://raw.githubusercontent.com/QiuSimons/Others/master/luci-app-ssr-plus-177-1/root/etc/init.d/shadowsocksr
#SSRP依赖
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/net/shadowsocks-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/shadowsocksr-libev package/lean/shadowsocksr-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/pdnsd-alt package/lean/pdnsd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/v2ray package/lean/v2ray
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/kcptun package/lean/kcptun
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/v2ray-plugin package/lean/v2ray-plugin
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/srelay package/lean/srelay
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/microsocks package/lean/microsocks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dns2socks package/lean/dns2socks
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/redsocks2 package/lean/redsocks2
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/proxychains-ng package/lean/proxychains-ng
git clone -b master --single-branch https://github.com/pexcn/openwrt-ipt2socks package/lean/ipt2socks
#svn co https://github.com/QiuSimons/Others/trunk/ipt2socks-1-1 package/lean/ipt2socks
git clone -b master --single-branch https://github.com/aa65535/openwrt-simple-obfs package/lean/simple-obfs
svn co https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/lean/shadowsocks-libev
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/trojan package/lean/trojan
svn co https://github.com/project-openwrt/openwrt/trunk/package/lean/tcpping package/lean/tcpping
#订阅转换
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/subconverter package/new/subconverter
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/jpcre2 package/new/jpcre2
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ctcgfw/rapidjson package/new/rapidjson
#清理内存
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-ramfree package/lean/luci-app-ramfree
#打印机
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-usb-printer package/lean/luci-app-usb-printer
#流量监视
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-wrtbwmon package/lean/luci-app-wrtbwmon
#流量监管
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-netdata package/lean/luci-app-netdata
#OpenClash
svn co https://github.com/vernesong/OpenClash/branches/master/luci-app-openclash package/new/luci-app-openclash
#SeverChan
git clone -b master --single-branch https://github.com/tty228/luci-app-serverchan package/new/luci-app-serverchan
svn co https://github.com/openwrt/openwrt/branches/openwrt-19.07/package/network/utils/iputils package/network/utils/iputils
#SmartDNS
svn co https://github.com/pymumu/smartdns/trunk/package/openwrt package/new/smartdns/smartdns
svn co https://github.com/project-openwrt/openwrt/branches/openwrt-19.07/package/ntlf9t/luci-app-smartdns package/new/smartdns/luci-app-smartdns
#上网APP过滤
git clone -b master --single-branch https://github.com/destan19/OpenAppFilter package/new/OpenAppFilter
#FullCone补丁
# FullCone
git clone -b master --single-branch https://github.com/QiuSimons/openwrt-fullconenat package/fullconenat
# FireWall Patch
mkdir package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/fullconenat.patch
# Patch LuCI
pushd feeds/luci
wget -O- https://github.com/LGA1150/fullconenat-fw3-patch/raw/master/luci.patch | git apply
popd
# Patch Kernel
pushd target/linux/generic/hack-5.4
wget https://raw.githubusercontent.com/project-openwrt/openwrt/18.06-kernel5.4/target/linux/generic/hack-5.4/952-net-conntrack-events-support-multiple-registrant.patch
popd
#最大连接
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
#翻译
git clone -b master --single-branch https://github.com/QiuSimons/addition-trans-zh package/lean/lean-translate
#生成默认配置及缓存
rm -rf .config
#修正架构
sed -i "s,boardinfo.system,'ARMv8',g" feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
chmod -R 755 ./
exit 0
