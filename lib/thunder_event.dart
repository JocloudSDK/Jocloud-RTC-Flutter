import 'package:flutter/cupertino.dart';
import 'base_model.dart';

abstract class ThunderEventHandler {
  /*
  @brief 进入房间回调
  @param room 房间名
  @param uid 用户id
  @elapsed 未实现
  */
  void onJoinRoomSuccess(String uid, String roomName) {}

  /*
    @brief 离开房间
  */
  void onLeaveRoomWithStats() {}

  /*
   @brief sdk鉴权结果
   @param sdkAuthResult 参见RtcSdkAuthResult
  */
  void onSdkAuthResult(RtcSdkAuthResult result) {}

  /*!
   @brief 业务鉴权结果
   @param bizAuthResult 由业务鉴权服务返回，0表示成功；
 */
  void onBizAuthResult(bool bPublish, int result) {}

  /*
   @brief 已显示远端视频首帧回调
   @param uid 对应的uid
   @param size 视频尺寸(宽和高)
   @param elapsed 从开始请求视频流到发生此事件过去的时间
  */
  void onRemoteVideoPlay(String uid, Size size) {}

  /*
   @brief 已发送本地视频首帧的回调
  */
  void onFirstLocalVideoFrameSent() {}

  /*
   @brief 用户进频道的回调
   @param uid 对应的uid
  */
  void onUserJoined(String uid) {}

  /*
   @brief 用户退频道的回调
   @param uid 对应的uid
   @param reason 退频道的原因 详见RtcUserOfflineReason
  */
  void onUserOffline(String uid, RtcUserOfflineReason reason) {}

  /*
   @brief 某个Uid用户的视频流状态变化回调
   @param stopped 流是否已经断开（YES:断开 NO:连接）
   @param uid 对应的uid
  */
  void onRemoteVideoStopped(String uid, bool stopped) {}

  /*
   @brief 本地或远端视频大小和旋转信息发生改变回调
   @param uid 对应的uid
   @param size 视频尺寸(宽和高)
   @param rotation 旋转信息 (0 到 360)
  */
  void onVideoSizeChangedOfUid(String uid, Size size, int rotation) {}

  /*
   @brief 网络类型变化时回调
   @param type
 */
  void onNetworkTypeChanged(NetworkType type) {}

  /*
   @brief sdk与服务器的网络连接状态回调
   @param status 连接状态，参见ThunderConnectionStatus
 */
  void onConnectionStatus(ConnectionStatus status) {}

  /*
   @brief 远端用户音频流停止/开启回调
   @param stopped 停止/开启，YES=停止 NO=开启
   @param uid 远端用户uid
 */
  void onRemoteAudioStopped(String uid, bool stopped) {}

  /*
   * 采集音量回调
   *
   * @param totalVolume 上行音量能量值[0-100]
   * @param cpt         采集时间戳
   * @param micVolume   仅麦克风采集的音量能量值[0-100]
   *                    默认关闭，开关：enableCaptureVolumeIndication
   */
  void onCaptureVolumeIndication(int totalVolume, int cpt, int micVolume) {}

  /*!
   @brief 网路上下行质量报告回调
   @param uid 表示该回调报告的是持有该id的用户的网络质量，当uid为0时，返回的是本地用户的网络质量
   @param txQuality 该用户的上行网络质量，参见ThunderLiveRtcNetworkQuality
   @param rxQuality 该用户的下行网络质量，参见ThunderLiveRtcNetworkQuality
 */
  void onNetworkQuality(String uid,
      {RtcNetworkQuality txQuality, RtcNetworkQuality rxQuality}) {}

  /*!
   @brief 说话声音音量提示回调
   @param speakers 用户Id-用户音量（未实现，音量=totalVolume）
   @param totalVolume 混音后总音量
 */
  void onPlayVolumeIndication(
      List<RtcAudioVolumeInfo> speakers, int totalVolume) {}

  /*!
  @brief 质量问题请求反馈日志
  @param description 反馈日志的文字描述
 */

  void onQualityLogFeedback(String description) {}
}
