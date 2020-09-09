package com.yy.awen.flutterthunder.sdk;

import android.util.Log;

import com.thunder.livesdk.ThunderNotification;
import com.yy.awen.flutterthunder.EventChannelManager;
import com.yy.awen.flutterthunder.utils.Constants;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class ThunderEventHandlerImpl extends AbsThunderEventHandler {

    @Override
    public void onJoinRoomSuccess(String room, String uid, int elapsed) {
        super.onJoinRoomSuccess(room, uid, elapsed);
        Log.d(Constants.tag, "android onJoinRoomSuccess, room = " + room + ",uid = " + uid);
        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onJoinRoomSuccess");
        Map<String, String> data = new HashMap<>();
        data.put("uid", uid);
        data.put("roomName", room);
        map.put(Constants.value, data);
        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onLeaveRoom(RoomStats status) {
        super.onLeaveRoom(status);
        Log.d(Constants.tag, "android onLeaveRoom");
        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onLeaveRoomWithStats");
        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onFirstLocalVideoFrameSent(int elapsed) {
        super.onFirstLocalVideoFrameSent(elapsed);
        Log.d(Constants.tag, "android onFirstLocalVideoFrameSent, elapsed: " + elapsed);

        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onFirstLocalVideoFrameSent");

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onFirstLocalAudioFrameSent(int elapsed) {
        super.onFirstLocalAudioFrameSent(elapsed);
        Log.d(Constants.tag, "android onFirstLocalAudioFrameSent, elapsed: " + elapsed);
    }

    @Override
    public void onRoomStats(ThunderNotification.RoomStats stats) {
        super.onRoomStats(stats);
        if (stats != null) {
            Log.d(Constants.tag, "onRoomStats 视频包的发送码率 " + stats.txVideoBitrate);
            Log.d(Constants.tag, "onRoomStats 视频包的接收码率： " + stats.rxVideoBitrate);
        }
    }

    @Override
    public void onUserJoined(String uid, int elapsed) {
        super.onUserJoined(uid, elapsed);

        Log.d(Constants.tag, "android onUserJoined, uid = " + uid + ",elapsed: " + elapsed);

        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onUserJoined");

        Map<String, Object> data = new HashMap<>();
        data.put("uid", uid);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onUserOffline(String uid, int reason) {
        super.onUserOffline(uid, reason);


        Log.d(Constants.tag, "android onUserOffline, uid = " + uid + ",reason: " + reason);

        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onUserOffline");

        Map<String, String> data = new HashMap<>();
        data.put("uid", uid);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onNetworkTypeChanged(int type) {
        super.onNetworkTypeChanged(type);
        Log.d(Constants.tag, "onNetworkTypeChanged type=" + type);
        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onNetworkTypeChanged");

        Map<String, Object> data = new HashMap<>();
        data.put("type", type);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

//    @Override
//    public void onQualityLogFeedback(String description) {
//        super.onQualityLogFeedback(description);
//        Log.d(Constants.tag, "onQualityLogFeedback description=" + description);
//        Map<String, Object> map = new HashMap<>();
//        map.put(Constants.key, "onQualityLogFeedback");
//
//        Map<String, Object> data = new HashMap<>();
//        data.put("description", description);
//        map.put(Constants.value, data);
//
//        EventChannelManager.INSTANCE.sendMessage(map);
//    }

    @Override
    public void onRemoteVideoStopped(String uid, boolean stop) {
        super.onRemoteVideoStopped(uid, stop);
        Log.d(Constants.tag, "android onRemoteVideoStopped, uid = " + uid + ", stop = " + stop);
        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onRemoteVideoStopped");
        Map<String, Object> data = new HashMap<>();
        data.put("uid", uid);
        data.put("stopped", stop);
        map.put(Constants.value, data);
        EventChannelManager.INSTANCE.sendMessage(map);
    }

    /**
     * 首帧回调
     *
     * @param uid
     * @param width
     * @param height
     * @param elapsed
     */
    @Override
    public void onRemoteVideoPlay(String uid, int width, int height, int elapsed) {
        super.onRemoteVideoPlay(uid, width, height, elapsed);
        Log.d(Constants.tag, "android onRemoteVideoPlay, uid = " + uid + ", width = " + width
                + ",height = " + height + ", elapsed: " + elapsed);

        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onRemoteVideoPlay");

        Map<String, Object> data = new HashMap<>();
        data.put("uid", uid);
        data.put("width", width * 1.0d);
        data.put("height", height * 1.0d);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onVideoSizeChanged(String uid, int width, int height, int rotation) {
        super.onVideoSizeChanged(uid, width, height, rotation);
        Log.d(Constants.tag, "android onVideoSizeChanged, uid = " + uid
                + ", width = " + width * 1.0d
                + ",height = " + height * 1.0d
                + ", rotation: " + rotation);

        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onVideoSizeChangedOfUid");

        Map<String, Object> data = new HashMap<>();
        data.put("uid", uid);
        data.put("width", width * 1.0d);
        data.put("height", height * 1.0d);
        data.put("rotation", rotation);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onRemoteAudioStopped(String uid, boolean stop) {
        super.onRemoteAudioStopped(uid, stop);
        Log.d(Constants.tag, "onRemoteAudioStopped uid=" + uid + ", stop=" + stop);
        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onRemoteAudioStopped");

        Map<String, Object> data = new HashMap<>();
        data.put("uid", uid);
        data.put("stopped", stop);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onConnectionStatus(int status) {
        super.onConnectionStatus(status);
        Log.d(Constants.tag, "onConnectionStatus status=" + status);
        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onConnectionStatus");

        Map<String, Object> data = new HashMap<>();
        data.put("type", status);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    /**
     * 网络上下行质量报告回调, 返回的是ID对应的用户的网络质量
     *
     * @param uid       表示该回调报告的是持有该 ID 的用户的网络质量, 当 uid 为 0 时，返回的是本地用户的网络质量
     * @param txQuality 网络上行质量(0-质量未知 1-质量极好 2-用户主观感觉和极好差不多，但码率可能略低于极好
     *                  3-用户主观感受有瑕疵但不影响沟通 4-勉强能沟通但不顺畅 5-网络质量非常差，基本不能沟通
     *                  6-网络连接已断开，完全无法沟通)
     * @param rxQuality 网络下行质量(0-质量未知 1-质量极好 2-用户主观感觉和极好差不多，但码率可能略低于极好
     *                  3-用户主观感受有瑕疵但不影响沟通 4-勉强能沟通但不顺畅 5-网络质量非常差，基本不能沟通
     *                  6-网络连接已断开，完全无法沟通)
     */
    @Override
    public void onNetworkQuality(String uid, int txQuality, int rxQuality) {
        super.onNetworkQuality(uid, txQuality, rxQuality);
        Log.d(Constants.tag, "onNetworkQuality uid=" + uid +
                ", txQuality=" + txQuality + ", rxQuality=" + rxQuality);
        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onNetworkQuality");

        Map<String, Object> data = new HashMap<>();
        data.put("uid", uid);
        data.put("txQuality", txQuality);
        data.put("rxQuality", rxQuality);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onPlayVolumeIndication(AudioVolumeInfo[] speakers, int totalVolume) {
        super.onPlayVolumeIndication(speakers, totalVolume);
        Log.d(Constants.tag, "onPlayVolumeIndication totalVolume=" + totalVolume);

        HashMap<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onPlayVolumeIndication");

        List<HashMap<String, Object>> list = new ArrayList<>();
        if (speakers != null && speakers.length > 0) {
            for (AudioVolumeInfo info : speakers) {
                HashMap<String, Object> value = new HashMap<>();
                value.put("uid", info.uid);
                value.put("pts", info.pts);
                value.put("volume", info.volume);
                list.add(value);
            }
        }
        HashMap<String, Object> data = new HashMap<>();
        data.put("totalVolume", totalVolume);
        data.put("speakers", list);

        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onCaptureVolumeIndication(int totalVolume, int cpt, int micVolume) {
        super.onCaptureVolumeIndication(totalVolume, cpt, micVolume);
        Log.d(Constants.tag, "onCaptureVolumeIndication totalVolume=" + totalVolume +
                ",cpt: " + cpt + ",micVolume" + micVolume);

        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onCaptureVolumeIndication");

        Map<String, Object> data = new HashMap<>();
        data.put("totalVolume", totalVolume);
        data.put("cpt", cpt);
        data.put("micVolume", micVolume);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onSdkAuthResult(int result) {
        super.onSdkAuthResult(result);
        Log.d(Constants.tag, "onSdkAuthResult result=" + result);

        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onSdkAuthResult");

        Map<String, Object> data = new HashMap<>();
        data.put("result", result);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }

    @Override
    public void onBizAuthResult(boolean bPublish, int result) {
        super.onBizAuthResult(bPublish, result);
        Log.d(Constants.tag, "onBizAuthResult bPublish=" + bPublish +
                ",result: " + result);

        Map<String, Object> map = new HashMap<>();
        map.put(Constants.key, "onBizAuthResult");

        Map<String, Object> data = new HashMap<>();
        data.put("bPublish", bPublish);
        data.put("result", result);
        map.put(Constants.value, data);

        EventChannelManager.INSTANCE.sendMessage(map);
    }
}
