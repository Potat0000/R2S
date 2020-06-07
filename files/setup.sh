#!/bin/sh

setup_ssid()
{
    local r=$1

    if ! uci show wireless.${r} >/dev/null 2>&1; then
        return
    fi

    logger "setup.sh: setup $1's ssid"

    uci set wireless.${r}.disabled=0
    uci set wireless.${r}.hwmode='11a'
    uci set wireless.${r}.channel='40'
    uci set wireless.${r}.htmode='HT40'
    uci set wireless.${r}.country='00'
    uci set wireless.${r}.legacy_rates=0
    uci set wireless.${r}.noscan=1     # Force 40MHz
    uci set wireless.default_${r}.wps_pushbutton=0

    wlan_path=/sys/devices/`uci get wireless.${r}.path`
    wlan_path=`find ${wlan_path} -name wlan* | tail -n 1`
    local default_name=FriendlyWrt-`cat ${wlan_path}/address`
    if [ "`uci get wireless.default_${r}.ssid`" == "${default_name}" ]; then
        uci set wireless.default_${r}.ssid="`uci get system.@system[0].hostname`"
        uci set wireless.default_${r}.encryption='none'
    fi

    uci commit
}

logger "/root/setup.sh running"

WIFI_NUM=`find /sys/class/net/ -name wlan* | wc -l`
if [ ${WIFI_NUM} -gt 0 ]; then

    # make sure lan interface exist
    if [ -z "`uci get network.lan`" ]; then
        uci batch <<EOF
set network.lan='interface'
set network.lan.type='bridge'
set network.lan.proto='static'
set network.lan.ipaddr='192.168.2.1'
set network.lan.netmask='255.255.255.0'
set network.lan.ip6assign='60'
EOF
    fi

    # update /etc/config/wireless
    for i in `seq 0 ${WIFI_NUM}`; do
        setup_ssid radio${i}
    done
fi

# fix netdata issue
[ -d /usr/share/netdata/web ] && chown -R root:root /usr/share/netdata/web

grep -qF 'songchenwen.com' /etc/opkg/customfeeds.conf || echo 'src/gz songchenwen https://nanopi-r2s-opkg-feeds.songchenwen.com/packages' >> /etc/opkg/customfeeds.conf
sed -i '/scw/d' /etc/opkg/distfeeds.conf
sed -i '/rk3328/d' /etc/opkg/distfeeds.conf
sed -i 's/openwrt.proxy.ustclug.org/downloads.openwrt.org/g' /etc/opkg/distfeeds.conf

sed -i "/update every = /c \\\tupdate every = 1\n\thistory = 86400" /etc/netdata/netdata.conf
sed -i 's/charts.d = no/charts.d = yes/' /etc/netdata/netdata.conf
cp /usr/lib/netdata/conf.d/charts.d.conf /etc/netdata/
echo 'temp=yes' >> /etc/netdata/charts.d.conf
echo 'freq=yes' >> /etc/netdata/charts.d.conf

logger "setup.sh: restart services"
/etc/init.d/led restart
/etc/init.d/network restart
/etc/init.d/dnsmasq restart
/etc/init.d/netdata restart

/usr/bin/check_net

sed -i '/exit/i\for i in /sys/class/leds/* ; do echo 0 > "$i"/brightness ; done' etc/rc.local

logger "setup.sh: done"
