import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterthunder/flutterthunder.dart';

class PlateformViewStack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PlatefromViewStackState();
  }
}

class _PlatefromViewStackState extends State<PlateformViewStack>
    with ThunderEventHandler {
  int _localViewId;
  int _remoteViewId;
  Key localKey = UniqueKey();
  Key remoteKey = UniqueKey();
  bool _isLocalFront = true;
  bool isJoinRoom = false;

  String _uid = Random().nextInt(1000000).toString();
  int sid = 60;

  String remoteUid;

  Widget localPosition() {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FlutterThunder.createNativeView((viewId) {
        _localViewId = viewId;
      }),
      key: localKey,
    );
  }

  Widget remotePosition() {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: FlutterThunder.createNativeView((viewId) {
        _remoteViewId = viewId;
      }),
      key: remoteKey,
    );
  }

  @override
  void initState() {
    FlutterThunder.addEventHandler(this);
    super.initState();
    _joinRoom();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _isLocalFront
          ? Stack(
              children: <Widget>[remotePosition(), localPosition()],
            )
          : Stack(
              children: <Widget>[localPosition(), remotePosition()],
            ),
      floatingActionButton: RaisedButton(
        child: Text("切换Stack"),
        onPressed: () {
          if (_localViewId != null && _remoteViewId != null) {
            if (mounted) {
              setState(() {
                _isLocalFront = !_isLocalFront;
              });
            }
          }
        },
      ),
    );
  }

  //TODO: 视频相关逻辑

  void _joinRoom() {
    if (isJoinRoom) {
      return;
    }
    FlutterThunder.setRoomMode(RtcRoomConfig.LIVE);
    FlutterThunder.setMediaMode(RtcConfig.NORMAL);
    FlutterThunder.setAudioConfig(
        RtcAudioConfig.STANDARD, RtcCommuteMode.HIGH, RtcScenarioMode.DEFAULT);

    FlutterThunder.setRemotePlayType(RtcRemotePlayType.MULTI);

    FlutterThunder.joinRoom(null, sid.toString(), _uid).then((onValue) {
      print("$kLogTag - joinRoom method call: $onValue");
    });
  }

  //TODO: 回调
  @override
  void onJoinRoomSuccess(String uid, String roomName) {
    isJoinRoom = true;

    //配置主播画布
    FlutterThunder.setLocalVideoCanvas(
        uid, _localViewId, VideoRenderMode.CLIP_TO_BOUNDS);
    //开启预览
    FlutterThunder.startVideoPreview();
    //配置混流
    FlutterThunder.setVideoEncoderConfig(
        PublishVideoMode.NORMAL, PublishPlayType.MULTI_INTERACT);
    //开始推流
    FlutterThunder.stopLocalVideoStream(false);
    FlutterThunder.stopLocalAudioStream(false);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void onRemoteVideoPlay(String uid, Size size) {
    super.onRemoteVideoPlay(uid, size);
  }

  @override
  void onRemoteVideoStopped(String uid, bool stopped) {
    print("PlateformViewStack onRemoteVideoStopped $uid, $stopped");
    if (!stopped && uid != remoteUid && uid != _uid) {
      int width = MediaQuery.of(context).size.width.toInt();
      MultiVideoViewCoordinate position =
          MultiVideoViewCoordinate(0, 0, width, 200, 0);
      FlutterThunder.setMultiVideoViewLayout(
          [position], position, "", 0, _remoteViewId);

      FlutterThunder.setRemoteCanvasScaleMode(
          uid, VideoRenderMode.CLIP_TO_BOUNDS);
      FlutterThunder.setRemoteVideoCanvas(
          uid, _remoteViewId, VideoRenderMode.CLIP_TO_BOUNDS, 0);
    }
  }

  @override
  void dispose() {
    isJoinRoom = false;
    FlutterThunder.leaveRoom();
    FlutterThunder.removeNativeView(_remoteViewId);
    FlutterThunder.removeNativeView(_localViewId);
    FlutterThunder.removeEventHandler(this);
    FlutterThunder.stopVideoPreview();
    super.dispose();
  }
}
