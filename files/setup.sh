#!/bin/sh

# fix netdata issue
[ -d /usr/share/netdata/web ] && chown -R root:root /usr/share/netdata/web

grep -qF 'songchenwen.com' /etc/opkg/customfeeds.conf || echo 'src/gz songchenwen https://songchenwen.com/nanopi-r2s-opkg-feeds/packages' >> /etc/opkg/customfeeds.conf
sed -i '/scw/d' /etc/opkg/distfeeds.conf
sed -i '/kenzo/d' /etc/opkg/distfeeds.conf
sed -i '/rk3328/d' /etc/opkg/distfeeds.conf
sed -i 's/openwrt.proxy.ustclug.org/downloads.openwrt.org/g' /etc/opkg/distfeeds.conf

sed -i "/update every = /c \\\tupdate every = 1\n\thistory = 86400" /etc/netdata/netdata.conf
sed -i 's/charts.d = no/charts.d = yes/' /etc/netdata/netdata.conf
cp /usr/lib/netdata/conf.d/charts.d.conf /etc/netdata/
echo 'temp=yes' >> /etc/netdata/charts.d.conf
echo 'freq=yes' >> /etc/netdata/charts.d.conf
/etc/init.d/netdata restart
