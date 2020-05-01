# NanoPi R2S OpenWrt 固件自动编译

### 发布地址

https://github.com/gyj1109/R2S/releases

(下载zip包之后解压出里面的.img固件包刷入sd卡，切勿直接刷写zip包！)

### 登录地址

- 地址：192.168.2.1
- 密码：password

### 用法

1. Fork 到自己的账号下
2. 进入 Actions 界面，启用 Github Actions(**必须要先启用**)
3. 在 [Github Token](https://github.com/settings/tokens) 页面申请 Token (需含有`repo`权限)
4. 在项目 Settings - Secrets 界面，添加一个 Secret 命名为`sec_token`，内容为上一步申请的 Token
5. 在 `config.seed` 文件中，自定义所需要的软件包
  - 比如需要 luci-app-samba， 那么只要在文件中添加一行 CONFIG_PACKAGE_luci-app-samba=y

*按此方法Fork后编译，**无需**修改用户名，自动按**您的用户名**生成ROM*

### 感谢

* [songchenwen/nanopi-r2s](https://github.com/songchenwen/nanopi-r2s)
* [klever1988/nanopi-openwrt](https://github.com/klever1988/nanopi-openwrt)
* [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
* [friendlyarm/friendlywrt](https://github.com/friendlyarm/friendlywrt)
