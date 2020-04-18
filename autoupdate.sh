#!/bin/sh

cd /mnt/mmcblk0p2
rm -rf artifact R2S*.zip FriendlyWrt*img*
wget https://glare.now.sh/gyj1109/R2S/R2S-Gyj1109-
if [ -f /mnt/mmcblk0p2/R2S*.zip ]; then
	echo -e '\e[92m固件已下载，准备解压\e[0m'
else
	echo -e '\e[91m下载失败\e[0m'
	exit 1
fi
unzip -d artifact R2S*.zip
rm R2S*.zip
if [ -f /mnt/mmcblk0p2/artifact/FriendlyWrt*.img.gz ]; then
	pv /mnt/mmcblk0p2/artifact/FriendlyWrt*.img.gz | gunzip -dc > FriendlyWrt.img
	echo -e '\e[92m准备解压镜像文件\e[0m'
fi
lodev=$(losetup -f)
mkdir /mnt/img
losetup -o 100663296 $lodev /mnt/mmcblk0p2/FriendlyWrt.img
mount $lodev /mnt/img
echo -e '\e[92m解压已完成，准备编辑镜像文件，写入备份信息\e[0m'
cd /mnt/img
sysupgrade -b /mnt/img/back.tar.gz
tar zxf back.tar.gz
echo -e '\e[92m备份文件已经写入，移除挂载\e[0m'
rm back.tar.gz
cd /tmp
umount /mnt/img
losetup -d $lodev
echo -e '\e[92m准备重新打包\e[0m'
zstdmt /mnt/mmcblk0p2/FriendlyWrt.img -o /tmp/FriendlyWrtupdate.img.zst
echo -e '\e[92m打包完毕，准备刷机\e[0m'
if [ -f /tmp/FriendlyWrtupdate.img.zst ]; then
	echo 1 > /proc/sys/kernel/sysrq
	echo u > /proc/sysrq-trigger || umount /
	pv /tmp/FriendlyWrtupdate.img.zst | zstdcat | dd of=/dev/mmcblk0 conv=fsync
	echo -e '\e[92m刷机完毕，正在重启...\e[0m'
	echo b > /proc/sysrq-trigger
fi
