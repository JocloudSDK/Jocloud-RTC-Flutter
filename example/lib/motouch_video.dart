import 'package:flutter/material.dart';
import 'package:flutterthunder/base_model.dart';
import 'package:flutterthunder/thunder_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterthunder/flutterthunder.dart';
import 'flutterthunderEx.dart';
import 'constants.dart';

const String kLogTag = "motouch";
const MAXUSER = 9;

class Video {
  /// 退出房间
  static void leaveRoom() {
    FlutterThunder.leaveRoom().then((onValue) {
      print("$kLogTag - leaveRoom method call: $onValue");
    });
  }

  static void enableEngine() {}

  /// 拉取远端（别人）的流
  static void pullRemoteStream(String uid) {
    FlutterThunderEx.enableRemoteVideoStream(uid);
    FlutterThunderEx.enableRemoteAudioStream(uid);
  }

  /// 推送自己的流
  static void pushLocalStream() {
    //开始推流
    FlutterThunderEx.enableLocalVideoStream();
    FlutterThunderEx.enableLocalAudioStream();
  }

  /// 停止推送自己的流
  static void stopLocalStream() {
    //开始推流
    FlutterThunderEx.disableLocalVideoStream();
    FlutterThunderEx.disableLocalAudioStream();
  }

  /// 添加进入房间的远端流
  static void addRemoteStream(String uid) {
    FlutterThunderEx.enableRemoteVideoStream(uid);
    FlutterThunderEx.enableRemoteAudioStream(uid);
  }

  /// 移除退出房间的远端流
  static void removeRemoteStream(String uid) {
    FlutterThunderEx.disableRemoteAudioStream(uid);
  }

  static void closeRemoteStream(String _localUid) {
    FlutterThunder.stopRemoteVideoStream(_localUid, true);
    FlutterThunder.stopRemoteAudioStream(_localUid, true);
  }

  static void closeAll() {
    FlutterThunder.stopAllRemoteAudioStreams(true);
    FlutterThunder.stopAllRemoteVideoStreams(true);
  }
}

class MotouchVideo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MotouchVideoState();
  }
}

class MotouchVideoState extends State<MotouchVideo>
    implements ThunderEventHandler {
  bool _isJoinRoom = false;
  List<String> _uses = [];
  num _width = 0;
  num _height = 0;
  num statusBarHeight;
  int _viewId;
  int _selfViewId;

  Widget _remoteWidget;

  List<String> enterUid = [];

  List<int> layout = [4, 9];
  int layoutIndex = 0;

  void _initSeats() {
    _uses.clear();
    for (int i = 0; i < MAXUSER; i++) {
      _uses.add("");
    }
  }

  void _clearUid(String uid) {
    for (int i = 0; i < MAXUSER; i++) {
      if (_uses[i] == uid) {
        _uses[i] = "";
      } else {}
    }
  }

  int _addUid(String uid) {
    for (int i = 0; i < MAXUSER; i++) {
      if (_uses[i] == "") {
        _uses[i] = uid;
        return i;
      }
    }
    return -1;
  }

  @override
  void initState() {
    FlutterThunder.addEventHandler(this);
    super.initState();
    _initSeats();
  }

  /// 离开房间
  void _leaveRoom() {
    enterUid.clear();
    Video.leaveRoom();
  }

  ///进入房间
  void _joinRoom() {
    if (Constants.sid.length == 0) {
      return;
    }
    if (Constants.localUid.length == 0) {
      return;
    }

    FlutterThunder.setRoomMode(RtcRoomConfig.LIVE);
    FlutterThunder.setMediaMode(RtcConfig.NORMAL);
    FlutterThunder.setAudioConfig(
        RtcAudioConfig.STANDARD, RtcCommuteMode.HIGH, RtcScenarioMode.DEFAULT);
    FlutterThunder.setRemotePlayType(RtcRemotePlayType.MULTI);

    FlutterThunder.joinRoom(null, Constants.sid, Constants.localUid)
        .then((onValue) {
      print("$kLogTag - joinRoom method call: $onValue");
    });
  }

  num _getWidth(BuildContext context) {
    if (_width == 0) {
      Size size = MediaQuery.of(context).size;
      _width = size.width;
      _height = size.height;
      print('context width=$_width,height=$_height');
    }
    return _width;
  }

  num getStatusBarHeight(BuildContext context) {
    if (statusBarHeight == 0) {
      statusBarHeight = MediaQuery.of(context).padding.top;
    }
    return statusBarHeight;
  }

  num _getHeight(BuildContext context) {
    if (_height == 0) {
      Size size = MediaQuery.of(context).size;
      _height = size.height;
      _width = size.width;
      print('context width=$_width,height=$_height');
    }
    return _height;
  }

  Widget _createView(BuildContext context) {
    if (_remoteWidget == null) {
      _remoteWidget = FlutterThunder.createNativeView((viewId) {
        _viewId = viewId;
      });
    }
    print("tttttt _createView $_viewId");
    return _remoteWidget;
  }

  Widget showUid() {
    Text text;
    if (enterUid.length == 0) {
      text = new Text('');
    } else {
      String str = "";
      for (int i = 0; i < enterUid.length; i++) {
        str = str + enterUid[i] + " , ";
      }
      text = new Text(str);
    }
    return text;
  }

  bool _changeLayer = true;
  int count = 0;

  Widget createOne(BuildContext context) {
    if (_changeLayer) {
      return Positioned(
        top: 0,
        left: 0,
        child: Container(
            width: _getWidth(context),
            height: _getHeight(context),
            child: FlutterThunder.createNativeView((viewId) {
              _selfViewId = viewId;
              if (_isJoinRoom) {
                joinRoomSelf();
              }
            })),
      );
    } else {
//      FlutterThunder.stopVideoPreview();
//      if (_isJoinRoom) {
//        FlutterThunder.stopVideoPreview();
//        Video.stopLocalStream();
//      }
      return Positioned(
        top: 0,
        left: 0,
        child: Container(width: 10, height: 10, child: Text("")),
      );
    }
  }

  Widget createTwo(BuildContext context) {
    if (_changeLayer) {
      return Positioned(
        top: 0,
        left: 0,
        child: Container(width: 0, height: 0, child: Text("")),
      );
    } else {
      var positon = Positioned(
        top: 30,
        left: 0,
        child: Container(
            color: Colors.green,
            width: 100,
            height: 100,
            child: FlutterThunder.createNativeView((viewId) {
              _selfViewId = viewId;
              if (_isJoinRoom) {
                joinRoomSelf();
              }
            })),
      );
      return positon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          createOne(context),
          Positioned(
            left: 0,
            top: 30,
            child: Container(
                color: Colors.red,
                width: _changeLayer ? 100 : _getWidth(context),
                height: _changeLayer ? 100 : _getHeight(context),
                child: _createView(context)),
          ),
          createTwo(context),
          Positioned(
              top: 30,
              left: 125,
              child: Container(
                  child: RaisedButton(
                child: Text(_isJoinRoom ? "退出房间" : "进入房间",
                    style: TextStyle(fontSize: 16)),
                onPressed: () {
                  if (_isJoinRoom) {
                    _leaveRoom();
                  } else {
                    _joinRoom();
                  }
                },
              ))),
          Positioned(
              top: 70,
              left: 125,
              child: Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: RaisedButton(
                      child: Text("切换层级", style: TextStyle(fontSize: 16)),
                      onPressed: () {
                        _changeLayer = !_changeLayer;
                        _resizeStream();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ))),
          Positioned(
              top: 45,
              left: 225,
              child: Text(
                "uid=${Constants.localUid}, sid=${Constants.sid}",
                style: TextStyle(color: Colors.red),
              )),
          Positioned(
              top: 135,
              left: 0,
              child: Container(
                width: double.maxFinite,
                child: Text("${enterUid.toString()}",
                    style: TextStyle(color: Colors.red)),
              )),
        ],
      ),
    );
  }

  void joinRoomSelf() {
    Video.enableEngine();
    FlutterThunder.setRemotePlayType(RtcRemotePlayType.MULTI);
    //配置主播画布
    FlutterThunder.setLocalVideoCanvas(
        Constants.localUid, _selfViewId, VideoRenderMode.CLIP_TO_BOUNDS);
    //开启预览
    FlutterThunder.startVideoPreview();
    //配置混流
    FlutterThunder.setVideoEncoderConfig(
        PublishVideoMode.NORMAL, PublishPlayType.MULTI_INTERACT);
    //开始推流
    Video.pushLocalStream();
    if (mounted) {
      setState(() {});
    }
  }

//------------------------方法回调----------------------
  @override
  void onJoinRoomSuccess(String uid, String roomName) {
    print("$kLogTag - onJoinRoomSuccess uid: $uid, roomName: $roomName");
    _isJoinRoom = true;
    joinRoomSelf();
  }

  @override
  void onLeaveRoomWithStats() {
    print("$kLogTag - onLeaveRoomWithStats");
    _isJoinRoom = false;
    _initSeats();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void onFirstLocalVideoFrameSent() {
    print("$kLogTag - onFirstLocalVideoFrameSent");
  }

  @override
  void onUserOffline(String uid, RtcUserOfflineReason reason) {}

  @override
  void onUserJoined(String uid) {}

  void _resizeStream() {
    FlutterThunder.setRemotePlayType(RtcRemotePlayType.MULTI);
    //开启视频
    Video.enableEngine();
    _setLayout();
  }

  List<MultiVideoViewCoordinate> videoPositions = [];
  MultiVideoViewCoordinate bgCoodinate;

  void _setLayout() {
    if (enterUid.length >= 9) {
      return;
    }
    videoPositions.clear();
    if (bgCoodinate == null) {
      bgCoodinate =
          MultiVideoViewCoordinate(0, 0, _width.toInt(), _height.toInt(), 0);
    }
    int len = enterUid.length;

    if (enterUid.length == 1) {
      if (_changeLayer) {
        int width = 100;
        MultiVideoViewCoordinate position;
        position = MultiVideoViewCoordinate(0, 0, width, width, 0);
        videoPositions.add(position);

        FlutterThunder.setMultiVideoViewLayout(videoPositions, bgCoodinate, "");

        FlutterThunder.setRemoteCanvasScaleMode(
            enterUid[0], VideoRenderMode.CLIP_TO_BOUNDS);
        FlutterThunder.setRemoteVideoCanvas(
            enterUid[0], _viewId, VideoRenderMode.CLIP_TO_BOUNDS, 0);
      } else {
        int width = 200;
        MultiVideoViewCoordinate position;
        position = MultiVideoViewCoordinate(200, 100, width, width, 0);
        videoPositions.add(position);

        FlutterThunder.setMultiVideoViewLayout(videoPositions, bgCoodinate, "");

        FlutterThunder.setRemoteCanvasScaleMode(
            enterUid[0], VideoRenderMode.CLIP_TO_BOUNDS);
        FlutterThunder.setRemoteVideoCanvas(
            enterUid[0], _viewId, VideoRenderMode.CLIP_TO_BOUNDS, 0);
      }
    } else if (enterUid.length == 2 || enterUid.length == 3) {
      int width = (_width / 2).toInt();
      int height = (_height / 2).toInt();
      int index = 0;
      for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
          MultiVideoViewCoordinate bgCoodinate = MultiVideoViewCoordinate(
              j * width, i * height, width, height, index);
          videoPositions.add(bgCoodinate);
          index++;
        }
      }

      FlutterThunder.setMultiVideoViewLayout(videoPositions, bgCoodinate, "");

      for (int i = 0; i < len; i++) {
        FlutterThunder.setRemoteVideoCanvas(
            enterUid[i], _viewId, VideoRenderMode.CLIP_TO_BOUNDS, i + 1);
        FlutterThunder.setRemoteCanvasScaleMode(
            enterUid[i], VideoRenderMode.CLIP_TO_BOUNDS);
      }
    } else if (enterUid.length >= 4) {
      int width = (_width / 3).toInt();
      int height = (_height / 3).toInt();
      int index = 0;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          MultiVideoViewCoordinate bgCoodinate = MultiVideoViewCoordinate(
              j * width, i * height, width, height, index);
          videoPositions.add(bgCoodinate);
          index++;
        }
      }
      FlutterThunder.setMultiVideoViewLayout(videoPositions, bgCoodinate, "");

      for (int i = 0; i < len; i++) {
        FlutterThunder.setRemoteVideoCanvas(
            enterUid[i], _viewId, VideoRenderMode.CLIP_TO_BOUNDS, i + 1);
        FlutterThunder.setRemoteCanvasScaleMode(
            enterUid[i], VideoRenderMode.CLIP_TO_BOUNDS);
      }
    }
  }

  @override
  void onRemoteVideoStopped(String uid, bool stopped) {
    print("$kLogTag - onRemoteVideoStopped uid: $uid, stopped: $stopped");
    print("$kLogTag - self: $_selfViewId, other: $_viewId");
    if (stopped) {
      enterUid.remove(uid);
      _clearUid(uid);
    } else {
      if (enterUid.length >= 9 || enterUid.indexOf(uid) != -1) {
        return;
      }
      enterUid.add(uid);
      _addUid(uid);
    }
    _resizeStream();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void onRemoteVideoPlay(String uid, Size size) {
    print("$kLogTag - onRemoteVideoPlay: $uid, size: $size");
  }

  @override
  void onVideoSizeChangedOfUid(String uid, Size size, int rotation) {
    print("$kLogTag - onVideoSizeChangedOfUid: $uid, size: $size, rotation: $rotation");
  }

  @override
  void onSdkAuthResult(RtcSdkAuthResult result) {
    // TODO: implement sdkAuthResult
  }

  @override
  void onNetworkQuality(String uid,
      {RtcNetworkQuality txQuality, RtcNetworkQuality rxQuality}) {
    // TODO: implement onNetworkQuality
  }

  @override
  void onNetworkTypeChanged(int type) {
    // TODO: implement onNetworkTypeChanged
  }

  @override
  void onConnectionStatus(ConnectionStatus status) {
    // TODO: implement onConnectionStatus
  }

  @override
  void onRemoteAudioStopped(String uid, bool stopped) {
    // TODO: implement onRemoteAudioStopped
  }

  @override
  void onPlayVolumeIndication(
      List<RtcAudioVolumeInfo> speakers, int totalVolume) {
    // TODO: implement onPlayVolumeIndication
  }

  @override
  void dispose() {
    FlutterThunder.removeEventHandler(this);
    if (_isJoinRoom) {
      FlutterThunder.stopVideoPreview();
    }
    Video.closeAll();
    Video.leaveRoom();
    FlutterThunder.removeNativeView(_viewId);
    FlutterThunder.removeNativeView(_selfViewId);
    super.dispose();
  }

  @override
  void onBizAuthResult(bool bPublish, int result) {
    // TODO: implement onBizAuthResult
  }

  @override
  void onRecordScreen(bool successs) {
    // TODO: implement onRecordScreen
  }

  @override
  void onCaptureVolumeIndication(int totalVolume, int cpt, int micVolume) {
    // TODO: implement onCaptureVolumeIndication
  }

  @override
  void onQualityLogFeedback(String description) {}
}
