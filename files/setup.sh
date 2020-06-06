#!/bin/sh

setup_ssid()
{
    local r=$1

    if ! uci show wireless.${r} >/dev/null 2>&1; then
        return
    fi

    logger "${TAG}: setup $1's ssid"
    wlan_path=/sys/devices/`uci get wireless.${r}.path`
    wlan_path=`find ${wlan_path} -name wlan* | tail -n 1`

    local dev_path=/sys/devices/`uci get wireless.${r}.path`

    if [ -e "${dev_path}/../idVendor" -a -e "${dev_path}/../idProduct" ]; then
	    idVendor=`cat ${dev_path}/../idVendor`
	    idProduct=`cat ${dev_path}/../idProduct`

        # onboard wifi
        # t4: 0x02d0:0x4356
        # r2: 0x02d0:0xa9bf
        if [ "x${idVendor}:${idProduct}" = "x0x02d0:0x4356" ] \
                || [ "x${idVendor}:${idProduct}" = "x0x02d0:0xa9bf" ]; then
                uci set wireless.${r}.hwmode='11a'
                uci set wireless.${r}.channel='40'
                uci set wireless.${r}.htmode='HT40'
                uci set wireless.${r}.country='AU'
        fi
    fi

    uci set wireless.${r}.disabled=0
    uci set wireless.default_${r}.ssid=`uci get system.@system[0].hostname`
    uci set wireless.default_${r}.encryption=psk2
    uci set wireless.default_${r}.key=password
    uci commit
}

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
    NEED_RESTART_SERVICE=1
fi

/etc/init.d/led restart

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
/etc/init.d/netdata restart

/usr/bin/check_net
