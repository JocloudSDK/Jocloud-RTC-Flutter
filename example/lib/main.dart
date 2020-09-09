import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterthunder/AndroidScreenRecord.dart';
import 'package:flutterthunder/flutterthunder.dart';
import 'package:flutterthunder/thunder_event.dart';

import 'android_mixin_video.dart';
import 'constants.dart';
import 'platformView_stack.dart';
import 'settings.dart';
import 'video.dart';

void main() => runApp(MyApp());

const String kLogTag = "Live_example";

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterThunder.createEngine(Constants.mAppId, Constants.mSceneId)
        .then((onValue) {
      //打开用户音量回调，500毫秒回调一次
      FlutterThunder.setAudioVolumeIndication(500, 0, 0, 0);
      //打开麦克风音量回调, 500毫秒回调一次
      FlutterThunder.enableCaptureVolumeIndication(500, 0, 0, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeRoute());
  }

  @override
  void dispose() {
    super.dispose();
    AndroidScreenRecord.stopScreenRecord();
  }
}

class HomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeRoute();
  }
}

class _HomeRoute extends State<HomeRoute> with ThunderEventHandler {
  String uid = Random().nextInt(1000000).toString();
  bool isStop = false;

  void ttt() async {
    MethodChannel _channel = const MethodChannel(kThunderChannel);
    Map data = await _channel.invokeMethod("ttt");
    String name = data['name'] as String;
    print('ttt name = $name');

    Map ttt = data["value"] as Map;
    var speakers = ttt["speakers"] as List;
    List<RtcAudioVolumeInfo> ddd = [];
    speakers.forEach((value) {
      var map = value as Map;
      String uid = map["uid"];
      int pts = map["pts"];
      int volume = map["volume"];
      RtcAudioVolumeInfo info = RtcAudioVolumeInfo(uid, pts, volume);
      ddd.add(info);
      print('ttt uid=${info.uid},pts=${info.pts},volume=${info.volume}');
    });
  }

  @override
  void initState() {
    super.initState();
    FlutterThunder.addEventHandler(this);
  }

  @override
  void dispose() {
    super.dispose();
    FlutterThunder.removeEventHandler(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('9x9连麦直播间'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NormalVideoLive()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('android端测试拉流'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AndroidMixinVideoLive()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('混流设置'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('切换Stack测试'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlateformViewStack()));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('Android录屏'),
                  onPressed: () {
                    if (!isStop) {
                      AndroidScreenRecord.startScreenRecord(
                          "", Constants.sid, "00${Constants.localUid}");
                    } else {
                      AndroidScreenRecord.stopScreenRecord();
                    }
                    isStop = !isStop;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
