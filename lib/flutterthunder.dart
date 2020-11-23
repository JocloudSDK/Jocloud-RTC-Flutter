library thunder;

export 'base_model.dart';
export 'thunder_event.dart';
export 'thunder_renderWidget.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterthunder/base_model.dart';
import 'base_model.dart';
import 'thunder_event.dart';
import 'package:flutter/foundation.dart';

const String kLogTag = "FlutterThunderDart";

const String kThunderChannel = "flutterthunder";
const String kEventChannel = "flutterthunder_event_channel";
const String kRenderViewType = "ThunderRenderView";

class FlutterThunder {
  static const MethodChannel _channel = MethodChannel(kThunderChannel);

  static MethodChannel get channel => _channel;

  static const EventChannel _eventChannel = const EventChannel(kEventChannel);
  static StreamSubscription<dynamic> _sink;
  static List<ThunderEventHandler> _handlers = [];

  static Future<void> _addEventChannelHandler() async {
    _sink = _eventChannel.receiveBroadcastStream(kEventChannel).listen(_onRcvBroadcast, onError: _onRcvBroadcastError);
  }

  static Future<void> _removeEventChannelHandler() async {
    if (_sink != null) {
      _handlers.clear();
      await _sink.cancel();
    }
  }

  static void _onRcvBroadcast(Object msg) {
    if (_handlers.isEmpty || _handlers == null) {
      return;
    }

    if (msg is Map) {
      String broadcastName = msg["broadcastName"] as String;
      Map data = msg["broadcastData"] as Map;

      switch (broadcastName) {
        case "onJoinRoomSuccess":
          _onJoinRoomSuccess(data);
          break;
        case "onLeaveRoomWithStats":
          _onLeaveRoomWithStats();
          break;
        case "onSdkAuthResult":
          _onSdkAuthResult(data);
          break;
        case "onRemoteVideoPlay":
          _onRemoteVideoPlay(data);
          break;
        case "onFirstLocalVideoFrameSent":
          _onFirstLocalVideoFrameSent();
          break;
        case "onUserJoined":
          _onUserJoined(data);
          break;
        case "onUserOffline":
          _onUserOffline(data);
          break;
        case "onRemoteVideoStopped":
          _onRemoteVideoStopped(data);
          break;
        case "onVideoSizeChangedOfUid":
          _onVideoSizeChangedOfUid(data);
          break;
        case "onNetworkTypeChanged":
          _onNetworkTypeChanged(data);
          break;
        case "onConnectionStatus":
          _onConnectionStatus(data);
          break;
        case "onRemoteAudioStopped":
          _onRemoteAudioStopped(data);
          break;
        case "onNetworkQuality":
          _onNetworkQuality(data);
          break;
        case "onPlayVolumeIndication":
          _onPlayVolumeIndication(data);
          break;
        case "onBizAuthResult":
          _onBizAuthResult(data);
          break;
        case "onCaptureVolumeIndication":
          _onCaptureVolumeIndication(data);
          break;
        case "onQualityLogFeedback":
          _onQualityLogFeedback(data);
          break;
      }
    }
  }

  static void _onBizAuthResult(Map data) {
    bool bPublish = data["bPublish"];
    int result = data["result"];
    _handlers.forEach((handler) {
      handler.onBizAuthResult(bPublish, result);
    });
  }

  static void _onJoinRoomSuccess(Map data) {
    String uid = data["uid"];
    String roomName = data["roomName"];
    _handlers.forEach((handler) {
      handler.onJoinRoomSuccess(uid, roomName);
    });
  }

  static void _onLeaveRoomWithStats() {
    _handlers.forEach((handler) {
      handler.onLeaveRoomWithStats();
    });
  }

  static void _onSdkAuthResult(Map data) {
    int authResult = data["result"];
    RtcSdkAuthResult result = rtcSdkAuthResultFromInt(authResult);
    _handlers.forEach((handler) {
      handler.onSdkAuthResult(result);
    });
  }

  static void _onRemoteVideoPlay(Map data) {
    String uid = data["uid"];
    double width = data["width"];
    double height = data["height"];
    _handlers.forEach((handler) {
      handler.onRemoteVideoPlay(uid, Size(width, height));
    });
  }

  static void _onFirstLocalVideoFrameSent() {
    _handlers.forEach((handler) {
      handler.onFirstLocalVideoFrameSent();
    });
  }

  static void _onUserJoined(Map data) {
    String uid = data["uid"];
    _handlers.forEach((handler) {
      handler.onUserJoined(uid);
    });
  }

  static void _onUserOffline(Map data) {
    String uid = data["uid"];
    int reason = data["reason"];
    RtcUserOfflineReason rtcReason = rtcUserOfflineReason(reason);
    _handlers.forEach((handler) {
      handler.onUserOffline(uid, rtcReason);
    });
  }

  static void _onRemoteVideoStopped(Map data) {
    String uid = data["uid"];
    bool stopped = data["stopped"];
    _handlers.forEach((handler) {
      handler.onRemoteVideoStopped(uid, stopped);
    });
  }

  static void _onVideoSizeChangedOfUid(Map data) {
    String uid = data["uid"];
    double width = data["width"];
    double height = data["height"];
    int rotation = data["rotation"];
    _handlers.forEach((handler) {
      handler.onVideoSizeChangedOfUid(uid, Size(width, height), rotation);
    });
  }

  static void _onNetworkTypeChanged(Map data) {
    int type = data["type"];
    _handlers.forEach((handler) {
      handler.onNetworkTypeChanged(networkTypeFromInt(type));
    });
  }

  static void _onConnectionStatus(Map data) {
    int type = data["type"];
    _handlers.forEach((handler) {
      handler.onConnectionStatus(sdkConnectionStatus(type));
    });
  }

  static void _onRemoteAudioStopped(Map data) {
    String uid = data["uid"];
    bool stopped = data["stopped"];
    _handlers.forEach((handler) {
      handler.onRemoteAudioStopped(uid, stopped);
    });
  }

  static void _onNetworkQuality(Map data) {
    String uid = data["uid"];
    int rxQualityType = data["rxQuality"];
    int txQualityType = data["txQuality"];

    RtcNetworkQuality txQuality = rtcNetworkQualityFromType(txQualityType);
    RtcNetworkQuality rxQuality = rtcNetworkQualityFromType(rxQualityType);

    _handlers.forEach((handler) {
      handler.onNetworkQuality(uid, txQuality: txQuality, rxQuality: rxQuality);
    });
  }

  static void _onPlayVolumeIndication(Map data) {
    int totalVolume = data["totalVolume"];
    List dataList = data["speakers"] as List;

    List<RtcAudioVolumeInfo> speakers = [];
    dataList.forEach((value) {
      if (value is Map) {
        String uid = value["uid"];
        int pts = value["pts"];
        int volume = value["volume"];
        RtcAudioVolumeInfo info = RtcAudioVolumeInfo(uid, pts, volume);
        speakers.add(info);
      }
    });

    _handlers.forEach((handler) {
      handler.onPlayVolumeIndication(speakers, totalVolume);
    });
  }

  static void _onCaptureVolumeIndication(Map data) {
    int totalVolume = data["totalVolume"];
    int cpt = data["cpt"];
    int micVolume = data["micVolume"];

    _handlers.forEach((handler) {
      handler.onCaptureVolumeIndication(totalVolume, cpt, micVolume);
    });
  }

  static void _onQualityLogFeedback(Map data) {
    String description = data["description"];
    _handlers.forEach((handler) {
      handler.onQualityLogFeedback(description);
    });
  }

  static void _onRcvBroadcastError(Object error) {
    print("$kLogTag - _onRcvBroadcastError error: $error");
  }

  static void addEventHandler(ThunderEventHandler handler) {
    _handlers.add(handler);
  }

  static void removeEventHandler(ThunderEventHandler handler) {
    _handlers.remove(handler);
  }

  /*
  * @brief 初始化,创建ThunderEngine
  * @param appId 接入app的唯一标识
  * @param area 区域
  * */
  static Future<void> createEngine(String appId, AreaType areaType) async {
    Map params = {"appId": appId, "area": intFromEnum(areaType), "is64bitUid": true};
    print("$kLogTag - createEngine appid : $appId, area: ${intFromEnum(areaType)}");

    assert(appId != null, "failed: create engine appId is null"); //release 模式需要屏蔽
    //sdk暂时不支持多实例
    if (appId == null) {
      return;
    }
    params.removeWhere((k, v) => v == null);
    await _addEventChannelHandler();
    await _channel.invokeMethod('createEngine', params);
  }

  /*
  * @brief 销毁ThunderEngine对象,退出App生命周期或者收到异常退出需要执行该方法
  * */
  static Future<void> destroyEngine() async {
    print("$kLogTag - destroy engine");
    await _removeEventChannelHandler();
    await _channel.invokeMethod('destroyEngine');
  }

  /*
  * @brief 订阅用户
  * @param roomId 房间号
  * @param uid 用户uid
  * @return 方法调用成功返回 0，失败返回 < 0
  * */

  static Future<int> addSubscribe(String uid, String roomId) async {
    print("$kLogTag - addSubscribe uid : $uid, roomId: $roomId");
    assert(uid != null && roomId != null, "failed: addSubscribe uid is $uid, roomId is $roomId");

    if (uid == null || roomId == null) {
      return -1;
    }
    Map params = {"uid": uid, "roomId": roomId};
    int code = await _channel.invokeMethod("addSubscribe", params);
    return code;
  }

  /*
  * @brief 删除用户
  * @param roomId 房间号
  * @param uid 用户uid
  * @return 方法调用成功返回 0，失败返回 < 0
  * */
  static Future<int> removeSubscribe(String uid, String roomId) async {
    print("$kLogTag - removeSubscribe uid : $uid, roomId: $roomId");
    assert(uid != null && roomId != null, "failed: removeSubscribe uid is $uid, roomId is $roomId ");
    if (uid == null || roomId == null) {
      return -1;
    }
    Map params = {"uid": uid, "roomId": roomId};
    int code = await _channel.invokeMethod("addSubscribe", params);
    return code;
  }

  /*
  * * 更新token，用于appid和业务功能鉴权
  * <br> token 格式
  * <br> -------------------------------------------------------------------------------------------------
  * <br> | TokenLen(uint16)    | AppId(uint32)        | uid (uint64)          | Timestamp(uint64)(ms)    |
  * <br> -------------------------------------------------------------------------------------------------
  * <br> | ValidTime(uint32)(s)| BizExtInfoLen(uint16)| BizExtInfoData(nBytes)| DigitalSignature(20Bytes)|
  * <br> -------------------------------------------------------------------------------------------------
  * <br> 1. 多字节整数使用网络字节序
  * <br> 2. TokenLen：整个token长度，包括自身2字节和摘要
  * <br> 3. 过期时间=Timestamp+ValidTime*1000, UTC时间距离1970的毫秒数
  * <br> 4. BizExtInfoData: 业务鉴权可能需要的扩展信息，透传
  * <br> 5. DigitalSignature：采用hmac-sha1算法对DigitalSignature前的所有数据运算得出[TokenLen,BizExtInfoData], 秘钥使用申请appId时分配的appSecret
  * <br> 6. 整个token 进行 url安全的 base64编码
  *
  * @param token 业务服务器生成的token，需要url base64编码
  *
  * 通过监听通知 kThunderAPINotification_BizAuthRes, kThunderAPINotification_SdkAuthRes获取鉴权结果
  * {@link ThunderNotification#kThunderAPINotification_BizAuthRes}
  * {@link ThunderNotification#kThunderAPINotification_SdkAuthRes}
  * */
  static Future<int> updateToken(String token) async {
    print("$kLogTag - updateToken token: $token");
    assert(token != null, "failed: updateToken token is null");
    Map params = {"token": token};
    int code = await _channel.invokeMethod("updateToken", params);
    return code;
  }

  static Future<int> leaveRoom() async {
    print("$kLogTag - leaveRoom");
    int code = await _channel.invokeMethod('leaveRoom');
    return code;
  }

  static Future<int> joinRoom(String token, String roomName, String uid) async {
    print("$kLogTag - joinRoom token: $token, roomName: $roomName, uid:$uid");

    assert(uid != null, "failed: joinRoom uid is null");
    Map params = {"token": token, "roomName": roomName, "uid": uid};
    int code = await _channel.invokeMethod('joinRoom', params);
    return code;
  }

  /*
   * @brief 设置房间模式
   * @param [IN] mode 房间模式 RtcRoomConfig
   * @remark 需在"初始化"后，仅在destroyEngine被重置
   */
  static Future<int> setRoomMode(RtcRoomConfig roomConfig) async {
    print("$kLogTag - setRoomMode $roomConfig");
    Map params = {"roomConfig": intFromRtcRoomConfig(roomConfig)};
    int code = await _channel.invokeMethod("setRoomMode", params);
    return code;
  }

  /*
   * @brief 设置媒体模式
   * @param [IN] mode 媒体模式 RtcConfig
   * @remark 需要"初始化"后、"进入房间"前调用，仅在destroyEngine被重置
   */
  static Future<int> setMediaMode(RtcConfig rtcConfig) async {
    print("$kLogTag - setMediaMode: $rtcConfig");

    Map params = {"rtcConfig": intFromRtcConfig(rtcConfig)};
    int code = await _channel.invokeMethod("setMediaMode", params);
    return code;
  }

  //新增接口 混流多人连麦场景使用
  static Future<int> setRemotePlayType(RtcRemotePlayType type) async {
    print("$kLogTag - setRemotePlayType: $type");
    Map params = {"remotePlayType": intFromRtcRemotePlayType(type)};
    int code = await _channel.invokeMethod("setRemotePlayType", params);
    return code;
  }

  static Widget createNativeView(Function(int viewId) created, {Key key}) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        key: key,
        viewType: kRenderViewType,
        onPlatformViewCreated: (viewId) {
          if (created != null) {
            created(viewId);
          }
        },
      );
    } else {
      try {
        return AndroidView(
          key: key,
          viewType: kRenderViewType,
          onPlatformViewCreated: (viewId) {
            if (created != null) {
              created(viewId);
            }
          },
        );
      } catch (e) {
        print("$kLogTag - catch AndroidView exception: $e");
        return Container();
      }
    }
  }

  static Future<void> removeNativeView(int viewId) async {
    print("$kLogTag - removeNativeView viewId: $viewId");
    if (viewId == null) {
      return;
    }
    await _channel.invokeMethod("removeNativeView", {"viewId": viewId});
  }

  static Future<int> setLogFilePath(String path) async {
    print("$kLogTag - setLogFilePath path: $path");
    assert(path != null);
    if (path == null) {
      return -1;
    }
    int code = await _channel.invokeMethod("setLogFilePath", {"path": path});
    return code;
  }

  static Future<int> setAudioConfig(
      RtcAudioConfig config, RtcCommuteMode commuteMode, RtcScenarioMode scenarioMode) async {
    print("$kLogTag - setAudioConfig config: $config, commutMode: $commuteMode, scenarioMode: $scenarioMode");
    Map params = {
      "config": intFromRtcAudioConfig(config),
      "commutMode": intFromRtcCommuteMode(commuteMode),
      "scenarioMode": intFromRtcScenarioMode(scenarioMode)
    };
    params.removeWhere((k, v) => v == null);
    int code = await _channel.invokeMethod("setAudioConfig", params);
    return code;
  }

  static Future<void> setAudioSourceType(ThunderSourceType sourceType) async {
    print("$kLogTag - setAudioSourceType sourceType: $sourceType");
    Map params = {"sourceType": intFormThunderSourceType(sourceType)};
    await _channel.invokeMethod("setAudioSourceType", params);
  }

  static Future<int> setAudioVolumeIndication(int interval, int moreThanThd, int lessThanThd, int smooth) async {
    print(
        "$kLogTag - setAudioVolumeIndication interval: $interval, moreThanThd: $moreThanThd, lessThanThd: $lessThanThd, soomth:$smooth");
    Map params = {"interval": interval, "moreThanThd": moreThanThd, "lessThanThd": lessThanThd, "soomth": smooth};
    params.removeWhere((k, v) => v == null);
    int code = await _channel.invokeMethod("setAudioVolumeIndication", params);
    return code;
  }

  static Future<int> stopLocalAudioStream(bool stopped) async {
    print("$kLogTag - stopLocalAudioStream stopped: $stopped");
    Map map = {"stopped": stopped};
    int code = await _channel.invokeMethod("stopLocalAudioStream", map);
    return code;
  }

  static Future<int> stopRemoteAudioStream(String uid, bool stopped) async {
    print("$kLogTag - stopRemoteAudioStream interval: $uid, stopped: $stopped");
    assert(uid != null, "failed: stopRemoteAudioStream uid is null");
    Map params = {"uid": uid, "stopped": stopped};
    params.removeWhere((k, v) => v == null);
    int code = await _channel.invokeMethod("stopRemoteAudioStream", params);
    return code;
  }

  static Future<int> stopAllRemoteAudioStreams(bool stopped) async {
    print("$kLogTag - stopAllRemoteAudioStreams stopped: $stopped");
    Map params = {"stopped": stopped};
    int code = await _channel.invokeMethod("stopAllRemoteAudioStreams", params);
    return code;
  }

  static Future<int> enableCaptureVolumeIndication(int interval, int moreThanThd, int lessThanThd, int smooth) async {
    print(
        "$kLogTag - setAudioVolumeIndication interval: $interval, moreThanThd: $moreThanThd, lessThanThd: $lessThanThd, soomth:$smooth");

    Map params = {"interval": interval, "moreThanThd": moreThanThd, "lessThanThd": lessThanThd, "soomth": smooth};
    params.removeWhere((k, v) => v == null);
    int code = await _channel.invokeMethod("enableCaptureVolumeIndication", params);
    return code;
  }

  static Future<int> enableLoudspeaker(bool enable) async {
    print("$kLogTag - enableLoudspeaker enable:$enable ");
    Map params = {"enable": enable};
    int code = await _channel.invokeMethod("enableLoudspeaker", params);
    return code;
  }

  static Future<bool> isLoudspeakerEnabled() async {
    bool resp = await _channel.invokeMethod("isLoudspeakerEnabled");
    return resp;
  }

  static Future<int> setLoudSpeakerVolume(int volume) async {
    print("$kLogTag - setLoudSpeakerVolume volume:$volume ");
    Map params = {"volume": volume};
    int code = await _channel.invokeMethod("setLoudSpeakerVolume", params);
    return code;
  }

  static Future<int> setMicVolume(int volume) async {
    print("$kLogTag - setMicVolume volume:$volume ");
    Map params = {"volume": volume};
    int code = await _channel.invokeMethod("setMicVolume", params);
    return code;
  }

  static Future<void> setRemoteAudioStreamsVolume(String uid, int volume) async {
    assert(uid != null, "failed: setPlayVolume uid is null");
    Map params = {"uid": uid, "volume": volume};
    int code = await _channel.invokeMethod("setPlayVolume", params);
    return code;
  }

  //配置码率、推流类型
  static Future<int> setVideoEncoderConfig(PublishVideoMode mode, PublishPlayType playType) async {
    print("$kLogTag - setVideoEncoderConfig videoMode: $mode, publishPlayType: $playType");
    assert(mode != null && playType != null, "failed: setVideoEncoderConfig videoMode: $mode, playType: $playType");
    Map params = {"mode": intFromPublishVideoMode(mode), "playType": intFromPublishPlayType(playType)};
    int code = await _channel.invokeMethod("setVideoEncoderConfig", params);
    return code;
  }

  /*
  * 设置主播视频画布
  * uid: 主播uid
  * viewId: 请传入createNativeView方法onCreated中回调的viewId，否则会出错
  * mode: 试图显示模式
  * */
  static Future<int> setLocalVideoCanvas(String uid, int viewId, VideoRenderMode mode) async {
    print("$kLogTag - setLocalVideoCanvas uid: $uid, viewId: $viewId, videoRenderMode: $mode");

    assert(viewId != null && uid != null, "failed: setLocalVideoCanvas viewId is $viewId, uid is $uid");
    if (viewId == null || uid == null) {
      return -1;
    }

    Map params = {
      "viewId": viewId,
      "renderMode": intFromVideoRenderMode(mode),
      "uid": uid,
    };
    int code = await _channel.invokeMethod("setLocalVideoCanvas", params);
    return code;
  }

  /*
  * 解除推流的view跟uid的绑定关系
  * uid： 主播的uid
  * */
  static Future<int> unbindLocalVideoCanvas(String uid) async {
    assert(uid != null, "failed: unbindLocalVideoCanvas  uid is $uid");
    if (uid == null) {
      return -1;
    }
    int code = await _channel.invokeMethod("unbindLocalVideoCanvas", {"uid": uid});
    return code;
  }

  /*
  * 设置远端视频画布
  * uid: 主播的uid
  * viewId: 请传入createNativeView方法onCreated回调的viewId，否则会出错
  * mode: 视图显示模式
  * seatIndex: 麦序，多人混画模式连麦场景需要此参数，如9人连麦麦序从0~8
  * */
  static Future<int> setRemoteVideoCanvas(String uid, int viewId, VideoRenderMode mode, int seatIndex) async {
    print("$kLogTag - setRemoteVideoCanvas uid: $uid, viewId: $viewId, videoRenderMode: $mode, seatIndex: $seatIndex");

    assert(viewId != null && uid != null, "failed: setRemoteVideoCanvas viewId is $viewId, uid is $uid");
    if (viewId == null || uid == null) {
      return -1;
    }

    Map params = {
      "viewId": viewId,
      "uid": uid,
      "renderMode": intFromVideoRenderMode(mode),
      "seatIndex": seatIndex,
    };
    params.removeWhere((k, v) => v == null);
    int code = await _channel.invokeMethod("setRemoteVideoCanvas", params);
    return code;
  }

  /*
  * 解除远端view的绑定
  * uid: 主播的uid
  * */
  static Future<int> unbindRemoteVideoCanvas(String uid) async {
    assert(uid != null, "failed: unbindRemoteVideoCanvas  uid is $uid");
    if (uid == null) {
      return -1;
    }
    int code = await _channel.invokeMethod("unbindRemoteVideoCanvas", {"uid": uid});
    return code;
  }

  static Future<int> setLocalCanvasScaleMode(VideoRenderMode mode) async {
    print("$kLogTag - setLocalCanvasScaleMode mode: $mode");

    Map params = {"mode": intFromVideoRenderMode(mode)};
    int code = await _channel.invokeMethod("setLocalCanvasScaleMode", params);
    return code;
  }

  static Future<int> setRemoteCanvasScaleMode(String uid, VideoRenderMode mode) async {
    print("$kLogTag - setRemoteCanvasScaleMode uid:$uid, mode: $mode");

    assert(uid != null, "failed:setRemoteCanvasScaleMode uid is null");
    Map params = {"uid": uid, "mode": intFromVideoRenderMode(mode)};
    int code = await _channel.invokeMethod("setRemoteCanvasScaleMode", params);
    return code;
  }

  static Future<int> startVideoPreview() async {
    int code = await _channel.invokeMethod("startVideoPreview");
    return code;
  }

  static Future<int> stopVideoPreview() async {
    int code = await _channel.invokeMethod("stopVideoPreview");
    return code;
  }

  static Future<int> enableLocalVideoCapture(bool enable) async {
    print("$kLogTag - enableLocalVideoCapture enable:$enable");
    Map params = {"enable": enable};
    int code = await _channel.invokeMethod("enableLocalVideoCapture", params);
    return code;
  }

  //推流接口
  static Future<int> stopLocalVideoStream(bool stopped) async {
    print("$kLogTag - stopLocalVideoStream stopped:$stopped");
    Map params = {"stopped": stopped};
    int code = await _channel.invokeMethod("stopLocalVideoStream", params);
    return code;
  }

  //拉流接口
  static Future<int> stopRemoteVideoStream(String uid, bool stopped) async {
    print("$kLogTag - stopRemoteVideoStream uid: $uid, stopped:$stopped");

    assert(uid != null, "failed: stopRemoteVideoStream uid is null");
    Map map = {"uid": uid, "stopped": stopped};
    int code = await _channel.invokeMethod("stopRemoteVideoStream", map);
    return code;
  }

  static Future<int> stopAllRemoteVideoStreams(bool stopped) async {
    print("$kLogTag - stopAllRemoteVideoStream stopped:$stopped");
    Map map = {"stopped": stopped};
    int code = await _channel.invokeMethod("stopAllRemoteVideoStreams", map);
    return code;
  }

  static Future<int> registerVideoCaptureTextureObserver() async {
    if (Platform.isAndroid) {
      int ret = await _channel.invokeMethod("registerVideoCaptureTextureObserver");
      return ret;
    }
    return 0;
  }

  static Future<int> registerVideoCaptureFrameObserver() async {
    int ret = await _channel.invokeMethod("registerVideoCaptureFrameObserver");
    return ret;
  }

  static Future<int> registerVideoDecodeFrameObserver(String uid) async {
    Map param = {"uid": uid};
    int ret = await _channel.invokeMethod("registerVideoDecodeFrameObserver", param);
    return ret;
  }

  static Future<int> setLocalVideoMirrorMode(VideoMirrorMode mode) async {
    print("$kLogTag - setLocalVideoMirrorMode mode: $mode");

    Map params = {"mode": intFromVideoMirrorMode(mode)};
    int code = await _channel.invokeMethod("setLocalVideoMirrorMode", params);
    return code;
  }

  static Future<int> setVideoCaptureOrientation(VideoCaptureOrientation orientation) async {
    print("$kLogTag - setVideoCaptureOrientation orientation: $orientation");
    Map params = {"orientation": intFromVideoCaptureOrientation(orientation)};
    int code = await _channel.invokeMethod("setVideoCaptureOrientation", params);
    return code;
  }

  static Future<int> switchFrontCamera(bool bFront) async {
    print("$kLogTag - switchFrontCamera bFront: $bFront");
    Map params = {"bFront": bFront};
    int code = await _channel.invokeMethod('switchFrontCamera', params);
    return code;
  }

  static Future<int> setEnableInEarMonitor(bool enable) async {
    Map params = {"enable": enable};
    return await _channel.invokeMethod('setEnableInEarMonitor', params);
  }

  ///新增接口 混流多人连麦场景使用
  static Future<int> setMultiVideoViewLayout(
      List<MultiVideoViewCoordinate> videoPositions, MultiVideoViewCoordinate bgCoordinate, String bgImageName,
      [int viewIndex, int viewId]) async {
    print(
        "$kLogTag - setMultiVideoViewLayout videoPositions: $videoPositions bgCoodinate: $bgCoordinate bgImageName:$bgImageName viewId: $viewId, viewIndex: $viewIndex");

    List positions = [];
    if (videoPositions.isNotEmpty) {
      positions = videoPositions
          .where((coordinate) => coordinate is MultiVideoViewCoordinate)
          .map((coordinate) => coordinate.toMap())
          .toList();
    }
    Map params = {
      "videoPositions": positions,
      "bgCoodinate": bgCoordinate?.toMap(),
      "bgImageName": bgImageName,
      "viewIndex": viewIndex,
      "viewId": viewId
    };
    params.removeWhere((k, v) => v == null);
    int code = await _channel.invokeMethod("setMultiVideoViewLayout", params);
    return code;
  }
}
