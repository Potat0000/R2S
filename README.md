# NanoPi R2S OpenWrt 固件自动编译

## 基于 [Dayong Chen Minimal版](https://github.com/klever1988/nanopi-openwrt) 修改

### 发布地址

https://github.com/gyj1109/R2S/releases

(下载zip包之后解压出里面的.img固件包刷入sd卡，切勿直接刷写zip包！)

### 编译方式

本编译方案采用git rebase，把友善FriendlyWrt对OpenWrt代码的修改应用到Lean和Lienol两个大佬的OpenWrt分支，并替换FriendlyWrt整套代码的方式，由此编译出分别包含两位大佬特色优化和插件的两版固件，寻求最佳的插件兼容性和稳定性。目前在Lean版的基础上只编译我认为不影响设备性能的插件，测试结果显示，虽然功能较少，但是性能是比较好的。

### 个人修改

基于Minimal版完全按个人口味调整插件内容

### 温馨提示

- 登录地址：192.168.2.1
- 密码：password
