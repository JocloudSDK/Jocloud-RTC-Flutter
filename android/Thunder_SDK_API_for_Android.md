# Thunder SDK for Android v2.4.0

## 概述

尚云提供各种客户端SDK，SDK具有可以灵活搭配的API组合，通过SDK连接全球部署的实时通信网络，为业务提供质量可靠的实时音视频通信服务。
<br>尚云SDK的代号为Thunderbolt，移动端特有的纯音频SDK代号为Thunder。

## 接口类

ThunderEngine 接口类提供所有可供应用程序调用的方法。
<br>ThunderEventHandler 接口类用于向应用程序发送回调通知。

## ThunderEngine 接口类

### 核心方法

本组方法用于 SDK 初始化、设置SDK特性、进入房间等。

| 方法                            | 功能                |
| ------------------------------- | ------------------- |
| [createEngine](#createEngine)   | 初始化引擎          |
| [destroyEngine](#destroyEngine) | 销毁 RtcEngine 实例 |
| [setArea](#setArea)             | 设置用户国家区域    |
| [setSceneId](#setSceneId)       | 设置场景Id          |
| [setRoomConfig](#setRoomConfig) | 设置房间模式        |
| [joinRoom](#joinRoom)           | 加入房间            |
| [leaveRoom](#leaveRoom)         | 离开房间            |

### 核心音频方法

本组方法主要用于语音通话。

| 方法                                                         | 功能                    |
| ------------------------------------------------------------ | ----------------------- |
| [enableAudioEngine](#enableAudioEngine)                      | 音频开播                |
| [disableAudioEngine](#disableAudioEngine)                    | 音频停播                |
| [setAudioConfig](#setAudioConfig)                            | 设置音频属性            |
| [setAudioSourceType](#setAudioSourceType)                    | 设置音频开播模式        |
| [setAudioVolumeIndication](#setAudioVolumeIndication)        | 启用说话者音量提示      |
| [stopLocalAudioStream](#stopLocalAudioStream)                | 开/关本地音频发送       |
| [stopRemoteAudioStream](#stopRemoteAudioStream)              | 接收/停止接收指定音频流 |
| [stopAllRemoteAudioStreams](#stopAllRemoteAudioStreams)      | 接收/停止接收所有音频流 |
| [enableCapturePcmDataCallBack](#enableCapturePcmDataCallBack) | 开/关采集音频数据回调   |
| [enableRenderPcmDataCallBack](#enableRenderPcmDataCallBack)  | 开/关渲染音频数据回调   |
| [enableCaptureVolumeIndication](#enableCaptureVolumeIndication) | 开/关采集音量回调       |

### 音频播放

| 方法                                                        | 功能                 |
| ----------------------------------------------------------- | -------------------- |
| [enableLoudspeaker](#enableLoudspeaker)                     | 启用/关闭扬声器播放  |
| [isLoudspeakerEnabled](#isLoudspeakerEnabled)               | 查询扬声器启用状态   |
| [setLoudSpeakerVolume](#setLoudSpeakerVolume)               | 设置扬声器音量       |
| [setMicVolume](#setMicVolume)                               | 设置麦克风音量       |
| [setRemoteAudioStreamsVolume](#setRemoteAudioStreamsVolume) | 设置远端用户播放音量 |

### 耳返设置

| 方法                                            | 功能      |
| ----------------------------------------------- | --------- |
| [setEnableInEarMonitor](#setEnableInEarMonitor) | 开/关耳返 |

### 语音音效设置

| 方法                                          | 功能                |
| --------------------------------------------- | ------------------- |
| [setSoundEffect](#setSoundEffect)             | 设置音效模式        |
| [setEnableEqualizer](#setEnableEqualizer)     | 开/关本地语音均衡器 |
| [setEqGains](#setEqGains)                     | 设置语音均衡器参数  |
| [setEnableReverb](#setEnableReverb)           | 开/关本地音效混响   |
| [setReverbExParameter](#setReverbExParameter) | 设置音效混响参数    |
| [setEnableCompressor](#setEnableCompressor)   | 开/关音效压缩器     |
| [setCompressorParam](#setCompressorParam)     | 设置压缩器参数      |
| [setEnableLimiter](#setEnableLimiter)         | 开/关压限器         |
| [setLimiterParam](#setLimiterParam)           | 设置压限器参数      |

### 语音文件播放

| 方法                                              | 功能                                                         |
| ------------------------------------------------- | ------------------------------------------------------------ |
| [createAudioFilePlayer](#createAudioFilePlayer)   | 创建文件播放 [ThunderAudioFilePlayer](#ThunderAudioFilePlayer) 对象 |
| [destroyAudioFilePlayer](#destroyAudioFilePlayer) | 销毁文件播放 [ThunderAudioFilePlayer](#ThunderAudioFilePlayer) 对象 |

### 其他音频方法

| 方法                                                         | 功能                              |
| ------------------------------------------------------------ | --------------------------------- |
| [enableAudioDataIndication](#enableAudioDataIndication)      | 开/关音频播放数据回调             |
| [startAudioSaver](#startAudioSaver)                          | 开始将音频数据保存成aac格式的文件 |
| [stopAudioSaver](#stopAudioSaver)                            | 停止将音频数据保存成acc格式的文件 |
| [registerAudioFrameObserver](#registerAudioFrameObserver)    | 注册音频帧观测器                  |
| [setRecordingAudioFrameParameters](#setRecordingAudioFrameParameters) | 设置录制的声音格式                |
| [setPlaybackAudioFrameParameters](#setPlaybackAudioFrameParameters) | 设置播放的声音格式                |

### 其他方法

| 方法                                      | 功能                   |
| ----------------------------------------- | ---------------------- |
| [getVersion](#getVersion)                 | 获取 SDK 版本号        |
| [updateToken](#updateToken)               | 更新 Token             |
| [setLogLevel](#setLogLevel)               | 设置日志级别           |
| [setLogFilePath](#setLogFilePath)         | 设置日志文件路径       |
| [setLogCallback](#setLogCallback)         | 设置日志回调           |
| [sendUserAppMsgData](#sendUserAppMsgData) | 发送业务自定义广播消息 |
| [setMediaExtraInfoCallback](#setMediaExtraInfoCallback) | 设置媒体次要信息的回调监听 |
| [sendMediaExtraInfo](#sendMediaExtraInfo) | 发送媒体次要信息 |

## ThunderEngine 接口类

### 事件回调

| 回调                                                          | 事件                                       |
| ------------------------------------------------------------ | ------------------------------------------ |
| [onJoinRoomSuccess](#onJoinRoomSuccess)                      | 加入房间回调                               |
| [onLeaveRoom](#onLeaveRoom)                                  | 离开房间回调                               |
| [onSdkAuthResult](#onSdkAuthResult)                          | SDK 鉴权结果回调                           |
| [onBizAuthResult](#onBizAuthResult)                          | 业务鉴权结果回调                           |
| [onUserBanned](#onUserBanned)                                | 用户被封禁/解封回调                        |
| [onRemoteAudioStopped](#onRemoteAudioStopped)                | 远端用户静音状态回调                       |
| [onUserJoined](#onUserJoined)                                | 远端用户加入当前房间回调                   |
| [onUserOffline](#onUserOffline)                              | 远端用户离开房间回调                       |
| [onTokenWillExpire](#onTokenWillExpire)                      | Token 服务即将过期回调                     |
| [onTokenRequested](#onTokenRequested)                        | Token 过期回调                             |
| [onNetworkQuality](#onNetworkQuality)                        | 通话中每个用户的网络上下行网络质量报告回调 |
| [onPlayVolumeIndication](#onPlayVolumeIndication)            | 说话音量回调                               |
| [onCaptureVolumeIndication](#onCaptureVolumeIndication)      | 采集音量回调                               |
| [onAudioPlayData](#onAudioPlayData)                          | 音频播放数据回调                           |
| [onAudioPlaySpectrumData](#onAudioPlaySpectrumData)          | 音频播放频谱数据回调                       |
| [onAudioCapturePcmData](#onAudioCapturePcmData)              | 音频采集数据回调                           |
| [onAudioRenderPcmData](#onAudioRenderPcmData)                | 音频渲染数据回调                           |
| [onRecvUserAppMsgData](#onRecvUserAppMsgData)                | 接收业务自定义广播消息回调                 |
| [onSendAppMsgDataFailedStatus](#onSendAppMsgDataFailedStatus) | 业务自定义广播消息发送失败回调             |

## 方法列表

### 一般调用流程

#### 音频流程

1. createEngine
2. setRoomConfig
3. joinRoom
4. enableAudioEngine
5. disableAudioEngine
6. leaveRoom

### 核心方法

#### 创建 ThunderEngine 对象 (<span id="createEngine">createEngine</sapn>)

```java
    public static synchronized ThunderEngine createEngine(Context context,
                                                      String appId,
                                                      long sceneId,
                                                      ThunderEventHandler handler)
```

创建 ThunderEngine 实例并初始化。
<br>目前 SDK 只支持一个 ThunderEngine 实例，每个应用程序仅创建一个 ThunderEngine 对象。ThunderEngine 类的所有接口函数，如无特殊说明，都是异步调用，对接口的调用建议在同一个线程进行。所有返回值为 int 型的 API，如无特殊说明，返回值 0 为调用成功，返回值小于 0 为调用失败。同一个AppId的用户才能互通。SceneId用以区分同一个业务的不同场景，有助于按照场景进行数据分析。设置回调用来接收 SDK 的回调事件。

| 名称    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| context | 安卓活动 (Android Activity) 的上下文                         |
| appId   | 为应用程序开发者签发的 AppId                                 |
| sceneId | 开发者自定义场景Id，用以细分业务场景；如果不需要，可以填0    |
| handler | ThunderEventHandler 是一个提供了缺省实现的抽象类，SDK 通过该抽象类向应用程序回调 SDK 运行时的各种事件 |
| 返回值  | ThunderEngine对象                                            |

### 创建 ThunderEngine 对象 (createWithLoop)

```java
    public static synchronized ThunderEngine createWithLoop(Context context,
                                                              String appId,
                                                              long sceneId,
                                                              ThunderEventHandler handler,
                                                              Looper loop)
```

创建 ThunderEngine 实例并初始化。
<br>目前 SDK 只支持一个 ThunderEngine 实例，每个应用程序仅创建一个 ThunderEngine 对象。ThunderEngine 类的所有接口函数，如无特殊说明，都是异步调用，对接口的调用建议在同一个线程进行。所有返回值为 int 型的 API，如无特殊说明，返回值 0 为调用成功，返回值小于 0 为调用失败。同一个AppId的用户才能互通。SceneId用以区分同一个业务的不同场景，有助于按照场景进行数据分析。设置回调用来接收 SDK 的回调事件。

| 名称    | 描述                                                         |
| ------- | ------------------------------------------------------------ |
| context | 安卓活动 (Android Activity) 的上下文                         |
| appId   | 为应用程序开发者签发的 AppID                                 |
| sceneId | 开发者自定义场景Id，用以细分业务场景；如果不需要，可以填0    |
| handler | ThunderEventHandler 是一个提供了缺省实现的抽象类，SDK 通过该抽象类向应用程序回调 SDK 运行时的各种事件 |
| loop    | 回调执行线程                                                 |
| 返回值  | ThunderEngine对象                                            |

#### 销毁 ThunderEngine 对象 (<span id="destroyEngine">destroyEngine</span>)

```java
public static synchronized void destroyEngine()
```

销毁 ThunderEngine 实例。
<br>该方法释放 SDK 使用的所有资源。有些应用程序只在用户需要时才进行语音通话，不需要时则将资源释放出来用于其他操作，该方法对这类程序可能比较有用。 只要调用了 destroy(), 用户将无法再使用和回调该 SDK 内的其它方法。如需再次使用通信功能，必须重新创建一个 ThunderEngine 实例。
注意：已经创建的文件播放对象也会被释放。

#### 设置区域 (<span id="setArea">setArea</span>)

```java
public int setArea(int area)
```

设置区域。
<br>为适应国内外不同的法律法规，尚云同时提供国内中心系统和国际中心系统，默认为国内中心系统。如果应用程序主要在国外开展业务，需要调用该接口设置为国外区域。
<br>**注：** 国内中心系统和国际中心系统的用户不能互通，请务必保证同一个房间的用户在同一个系统。
<br>**注：** 国内中心系统和国际中心系统同样是全球部署，支持全球访问。

| area取值       | 描述                    |
| -------------- | ----------------------- |
| 默认值（国内） | THUNDER_AREA_DEFAULT(0) |
| 国外           | THUNDER_AREA_FOREIGN(1) |

#### 设置场景id (setSceneId)

```java
public void setSceneId(long sceneId)
```

设置场景id。

| 名称    | 描述                                                      |
| ------- | --------------------------------------------------------- |
| sceneId | 开发者自定义场景Id，用以细分业务场景；如果不需要，可以填0 |

#### 设置房间模式 (<span id="setRoomConfig">setRoomConfig</span>)
```java
public int setRoomConfig(int config, int roomconfig)
```
设置房间模式。<br>

| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| config | 设置音视频模式。<br> THUNDER_PROFILE_DEFAULT(0) : 默认为音视频模式<br> THUNDER_PROFILE_NORMAL(1) : 音视频模式（同时使用音频和视频） <br> THUNDER_PROFILE_ONLY_AUDIO(2) : 纯语音模式(无视频场景建议使用，获取更佳音频性能) |
| roomlConfig | 设置场景模式， SDK 需知道应用程序的使用场景（例如通信模式或直播模式），从而使用不同的优化手段。 <br> THUNDER_ROOMCONFIG_LIVE(0) : 直播模式，质量优先，时延较大，适合观众或者听众场景，观众开播音视频变为主播时自动切换为通信模式 <br> THUNDER_ROOMCONFIG_COMMUNICATION(1) : 通信模式，追求低延时和通话流畅，适用于1v1通话和多人聊天 <br> THUNDER_ROOMCONFIG_MULTIAUDIOROOM(4) : 语音房模式，追求低延时和低带宽占用，适用于多人语音房间 |

- 返回值：方法调用成功返回 0，失败返回 < 0。

#### 加入房间 (<span id="joinRoom">joinRoom</span>)

```java
public int joinRoom(byte[] token,
                           String roomName,
                           String uid)
```

加入房间。
该方法让用户加入通话房间，在同一个房间内的用户可以互相通话，多个用户加入同一个房间，可以群聊。使用不同 App ID 的 App 是不能互通的。如果已在通话中，用户必须调用 [leaveRoom](#leaveRoom) 退出当前通话，才能进入下一个房间。

| 参数 | 描述 |
|---|---|
|token | 鉴权所需，详见鉴权接入手册
|roomName | 房间名称(需保证一个AppId内唯一)，只支持[A,Z],[a,z],[0,9],-,_等字符的排列组合，且长度不能超过64个字节
|uid | 用户ID，32位无符号整数
|返回值 | 0：方法调用成功<br>< 0：方法调用失败

#### 离开房间 (<span id="leaveRoom">leaveRoom</span>)

```java
public int leaveRoom()
```

离开房间。
<br>离开房间，即挂断或退出通话。 当调用 [joinRoom](#joinRoom) 方法后，必须调用 [leaveRoom](#leaveRoom) 结束通话，否则无法开始下一次通话。 不管当前是否在通话中，都可以调用 [leaveRoom](#leaveRoom)，没有副作用。该方法会把会话相关的所有资源释放掉。

| 参数   | 描述                                  |
| ------ | ------------------------------------- |
| 返回值 | 0：方法调用成功<br> < 0：方法调用失败 |

### 核心音频方法

#### 音频开播 (<span id="enableAudioEngine">enableAudioEngine</span>)

```java
public int enableAudioEngine()

```

音频开播。
<br>音频开麦，进行音频采集编码，并推送音频流到房间。
<br>成功调用该方法后，远端会触发 [onRemoteAudioStopped](#onRemoteAudioStopped) 回调。

| 参数   | 描述                                  |
| ------ | ------------------------------------- |
| 返回值 | 0：方法调用成功<br> < 0：方法调用失败 |

#### 音频停播 (<span id="disableAudioEngine">disableAudioEngine</span>)

```java
public int disableAudioEngine()

```

音频停播。
<br>音频关麦，停止音频采集编码，停止推送音频流到房间。
<br>成功调用该方法后，远端会触发 [onRemoteAudioStopped](#onRemoteAudioStopped) 回调。

| 参数   | 描述                                  |
| ------ | ------------------------------------- |
| 返回值 | 0：方法调用成功<br> < 0：方法调用失败 |

#### 设置音频属性 (<span id="setAudioConfig">setAudioConfig</span>)

```java
public int setAudioConfig(int config, int commutMode, int scenarioMode)

```

设置音频属性。
<br>该方法用于设置音频参数和应用场景。

| 参数         | 描述                                                         |
| ------------ | ------------------------------------------------------------ |
| config       | THUNDER_AUDIO_CONFIG_DEFAULT(0)：默认设置。通信模式下为 1，直播模式下为 2 <br> THUNDER_AUDIO_CONFIG_SPEECH_STANDARD(1)：指定 16 KHz采样率，语音编码, 单声道，编码码率约 18 kbps <br> THUNDER_AUDIO_CONFIG_MUSIC_STANDARD_STEREO(2)：指定 44.1 KHz采样率，音乐编码, 双声道，编码码率约 24 kbps，编码延迟高 <br> THUNDER_AUDIO_CONFIG_MUSIC_STANDARD(3)：指定 44.1 KHz采样率，音乐编码, 双声道，编码码率约 40 kbps，编码延迟低 <br> THUNDER_AUDIO_CONFIG_MUSIC_HIGH_QUALITY_STEREO(4)：指定 44.1KHz采样率，音乐编码, 双声道，编码码率约 128kbps |
| commuMode    | 设置交互模式 CommutMode: <br>     THUNDER_COMMUT_MODE_DEFAULT(0)：默认=1 <br> THUNDER_COMMUT_MODE_HIGH(1)：强交互模式 <br> THUNDER_COMMUT_MODE_LOW(2)：弱交互模式 |
| scenarioMode | 设置场景模式 ScenarioMode: <br>THUNDER_SCENARIO_MODE_DEFAULT(0)：默认=1 <br> THUNDER_SCENARIO_MODE_STABLE_FIRST(1)：流畅优先：推荐注重稳定的教育 <br> THUNDER_SCENARIO_MODE_QUALITY_FIRST(2)：音质优先：推荐很少或者不连麦的秀场 |

#### 设置音频开播模式(<span id="setAudioSourceType">setAudioSourceType</span>)

```java
public void setAudioSourceType(int sourceType);

```

设置音频开播模式。

| 参数       | 描述                                                         |
| ---------- | ------------------------------------------------------------ |
| sourceType | THUNDER_PUBLISH_MODE_MIC(0):麦克风(仅麦克风采集开播到房间) <br> THUNDER_PUBLISH_MODE_FILE(1):伴奏(仅文件播放开播到房间) <br> THUNDER_PUBLISH_MODE_MIX(2):混合(麦克风采集和文件播放都开播到房间) <br>THUNDER_PUBLISH_NONE(10):停止所有音频数据上行 |

#### 启用说话者音量提示 (<span id="setAudioVolumeIndication">setAudioVolumeIndication</span>)

```java
public int setAudioVolumeIndication(int interval,
                                           int moreThanThd,
                                           int lessThanThd,
                                           int smooth)

```

启用说话者音量提示。
<br>该方法允许 SDK 定期向应用程序反馈当前谁在说话以及说话者的音量。
由回调接口 [onPlayVolumeIndication](#onPlayVolumeIndication) 返回。
**注**：不含本地麦克风采集或者文件播放的声音音量。

| 参数        | 描述                                                         |
| ----------- | ------------------------------------------------------------ |
| interval    | 回调间隔，默认=0<br> <=0时: 禁用音量提示功能 <br>  >0时: 回调间隔，单位为毫秒 |
| moreThanThd | 从<moreThanThd到>=moreThanThd，立即回调一次(此时不受interval约束) <br> <=0无效，默认=0 |
| lessThanThd | 从>=lessThanThd到<lessThanThd，立即回调一次(此时不受interval约束) <br> <=0无效，默认=0 |
| smooth      | 暂无作用                                                     |
| 返回值      | 0：方法调用成功 <br> < 0：方法调用失败                       |

#### 开/关本地音频发送 (<span id="stopLocalAudioStream">stopLocalAudioStream</span>)

```java
public int stopLocalAudioStream(boolean stop)

```

开/关本地音频发送。
<br>该方法用于允许/禁止往网络发送本地音频流。

| 参数   | 描述                                              |
| ------ | ------------------------------------------------- |
| stop   | true:关闭本地音频发送 <br> false:打开本地音频发送 |
| 返回值 | 0：方法调用成功 <br> < 0：方法调用失败            |

#### 接收/停止接收指定音频流 (<span id="stopRemoteAudioStream">stopRemoteAudioStream</span>)

```java
public int stopRemoteAudioStream(String uid, boolean stop)

```

接收/停止接收指定音频流。
<br> 注意：如果之前有调用过 [stopAllRemoteAudioStreams](#stopAllRemoteAudioStreams) (true) 停止接收所有远端音频流，在调用本 API 之前请确保你已调用 [stopAllRemoteAudioStreams](#stopAllRemoteAudioStreams) (false)。[stopAllRemoteAudioStreams](#stopAllRemoteAudioStreams) 是全局控制，[stopRemoteAudioStream](#stopRemoteAudioStream) 是精细控制。

| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| uid    | 用户id                                                       |
| stop   | true:停止接收指定用户的远端音频流 <br> false:开始接收指定用户的远端音频流 |
| 返回值 | 0：方法调用成功 <br> < 0：方法调用失败                       |

#### 接收/停止接收所有音频流 (<span id="stopAllRemoteAudioStreams">stopAllRemoteAudioStreams</span>)

```java
public int stopAllRemoteAudioStreams(boolean stop)

```

接收/停止接收所有音频流。
<br>该设置只对当前房间生效。

| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| stop   | true:停止接收所有远端音频流<br>false:开始接收所有远端音频流（同时清空 [stopAllRemoteAudioStreams](#stopAllRemoteAudioStreams) 的黑名单） |
| 返回值 | 0：方法调用成功 <br> < 0：方法调用失败                       |

#### 开/关采集音频数据回调（<span id="enableCapturePcmDataCallBack">enableCapturePcmDataCallBack</span>）

```java
public void enableCapturePcmDataCallBack(boolean enable, int sampleRate, int room)

```

开/关采集音频数据回调。
<br>打开后通过回调接口 [onAudioCapturePcmData](#onAudioCapturePcmData) 获得采集音频数据。

| 参数       | 描述                                                         |
| ---------- | ------------------------------------------------------------ |
| enable     | true：打开<br>false：关闭                                    |
| sampleRate | 设置需要回调数据的采样率，取值范围 [-1,8000,16000,44100,48000] |
| room       | 设置需要回调数据的声道数，取值范围 [-1,1,2]                  |

**注意**：只要 sampleRate 和 room 其中一个参数的取值为 -1，回调的数据是没有经过重采样的原始数据。

#### 开/关渲染音频数据回调（<span id="enableRenderPcmDataCallBack">enableRenderPcmDataCallBack</span>）

```java
public boolean enableRenderPcmDataCallBack(boolean enable, int sampleRate, int room)

```

开/关渲染音频数据回调。
<br>打开后通过回调接口 [onAudioRenderPcmData](#onAudioRenderPcmData) 获得音频渲染数据回调。

| 参数       | 描述                                                         |
| ---------- | ------------------------------------------------------------ |
| enable     | true：打开<br>false：关闭                                    |
| sampleRate | 设置需要回调数据的采样率，取值范围 [-1,8000,16000,44100,48000] |
| room       | 设置需要回调数据的声道数，取值范围 [-1,1,2]                  |

**注意**：只要 sampleRate 和 room 其中一个参数的取值为 -1，回调的数据是没有经过重采样的原始数据。

#### 开/关采集音量回调 (enableCaptureVolumeIndication)（<span id="enableCaptureVolumeIndication">enableCaptureVolumeIndication</span>）

```java
public int enableCaptureVolumeIndication(int interval,
                                             int moreThanThd,
                                             int lessThanThd,
                                             int smooth)

```

开/关采集音量回调。
<br>该方法允许 SDK 定期向应用程序反馈当前麦克风采集音量。
由 [onCaptureVolumeIndication](#onCaptureVolumeIndication) 返回。

| 参数        | 描述                                                         |
| ----------- | ------------------------------------------------------------ |
| interval    | 回调间隔;<br> <=0时: 禁用音量提示功能<br>  >0时: 回调间隔，单位为毫秒<br> 默认=0 |
| moreThanThd | 从<moreThanThd到>=moreThanThd，立即回调一次(此时不受interval约束) <br> <=0无效，默认=0 |
| lessThanThd | 从>=lessThanThd到<lessThanThd，立即回调一次(此时不受interval约束)<br> <=0无效，默认=0 |
| smooth      | 暂无作用                                                     |
| 返回值      | 0：方法调用成功<br> < 0：方法调用失败                        |

### 音频播放

#### 启用/关闭扬声器播放 (<span id="enableLoudspeaker">enableLoudspeaker</span>)

```java
public int enableLoudspeaker(boolean enabled)

```

启用/关闭扬声器播放。
<br>该方法将语音路由强制设置为扬声器（外放）。

| 参数    | 描述                                   |
| ------- | -------------------------------------- |
| enabled | true:扬声器播放 <br> false:听筒播放    |
| 返回值  | 0：方法调用成功 <br> < 0：方法调用失败 |

#### 查询扬声器启用状态 (<span id="isLoudspeakerEnabled">isLoudspeakerEnabled</span>)

```java
public boolean isLoudspeakerEnabled()

```

查询扬声器启用状态。

| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| 返回值 | true: 表明输出到扬声器<br>  false: 表明输出到非扬声器(听筒，耳机等) |

#### 设置扬声器音量(<span id="setLoudSpeakerVolume">setLoudSpeakerVolume</span>)

```java
public int setLoudSpeakerVolume(int volume)

```

设置扬声器音量。

| 参数   | 描述                                 |
| ------ | ------------------------------------ |
| volume | 音量值[0-100]                        |
| 返回值 | 0：方法调用成功<br>< 0：方法调用失败 |

#### 设置麦克风音量(<span id="setMicVolume">setMicVolume</span>)

```java
public int setMicVolume(int volume)

```

设置麦克风音量。

| 参数   | 描述                                 |
| ------ | ------------------------------------ |
| volume | 音量值[0-100]                        |
| 返回值 | 0：方法调用成功<br>< 0：方法调用失败 |

#### 设置远端用户的播放音量(<span id="setRemoteAudioStreamsVolume">setRemoteAudioStreamsVolume</span>)

```java
public int setRemoteAudioStreamsVolume(String uid, int volume)

```

设置远端用户的播放音量。

| 参数   | 描述                                 |
| ------ | ------------------------------------ |
| uid    | 用户id                               |
| volume | 音量值[0-100]                        |
| 返回值 | 0：方法调用成功<br>< 0：方法调用失败 |

### 耳返设置

#### 开/关耳返(<span id="setEnableInEarMonitor">setEnableInEarMonitor</span>)

```java
public int setEnableInEarMonitor (boolean enable)

```

开/关耳返。

| 参数    | 描述                                  |
| ------- | ------------------------------------- |
| enabled | true：打开 <br> false：关闭           |
| 返回值  | 0：方法调用成功<br> < 0：方法调用失败 |

### 语音变声设置
#### 设置变声模式(<span id="setVoiceChanger">setVoiceChanger</span>)
```java
public void setVoiceChanger(int mode)
```
设置变声模式。

参数 | 描述
---|---
mode | THUNDER_VOICE_CHANGER_NONE(0): 关闭模式 <br>THUNDER_VOICE_CHANGER_ETHEREAL(1): 空灵 <br>THUNDER_VOICE_CHANGER_THRILLER(2): 惊悚 <br>THUNDER_VOICE_CHANGER_LUBAN(3): 鲁班 <br>THUNDER_VOICE_CHANGER_LORIE(4): 萝莉 <br>THUNDER_VOICE_CHANGER_UNCLE(5): 大叔 <br>THUNDER_VOICE_CHANGER_DIEFAT(6): 死肥仔 <br>THUNDER_VOICE_CHANGER_BADBOY(7): 熊孩子 <br>THUNDER_VOICE_CHANGER_WRACRAFT(8): 魔兽农民 <br>THUNDER_VOICE_CHANGER_HEAVYMETAL(9): 重金属 <br>THUNDER_VOICE_CHANGER_COLD(10): 感冒 <br>THUNDER_VOICE_CHANGER_HEAVYMECHINERY(11): 重机械 <br>THUNDER_VOICE_CHANGER_TRAPPEDBEAST(12): 困兽 <br>THUNDER_VOICE_CHANGER_POWERCURRENT(13): 强电流 |

### 语音音效设置

#### 设置音效模式(<span id="setSoundEffect">setSoundEffect</span>)

```java
public void setSoundEffect(int mode)

```

设置音效模式。

| 参数 | 描述                                                         |
| ---- | ------------------------------------------------------------ |
| mode | THUNDER_SOUND_EFFECT_MODE_NONE(0)：关闭模式 <br>THUNDER_SOUND_EFFECT_MODE_VALLEY(1): VALLEY模式 <br>THUNDER_SOUND_EFFECT_MODE_RANDB(2)：R&B模式 <br>THUNDER_SOUND_EFFECT_MODE_KTV(3)：KTV模式<br>THUNDER_SOUND_EFFECT_MODE_CHARMING(4)：CHARMING模式 <br>THUNDER_SOUND_EFFECT_MODE_POP(5): 流行模式 <br>THUNDER_SOUND_EFFECT_MODE_HIPHOP(6): 嘻哈模式 <br>THUNDER_SOUND_EFFECT_MODE_ROCK(7): 摇滚模式 <br>THUNDER_SOUND_EFFECT_MODE_CONCERT(8): 演唱会模式 <br>THUNDER_SOUND_EFFECT_MODE_STUDIO(9): 录音棚模式|



#### 开/关本地语音均衡器（<span id="setEnableEqualizer">setEnableEqualizer</span>）

```java
public int setEnableEqualizer(boolean enabled)

```

开/关本地语音均衡器。

| 参数    | 描述                                 |
| ------- | ------------------------------------ |
| enabled | true:打开 <br> false:关闭            |
| 返回值  | 0：方法调用成功<br>< 0：方法调用失败 |

#### 设置均衡器参数（<span id="setEqGains">setEqGains</span>）

```java
public int setEqGains(final int [] gains)

```

设置均衡器参数。

| 参数   | 描述                                              |
| ------ | ------------------------------------------------- |
| gains  | -12 <= gains[i] <= 12, 其中i去取范围是 0<= i <=10 |
| 返回值 | 0：方法调用成功<br>< 0：方法调用失败              |

#### 开/关本地音效混响（<span id="setEnableReverb">setEnableReverb</span>）

```java
public int setEnableReverb(boolean enabled)

```

开/关本地音效混响。

| 参数    | 描述                                 |
| ------- | ------------------------------------ |
| enabled | true：打开<br>false：关闭            |
| 返回值  | 0：方法调用成功<br>< 0：方法调用失败 |

#### 设置混响参数（<span id="setReverbExParameter">setReverbExParameter</span>）

```java
public int setReverbExParameter(ReverbExParameter param)

```

设置混响参数。

| 参数   | 描述                                                  |
| ------ | ----------------------------------------------------- |
| param  | 混响参数详见：[ReverbExParameter](#ReverbExParameter) |
| 返回值 | 0：方法调用成功<br>< 0：方法调用失败                  |

#### 开/关音效压缩器（<span id="setEnableCompressor">setEnableCompressor</span>）

```java
public int setEnableCompressor(boolean enabled)

```

开/关音效压缩器。

| 参数    | 描述                                 |
| ------- | ------------------------------------ |
| enabled | true：打开<br>false：关闭            |
| 返回值  | 0：方法调用成功<br>< 0：方法调用失败 |

#### 设置压缩器参数（<span id="setCompressorParam">setCompressorParam</span>）

```java
public int setCompressorParam(CompressorParam param)

```

设置压缩器参数。

| 参数   | 描述                                              |
| ------ | ------------------------------------------------- |
| param  | 压缩参数详见：[CompressorParam](#CompressorParam) |
| 返回值 | 0：方法调用成功<br>< 0：方法调用失败              |

#### 开/关压限器（<span id="setEnableLimiter">setEnableLimiter</span>）

```java
public int setEnableLimiter(boolean enabled)

```

开/关压限器。

| 参数    | 描述                                 |
| ------- | ------------------------------------ |
| enabled | true：打开<br>false：关闭            |
| 返回值  | 0：方法调用成功<br>< 0：方法调用失败 |

#### 设置压限器参数（<span id="setLimiterParam">setLimiterParam</span>）

```java
public int setLimiterParam(LimterParam param)

```

设置压限器参数。

| 参数   | 描述                                      |
| ------ | ----------------------------------------- |
| param  | 压缩参数详见：[LimterParam](#LimterParam) |
| 返回值 | 0：方法调用成功<br>< 0：方法调用失败      |

### 语音文件播放(<span id="ThunderAudioFilePlayer">ThunderAudioFilePlayer</span>)

#### 调用流程：

1. createAudioFilePlayer 获取文件播放对象
2. open
3. play, stop, pause, resume……
4. close
5. destroyAudioFilePlayer 释放文件播放对象
   <br>注：ThunderEngine 对象释放后，将导致通过createAudioFilePlayer获取的对象失效。

#### 创建文件播放对象(<span id="createAudioFilePlayer">createAudioFilePlayer</span>)

```java
public ThunderAudioFilePlayer createEngineAudioFilePlayer()

```

#### 销毁文件播放对象(<span id="destroyAudioFilePlayer">destroyAudioFilePlayer</span>)

```java
public void destroyAudioFilePlayer(ThunderAudioFilePlayer audioFilePlayer)

```

#### 打开文件(ThunderAudioFilePlayer.open)

```java
public boolean open(String path)

```

| 参数   | 描述                                 |
| ------ | ------------------------------------ |
| path   | 文件路径                             |
| 返回值 | 0：方法调用成功<br>< 0：方法调用失败 |

#### 关闭文件(ThunderAudioFilePlayer.close)

```java
public void close()

```

#### 开始播放(ThunderAudioFilePlayer.play)

```java
public void play()

```

#### 停止播放(ThunderAudioFilePlayer.stop)

```java
public void stop()

```

#### 暂停播放(ThunderAudioFilePlayer.pause)

```java
public void pause()

```

#### 继续播放(ThunderAudioFilePlayer.resume)

```java
public void resume()

```

#### 设置循环播放次数(<span id="ThunderAudioFilePlayer.setLooping"> ThunderAudioFilePlayer.setLooping </span>)
```java
public int setLooping(int cycle)
```
| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| cycle | -1: 表示无限循环；0： 无循环(默认值) 正整数：循环次数|
- 返回值：方法调用成功返回 0，失败返回 < 0。

#### 获取打开文件的音轨数量(<span id="ThunderAudioFilePlayer.getAudioTrackCount"> ThunderAudioFilePlayer.getAudioTrackCount </span>)

```java
public int getAudioTrackCount()
```
- 返回值：当前文件的轨道数量


#### 切换到指定音轨(<span id="ThunderAudioFilePlayer.selectAudioTrack"> ThunderAudioFilePlayer.selectAudioTrack </span>)
```java
public int selectAudioTrack(int audioTrack)
```
| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| audiotrack | 指定音频轨，0表示文件第一条轨道|
- 返回值：方法调用成功返回 0，失败返回 < 0。


#### 跳转到指定的播放时间(ThunderAudioFilePlayer.seek)

```java
public void seek(long timeMS)

```

| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| timeMs | 需要跳转到的时间点（单位：毫秒），不应该大于getTotalPlayTimeMS()获取的值 |

#### 获取文件的总播放时长(<span id="ThunderAudioFilePlayer.getTotalPlayTimeMS"> ThunderAudioFilePlayer.getTotalPlayTimeMS </span>)

```java
public long getTotalPlayTimeMS()
```

#### 获取当前已经播放的时长(<span id="ThunderAudioFilePlayer.getCurrentPlayTimeMS"> ThunderAudioFilePlayer.getCurrentPlayTimeMS </span>)

```java
public long getCurrentPlayTimeMS()
```

#### 设置音乐文件在本地和远端的播放音量(<span id="ThunderAudioFilePlayer.setPlayVolume"> ThunderAudioFilePlayer.setPlayVolume </span>)

```java
public void setPlayVolume(int volume)
```
| 参数   | 描述             |
| ------ | ---------------- |
| volume | 播放音量 [0-100] |

#### 调节音乐文件在本端播放的音量大小(<span id="ThunderAudioFilePlayer.setPlayerLocalVolume"> ThunderAudioFilePlayer.setPlayerLocalVolume </span>)
```java
public int setPlayerLocalVolume(int volume)
```
| 参数   | 描述             |
| ------ | ---------------- |
| volume | 播放音量 [0-100] |

#### 调节音乐文件在远端播放的音量大小(<span id="ThunderAudioFilePlayer.setPlayerPublishVolume"> ThunderAudioFilePlayer.setPlayerPublishVolume </span>)

```java
public int setPlayerPublishVolume(int volume)
```
| 参数   | 描述             |
| ------ | ---------------- |
| volume | 播放音量 [0-100] |

#### 获取音乐文件在本地播放的音量大小(<span id="ThunderAudioFilePlayer.getPlayerLocalVolume"> ThunderAudioFilePlayer.getPlayerLocalVolume </span>)

```java
public int getPlayerLocalVolume()
```
| 描述             |
|---------------- |
| 对应setPlayerLocalVolume设置值 |

#### 获取音乐文件在远端播放的音量大小(<span id="ThunderAudioFilePlayer.getPlayerPublishVolume"> ThunderAudioFilePlayer.getPlayerPublishVolume </span>)

```java
public int getPlayerPublishVolume()
```
| 描述             |
|---------------- |
| 对应setPlayerPublishVolume设置值 |

#### 设置音频播放的声调(<span id="ThunderAudioFilePlayer.setSemitone"> ThunderAudioFilePlayer.setSemitone </span>)
```java
public void setSemitone(int val)
```
| 参数 | 描述                                                |
| ---- | --------------------------------------------------- |
| val  | 取值： -5, -4, -3, -2, -1, 0(normal), 1, 2, 3, 4, 5 |

#### 打开文件播放音量回调(<span id="ThunderAudioFilePlayer.enableVolumeIndication"> ThunderAudioFilePlayer.enableVolumeIndication </span>)
```java
public synchronized void enableVolumeIndication(boolean enable, int interval)
```
| 参数     | 描述                                                         |
| -------- | ------------------------------------------------------------ |
| enable   | 打开/关闭                                                    |
| interval | 回调时间间隔（单位:毫秒），建议设置200ms以上;如果<=0,则重置为200ms； |

#### 播放结束回调接口(<span id="IThunderAudioFilePlayerCallback.onAudioFilePlayEnd"> IThunderAudioFilePlayerCallback.onAudioFilePlayEnd </span>)
```java
void onAudioFilePlayEnd()
```

#### 播放状态错误回调接口(<span id="IThunderAudioFilePlayerCallback.onAudioFilePlayError"> IThunderAudioFilePlayerCallback.onAudioFilePlayError </span>)
```java
void onAudioFilePlayError(int errorCode)
```

| 参数      | 描述                     |
| --------- | ------------------------ |
| 0    | 文件打开成功           |
| -1 | 文件解析出错 |
| -2 | 文件解码出错 |
| -3 | 文件格式不支持 |
| -4 | 文件路径不存在 |

#### 播放音量回调(<span id="IThunderAudioFilePlayerCallback.onAudioFileVolume"> IThunderAudioFilePlayerCallback.onAudioFileVolume </span>)

```java
void onAudioFileVolume(long volume, long currentMs, long totalMs);
```
| 参数      | 描述                     |
| --------- | ------------------------ |
| volume    | 音量值[0-100]            |
| currentMs | 播放进度值（单位：毫秒） |
| totalMs   | 文件总长度（单位：毫秒） |


### 其他音频方法

#### 开/关音频播放数据回调(<span id="enableAudioDataIndication">enableAudioDataIndication</span>)

```java
public void enableAudioDataIndication(boolean enablePlay)

```

开/关音频播放数据回调。
<br>打开后，将由 [onAudioPlayData](#onAudioPlayData) 函数回调。

| 参数       | 描述                        |
| ---------- | --------------------------- |
| enablePlay | true：打开 <br> false：关闭 |

#### 开始将音频数据保存成aac格式的文件(<span id="startAudioSaver">startAudioSaver</span>)

```java
public boolean startAudioSaver(String fileName, int saverMode, int fileMode)

```

开始将音频数据保存成aac格式的文件。

| 参数      | 描述                                                         |
| --------- | ------------------------------------------------------------ |
| fileName  | 文件绝对路径，包含文件名，后缀名为.aac                       |
| saverMode | THUNDER_AUDIO_SAVER_ONLY_CAPTURE(0): 保存房间内所有的上行的音频数据。麦克风采集和伴奏的声音，只有被设置成上行才会被保存 <br>THUNDER_AUDIO_SAVER_ONLY_RENDER(1)保存房间内下行的音频数据<br>THUNDER_AUDIO_SAVER_BOTH(2)保存房间类上下行音频数据 |
| fileMode  | THUNDER_AUDIO_SAVER_FILE_APPEND(0):追加打开一个文本文件，并在文件末尾写数据<br>THUNDER_AUDIO_SAVER_FILE_OVERRIDE(1):打开一个文本文件，写入的数据会覆盖文件本身的内容 |

#### 停止将音频数据保存成acc格式的文件(<span id="stopAudioSaver">stopAudioSaver</span>)

```java
public boolean stopAudioSaver()

```

停止将音频数据保存成acc格式的文件。

#### 注册音频帧观测器(<span id="registerAudioFrameObserver">registerAudioFrameObserver</span>)

```
public int registerAudioFrameObserver(IAudioFrameObserver observer)

```

| 参数     | 描述                                                         |
| -------- | ------------------------------------------------------------ |
| observer | 继承 IAudioFrameObserver 的类对象的引用，此类需要实现以下虚拟接口：<br>boolean onRecordFrame(ByteBuffer samples, int numOfSamples, int bytesPerSample, int rooms, int samplesPerSec); // 音频采集原始数据回调<br>boolean onPlaybackFrame(ByteBuffer samples, int numOfSamples, int bytesPerSample, int rooms, int samplesPerSec); // 音频播放原始数据调<br><br>传入null则取消注册 |
|          | 返回值                                                       |

#### 设置录制的声音格式(<span id="setRecordingAudioFrameParameters">setRecordingAudioFrameParameters</span>)

```
public int setRecordingAudioFrameParameters (int sampleRate, int room, int mode, int samplesPerCall)

```

| 参数           | 描述                                                         |
| -------------- | ------------------------------------------------------------ |
| sampleRate     | 采样率                                                       |
| room           | 声道；1:单声道，2：双声道                                    |
| mode           | onRecordAudioFrame 的使用模式，详见 ThunderAudioRawFrameOperationMode |
| samplesPerCall | 指定 onRecordAudioFrame 中返回数据的采样点数，如转码推流应用中通常为 1024。samplesPerCall = (int)(sampleRate × sampleInterval)，其中：sampleInterval ≥ 0.01，单位为秒。 |
| 返回值         | 0：方法调用成功<br> < 0：方法调用失败                        |

#### 设置播放的声音格式(<span id="setPlaybackAudioFrameParameters">setPlaybackAudioFrameParameters</span>)

```
public int setPlaybackAudioFrameParameters (int sampleRate, int room, int mode, int samplesPerCall)

```

| 参数           | 描述                                                         |
| -------------- | ------------------------------------------------------------ |
| sampleRate     | 采样率                                                       |
| room           | 声道；1:单声道，2：双声道                                    |
| mode           | onRecordAudioFrame 的使用模式，详见 ThunderAudioRawFrameOperationMode |
| samplesPerCall | 指定 onRecordAudioFrame 中返回数据的采样点数，如转码推流应用中通常为 1024。samplesPerCall = (int)(sampleRate × sampleInterval)，其中：sampleInterval ≥ 0.01，单位为秒。 |
| 返回值         | 0：方法调用成功<br> < 0：方法调用失败                        |

### 其它

#### 获取版本号 (<span id="getVersion">getVersion</span>)

```java
public static String getVersion()

```

获取版本号。
<br>该方法返回 SDK 版本号字符串。

#### 更新Token (<span id="updateToken">updateToken</span>)

```java
public int updateToken(byte[] token)

```

该方法用于更新 Token, 用于业务鉴权。
<br>Token建议格式如下，详见鉴权接入手册。

| uint16   | uint32 | uint64 | uint64        | uint32       | uint16        | nBytes         | 20 Bytes         |
| -------- | ------ | ------ | ------------- | ------------ | ------------- | -------------- | ---------------- |
| TokenLen | AppId  | uid    | TimeStamp(ms) | ValidTime(s) | BizExtInfoLen | BizExtInfoData | DigitalSignature |

1. 多字节整数使用网络字节序，即大端。
2. TokenLen：整个token长度，包括自身2字节和摘要。
3. Token过期时间=Timestamp+ValidTime*1000, UTC时间距离1970的毫秒数。
4. BizExtInfoData: 业务鉴权可能需要的扩展信息，由业务自定义。
5. DigitalSignature：数字签名采用hmac-sha1算法对DigitalSignature前的所有数据运算得出[TokenLen,BizExtInfoData], 秘钥使用申请appId时分配的appSecret。
6. 因为Token要通过http传递，所以需对整个Token进行url安全的base64编码，注意不是对整个base64进行url encode。

#### 设置日志级别 (<span id="setLogLevel">setLogLevel</span>)

```java
public static int setLogLevel(int level)

```

设置日志级别。
<br>谁知日志输出过滤级别，在setLogFilePath或者setLogCallback之前调用。不调用此接口，使用默认等级:THUNDER_LOG_LEVEL_INFO。

| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| filter | THUNDER_LOG_LEVEL_TRACE = 0 <br> THUNDER_LOG_LEVEL_DEBUG = 1 <br> THUNDER_LOG_LEVEL_INFO = 2 <br> THUNDER_LOG_LEVEL_WARN = 3 <br> THUNDER_LOG_LEVEL_ERROR = 4 |

#### 设置日志文件路径 (<span id="setLogFilePath">setLogFilePath</span>)

```java
public static int setLogFilePath(String filePath)

```

设置日志文件路径。
<br>SDK 日志输出的两种方法之一，由应用程序指定输出目录并保证目录可写，SDK 自行输出日志到该目录。

#### 设置日志回调 (setLogCallback)

```java
public static int setLogCallback(IThunderLogCallback callback)

```

设置日志回调输出。
<br>SDK 日志输出的两种方法之一，SDK 回调日志消息给应用程序，由应用程序代写。设置日志回调后，则setLogFilePath失效。

#### 发送业务自定义广播消息 (<span id="sendUserAppMsgData">sendUserAppMsgData</span>)

```java
public int sendUserAppMsgData(byte[] msgData)

```

在房间内发送业务自定义广播消息。该接口通过媒体UDP通道发送消息，具有低延时和不可靠的特性。具体约束如下：

1. 发送者必须进入房间。
2. 开麦成功后才能调用(纯观众和开播鉴权失败都不能发)。
3. 调用该接口的频率每秒不能超过2次,msgData的大小不能超过200Byte。
4. 不满足以上任一条件msg都会被丢弃。
5. 不保证一定送达房间内所有在线用户，不保证一定按序送达。

<br>其他用户发来的自定义广播消息，通过回调接口 [onRecvUserAppMsgData](#onRecvUserAppMsgData) 回调给应用程序。
<br>通过回调接口 [onSendAppMsgDataFailedStatus](#onSendAppMsgDataFailedStatus) 获得发送该msg失败原因。

| 参数    | 描述       |
| ------- | ---------- |
| msgData | 发送的消息 |

#### 设置媒体次要信息的回调监听 (<span id="setMediaExtraInfoCallback">setMediaExtraInfoCallback</span>)

```java
public int setMediaExtraInfoCallback(IThunderMediaExtraInfoCallback callback)
```

```java

public interface IThunderMediaExtraInfoCallback {

	/**
	 * 发送媒体次要信息失败状态回调
	 *
	 * @param status 失败错误码 {参见 ThunderSendMediaExtraInfoFailedStatus}
	 */

	void onSendMediaExtraInfoFailedStatus(int status);
	/**
	 * 接收媒体次要信息
	 *
	 * @param uid		主播的uid
	 * @param data	  	接收到的媒体次要信息
	 * @param dataLen	媒体次要信息长度
	 */
	void onRecvMediaExtraInfo(java.lang.String uid,
							  java.nio.ByteBuffer data,
							  int dataLen);
}


    
```

<br>设置媒体次要信息回调接口，用户需要实现IThunderMediaExtraInfoCallback回调接口。

| 参数    | 描述       |
| ------- | ---------- |
| callback | 实现了IThunderMediaExtraInfoCallback接口的对象实例 |


ThunderSendMediaExtraInfoFailedStatus | 描述
--- | ---
THUNDER_SEND_MEDIA_EXTRA_INFO_FAILED_DATA_EMPTY(1)| 次要信息为空
THUNDER_SEND_MEDIA_EXTRA_INFO_FAILED_DATA_TOO_LARGE(2)| 每次发送数据太大，每次不能超过200Byte
THUNDER_SEND_MEDIA_EXTRA_INFO_FAILED_FREQUENCY_TOO_HIGHT(3)| 发送频率太高，不能超过100ms一次
THUNDER_SEND_MEDIA_EXTRA_INFO_FAILED_NOT_IN_ANCHOR_SYSTEM(4)| 不是主播系统
THUNDER_SEND_MEDIA_EXTRA_INFO_FAILED_NO_JOIN_MEDIA(5)| 未进房间
THUNDER_SEND_MEDIA_EXTRA_INFO_FAILED_NO_PUBLISH_SUCCESS(6)| 未成功开播

- 返回值：方法调用成功返回 0，失败返回 < 0。

#### 发送媒体次要信息 (<span id="sendMediaExtraInfo">sendMediaExtraInfo</span>)

```java
public int sendMediaExtraInfo(IThunderMediaExtraInfoCallback callback)
```

发送媒体次要信息。具体约束如下：

1. 发送者必须进入房间，音频开播成功之后调用
2. 调用频率最快为100ms一次
3. 媒体次要信息大小不超过200字节
4. 可能存在丢包情况

<br>通过IThunderMediaExtraInfoCallback接口的onSendMediaExtraInfoFailedStatus获得发送媒体次要信息失败的原因。
<br>其他用户发来的媒体次要信息，通过IThunderMediaExtraInfoCallback接口中的onRecvMediaExtraInfo回调给应用程序。


| 参数    | 描述       |
| ------- | ---------- |
| data | 需要传输的媒体要信息数据，必须使用ByteBuffer.allocateDirect(int)创建 |
| dataLen | 传入的总长度，不能超过200字节 |

- 返回值：方法调用成功返回 0，失败返回 < 0。


### 事件回调（ThunderEventHandler）

#### 发生错误回调(onError)

```java
public void onError(int error)

```

暂未启用

#### 加入房间回调(<span id="onJoinRoomSuccess">onJoinRoomSuccess</span>)

```java
public void onJoinRoomSuccess(String room, String uid, int elapsed)


```

加入房间回调。

| 参数    | 描述                                                     |
| ------- | -------------------------------------------------------- |
| room    | 房间名                                                   |
| uid     | 用户ID                                                   |
| elapsed | 从调用 [joinRoom](#joinRoom) API 回调该事件的耗时（毫秒) |

#### 离开房间回调(<span id="onLeaveRoom">onLeaveRoom</span>)

```java
public void onLeaveRoom(ThunderEventHandler.RoomStats status)

```

离开房间回调。

#### SDK 鉴权结果回调（<span id="onSdkAuthResult">onSdkAuthResult</span>）

```java
public void onSdkAuthResult(int result)

```

SDK鉴权结果回调。
<br>由尚云进行的鉴权所返回结果。

| 参数   | 描述                             |
| ------ | -------------------------------- |
| result | 鉴权结果 0：成功<br>其他值：失败 |

#### 业务鉴权结果回调（<span id="onBizAuthResult">onBizAuthResult</span>）

```java
public void onBizAuthResult(boolean bPublish, int result)

```

业务鉴权结果回调。<br>
由业务进行的鉴权的返回结果，尚云会转发鉴权请求给业务鉴权服务器，并透传返回鉴权结果。

| 参数     | 描述                              |
| -------- | --------------------------------- |
| bPublish | true：开播鉴权<br>false：播放鉴权 |
| result   | 鉴权结果 0：成功<br>其他值：失败  |

#### 用户被封禁/解封回调(<span id="onUserBanned">onUserBanned</span>)

```java
public void onUserBanned(boolean status);

```

用户被封禁/解封回调。<br>

| 参数   | 描述                                      |
| ------ | ----------------------------------------- |
| status | 封禁状态：<br> ture：封禁 <br>false：解禁 |

#### 远端用户加入当前房间回调(<span id="onUserJoined">onUserJoined</span>)

```java
public void onUserJoined(String uid, int elapsed);

```

远端用户加入当前房间回调。<br>
该回调在如下情况下会被触发：<br>

- 远端用户/主播调用 joinRoom 方法加入房间 <br>
- 远端用户/主播网络中断后重新加入房间 <br>

| 参数    | 描述                                              |
| ------- | ------------------------------------------------- |
| uid     | 新加入房间的远端用户/主播 ID                      |
| elapsed | 从本地用户调用 joinRoom到触发该回调的延迟（毫秒） |

#### 远端用户离开房间回调(<span id="onUserOffline">onUserOffline</span>)

```java
public void onUserOffline(String uid, int reason);

```

远端用户离开房间回调。<br>
提示有远端用户/主播离开了房间（或掉线），用户离开房间有两个原因，即正常离开和超时掉线。<br>

| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| uid    | 远端用户/主播 ID                                             |
| reason | 离线原因：<br>1： THUNDER_OFFLINE_QUIT(0)：用户主动离开<br>2： THUNDER_OFFLINE_DROPPED(1)：因过长时间收不到对方数据包，超时掉线。注意：由于 SDK 使用的是不可靠通道，也有可能对方主动离开本方没收到对方离开消息而误判为超时掉线<br>3：THUNDER_OFFLINE_BECOME_AUDIENCE(2)：用户身份从主播切换为观众（直播模式下）（暂未实现） |



#### 远端用户静音状态回调(<span id="onRemoteAudioStopped">onRemoteAudioStopped</span>)

```java
public void onRemoteAudioStopped(String uid, boolean stop);

```

远端用户静音/取消静音通知。

| 参数 | 描述                                                         |
| ---- | ------------------------------------------------------------ |
| uid  | 远端用户/主播 ID                                             |
| stop | 该用户是否静音：<br> true: 该用户已静音音频 <br>false: 该用户已取消音频静音 |



#### Token 服务即将过期回调(<span id="onTokenWillExpire">onTokenWillExpire</span>)

```java
public void onTokenWillExpire(byte[] token);

```

Token 服务即将过期回调。<br>
在调用 joinRoom 时如果指定了 Token，由于 Token 具有一定的时效，在通话过程中如果 Token 即将失效，SDK 会提前 30 秒触发该回调，提醒 App 更新 Token。 当收到该回调时，用户需要重新在服务端生成新的 Token，然后调用 updateToken 将新生成的 Token 传给 SDK。

| 参数  | 描述                |
| ----- | ------------------- |
| token | 即将服务失效的Token |

#### Token 过期回调(<span id="onTokenRequested">onTokenRequested</span>)

```java
public void onTokenRequested();

```

Token 过期回调。<br>
在调用 joinRoom 时如果指定了 Token，由于 Token 具有一定的时效，在通话过程中 SDK 可能由于网络原因和服务器失去连接，重连时可能需要新的 Token。该回调通知 App 需要生成新的 Token，并需调用 updateToken 为 SDK 指定新的 Token。

#### 通话中每个用户的网络上下行网络质量报告回调(<span id="onNetworkQuality">onNetworkQuality</span>)

```java
public void onNetworkQuality(String uid, int txQuality, int rxQuality);

```

通话中每个用户的网络上下行网络质量报告回调。<br>
通话中每个用户的网络上下行网络质量报告回调。该回调每 5 秒触发一次。如果远端有多个用户/主播，该回调每 5 秒会被触发多次。<br>

| 参数      | 描述                                                         |
| --------- | ------------------------------------------------------------ |
| uid       | 远端用户/主播 ID                                             |
| txQuality | 该用户的上行网络质量，基于上行网络的丢包率、平均往返延时和网络抖动计算：<br>THUNDER_QUALITY_UNKNOWN(0)：质量未知<br>THUNDER_QUALITY_EXCELLENT(1)：网络质量极好<br>THUNDER_QUALITY_GOOD(2)：网络质量好<br>THUNDER_QUALITY_POOR(3)：网络质量较好，用户感受有瑕疵但不影响沟通<br>THUNDER_QUALITY_BAD(4)：网络质量一般，勉强能沟通但不顺畅<br>THUNDER_QUALITY_VBAD(5)：网络质量非常差，基本不能沟通<br>THUNDER_QUALITY_DOWN(6): 网络连接已断开，完全无法沟通 |
| rxQuality | 该用户的下行网络质量，基于下行网络的丢包率、平均往返延时和网络抖动计算：<br>THUNDER_QUALITY_UNKNOWN(0)：质量未知<br>THUNDER_QUALITY_EXCELLENT(1)：网络质量极好<br>THUNDER_QUALITY_GOOD(2)：网络质量好<br>THUNDER_QUALITY_POOR(3)：网络质量较好，用户感受有瑕疵但不影响沟通<br>THUNDER_QUALITY_BAD(4)：网络质量一般，勉强能沟通但不顺畅<br>THUNDER_QUALITY_VBAD(5)：网络质量非常差，基本不能沟通<br>THUNDER_QUALITY_DOWN(6): 网络连接已断开，完全无法沟通 |

#### 说话音量回调(<span id="onPlayVolumeIndication">onPlayVolumeIndication</span>)

```java
public void onPlayVolumeIndication(ThunderEventHandler.AudioVolumeInfo[] speakers, int totalVolume)

```

说话音量回调。	
<br>提示房间内谁正在说话以及说话者音量的回调。

| 参数        | 描述                                                         |
| ----------- | ------------------------------------------------------------ |
| speakers    | 说话者（数组）。每个 speaker包括：<br> uid：说话者的用户 ID。<br>volume：说话者的音量。<br>pts:播放时间戳 |
| totalVolume | (混音后的)总音量[0-100]                                      |

#### 采集音量回调(<span id="onCaptureVolumeIndication">onCaptureVolumeIndication</span>)

```java
public void onCaptureVolumeIndication(int totalVolume, int cpt, int micVolume)

```

采集音量回调。
<br>该回调通过 [enableCaptureVolumeIndication](#enableCaptureVolumeIndication) 接口设置。

| 参数        | 描述                                          |
| ----------- | --------------------------------------------- |
| totalVolume | 采集总音量（包含麦克风采集和文件播放）[0-100] |
| cpt         | 采集时间戳（ms）                              |
| micVolume   | 麦克风采集音量[0-100]                         |

#### 音频播放数据回调(<span id="onAudioPlayData">onAudioPlayData</span>)

```java
public void onAudioPlayData(byte[] data, long cpt, long pts, String uid, long duration)

```

音频播放数据回调。
<br>该回调将音频播放的数据（解码前）回调。

| 参数     | 描述             |
| -------- | ---------------- |
| data     | 媒体数据         |
| cpt      | 采集时间戳（ms） |
| pts      | 播放时间戳（ms） |
| uid      | 用户id           |
| duration | 播放时长（ms）   |

#### 音频播放频谱数据回调(<span id="onAudioPlaySpectrumData">onAudioPlaySpectrumData</span>)

```java
public void onAudioPlaySpectrumData(byte[] data);

```

音频播放频谱数据回调。
<br>该回调用于将播放音频的频谱数据回调给用户。

| 参数 | 描述     |
| ---- | -------- |
| data | 频谱数据 |

#### 音频采集数据回调(<span id="onAudioCapturePcmData">onAudioCapturePcmData</span>)

```java
public void onAudioCapturePcmData(byte[] data, int dataSize, int sampleRate, int room);

```

音频采集数据回调。
<br>该回调在打开音频采集回调 [enableCapturePcmDataCallBack](#enableCapturePcmDataCallBack) 开关后，将音频采集数据（PCM）回调给用户。

| 参数       | 描述          |
| ---------- | ------------- |
| data       | 采集 PCM 数据 |
| dataSize   | 数据大小      |
| sampleRate | 数据的采样率  |
| room       | 数据的声道数  |

#### 音频渲染数据回调(<span id="onAudioRenderPcmData">onAudioRenderPcmData</span>)

```java
public void onAudioRenderPcmData(byte[] data, int dataSize, long duration, int sampleRate, int room);

```

音频渲染数据回调。
<br>该回调在打开音频渲染数据回调 [enableRenderPcmDataCallBack](#enableRenderPcmDataCallBack) 开关后，将渲染音频数据（PCM）回调给用户。

| 参数       | 描述           |
| ---------- | -------------- |
| data       | 采集 PCM 数据  |
| dataSize   | 数据大小       |
| duration   | 数据时长（ms） |
| sampleRate | 数据的采样率   |
| room       | 数据的声道数   |

#### 接收业务自定义广播消息回调(<span id="onRecvUserAppMsgData">onRecvUserAppMsgData</span>)

```java
 public void onRecvUserAppMsgData(byte[] data, String uid)

```

接收业务自定义广播消息回调。
<br>该回调是回调用户消接收到的透传消息以及发该消息的用户uid。

| 参数   | 描述             |
| ------ | ---------------- |
| msgDta | 接收到的透传消息 |
| uid    | 发送该消息的uid  |

#### 业务自定义广播消息发送失败回调(<span id="onSendAppMsgDataFailedStatus">onSendAppMsgDataFailedStatus</span>)

```java
public void onSendAppMsgDataFailedStatus(int status)

```

业务自定义广播消息发送失败回调。
<br>该回调是回调当前用户发送业务自定义广播消息失败的原因，目前规定透传频率2次/s,发送数据大小限制在<=200Byte。

| 参数   | 描述                                                         |
| ------ | ------------------------------------------------------------ |
| status | 失败状态（<br> 1：频率太高 <br>2：发送数据太大 <br>3：未成功开播） |

# 附录：类成员变量

### ThunderEngine

- **混响参数（<span id="ReverbExParameter">ReverbExParameter</span>）**

```java
public static final class ReverbExParameter {
        /**
         * 房间大小; 范围: [0~100]
         */
        public float mRoomSize = 0;
        /**
         * 预延时; 范围: [0~200]
         */
        public float mPreDelay = 0;
        /**
         * 混响度; 范围: [0~100]
         */
        public float mReverberance = 0;
        /**
         * 高频因子; 范围: [0~100]
         */
        public float mHfDamping = 0;
        /**
         * 低频量; 范围: [0~100]
         */
        public float mToneLow = 0;
        /**
         * 高频量; 范围: [0~100]
         */
        public float mToneHigh = 0;
        /**
         * 湿增益; 范围: [-20~10]
         */
        public float mWetGain = 0;
        /**
         * 干增益; 范围: [-20~10]
         */
        public float mDryGain = 0;
        /**
         * 立体声宽度; 范围: [0~100]
         */
        public float mStereoWidth = 0;
    }
```

- **压缩参数（<span id="CompressorParam">CompressorParam</span>）**

```java
public static final class CompressorParam {
        /**
         * 阈值; 范围: [-40~0]
         */
        public int mThreshold = 0;
        /**
         * 增益
         */
        public int mMakeupGain = 0;
        /**
         * 比例
         */
        public int mRatio = 0;
        /**
         * 斜率
         */
        public int mKnee = 0;
        /**
         * 释放时间; 范围: 大于0
         */
        public int mReleaseTime = 0;
        /**
         * 启动时间; 范围: 大于0
         */
        public int mAttackTime = 0;
    }
```

- **限制器参数（<span id="LimterParam">LimterParam</span>）**

```java
public static final class LimterParam {
        /*
         *  -30 ~ 0
         */
        public float fCeiling = 0;
        /*
         *  -10 ~ 0
         */
        public float fThreshold = 0;
        /*
         *   0 ~ 30
         */
        public float fPreGain = 0;
        /*
         *  0 ~ 1000
         */
        public float fRelease = 0;
        /*
         *  0 ~ 1000
         */
        public float fAttack = 0;
        /*
         *   0 ~ 8
         */
        public float fLookahead = 0;
        /*
         * 0.5 ~ 2
         */
        public float fLookaheadRatio = 0;
        /*
         * 0 ~ 100
         */
        public float fRMS = 0;
        /*
         * 0 ~ 1
         */
        public float fStLink = 0;
    }
```

## 更新记录

1. java包名由`com.yy.yylivesdk4cloud.*` 改为 `com.thunder.livesdk.*`
   
   注意: 在xml配置文件也要对`com.thunder.livesdk.ThunderPreviewView` 和 `com.thunder.livesdk.ThunderPlayView`做相应修改


2. [setRoomConfig](#setRoomConfig) 接口参数发生变更

   纯音频模式下调用示例: 
   ```java
   setRoomConfig(ThunderRtcConstant.ThunderRtcProfile.THUNDER_PROFILE_ONLY_AUDIO, roomConfig);
   ```
  
  **注意: 纯音频模式下第一个参数固定为: `THUNDER_PROFILE_ONLY_AUDIO`**
  
  第二个roomlConfig参数含义: 设置场景模式， SDK 需知道应用程序的使用场景（例如通信模式或直播模式），从而使用不同的优化手段。
   
  | roomlConfig | 描述 |
  | --- | --- |
  | THUNDER_ROOMCONFIG_LIVE(0) |直播模式，质量优先，时延较大，适合观众或者听众场景，观众开播音视频变为主播时自动切换为通信模式 |
  | THUNDER_ROOMCONFIG_COMMUNICATION(1) |通信模式，追求低延时和通话流畅，适用于1v1通话和多人聊天 |
  | THUNDER_ROOMCONFIG_MULTIAUDIOROOM(4) |语音房模式，追求低延时和低带宽占用，适用于多人语音房间 |

3. Token过期回调接口 ~~`onTokenRequest`~~ 弃用，更新为 `onTokenRequested`，参数也意义不变

4. [setLogLevel](#setLogLevel)接口中level参数的枚举定义：~~`LogLevel`~~ 废弃，请使用 `ThunderLogLevel`

5. [onNetworkQuality](#onNetworkQuality) 回调取值新增:

 | 新增值 | 描述 |
 | --- | --- |
 |THUNDER_QUALITY_DOWN(6) | 网络连接已断开，完全无法沟通|

6. 新增接口列表如下：

| 方法                                                          | 功能                  |
| ------------------------------------------------------------ | -------------------- |
| [setMediaExtraInfoCallback](#setMediaExtraInfoCallback)                                                          | 设置媒体次要信息的回调监听 |
| [sendMediaExtraInfo](#sendMediaExtraInfo)                                                                        | 发送媒体次要信息 |
| [ThunderAudioFilePlayer.setPlayerLocalVolume](#ThunderAudioFilePlayer.setPlayerLocalVolume)                      | 调节音乐文件在本端播放的音量大小 |
| [ThunderAudioFilePlayer.setPlayerPublishVolume](#ThunderAudioFilePlayer.setPlayerPublishVolume)                  | 调节音乐文件在远端播放的音量大小 |
| [ThunderAudioFilePlayer.getPlayerLocalVolume](#ThunderAudioFilePlayer.getPlayerLocalVolume)                      | 获取音乐文件在本地播放的音量大小 |
| [ThunderAudioFilePlayer.getPlayerPublishVolume](#ThunderAudioFilePlayer.getPlayerPublishVolume)                  | 获取音乐文件在远端播放的音量大小 |
| [ThunderAudioFilePlayer.setLooping](#ThunderAudioFilePlayer.setLooping)                                          | 设置循环播放次数 |
| [ThunderAudioFilePlayer.selectAudioTrack](#ThunderAudioFilePlayer.selectAudioTrack)                              | 切换到指定音轨 |
| [ThunderAudioFilePlayer.getAudioTrackCount](#ThunderAudioFilePlayer.getAudioTrackCount)                          | 获取打开文件的音轨数量 |
| [IThunderAudioFilePlayerCallback.onAudioFilePlayError](#IThunderAudioFilePlayerCallback.onAudioFilePlayError)    | 播放状态回调接口 |

7. 新增回调

```java
    /**
     * 当前用户上下行流量通知
     *
     * @param stats 流量通知详细属性{@link ThunderNotification.RoomStats}
     */
    public void onRoomStats(ThunderNotification.RoomStats stats);

    /**
     * 远端用户视频流开启/停止通知
     *
     * @param uid  用户uid
     * @param stop ture：停止 false：开启
     */
    public void onRemoteVideoStopped(String uid, boolean stop);

    /**
     * 已显示远端视频首帧回调
     *
     * @param uid     用户id
     * @param width   视频尺寸 - 宽
     * @param height  视频尺寸 - 高
     * @param elapsed 从调用 [joinRoom](#joinRoom) API 到回调该事件的耗时（ms）
     */
    public void onRemoteVideoPlay(String uid, int width, int height, int elapsed);

    /**
     * 本地或远端视频分辨率改变回调
     *
     * @param uid     用户id
     * @param width
     * @param height
     * @param rotation
     */
    public void onVideoSizeChanged(String uid, int width, int height, int rotation);

    /**
     * 已发送本地音频首帧的回调
     *
     * @param elapsed 从本地用户调用 joinRoom 方法直至该回调被触发的延迟（毫秒）
     */
    void onFirstLocalAudioFrameSent(int elapsed);

    /**
     * 已发送本地视频首帧的回调
     *
     * @param elapsed 从本地用户调用 joinRoom 方法直至该回调被触发的延迟（毫秒）
     */
    void onFirstLocalVideoFrameSent(int elapsed);

    /**
     * cdn推流结果回调
     *
     * @param url       推流的目标url
     * @param errorCode 推流错误码 {@link ThunderRtcConstant.ThunderPublishCDNErrorCode}
     */
    void onPublishStreamToCDNStatus(String url, int errorCode);

    /**
     * 网络连接类型变化回调
     *
     * @param type 网络连接类型 {@link ThunderRtcConstant.ThunderNetworkType}
     */
    void onNetworkTypeChanged(int type);

    /**
     * 与服务器网络连接状态回调(service和avp)
     * thunder模式下，只看跟avp的连接状态
     * thunderbolt模式下且没有开播或订阅（不会连接avp）只看service连接状态
     * thunderbolt模式下且有开播或订阅，同时看service和avp的连接状态
     *
     * @param status {@link ThunderRtcConstant.ThunderConnectionStatus}
     */
    void onConnectionStatus(int status);
```