# Jocloud-RTC-Flutter Plugin
[中文](README.zh.md) | [English](README.md)
## 1 Overview
The Flutter plugin integrates Jocloud Thunderbolt SDK for developers

## 2 Quick start
### 2.1 Prerequisites
You must meet the following conditions before starting development:
- Android Studio 3.0 or above
- Android SDK API level 16 or above
- Supports mobile devices with Android 4.1 or above
- Valid Jocloud account (valid APPID)，See details in [Jocloud account](https://jocloud.com/en/reg), [AppID](https://docs.jocloud.com/cloud/en/platform/other/user_auth.html#e9a1b9e79bae-e4b88e-app-id)
- Modify your Podfile
```
    platform :ios, '9.0' #platform need 9.0 or upper
    
    source 'https://github.com/CocoaPods/Specs.git'    #add item
    source 'https://github.com/yyqapm/specs.git'       #add item
```

### 2.2 Run the Demo
- Open the demo with Android Studio, connect to your Android device.
- modify rtc_flutter/example/lib/constants.dart mAppId,add yours APPID
- build and run

### 2.3 Integrate this plugin
Modify dev_dependencies in pubspec.yaml
```
    dev_dependencies:
        ...
        flutterthunder:
            git:
                url: https://github.com/JocloudSDK/Jocloud-RTC-Flutter.git
                ref: branch eg:1.0.0
        ...
```

## 3 FAQ
1. What is the function of dev_dependencies ref？
This plugin uses git branch to maintain the version 
```
    ref: thunder2919 meaning use thunderbolt android:2.9.19,ios:2.9.20 version

    The specific version of thunderbolt used by android and ios needs to be confirmed according to the code in the branch
```

## 4 Contact us
- For the complete API documentation, please see [Developer Center](https://docs.jocloud.com/cn)
- For related Demo downloads, please visit: [SDK and Demo Download](https://docs.jocloud.com/download)
- If you have questions about pre-sales consultation, you can call: 020-82120482 or contact email: marketing@jocloud.com.
- If you need technical support, please contact: huangcanbin@yy.com, zhouwen3@yy.com
