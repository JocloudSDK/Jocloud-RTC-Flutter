import 'package:flutterthunder/base_model.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutterthunder/flutterthunder.dart';

class FlutterThunderEx {

  static const MethodChannel _channel = const MethodChannel(kThunderChannel);

  static Future<int> enableLocalAudioStream() async {
    Map map = {"stopped": false};
    int code = await _channel.invokeMethod("stopLocalAudioStream", map);
    return code;
  }

  static Future<int> disableLocalAudioStream() async {
    Map map = {"stopped": true};
    int code = await _channel.invokeMethod("stopLocalAudioStream", map);
    return code;
  }

  static Future<int> enableLocalVideoStream() async {
    Map params = {"stopped": false};
    int code = await _channel.invokeMethod("stopLocalVideoStream", params);
    return code;
  }

  static Future<int> disableLocalVideoStream() async {
    Map params = {"stopped": true};
    int code = await _channel.invokeMethod("stopLocalVideoStream", params);
    return code;
  }

  static Future<int> enableRemoteAudioStream(String uid) async {
    assert(uid != null, "failed: enableRemoteAudioStream uid is null");
    if (uid == null) {
      return -1;
    }
    Map params = {"uid": uid, "stopped": false};
    int code = await _channel.invokeMethod("stopRemoteAudioStream", params);
    return code;
  }

  static Future<int> disableRemoteAudioStream(String uid) async {
    assert(uid != null, "failed: disableRemoteAudioStream uid is null");
    if (uid == null) {
      return -1;
    }
    Map params = {"uid": uid, "stopped": true};
    int code = await _channel.invokeMethod("stopRemoteAudioStream", params);
    return code;
  }


  static Future<int> enableRemoteVideoStream(String uid) async {
    assert(uid != null, "failed: enableRemoteVideoStream uid is null");
    if (uid == null) {
      return -1;
    }
    Map map = {"uid": uid, "stopped": false};
    int code = await _channel.invokeMethod("stopRemoteVideoStream", map);
    return code;
  }

  static Future<int> disableRemoteVideoStream(String uid) async {
    assert(uid != null, "failed: diableRemoteVideoStream uid is null");
    Map map = {"uid": uid, "stopped": true};
    int code = await _channel.invokeMethod("stopRemoteVideoStream", map);
    return code;
  }

}