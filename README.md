# ScreenMe

ScreenMe 是一款专门为带屏小爱音响（LX04）设计的大屏 Android 应用，基于 Flutter 开发。

[![APK Release](https://github.com/corkine/screenMe/actions/workflows/dart.yml/badge.svg)](https://github.com/corkine/screenMe/actions/workflows/dart.yml)


ScreenMe 支持如下特性：
- 时钟显示
- 本地天气显示（彩云天气）
- 工作状态指示（已打卡、未打卡、请假、休假）
- Microsoft TODO 待办事项
- 实时显示蓝牙状态，开启、关闭时自动调节蓝牙音量
- 每日 Bing 壁纸
- Apple Health 健康数据显示（消耗卡路里、运动和冥想）
- 滑动切换表盘（壁纸 or 健身圆环）
- 演示模式

![每日bing壁纸视图](https://static2.mazhangjing.com/cyber/202401/bf82fd5b_78f32fd0b8be5068c8fc663f3aad177.jpg)

![健康视图](https://static2.mazhangjing.com/cyber/202401/4479c7ac_edbcd5ae2623ef7e4eb1a57c970e22e.jpg)

可前往 [Github Release 页面](https://github.com/corkine/screenMe/releases)下载构建好的 Android apk 安装包。应用对 iOS、macOS、iPadOS 以及 Windows 都进行了兼容，可自行下载编译打包。

## Config Server

在 `config-server` 下包含了一个基于 Go 的简单配置服务器，用于在 ScreenMe 升级和 App 重新安装时进行配置迁移。