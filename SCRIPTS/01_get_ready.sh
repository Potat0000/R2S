#!/bin/bash
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
patch -p1 < ../PATCH/R2S.patch
cd target/linux/rockchip
mkdir patches-5.4
cp -rf ../../../../PATCH/000-add-nanopi-r2s-support.patch patches-5.4/000-add-nanopi-r2s-support.patch
cd ..
cd ..
cd ..
exit 0
