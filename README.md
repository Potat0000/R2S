# NanoPi R2S OpenWrt 固件自动编译

喜欢记得右上角Star哟！！

### 发布地址

https://github.com/gyj1109/R2S/releases

#### 版本说明

* `SelfUse`版：
  自用版本，包含本人最常用的插件
* `WithFeatures`版：
  在自用版本的基础上增加了更多插件

原则上，Issue中提出需要加入的插件都将并入`WithFeatures`版。

欢迎有能力的朋友修改`config.addon.seed`文件后提出PR！

#### 刷入帮助

* 使用 [balenaEtcher](https://www.balena.io/etcher/) 或直接使用系统升级

* 刷写时需解压出`.img`文件后刷入

### 管理后台

- 地址：192.168.1.1
- 密码：*无*

### Fork方法

1. Fork 到自己的账号下
2. 进入 Actions 界面，启用 Github Actions(**必须要先启用**)
3. 在 [Github Token](https://github.com/settings/tokens) 页面申请 Token (需含有`repo`权限)
4. 在项目 Settings - Secrets 界面，添加一个 Secret 命名为`sec_token`，内容为上一步申请的 Token
5. 在 `config.addon.seed` 文件中，自定义所需要的软件包
    - 比如需要 luci-app-samba， 那么只要在文件中添加一行 CONFIG_PACKAGE_luci-app-samba=y

所有可能的选项均在`env`块中，修改成`true`或`false`来启用或禁用

*按此方法Fork后编译，**无需**修改workflow文件，并将自动按**您的用户名**生成ROM*

### 贡献

欢迎提出各种Issue，包括但不限于：

* 新模块需求
* Fork后编译失败的帮助
* 新的编译选项（及将部分功能设置成可选择性编译）
* 来自其他R2S编译项目的优秀workflow建议
* ……

此外，一个人精力有限。如果有能力，一定要多提PR哦！

### 感谢

* [QiuSimons/R2S-OpenWrt](https://github.com/QiuSimons/R2S-OpenWrt)
* [coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)
* [openwrt/openwrt](https://git.openwrt.org/openwrt/openwrt.git)
