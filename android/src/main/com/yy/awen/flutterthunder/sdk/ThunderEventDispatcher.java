package com.yy.awen.flutterthunder.sdk;

import com.thunder.livesdk.ThunderNotification;

import java.util.LinkedList;
import java.util.List;

/**
 * create by chenhaofeng 2019-08-15
 * 该类是实现 SDK ThunderEventHandler 回调
 */
public class ThunderEventDispatcher extends AbsThunderEventHandler {
    private static final String TAG = "ThunderEventDispatcher";
    private List<AbsThunderEventHandler> mHandlers = new LinkedList<>();

    public void addHandler(AbsThunderEventHandler handler) {
        mHandlers.add(handler);
    }

    public void removeHandler(AbsThunderEventHandler listener) {
        mHandlers.remove(listener);
    }

    @Override
    public void onError(int error) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onError(error);
        }
    }

    @Override
    public void onJoinRoomSuccess(String room, String uid, int elapsed) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onJoinRoomSuccess(room, uid, elapsed);
        }
    }

    @Override
    public void onLeaveRoom(RoomStats status) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onLeaveRoom(status);
        }
    }

    @Override
    public void onBizAuthResult(boolean bPublish, int result) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onBizAuthResult(bPublish, result);
        }
    }

    @Override
    public void onSdkAuthResult(int result) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onSdkAuthResult(result);
        }
    }

    @Override
    public void onUserBanned(boolean status) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onUserBanned(status);
        }
    }

    @Override
    public void onUserJoined(String uid, int elapsed) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onUserJoined(uid, elapsed);
        }
    }

    @Override
    public void onUserOffline(String uid, int reason) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onUserOffline(uid, reason);
        }
    }

    @Override
    public void onTokenWillExpire(byte[] token) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onTokenWillExpire(token);
        }
    }

    @Override
    public void onTokenRequested() {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onTokenRequested();
        }
    }

    @Override
    public void onNetworkQuality(String uid, int txQuality, int rxQuality) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onNetworkQuality(uid, txQuality, rxQuality);
        }
    }

//    @Override
//    public void onQualityLogFeedback(String description) {
//        for (AbsThunderEventHandler listener : mHandlers) {
//            listener.onQualityLogFeedback(description);
//        }
//    }

    @Override
    public void onRoomStats(ThunderNotification.RoomStats stats) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onRoomStats(stats);
        }
    }

    @Override
    public void onPlayVolumeIndication(AudioVolumeInfo[] speakers, int totalVolume) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onPlayVolumeIndication(speakers, totalVolume);
        }
    }

    @Override
    public void onCaptureVolumeIndication(int totalVolume, int cpt, int micVolume) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onCaptureVolumeIndication(totalVolume, cpt, micVolume);
        }
    }

    @Override
    public void onAudioQuality(String uid, int quality, short delay, short lost) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onAudioQuality(uid, quality, delay, lost);
        }
    }

    @Override
    public void onConnectionLost() {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onConnectionLost();
        }
    }

    @Override
    public void onConnectionInterrupted() {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onConnectionInterrupted();
        }
    }

    @Override
    public void onAudioRouteChanged(int routing) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onAudioRouteChanged(routing);
        }
    }

    @Override
    public void onAudioPlayData(byte[] data, long cpt, long pts, String uid, long duration) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onAudioPlayData(data, cpt, pts, uid, duration);
        }
    }

    @Override
    public void onAudioPlaySpectrumData(byte[] data) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onAudioPlaySpectrumData(data);
        }
    }

    @Override
    public void onAudioCapturePcmData(byte[] data, int dataSize, int sampleRate, int channel) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onAudioCapturePcmData(data, dataSize, sampleRate, channel);
        }
    }

    @Override
    public void onAudioRenderPcmData(byte[] data, int dataSize, long duration, int sampleRate, int channel) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onAudioRenderPcmData(data, dataSize, duration, sampleRate, channel);
        }
    }

    @Override
    public void onRecvUserAppMsgData(byte[] data, String uid) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onRecvUserAppMsgData(data, uid);
        }
    }

    @Override
    public void onSendAppMsgDataFailedStatus(int status) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onSendAppMsgDataFailedStatus(status);
        }
    }

    @Override
    public void onRemoteAudioStopped(String uid, boolean stop) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onRemoteAudioStopped(uid, stop);
        }
    }

    @Override
    public void onRemoteVideoStopped(String uid, boolean stop) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onRemoteVideoStopped(uid, stop);
        }
    }

    @Override
    public void onRemoteVideoPlay(String uid, int width, int height, int elapsed) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onRemoteVideoPlay(uid, width, height, elapsed);
        }
    }

    @Override
    public void onVideoSizeChanged(String uid, int width, int height, int rotation) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onVideoSizeChanged(uid, width, height, rotation);
        }
    }

    @Override
    public void onFirstLocalAudioFrameSent(int elapsed) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onFirstLocalAudioFrameSent(elapsed);
        }
    }

    @Override
    public void onFirstLocalVideoFrameSent(int elapsed) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onFirstLocalVideoFrameSent(elapsed);
        }
    }

    @Override
    public void onPublishStreamToCDNStatus(String url, int errorCode) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onPublishStreamToCDNStatus(url, errorCode);
        }
    }

    @Override
    public void onNetworkTypeChanged(int type) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onNetworkTypeChanged(type);
        }
    }

    @Override
    public void onConnectionStatus(int status) {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onConnectionStatus(status);
        }
    }

    @Override
    public void onStartPreview() {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onStartPreview();
        }
    }

    @Override
    public void onStopPreview() {
        for (AbsThunderEventHandler listener : mHandlers) {
            listener.onStopPreview();
        }
    }
}
