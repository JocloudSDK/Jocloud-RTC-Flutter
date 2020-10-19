import 'package:flutter/material.dart';
import 'package:flutterthunder/thunder_renderWidget.dart';
import 'package:flutterthunder/base_model.dart';
import 'package:flutterthunder/thunder_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterthunder/flutterthunder.dart';
import 'package:flutterthunder_example/constants.dart';

const String kLogTag = "Live_example";

class NormalVideoLive extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NormalVideoLive();
  }
}

class _NormalVideoLive extends State<NormalVideoLive> with ThunderEventHandler {
  String _localUid = randomUid().toString();
  String _sid = "";
  bool _isJoinRoom = false;

  //当前所有在房间的用户（只要有流推送就在记录），用于存储_linkingQueue和_waitingQueue里的所有元素
  Map<String, Widget> _users = new Map();

  //连麦中
  List<ThunderRenderWidget> _linkingQueue = [];

  @override
  void initState() {
    super.initState();
    FlutterThunder.addEventHandler(this);
  }

  void _leaveRoom() {
    FlutterThunder.leaveRoom().then((onValue) {
      print("$kLogTag - leaveRoom method call: $onValue");
    });
  }

  void _joinRoom() {
    if (_sid.length == 0) {
      return;
    }
    if (_localUid.length == 0) {
      return;
    }
    print("$kLogTag - _joinRoom sid： $_sid, $_localUid");
    //TODO: 实际需求中，需要先从业务服务器获取token，才能进行下面的进房间操作，否则可能会产生token鉴权失败
    FlutterThunder.setRoomMode(RtcRoomConfig.LIVE);
    FlutterThunder.setMediaMode(RtcConfig.NORMAL);
    FlutterThunder.setAudioConfig(
        RtcAudioConfig.STANDARD, RtcCommuteMode.HIGH, RtcScenarioMode.DEFAULT);
    // 每次进房间都需要再次设置，否则会使用默认配置
    FlutterThunder.setVideoEncoderConfig(
        PublishVideoMode.NORMAL, PublishPlayType.INTERACT);

    FlutterThunder.joinRoom(null, _sid, _localUid).then((onValue) {
      print("$kLogTag - joinRoom method call: $onValue");
    });
  }

  void _createRenderWidget(String uid) {
    if (uid == null || _users.containsKey(uid)) {
      return;
    }
    ThunderRenderWidget widget;
    if (uid == _localUid) {
      widget = ThunderRenderWidget(
        uid,
        local: true,
        preview: true,
        mode: VideoRenderMode.CLIP_TO_BOUNDS,
        onCanvasDidSet: (uid, local, mode) {
          //进房间成功，开启直播
          _pushVideoLive();
        },
        onDispose: (uid, viewId, local) {
          //widget 销毁
          FlutterThunder.stopLocalAudioStream(true);
          FlutterThunder.stopLocalVideoStream(true);
        },
        onScaleModeDidChanged: (mode) {
          //设置码率
        },
      );
    } else {
      widget = ThunderRenderWidget(uid,
          local: false, preview: false, mode: VideoRenderMode.CLIP_TO_BOUNDS,
          onCanvasDidSet: (uid, local, mode) {
        _pullVideoLive(uid);
      }, onDispose: (uid, viewId, local) {
        //widget销毁，停止拉流
        FlutterThunder.stopRemoteVideoStream(uid, true);
        FlutterThunder.stopRemoteAudioStream(uid, true);
      }, onScaleModeDidChanged: (mode) {
        //设置码率
      });
    }
    _linkingQueue.add(widget);
    _users[uid] = widget;
  }

  void _pullVideoLive(String uid) {
    FlutterThunder.stopRemoteVideoStream(uid, false);
    FlutterThunder.stopRemoteAudioStream(uid, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Text("请输入sid", style: TextStyle(fontSize: 16)),
                  ),
                  Expanded(
                    flex: 1,
                    child: CupertinoTextField(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      placeholder: "请输入sid",
                      keyboardType: TextInputType.phone,
                      onChanged: (sid) {
                        _sid = sid;
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text(_isJoinRoom ? "退出房间" : "进入房间",
                        style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      if (_isJoinRoom) {
                        _leaveRoom();
                      } else {
                        _joinRoom();
                      }
                    },
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: _linkingQueue.length,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                print("$kLogTag - FlutterThunder gridview: index = $index, _linkingQueue length: ${_linkingQueue.length}");
                return _linkingQueue[index];
              },
            )
          ],
        ),
      ),
    );
  }

  //------------------------方法调用流程------------------

  void _resumeRemoteVideo(String uid) {
    FlutterThunder.stopRemoteVideoStream(uid, false);
    FlutterThunder.stopRemoteAudioStream(uid, false);
  }

  void _resumeAllRemoteVideo() {
    FlutterThunder.stopAllRemoteVideoStreams(
        true); // 为了让下面的stopAllRemoteVideoStreams生效
    FlutterThunder.stopAllRemoteVideoStreams(false);

    FlutterThunder.stopAllRemoteAudioStreams(
        true); // 为了让下面的stopAllRemoteVideoStreams生效
    FlutterThunder.stopAllRemoteAudioStreams(false);
  }

  void _pushVideoLive() {
    //开始推流
    FlutterThunder.stopLocalVideoStream(false);
    FlutterThunder.stopLocalAudioStream(false);
  }

  void _stoppedRemoteStream(String uid, bool isVideo) {
    ThunderRenderWidget widget = _users["uid"];
    if (_linkingQueue.contains(widget)) {
      // 恢复对远程用户音频流和视频流的设置，避免远程用户退出后再次进入房间还保持上次的mute操作
      _resumeRemoteVideo(widget.uid);
      _users.remove(uid);
      if (mounted) {
        setState(() {
          _linkingQueue.remove(widget);
        });
      }
    }
  }

  void _startedRetmoteStream(String uid, bool isVideo) {
    ThunderRenderWidget widget = _users["uid"];
    if (!_linkingQueue.contains(widget)) {
      if (mounted) {
        setState(() {
          _createRenderWidget(uid);
        });
      }
    }
  }

//------------------------方法回调----------------------
  @override
  void onJoinRoomSuccess(String uid, String roomName) {
    print("$kLogTag - onJoinRoomSuccess uid: $uid, roomName: $roomName");
    _isJoinRoom = true;
    if (!_users.containsKey(uid)) {
      if (mounted) {
        setState(() {
          _createRenderWidget(uid);
        });
      }
    }
  }

  @override
  void onLeaveRoomWithStats() {
    print("$kLogTag - onLeaveRoomWithStats");
    _isJoinRoom = false;
    _linkingQueue.clear();
    _users.clear();
    if (mounted) {
      setState(() {});
    }
    FlutterThunder.stopVideoPreview();
  }

  @override
  void onFirstLocalVideoFrameSent() {
    print("$kLogTag - onFirstLocalVideoFrameSent");
  }

  @override
  void onUserOffline(String uid, RtcUserOfflineReason reason) {}

  @override
  void onUserJoined(String uid) {}

  @override
  void onRemoteVideoStopped(String uid, bool stopped) {
    print("$kLogTag - onRemoteVideoStopped uid: $uid, stopped: $stopped");
    if (stopped) {
      _stoppedRemoteStream(uid, true);
    } else {
      _startedRetmoteStream(uid, true);
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

  /*
   @brief 网络类型变化时回调
   @param type
 */
  @override
  void onNetworkTypeChanged(NetworkType type) {}

  /*
   @brief sdk与服务器的网络连接状态回调
   @param status 连接状态，参见ThunderConnectionStatus
 */
  @override
  void onConnectionStatus(ConnectionStatus status) {}

  /*
   @brief 远端用户音频流停止/开启回调
   @param stopped 停止/开启，YES=停止 NO=开启
   @param uid 远端用户uid
 */
  @override
  void onRemoteAudioStopped(String uid, bool stopped) {}

  @override
  void onNetworkQuality(String uid,
      {RtcNetworkQuality txQuality, RtcNetworkQuality rxQuality}) {
    // TODO: implement onNetworkQuality
  }

  @override
  void onPlayVolumeIndication(
      List<RtcAudioVolumeInfo> speakers, int totalVolume) {
    // TODO: implement onPlayVolumeIndication
  }

  @override
  void dispose() {
    FlutterThunder.removeEventHandler(this);
    FlutterThunder.leaveRoom();
    FlutterThunder.stopVideoPreview();

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
}
