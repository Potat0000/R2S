#!/bin/sh

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

mv /root/screen/screen.init.d /etc/init.d/screen
chmod +x /root/screen/screen
chmod +x /etc/init.d/screen

/usr/bin/check_net

if [ `grep -c "/sys/class/leds/" /etc/rc.local` -eq '0' ]; then
    sed -i '/exit/i\for i in /sys/class/leds/* ; do echo 0 > "$i"/brightness ; done' /etc/rc.local
fi

if [ `grep -c "/etc/openclash/config" /etc/sysupgrade.conf` -eq '0' ]; then
    echo "/etc/openclash/config/" >> /etc/sysupgrade.conf
fi

logger "setup.sh: done"
