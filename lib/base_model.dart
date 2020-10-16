/*
* 试图显示模式
* */
enum VideoRenderMode {
  FILL, //0 铺满窗口，如果比例不适应的，会拉伸以铺满窗口
  ASPECT_FIT, //1 适应窗口，如果比例不适应，会留黑边
  CLIP_TO_BOUNDS, //2 铺满窗口，如果比例不适应，会截取
}

int intFromVideoRenderMode(VideoRenderMode renderMode) {
  if (renderMode == null || renderMode.index > 2) {
    return 2;
  }
  return renderMode.index;
}

/*
* 场景模式
* */
enum RtcScenarioMode {
  DEFAULT, //0 默认=1
  STABLE_FIRST, //1 流畅优先：推荐注重稳定的教育
  QUALITY_FIRST, //2 音质优先：推荐很少或者不连麦的秀场
}

int intFromRtcScenarioMode(RtcScenarioMode mode) {
  if (mode == null || mode.index > 2) {
    return 1;
  }
  return mode.index;
}

/*
* 音频属性
* */
enum RtcAudioConfig {
  DEFAULT, //0 默认设置。通信模式下为 1，直播模式下为 2
  SPEECH_STANDARD, //1 指定 16 KHz采样率，语音编码, 单声道，编码码率约 18 kbps
  STANDARD_STEREO, //2 指定 44.1 KHz采样率，音乐编码, 双声道，编码码率约 24 kbps，编码延迟高
  STANDARD, // 3 指定 44.1 KHz采样率，音乐编码, 双声道，编码码率约 40 kbps，编码延迟低
  HIGH_QUALITY_STEREO, //4 指定 44.1KHz采样率，音乐编码, 双声道，编码码率约 128kbps
  HIGH_QUALITY_STEREO_192, // 5 指定 44.1KHz采样率，音乐编码, 双声道，编码码率约 192kbps
}

int intFromRtcAudioConfig(RtcAudioConfig config) {
  if (config == null || config.index > 5) {
    return 0;
  }
  return config.index;
}

/*
* 交互模式
* */
enum RtcCommuteMode {
  DEFAULT, //0 默认=1
  HIGH, //1 强交互模式
  LOW, //2 弱交互模式
}

int intFromRtcCommuteMode(RtcCommuteMode mode) {
  if (mode == null || mode.index > 2) {
    return 1;
  }
  return mode.index;
}

/*
* 音频开播模式
* */
enum ThunderSourceType {
  AUDIO_MIC, //0 仅麦克风
  AUDIO_FILE, //1 仅文件
  AUDIO_MIX, //2 麦克风和文件
  NONE, //10 停止所有音频数据上行
}

int intFormThunderSourceType(ThunderSourceType sourceType) {
  assert(sourceType != null, "fail: sourceType is null");
  switch (sourceType) {
    case ThunderSourceType.NONE:
      return 10;
    default:
      return sourceType.index;
  }
}

/*
* 开播玩法
* */
enum PublishPlayType {
  SINGLE, //0 单人开播
  INTERACT, //1 视频连麦开播
  SCREENCAP, //2 录屏开播
  MULTI_INTERACT, //3 视频多人连麦开播
}

int intFromPublishPlayType(PublishPlayType type) {
  if (type == null) {
    return 0;
  }
  return type.index;
}

/*
* 视频编码类型
* */
enum PublishVideoMode {
  DEFAULT, //-1未定义，由配置自由决定开播清晰度
  NORMAL, //1 普通
  HIGHQULITY, //2 高清
  SUPERQULITY, //3 超清
  BLUERAY_2M, //4 蓝光2M
  BLUERAY_4M, //5 蓝光4M
  BLUERAY_6M, //6 蓝光6M
  BLUERAY_8M, // 7 蓝光8M
  FLUENCY, //8 流畅
}

int intFromPublishVideoMode(PublishVideoMode mode) {
  if (mode == null || mode.index > 8) {
    return 1; //默认是流畅
  }
  return mode.index;
}

enum AreaType {
  THUNDER_AREA_DEFAULT, //0	默认值（国内），等同于 THUNDER_AREA_RESERVED(1)
  THUNDER_AREA_FOREIGN, //1 国外
}

/*
* 摄像头镜像
* */
enum VideoMirrorMode {
  NO_MIRROR, // 0 预览镜像，推流不镜像
  BOTH_MIRROR, // 1 预览推流都镜像
  BOTH_NO_MIRROR, // 2 预览推流都不镜像
  PUBLISH_MIRROR, // 3 预览不镜像，开播镜像
}

int intFromVideoMirrorMode(VideoMirrorMode mode) {
  if (mode == null || mode.index > 3) {
    return 2;
  }
  return mode.index;
}

/*
* 横竖屏
* */
enum VideoCaptureOrientation {
  PORTRAIT, //0 竖屏
  LANDSCAPE, //1 横屏
}

int intFromVideoCaptureOrientation(VideoCaptureOrientation orientation) {
  if (orientation == null || orientation.index > 1) {
    return 0;
  }
  return orientation.index;
}

/*
* 设置SDK运行模式；注意：不同模式之间不互通！joinRoom之前调用！
* */
enum RtcConfig {
  DEFAULT, //0 默认模式。 =1
  NORMAL, //1 音视频模式
  ONLY_AUDIO, //2 纯语音模式；针对纯语音优化
}

int intFromRtcConfig(RtcConfig config) {
  if (config == null || config.index > 2) {
    return 1;
  }
  return config.index;
}

/*
* 房间模式
* */
enum RtcRoomConfig {
  LIVE, //0 直播 （音质高、交互模式无）（连麦时切换到音质中、交互模式强）
  COMMUNICATION, //1 通信 （音质中、交互模式强）
  NO_USE_2, //dart占位值，禁止使用
  GAME, //3 游戏（音质低、交互模式强）
  MULTIAUDIOROOM, //4 多人语音房间 (音质中、省流量、交互模式强)
  CONFERRENCE, //5 会议（音质中、交互模式墙、是用频繁上下麦，上下麦流畅不卡顿)
}

int intFromRtcRoomConfig(RtcRoomConfig config) {
  if (config == null || config.index > 5) {
    return 0;
  }
  return config.index;
}

/*
* SDK鉴权结果回调， 由尚云进行的鉴权所返回结果
* */
enum RtcSdkAuthResult {
  SUCCUSS, //0鉴权成功
  SERVER_INTERNAL, //10000服务器内部错误，可以重试
  NO_TOKEN, //10001 没有带token，需要调用[ThunderAPI updateToken:]
  TOKEN_ERR, //10002 token校验失败（数字签名不对），可能使用的appSecret不对
  ERR_APPID, //10003 token中appid跟鉴权时带的appid不一致
  ERR_UID, //10004 token中uid跟鉴权时带的uid不一致
  TOKEN_EXPIRE, //10005 token已过期
  NO_APP, //10006 app不存在，没有在管理后台注册
  TOKEN_WILL_EXPIRE, //10007 token即将过期
  ERR_BAND, //10008 用户被封禁
}

RtcSdkAuthResult rtcSdkAuthResultFromInt(int result) {
  switch (result) {
    case 0:
      return RtcSdkAuthResult.SUCCUSS;
    case 10000:
      return RtcSdkAuthResult.SERVER_INTERNAL;
    case 10001:
      return RtcSdkAuthResult.NO_TOKEN;
    case 10002:
      return RtcSdkAuthResult.TOKEN_ERR;
    case 10003:
      return RtcSdkAuthResult.ERR_APPID;
    case 10004:
      return RtcSdkAuthResult.ERR_UID;
    case 10005:
      return RtcSdkAuthResult.TOKEN_EXPIRE;
    case 10006:
      return RtcSdkAuthResult.NO_APP;
    case 10007:
      return RtcSdkAuthResult.TOKEN_WILL_EXPIRE;
    case 10008:
      return RtcSdkAuthResult.ERR_BAND;
  }
}

/*
* 离线原因
* */
enum RtcUserOfflineReason {
  QUIT, //1用户主动离开
  DROPPED, //2因长时间收不到对方数据，超时掉线
  BECOME_AUDIENCE, //3用户身份从主播切换为观众（直播模式下）
}

RtcUserOfflineReason rtcUserOfflineReason(int reason) {
  switch (reason) {
    case 0:
      return RtcUserOfflineReason.QUIT;
    case 1:
      return RtcUserOfflineReason.DROPPED;
    case 3:
      return RtcUserOfflineReason.BECOME_AUDIENCE;
  }
}

/*
* sdk与服务器的连接状态
* */
enum ConnectionStatus {
  CONNECTING, //0 连接中
  CONNECTED, //1 连接成功
  DISCONNECTED, //2 连接断开
}

ConnectionStatus sdkConnectionStatus(int type) {
  switch (type) {
    case 0:
      return ConnectionStatus.CONNECTING;
    case 1:
      return ConnectionStatus.CONNECTED;
    case 2:
      return ConnectionStatus.DISCONNECTED;
  }
}

/*
* 网络上行、下行质量
* */
enum RtcNetworkQuality {
  UNKNOWN, //0质量未知
  EXCELLENT, //1网络质量极好
  GOOD, //2网络质量好
  POOR, //3网络质量较好，用户感受有瑕疵但不影响沟通
  BAD, //4网络质量一般，勉强能沟通但不顺畅
  VBAD, //5网络质量非常差，基本不能沟通
  DOWN, //6网络连接已断开，完全无法沟通
}

RtcNetworkQuality rtcNetworkQualityFromType(int type) {
  switch (type) {
    case 0:
      return RtcNetworkQuality.UNKNOWN;
    case 1:
      return RtcNetworkQuality.EXCELLENT;
    case 2:
      return RtcNetworkQuality.GOOD;
    case 3:
      return RtcNetworkQuality.POOR;
    case 4:
      return RtcNetworkQuality.BAD;
    case 5:
      return RtcNetworkQuality.VBAD;
    case 6:
      return RtcNetworkQuality.DOWN;
    default:
      return RtcNetworkQuality.UNKNOWN;
  }
}

/*
* 多人视图玩法
* */
enum RtcRemotePlayType {
  NORMAL, //0单人开播 或者双人连麦
  MULTI, //1多人连麦
}

int intFromRtcRemotePlayType(RtcRemotePlayType type) {
  if (type.index > 1 || type == null) {
    return 0;
  }
  return type.index;
}

/*
* 原始音频数据使用模式
* */
enum AudioRawFrameOperationMode {
  READ_ONLY, //1只读模式，用户仅从 AudioFrame 获取原始数据
  WRITE_ONLY, //2只写模式，用户替换 AudioFrame 中的数据以供 SDK 编码传输
  READ_WRITE, //3读写模式，用户从 AudioFrame 获取并修改数据，并返回给 SDK 进行编码传输
}

int intFromAudioRawFrameOperationMode(AudioRawFrameOperationMode mode) {
  if (mode == null) {
    return 0;
  }
  return mode.index + 1;
}

/*
* 多人连麦view的坐标
* */
class MultiVideoViewCoordinate {
  int x;
  int y;
  int width;
  int height;
  int index; //麦序

  MultiVideoViewCoordinate(this.x, this.y, this.width, this.height, this.index);

  Map toMap() {
    Map map = new Map();
    map['x'] = x;
    map['y'] = y;
    map['width'] = width;
    map['height'] = height;
    map['index'] = index;
    map.removeWhere((k, v) => v == null);
    return map;
  }

  MultiVideoViewCoordinate.fromMap(jsonMap) {
    x = jsonMap ?? jsonMap['x'];
    y = jsonMap ?? jsonMap['y'];
    width = jsonMap ?? jsonMap['width'];
    height = jsonMap ?? jsonMap['height'];
    index = jsonMap ?? jsonMap['index'];
  }
}

class RtcAudioVolumeInfo {
  String uid;
  int volume;
  int pts;

  RtcAudioVolumeInfo(this.uid, this.pts, this.volume);

  RtcAudioVolumeInfo.fromMap(jsonMap) {
    uid = jsonMap ?? jsonMap['uid'];
    volume = jsonMap ?? jsonMap['volume'];
    pts = jsonMap ?? jsonMap['pts'];
  }

  Map toMap() {
    Map map = new Map();
    map['uid'] = uid;
    map['volume'] = volume;
    map['pts'] = pts;
    map.removeWhere((k, v) => v == null);
    return map;
  }
}

enum NetworkType {
  THUNDER_NETWORK_TYPE_UNKNOWN, //(0)	未能识别网络类型
  THUNDER_NETWORK_TYPE_DISCONNECTED, //(1)	网络不通
  THUNDER_NETWORK_TYPE_CABLE, //(2)	有线网络
  THUNDER_NETWORK_TYPE_WIFI, //(3)	无线Wi-Fi，含wifi热点
  THUNDER_NETWORK_TYPE_MOBILE, //(4)	移动网络，没能区分2G,3G,4G网络
  THUNDER_NETWORK_TYPE_MOBILE_2G, //(5)	2G
  THUNDER_NETWORK_TYPE_MOBILE_3G, //(6)	3G
  THUNDER_NETWORK_TYPE_MOBILE_4G, //(7)	4G
}

NetworkType networkTypeFromInt(int type) {
  if (type == 1) {
    return NetworkType.THUNDER_NETWORK_TYPE_DISCONNECTED;
  } else if (type == 2) {
    return NetworkType.THUNDER_NETWORK_TYPE_CABLE;
  } else if (type == 3) {
    return NetworkType.THUNDER_NETWORK_TYPE_WIFI;
  } else if (type == 4) {
    return NetworkType.THUNDER_NETWORK_TYPE_MOBILE;
  } else if (type == 5) {
    return NetworkType.THUNDER_NETWORK_TYPE_MOBILE_2G;
  } else if (type == 6) {
    return NetworkType.THUNDER_NETWORK_TYPE_MOBILE_3G;
  } else if (type == 7) {
    return NetworkType.THUNDER_NETWORK_TYPE_MOBILE_4G;
  }
  return NetworkType.THUNDER_NETWORK_TYPE_UNKNOWN;
}

/*
 * 美颜滤镜风格
 */
enum ThunderBeautyLookUpTable {
  BASE,
  COOL,
  SPRING,
  SWEET,
  WARM,
}

intFromEnum(dynamic enumVar, {int plus = 0}) {
  return enumVar.index + plus;
}
