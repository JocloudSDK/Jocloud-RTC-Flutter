package com.yy.awen.flutterthunder.sdk;

import android.content.Context;

import com.thunder.livesdk.IThunderLogCallback;
import com.thunder.livesdk.LiveTranscoding;
import com.thunder.livesdk.ThunderAudioFilePlayer;
import com.thunder.livesdk.ThunderBoltImage;
import com.thunder.livesdk.ThunderCustomVideoSource;
import com.thunder.livesdk.ThunderEngine;
import com.thunder.livesdk.ThunderMultiVideoViewParam;
import com.thunder.livesdk.ThunderRtcConstant;
import com.thunder.livesdk.ThunderVideoCanvas;
import com.thunder.livesdk.ThunderVideoEncoderConfiguration;
import com.thunder.livesdk.video.IVideoCaptureObserver;
import com.thunder.livesdk.video.IVideoDecodeObserver;
import com.yy.mediaframework.gpuimage.custom.IGPUProcess;


public final class LiveSDKManager {
    private final static String TAG = "LiveSDKManager";
    public static final int RTC_CALL_NO_INIT = Integer.MIN_VALUE;

    private static volatile LiveSDKManager instance;
    private ThunderEngine mYYLiveRtcEngine = null;
    private ThunderEventDispatcher mThunderEventDispatcher = new ThunderEventDispatcher();
//    private IThunderLogCallback mLogCallback = new IThunderLogCallback() {
//        @Override
//        public void onThunderLogWithLevel(int level, String tag, String msg) {
//            switch (level) {
//                case ThunderRtcConstant.ThunderLogLevel.THUNDERLOG_LEVEL_WARN:
//                    Log.w(tag, msg);
//                    break;
//                case ThunderRtcConstant.ThunderLogLevel.THUNDERLOG_LEVEL_ERROR:
//                    Log.e(tag, msg);
//                    break;
//                default:
//                    Log.d(tag, msg);
//                    break;
//            }
//        }
//    };

    private long mEap;

    private LiveSDKManager() {

    }

    public static final LiveSDKManager getInstance() {
        if (instance == null) {
            synchronized (LiveSDKManager.class) {
                if (instance == null) {
                    instance = new LiveSDKManager();
                }
            }
        }
        return instance;
    }

    public void addThunderEventHandler(AbsThunderEventHandler handler) {
        if (mThunderEventDispatcher == null) {
            return;
        }
        mThunderEventDispatcher.addHandler(handler);
    }

    public void removeThunderEventHandler(AbsThunderEventHandler handler) {
        if (mThunderEventDispatcher == null) {
            return;
        }
        mThunderEventDispatcher.removeHandler(handler);
    }

    /**
     * 初始化LiveSDK
     *
     * @param context
     * @param appId
     * @param sceneId
     */
    public void initialize(Context context, String appId, long sceneId) {
        if (mYYLiveRtcEngine != null) {
            return;
        }
        mYYLiveRtcEngine = ThunderEngine.createEngine(context, appId, sceneId, mThunderEventDispatcher);

        if (mEap > 0) {
            mYYLiveRtcEngine.setExternalAudioProcessor(mEap);
        }

//        setLogCallback(mLogCallback);
    }

    public void destroyEngine() {
        if (mYYLiveRtcEngine != null) {
            mYYLiveRtcEngine.destroyEngine();
            mEap = 0;
            mYYLiveRtcEngine = null;
        }
    }

    public boolean isInitialized() {
        return mYYLiveRtcEngine != null;
    }

    public int setRoomMode(int mode) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setRoomMode(mode);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setMediaMode(int mode) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setMediaMode(mode);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setArea(int area) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setArea(area);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setUse64bitUid(boolean is64bitUid) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setUse64bitUid(is64bitUid);
        }
        return RTC_CALL_NO_INIT;
    }

    public void setParameter(String json) {
        if (mYYLiveRtcEngine != null) {
            mYYLiveRtcEngine.setParameters(json);
        }
    }

    public int joinRoom(byte[] token, String roomName, String uid) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.joinRoom(token, roomName, uid);
        }
        return RTC_CALL_NO_INIT;
    }

    public int leaveRoom() {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.leaveRoom();
        }
        return RTC_CALL_NO_INIT;
    }

    public int updateToken(byte[] token) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.updateToken(token);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setLogFilePath(String filePath) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setLogFilePath(filePath);
        }
        return RTC_CALL_NO_INIT;
    }

    private int setLogCallback(IThunderLogCallback callback) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setLogCallback(callback);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setLogFilter(int filter) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setLogLevel(filter);
        }
        return RTC_CALL_NO_INIT;
    }

    public int enableAudioEngine() {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.enableAudioEngine();
        }
        return RTC_CALL_NO_INIT;
    }

    public int disableAudioEngine() {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.disableAudioEngine();
        }
        return RTC_CALL_NO_INIT;
    }

    public int setAudioConfig(int profile, int commutMode, int scenarioMode) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setAudioConfig(profile, commutMode, scenarioMode);
        }
        return RTC_CALL_NO_INIT;
    }

    public int enableLoudspeaker(boolean enabled) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.enableLoudspeaker(enabled);
        }
        return RTC_CALL_NO_INIT;
    }

    public boolean isLoudspeakerEnabled() {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.isLoudspeakerEnabled();
        }
        return false;
    }

    public int setAudioVolumeIndication(int interval,
                                        int moreThanThd,
                                        int lessThanThd,
                                        int smooth) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setAudioVolumeIndication(interval, moreThanThd, lessThanThd,
                    smooth);
        }
        return RTC_CALL_NO_INIT;
    }

    public int enableCaptureVolumeIndication(int interval,
                                             int moreThanThd,
                                             int lessThanThd,
                                             int smooth) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.enableCaptureVolumeIndication(interval, moreThanThd,
                    lessThanThd, smooth);
        }
        return RTC_CALL_NO_INIT;
    }

    public void enableCapturePcmDataCallBack(boolean enable, int sampleRate, int channel) {
        if (mYYLiveRtcEngine != null) {
            mYYLiveRtcEngine.enableCapturePcmDataCallBack(enable, sampleRate, channel);
        }
    }

    public boolean enableRenderPcmDataCallBack(boolean enable, int sampleRate, int channel) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.enableRenderPcmDataCallBack(enable, sampleRate, channel);
        }
        return false;
    }

    /**
     * 是否静音自己
     *
     * @param stop
     * @return
     */
    public int stopLocalAudioStream(boolean stop) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.stopLocalAudioStream(stop);
        }
        return RTC_CALL_NO_INIT;
    }

    public void setAudioSourceType(int mode) {
        if (mYYLiveRtcEngine != null) {
            mYYLiveRtcEngine.setAudioSourceType(mode);
        }
    }

    public int stopAllRemoteAudioStreams(boolean muted) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.stopAllRemoteAudioStreams(muted);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setRemotePlayType(int remotePlayType) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setRemotePlayType(remotePlayType);
        }
        return RTC_CALL_NO_INIT;
    }

    /**
     * 是否静音某个用户的声音
     *
     * @param uid
     * @param stop
     * @return
     */
    public int stopRemoteAudioStream(String uid, boolean stop) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.stopRemoteAudioStream(uid, stop);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setLoudSpeakerVolume(int volume) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setLoudSpeakerVolume(volume);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setMicVolume(int volume) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setMicVolume(volume);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setRemoteAudioStreamsVolume(String uid, int volume) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setRemoteAudioStreamsVolume(uid, volume);
        }
        return RTC_CALL_NO_INIT;
    }

    public ThunderAudioFilePlayer createAudioFilePlayer() {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.createAudioFilePlayer();
        }
        return null;
    }

    public ThunderAudioFilePlayer destroyAudioFilePlayer(
            ThunderAudioFilePlayer audioFilePlayer) {
        if (mYYLiveRtcEngine != null) {
            mYYLiveRtcEngine.destroyAudioFilePlayer(audioFilePlayer);
        }
        return null;
    }

    public int setEnableEqualizer(boolean enabled) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setEnableEqualizer(enabled);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setEqGains(int[] gains) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setEqGains(gains);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setEnableReverb(boolean enabled) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setEnableReverb(enabled);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setReverbExParameter(ThunderRtcConstant.ReverbExParameter param) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setReverbExParameter(param);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setEnableCompressor(boolean enabled) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setEnableCompressor(enabled);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setCompressorParam(ThunderRtcConstant.CompressorParam param) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setCompressorParam(param);
        }
        return RTC_CALL_NO_INIT;
    }

    public boolean startAudioSaver(String fileName, int saverMode, int fileMode) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.startAudioSaver(fileName, saverMode, fileMode);
        }
        return false;
    }

    public void setSoundEffect(int mode) {
        if (mYYLiveRtcEngine != null) {
            mYYLiveRtcEngine.setSoundEffect(mode);
        }
    }

    public void setVoiceChanger(int mode) {
        if (mYYLiveRtcEngine != null) {
            mYYLiveRtcEngine.setVoiceChanger(mode);
        }
    }

    public boolean stopAudioSaver() {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.stopAudioSaver();
        }
        return false;
    }

    public int sendUserAppMsgData(byte[] msgData) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.sendUserAppMsgData(msgData);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setEnableInEarMonitor(boolean enable) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setEnableInEarMonitor(enable);
        }

        return RTC_CALL_NO_INIT;
    }

    public int enableVideoEngine() {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.enableVideoEngine();
        }
        return RTC_CALL_NO_INIT;
    }

    public int disableVideoEngine() {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.disableVideoEngine();
        }
        return RTC_CALL_NO_INIT;
    }

    public int setVideoEncoderConfig(ThunderVideoEncoderConfiguration vConfig) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setVideoEncoderConfig(vConfig);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setLocalVideoCanvas(ThunderVideoCanvas localView) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setLocalVideoCanvas(localView);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setRemoteVideoCanvas(ThunderVideoCanvas remoteView) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setRemoteVideoCanvas(remoteView);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setLocalCanvasScaleMode(int mode) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setLocalCanvasScaleMode(mode);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setRemoteCanvasScaleMode(String uid, int mode) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setRemoteCanvasScaleMode(uid, mode);
        }
        return RTC_CALL_NO_INIT;
    }

    public int startPreview() {
        if (mYYLiveRtcEngine != null) {
            int ret = mYYLiveRtcEngine.startVideoPreview();
            if (ret == 0) {
                mThunderEventDispatcher.onStartPreview();
            }
            return ret;
        }

        return RTC_CALL_NO_INIT;
    }

    public int stopVideoPreview() {
        mThunderEventDispatcher.onStopPreview();
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.stopVideoPreview();
        }
        return RTC_CALL_NO_INIT;
    }

    public int enableLocalVideoCapture(boolean enable) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.enableLocalVideoCapture(enable);
        }
        return RTC_CALL_NO_INIT;
    }

    public int stopLocalVideoStream(boolean stop) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.stopLocalVideoStream(stop);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setCustomVideoSource(ThunderCustomVideoSource videoSource) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setCustomVideoSource(videoSource);
        }
        return RTC_CALL_NO_INIT;
    }

    public int stopRemoteVideoStream(String uid, boolean stop) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.stopRemoteVideoStream(uid, stop);
        }
        return RTC_CALL_NO_INIT;
    }

    public int stopAllRemoteVideoStreams(boolean stop) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.stopAllRemoteVideoStreams(stop);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setExternalAudioSource(boolean enabled, int sampleRate, int channels) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setCustomAudioSource(enabled, sampleRate, channels);
        }
        return RTC_CALL_NO_INIT;
    }

    public int pushExternalAudioFrame(byte[] data, long timeStamp) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.pushCustomAudioFrame(data, timeStamp);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setVideoSource(ThunderCustomVideoSource videoSource) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setCustomVideoSource(videoSource);
        }
        return RTC_CALL_NO_INIT;
    }

    public int addVideoWatermark(ThunderBoltImage watermark) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setVideoWatermark(watermark);
        }
        return RTC_CALL_NO_INIT;
    }

    public int addSubscribe(String channelId, String uid) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.addSubscribe(channelId, uid);
        }
        return RTC_CALL_NO_INIT;
    }

    public int removeSubsribe(String channelId, String uid) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.removeSubscribe(channelId, uid);
        }
        return RTC_CALL_NO_INIT;
    }

    public int addPublishOriginStreamUrl(String url) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.addPublishOriginStreamUrl(url);
        }
        return RTC_CALL_NO_INIT;
    }

    public int removePublishOriginStreamUrl(String url) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.removePublishOriginStreamUrl(url);
        }
        return RTC_CALL_NO_INIT;
    }

    public int addPublishTranscodingStreamUrl(String taskId, String url) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.addPublishTranscodingStreamUrl(taskId, url);
        }
        return RTC_CALL_NO_INIT;
    }

    public int removePublishTranscodingStreamUrl(String taskId, String url) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.removePublishTranscodingStreamUrl(taskId, url);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setLiveTranscodingTask(String taskId, LiveTranscoding transcoding) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setLiveTranscodingTask(taskId, transcoding);
        }
        return RTC_CALL_NO_INIT;
    }

    public int removeLiveTranscodingTask(String taskId) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.removeLiveTranscodingTask(taskId);
        }
        return RTC_CALL_NO_INIT;
    }

    public int enableWebSdkCompatibility(boolean enabled) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.enableWebSdkCompatibility(enabled);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setVideoCaptureOrientation(int orientation) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setVideoCaptureOrientation(orientation);
        }
        return RTC_CALL_NO_INIT;
    }


    public int setLocalVideoMirrorMode(int mode) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setLocalVideoMirrorMode(mode);
        }
        return RTC_CALL_NO_INIT;
    }

    public int switchFrontCamera(boolean bFront) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.switchFrontCamera(bFront);
        }
        return RTC_CALL_NO_INIT;
    }

    /**
     * {@link IGPUProcess} 接口对象实例；如果传入 null，则取消注册
     *
     * @param observer 用于设置获取处理每一帧video渲染纹理的实例
     * @return <0 返回异常 0正常
     */
    public int registerVideoCaptureTextureObserver(IGPUProcess observer) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.registerVideoCaptureTextureObserver(observer);
        }
        return RTC_CALL_NO_INIT;
    }

    /**
     * {@link IVideoCaptureObserver} 接口对象实例；如果传入 null，则取消注册
     *
     * @param observer 用于设置分别获取video camera yuv采集和video渲染数据的实例
     * @return <0 返回异常 0正常
     */
    public int registerVideoCaptureFrameObserver(IVideoCaptureObserver observer) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.registerVideoCaptureFrameObserver(observer);
        }
        return RTC_CALL_NO_INIT;
    }

    public int setMultiVideoViewLayout(ThunderMultiVideoViewParam params) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.setMultiVideoViewLayout(params);
        }
        return RTC_CALL_NO_INIT;
    }

    public int registerVideoDecodeFrameObserver(String uid, IVideoDecodeObserver observer) {
        if (mYYLiveRtcEngine != null) {
            return mYYLiveRtcEngine.registerVideoDecodeFrameObserver(uid, observer);
        }
        return RTC_CALL_NO_INIT;
    }
}
