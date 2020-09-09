# Jocloud-RTC-Flutter Plugin
[中文](README.zh.md) | [English](README.md)
## 1 概览
该Flutter插件集成了聚联云thunderbolt SDK，供开发者直接引入快速集成SDK

## 2 快速开始
### 2.1 前提条件
- Android Studio 3.0 或以上版本
- Android SDK API 等级 16 或以上
- 支持 Android 4.1 或以上版本的移动设备
- 有效的聚联云账号和有效的APPID，[注册聚联云账号](https://jocloud.com/cn/reg)、[APPID申请](https://docs.jocloud.com/cloud/cn/platform/other
/user_auth.html#e9a1b9e79bae-e4b88e-app-id)
- Podfile需要修改的内容
```
    platform :ios, '9.0' #platform 需要9.0及以上
    
    source 'https://github.com/CocoaPods/Specs.git'    #添加项
    source 'https://github.com/yyqapm/specs.git'       #添加项
```

### 2.2 运行示例程序
- 使用Android Studio打开工程后同步
- 修改rtc_flutter/example/lib/constants.dart 下的mAppId,填入申请的APPID
- 编译代码安装到手机上

### 2.3 集成本插件
修改pubspec.yaml下的dev_dependencies
```
    dev_dependencies:
        ...
        flutterthunder:
            git:
                url: https://github.com/JocloudSDK/Aivacom-RTC-Flutter.git
                ref: branch eg:thunder2919
        ...
```

## 3 FAQ
1. dev_dependencies的ref是什么作用？
本插件使用git branch方式维护版本 
```
    ref: thunder2919表示使用thunderbolt android:2.9.19,ios:2.9.20版本

    具体android、ios使用thunderbolt版本需要根据branch中代码确认
```

## 4 联系我们
- 完整的 API 文档见[开发者中心](https://docs.jocloud.com/cn)
- 相关Demo下载，请访问：[SDK及Demo下载](https://docs.jocloud.com/download)
- 如果有售前咨询问题, 可以拨打电话:020-82120482 或 联系邮箱:marketing@jocloud.com
- 如需要技术支持请联系：huangcanbin@yy.com, zhouwen3@yy.com
