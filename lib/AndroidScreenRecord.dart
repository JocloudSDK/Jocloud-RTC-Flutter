import 'package:flutter/foundation.dart';
import 'package:flutterthunder/flutterthunder.dart';

class AndroidScreenRecord {
  /*
  * 开始屏幕录制, iOS端不需要调用
  * token: 鉴权
  * roomId: 房间id
  * uid: 用户uid
  * */
  static Future<int> startScreenRecord(String token, String roomId, String uid,
      {num sceneId = 0}) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      Map params = {
        "token": token,
        "roomId": roomId,
        "uid": uid,
        "isStop": false,
        "sceneId": sceneId
      };
      params.removeWhere((k, v) => v == null);
      int code =
          await FlutterThunder.channel.invokeMethod("recordScreen", params);
      return code;
    }
    return -1;
  }

  /*
  * 停止屏幕录制, iOS端不需要调用
  * */
  static Future<int> stopScreenRecord() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      Map params = {
        "isStop": true,
      };
      int code =
          await FlutterThunder.channel.invokeMethod("recordScreen", params);
      return code;
    }
    return -1;
  }
}
