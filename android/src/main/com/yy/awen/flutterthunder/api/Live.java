package com.yy.awen.flutterthunder.api;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.text.TextUtils;
import android.util.Log;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.thunder.livesdk.ThunderMultiVideoViewParam;
import com.thunder.livesdk.ThunderVideoCanvas;
import com.thunder.livesdk.ThunderVideoEncoderConfiguration;
import com.yy.awen.flutterthunder.EventChannelManager;
import com.yy.awen.flutterthunder.platform.LiveStreamView;
import com.yy.awen.flutterthunder.sdk.AbsThunderEventHandler;
import com.yy.awen.flutterthunder.sdk.LiveSDKManager;
import com.yy.awen.flutterthunder.sdk.ThunderEventHandlerImpl;
import com.yy.awen.flutterthunder.srceenrecord.APIConfig;
import com.yy.awen.flutterthunder.srceenrecord.RemoteService;
import com.yy.awen.flutterthunder.utils.Constants;
import com.yy.awen.flutterthunder.utils.ScreenUtils;
import com.yy.videoplayer.videoview.VideoPosition;

import org.json.JSONObject;

import java.io.InputStream;
import java.nio.FloatBuffer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class Live implements IMethodCall {

    private boolean isInit = false;
    private long time;
    private PluginRegistry.Registrar registrar;
    private io.flutter.plugin.common.MethodCall call;
    private MethodChannel.Result result;
    private Messenger messenger;
    private String token;
    private String roomId;
    private String uid;
    private String appId;
    private Integer sceneId;
    private volatile boolean isInitServiceConnection;

    private AbsThunderEventHandler mThunderEventHandler;

    public Live() {
        mThunderEventHandler = new ThunderEventHandlerImpl() {

            @Override
            public void onLeaveRoom(RoomStats status) {
                super.onLeaveRoom(status);
                LiveSDKManager.getInstance().removeThunderEventHandler(mThunderEventHandler);
            }
        };
    }

    @Override
    public boolean onMethodCall(PluginRegistry.Registrar registrar, MethodCall call, MethodChannel.Result result) {
        this.registrar = registrar;
        this.call = call;
        this.result = result;
        if (call.method.equals("joinRoom")) {
            return joinRoom();
        } else if (call.method.equals("leaveRoom")) {
            return leaveRoom();
        } else if (call.method.equals("enableAudioEngine")) {
            return enableAudioEngine();
        } else if (call.method.equals("disableAudioEngine")) {
            return disableAudioEngine();
        } else if (call.method.equals("setAudioConfig")) {
            return setAudioConfig();
        } else if (call.method.equals("enableVideo")) {
            return enableVideo();
        } else if (call.method.equals("init")) {
            return init();
        } else if (call.method.equals("createEngine")) {
            return init();
        } else if (call.method.equals("destroyEngine")) {
            isInit = false;
            LiveSDKManager.getInstance().destroyEngine();
            result.success(Constants.FLUTTER_OK);
            return true;
        } else if (call.method.equals("addSubscribe")) {
            return addSubscribe();
        } else if (call.method.equals("removeSubscribe")) {
            return removeSubscribe();
        } else if (call.method.equals("updateToken")) {
            return updateToken();
        } else if (call.method.equals("setAudioSourceType")) {
            return setAudioSourceType();
        } else if (call.method.equals("setAudioVolumeIndication")) {
            return setAudioVolumeIndication();
        } else if (call.method.equals("stopLocalAudioStream")) {
            return stopLocalAudioStream();
        } else if (call.method.equals("stopRemoteAudioStream")) {
            return stopRemoteAudioStream();
        } else if (call.method.equals("stopAllRemoteAudioStreams")) {
            return stopAllRemoteAudioStreams();
        } else if (call.method.equals("enableCapturePcmDataCallBack")) {
            return enableCapturePcmDataCallBack();
        } else if (call.method.equals("enableRenderPcmDataCallBack")) {
            return enableRenderPcmDataCallBack();
        } else if (call.method.equals("enableCaptureVolumeIndication")) {
            return enableCaptureVolumeIndication();
        } else if (call.method.equals("enableLoudspeaker")) {
            return enableLoudspeaker();
        } else if (call.method.equals("isLoudspeakerEnabled")) {
            return isLoudspeakerEnabled();
        } else if (call.method.equals("setLoudSpeakerVolume")) {
            return setLoudSpeakerVolume();
        } else if (call.method.equals("setMicVolume")) {
            return setMicVolume();
        } else if (call.method.equals("setPlayVolume")) {
            return setPlayVolume();
        } else if (call.method.equals("enableVideoEngine")) {
            return enableVideoEngine();
        } else if (call.method.equals("disableVideoEngine")) {
            return disableVideoEngine();
        } else if (call.method.equals("startVideoPreview")) {
            return startVideoPreview();
        } else if (call.method.equals("stopVideoPreview")) {
            return stopVideoPreview();
        } else if (call.method.equals("enableLocalVideoCapture")) {
            return enableLocalVideoCapture();
        } else if (call.method.equals("stopLocalVideoStream")) {
            return stopLocalVideoStream();
        } else if (call.method.equals("stopRemoteVideoStream")) {
            return stopRemoteVideoStream();
        } else if (call.method.equals("stopAllRemoteVideoStreams")) {
            return stopAllRemoteVideoStreams();
        } else if (call.method.equals("setLocalVideoMirrorMode")) {
            return setLocalVideoMirrorMode();
        } else if (call.method.equals("setVideoCaptureOrientation")) {
            return setVideoCaptureOrientation();
        } else if (call.method.equals("setRoomMode")) {
            return setRoomMode();
        } else if (call.method.equals("setMediaMode")) {
            return setMediaMode();
        } else if (call.method.equals("setVideoEncoderConfig")) {
            return setVideoEncoderConfig();
        } else if (call.method.equals("setLocalVideoCanvas")) {
            return setLocalVideoCanvas();
        } else if (call.method.equals("unbindLocalVideoCanvas")) {
            return unbindLocalVideoCanvas();
        } else if (call.method.equals("setRemoteVideoCanvas")) {
            return setRemoteVideoCanvas();
        } else if (call.method.equals("unbindRemoteVideoCanvas")) {
            return unbindRemoteVideoCanvas();
        } else if (call.method.equals("setLocalCanvasScaleMode")) {
            return setLocalCanvasScaleMode();
        } else if (call.method.equals("setRemoteCanvasScaleMode")) {
            return setRemoteCanvasScaleMode();
        } else if (call.method.equals("setMultiVideoViewLayout")) {
            return setMultiVideoViewLayout();
        } else if (call.method.equals("setLogFilePath")) {
            return setLogFilePath();
        } else if (call.method.equals("setRemotePlayType")) {
            return setRemotePlayType();
        } else if (call.method.equals("recordScreen")) {
            return recordScreen();
        } else if (call.method.equals("registerVideoCaptureTextureObserver")) {
            return registerVideoCaptureTextureObserver();
        } else if (call.method.equals("registerVideoCaptureFrameObserver")) {
            return registerVideoCaptureFrameObserver();
        } else if (call.method.equals("registerVideoDecodeFrameObserver")) {
            return registerVideoDecodeFrameObserver();
        }else if (call.method.equals("setEnableInEarMonitor")) {
            return setEnableInEarMonitor();
        }
        return false;
    }

    private boolean recordScreen() {
        token = call.argument("token");
        roomId = call.argument("roomId");
        uid = call.argument("uid");
        boolean stop = call.argument("isStop");
        sceneId = call.argument("sceneId");
        if (stop) {
            if (isInitServiceConnection) {
                stopProcess();
            }
        } else {
            isInitServiceConnection = true;
            Intent service = new Intent(registrar.context(), RemoteService.class);
            registrar.context().bindService(service, mSc, Context.BIND_AUTO_CREATE);
        }
        result.success(Constants.FLUTTER_OK);
        return true;
    }

    private void stopProcess() {
        if (!isInitServiceConnection) {
            return;
        }
        isInitServiceConnection = false;
        sendMSG("", APIConfig.ACTION_CLOSE_RECORD_PROCESS);
        registrar.context().unbindService(mSc);
    }

    private Messenger replyMessager = new Messenger(new Handler() {
        @Override
        public void handleMessage(Message msg) {
            Log.i(Constants.tag, "receive reply message from remote service, msg.what=" + msg.what);
            switch (msg.what) {
                case 0:
                    Map<String, Object> success = new HashMap<>();
                    success.put(Constants.key, "onRecordScreen");
                    Map<String, Boolean> data = new HashMap<>();
                    data.put("success", true);
                    success.put(Constants.value, data);
                    EventChannelManager.INSTANCE.sendMessage(success);
                    break;
                case -1:
                    stopProcess();
                    Map<String, Object> fail = new HashMap<>();
                    fail.put(Constants.key, "onRecordScreen");
                    Map<String, Boolean> d = new HashMap<>();
                    d.put("success", false);
                    fail.put(Constants.value, d);
                    EventChannelManager.INSTANCE.sendMessage(fail);
                    break;
                default:
                    break;
            }
        }
    });

    ServiceConnection mSc = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            messenger = new Messenger(service);
            try {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put(Constants.key_token, token == null ? "" : token);
                jsonObject.put(Constants.key_appId, appId);
                jsonObject.put(Constants.key_roomId, roomId);
                jsonObject.put(Constants.key_uid, uid);
                jsonObject.put(Constants.key_sceneId, sceneId);
                String msg = jsonObject.toString();
                Log.d(Constants.tag, "RemoteService onServiceConnected: " + msg);
                sendMSG(msg, APIConfig.MSG_TO_SERVER);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Log.d(Constants.tag, "RemoteService onServiceDisconnected");
        }
    };

    private void sendMSG(String data, int what) {
        Message msg = new Message();
        msg.what = what;

        Bundle bundle = new Bundle();
        bundle.putString("msg", data);
        msg.setData(bundle);
        msg.replyTo = replyMessager;
        try {
            if (messenger != null) {
                messenger.send(msg);
            }
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }


    private boolean setRemotePlayType() {
        int remotePlayType = call.argument("remotePlayType");
        int value = LiveSDKManager.getInstance().setRemotePlayType(remotePlayType);
        result.success(value);
        return true;
    }

    private boolean setLogFilePath() {
        String path = call.argument("path");
        int value = LiveSDKManager.getInstance().setLogFilePath(path);
        result.success(value);
        return true;
    }

    private boolean setMultiVideoViewLayout() {
        try {
            Activity activity = registrar.activity();
            float density = ScreenUtils.Companion.getDensity(activity);
            Log.d(Constants.tag, "width: " + ScreenUtils.Companion.getWidth(activity)
                    + ", density: " + density
                    + ", densityDpi: " + ScreenUtils.Companion.getDensityDpi(activity));

            Map<String, Object> map = call.arguments();

            // bgImageName
            Bitmap mBgBitmap = null;
            if (map.containsKey("bgImageName")) {
                String img = (String) map.get("bgImageName");
                if (!TextUtils.isEmpty(img)) {
                    AssetManager assetManager = registrar.context().getAssets();
                    String key = registrar.lookupKeyForAsset("images/" + img);
                    AssetFileDescriptor fileDescriptor = assetManager.openFd(key);
                    InputStream inputStream = fileDescriptor.createInputStream();
                    mBgBitmap = BitmapFactory.decodeStream(inputStream);
                    inputStream.close();
                }
            }

            // videoPositions
            ArrayList<VideoPosition> videoPositions = null;
            if (map.containsKey("videoPositions")) {
                ArrayList<HashMap<String, Integer>> tmp;
                tmp = (ArrayList<HashMap<String, Integer>>) map.get("videoPositions");
                videoPositions = new ArrayList<>();
                if (tmp.size() > 0) {
                    for (int i = 0; i < tmp.size(); i++) {
                        HashMap<String, Integer> data = tmp.get(i);
                        VideoPosition position = new VideoPosition();
                        position.mX = data.get("x");
                        position.mX = (int) (position.mX * density);

                        position.mY = data.get("y");
                        position.mY = (int) (position.mY * density);

                        position.mWidth = data.get("width");
                        position.mWidth = (int) (position.mWidth * density);

                        position.mHeight = data.get("height");
                        position.mHeight = (int) (position.mHeight * density);

                        position.mIndex = data.get("index");
                        videoPositions.add(position);
                    }
                }
            }

            // bgCoodinate
            VideoPosition mBgPosition = null;
            if (map.containsKey("bgCoodinate")) {
                HashMap<String, Integer> data = (HashMap<String, Integer>) map.get("bgCoodinate");
                mBgPosition = new VideoPosition();
                mBgPosition.mX = data.get("x");
                mBgPosition.mX = (int) (mBgPosition.mX * density);

                mBgPosition.mY = data.get("y");
                mBgPosition.mY = (int) (mBgPosition.mY * density);

                mBgPosition.mWidth = data.get("width");
                mBgPosition.mWidth = (int) (mBgPosition.mWidth * density);

                mBgPosition.mHeight = data.get("height");
                mBgPosition.mHeight = (int) (mBgPosition.mHeight * density);

                mBgPosition.mIndex = data.get("index");
                Log.d(Constants.tag, "VideoPosition: x=" + mBgPosition.mX + ", y=" +
                        mBgPosition.mY + ",width=" + mBgPosition.mWidth +
                        ",height=" + mBgPosition.mHeight + ",index=" + mBgPosition.mIndex);
            }

            // viewIndex, viewId
            int viewIndex = -1;
            int viewId = -1;
            if (map.containsKey("viewIndex")) {
                viewIndex = (int) map.get("viewIndex");
            }
            if (map.containsKey("viewId")) {
                viewId = (int) map.get("viewId");
            }

            ThunderMultiVideoViewParam param = new ThunderMultiVideoViewParam(videoPositions,
                    mBgPosition, mBgBitmap);
            if (viewIndex >= 0) {
                param.mViewId = viewIndex;
                if (viewId == -1) { // 销毁对应view及布局
                    param.mView = null;
                    int value = LiveSDKManager.getInstance().setMultiVideoViewLayout(param);
                    Log.d(Constants.tag, "setMultiVideoViewLayout value = " + value);
                    result.success(value);
                } else {
                    LiveStreamView.MultiPlayerViewParamHolder.put(viewId, param);
                    Intent intent = new Intent(Constants.broadcast_setMultiVideoViewLayout);
                    intent.putExtra("viewId", viewId);
                    LocalBroadcastManager.getInstance(registrar.activity()).sendBroadcast(intent);
                    result.success(Constants.FLUTTER_OK);
                }
            } else {
                int value = LiveSDKManager.getInstance().setMultiVideoViewLayout(param);
                Log.d(Constants.tag, "setMultiVideoViewLayout value = " + value);
                result.success(value);
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.success(Constants.FLUTTER_FAIL);
        }
        return true;
    }

    private boolean setRemoteCanvasScaleMode() {
        String uid = call.argument("uid");
        int renderMode = call.argument("mode");
        int value = LiveSDKManager.getInstance().setRemoteCanvasScaleMode(uid, renderMode);
        result.success(value);
        return true;
    }

    private boolean setLocalCanvasScaleMode() {
        int mode = call.argument("mode");
        int value = LiveSDKManager.getInstance().setLocalCanvasScaleMode(mode);
        result.success(value);
        return true;
    }

    private boolean setRemoteVideoCanvas() {
        int viewId = call.argument("viewId");
        int renderMode = call.argument("renderMode");
        String uid = call.argument("uid");
        Integer obj = call.argument("seatIndex");
        int index = -1;
        if (obj != null) {
            index = obj;
        }
        Intent intent = new Intent(Constants.broadcast_watchLive);
        intent.putExtra(Constants.command, Constants.command_startRemotePreview);
        intent.putExtra("uid", uid);
        intent.putExtra("viewId", viewId);
        intent.putExtra("renderMode", renderMode);
        intent.putExtra("index", index);
        LocalBroadcastManager.getInstance(registrar.activity()).sendBroadcast(intent);
        result.success(Constants.FLUTTER_OK);
        return true;
    }

    private boolean unbindRemoteVideoCanvas() {
        String uid = call.argument("uid");
        ThunderVideoCanvas canvas = new ThunderVideoCanvas(null, 0, uid);
        int value = LiveSDKManager.getInstance().setRemoteVideoCanvas(canvas);
        result.success(value);
        return true;
    }

    private boolean setLocalVideoCanvas() {
        int viewId = call.argument("viewId");
        int renderMode = call.argument("renderMode");
        String uid = call.argument("uid");
        Intent intent = new Intent(Constants.broadcast_startLive);
        intent.putExtra(Constants.command, Constants.command_startPreview);
        intent.putExtra("uid", uid);
        intent.putExtra("viewId", viewId);
        intent.putExtra("renderMode", renderMode);
        LocalBroadcastManager.getInstance(registrar.activity()).sendBroadcast(intent);
        result.success(Constants.FLUTTER_OK);
        return true;
    }

    private boolean unbindLocalVideoCanvas() {
        String uid = call.argument("uid");
        ThunderVideoCanvas canvas = new ThunderVideoCanvas(null, 0, uid);
        int value = LiveSDKManager.getInstance().setLocalVideoCanvas(canvas);
        result.success(value);
        return true;
    }

    private boolean setVideoEncoderConfig() {
        ThunderVideoEncoderConfiguration config = new ThunderVideoEncoderConfiguration();
        config.playType = call.argument("playType");
        Constants.room_mode = config.playType;
        config.publishMode = call.argument("mode");
        int value = LiveSDKManager.getInstance().setVideoEncoderConfig(config);
        result.success(value);
        return true;
    }

    private boolean setRoomMode() {
        int roomConfig = call.argument("roomConfig");
        int value = LiveSDKManager.getInstance().setRoomMode(roomConfig);
        result.success(value);
        return true;
    }

    private boolean setMediaMode() {
        int rtcConfig = call.argument("rtcConfig");
        int value = LiveSDKManager.getInstance().setMediaMode(rtcConfig);
        result.success(value);
        return true;
    }

    private boolean setVideoCaptureOrientation() {
        int orientation = call.argument("orientation");
        int value = LiveSDKManager.getInstance().setVideoCaptureOrientation(orientation);
        result.success(value);
        return true;
    }

    private boolean setLocalVideoMirrorMode() {
        int mode = call.argument("mode");
        int value = LiveSDKManager.getInstance().setLocalVideoMirrorMode(mode);
        result.success(value);
        return true;
    }

    private boolean stopAllRemoteVideoStreams() {
        boolean isStopped = call.argument("stopped");
        int value = LiveSDKManager.getInstance().stopAllRemoteVideoStreams(isStopped);
        result.success(value);
        return true;
    }

    private boolean stopRemoteVideoStream() {
        boolean stopped = call.argument("stopped");
        String uid = call.argument("uid");
        int value = LiveSDKManager.getInstance().stopRemoteVideoStream(uid, stopped);
        result.success(value);
        return true;
    }

    private boolean stopLocalVideoStream() {
        boolean stopped = call.argument("stopped");
        int value = LiveSDKManager.getInstance().stopLocalVideoStream(stopped);
        result.success(value);
        return true;
    }

    private boolean enableLocalVideoCapture() {
        boolean enable = call.argument("enable");
        int value = LiveSDKManager.getInstance().enableLocalVideoCapture(enable);
        result.success(value);
        return true;
    }

    private boolean stopVideoPreview() {
        int value = LiveSDKManager.getInstance().stopVideoPreview();
        result.success(value);
        return true;
    }

    private boolean startVideoPreview() {
        int value = LiveSDKManager.getInstance().startPreview();
        result.success(value);
        return true;
    }

    private boolean disableVideoEngine() {
        int value = LiveSDKManager.getInstance().disableVideoEngine();
        result.success(value);
        return true;
    }

    private boolean enableVideoEngine() {
        int value = LiveSDKManager.getInstance().enableVideoEngine();
        result.success(value);
        return true;
    }

    private boolean setPlayVolume() {
        String uid = call.argument("uid");
        int volume = call.argument("volume");
        int value = LiveSDKManager.getInstance().setRemoteAudioStreamsVolume(uid, volume);
        result.success(value);
        return true;
    }

    private boolean setMicVolume() {
        int volume = call.argument("volume");
        int value = LiveSDKManager.getInstance().setMicVolume(volume);
        result.success(value);
        return true;
    }

    private boolean setLoudSpeakerVolume() {
        int volume = call.argument("volume");
        int value = LiveSDKManager.getInstance().setLoudSpeakerVolume(volume);
        result.success(value);
        return true;
    }

    private boolean isLoudspeakerEnabled() {
        boolean flag = LiveSDKManager.getInstance().isLoudspeakerEnabled();
        result.success(flag);
        return true;
    }

    private boolean enableLoudspeaker() {
        boolean enable = call.argument("enable");
        int value = LiveSDKManager.getInstance().enableLoudspeaker(enable);
        result.success(value);
        return true;
    }

    private boolean enableCaptureVolumeIndication() {
        int interval = call.argument("interval");
        int moreThanThd = call.argument("moreThanThd");
        int lessThanThd = call.argument("lessThanThd");
        int soomth = call.argument("soomth");
        int value = LiveSDKManager.getInstance().enableCaptureVolumeIndication(interval,
                moreThanThd, lessThanThd, soomth);
        result.success(value);
        return true;
    }

    private boolean enableRenderPcmDataCallBack() {
        boolean enable = call.argument("enable");
        int sampleRate = call.argument("sampleRate");
        int channel = call.argument("channel");
        LiveSDKManager.getInstance().enableRenderPcmDataCallBack(enable, sampleRate, channel);
        result.success(true);
        return true;
    }

    private boolean enableCapturePcmDataCallBack() {
        boolean enable = call.argument("enable");
        int sampleRate = call.argument("sampleRate");
        int channel = call.argument("channel");
        LiveSDKManager.getInstance().enableCapturePcmDataCallBack(enable, sampleRate, channel);
        result.success(true);
        return true;
    }

    private boolean stopAllRemoteAudioStreams() {
        boolean stopped = call.argument("stopped");
        int value = LiveSDKManager.getInstance().stopAllRemoteAudioStreams(stopped);
        result.success(value);
        return true;
    }

    private boolean stopRemoteAudioStream() {
        boolean stopped = call.argument("stopped");
        String uid = call.argument("uid");
        int value = LiveSDKManager.getInstance().stopRemoteAudioStream(uid, stopped);
        result.success(value);
        return true;
    }

    private boolean stopLocalAudioStream() {
        boolean stopped = call.argument("stopped");
        int value = LiveSDKManager.getInstance().stopLocalAudioStream(stopped);
        result.success(value);
        return true;
    }

    private boolean setAudioVolumeIndication() {
        int interval = call.argument("interval");
        int moreThanThd = call.argument("moreThanThd");
        int lessThanThd = call.argument("lessThanThd");
        int soomth = call.argument("soomth");
        int value = LiveSDKManager.getInstance().setAudioVolumeIndication(interval, moreThanThd, lessThanThd, soomth);
        result.success(value);
        return true;
    }

    private boolean setAudioSourceType() {
        int sourceType = call.argument("sourceType");
        LiveSDKManager.getInstance().setAudioSourceType(sourceType);
        result.success(Constants.FLUTTER_OK);
        return true;
    }

    private boolean setAudioConfig() {
        int config = call.argument("config");
        int commutMode = call.argument("commutMode");
        int scenarioMode = call.argument("scenarioMode");
        int value = LiveSDKManager.getInstance().setAudioConfig(config, commutMode, scenarioMode);
        Log.i(Constants.tag, "setAudioConfig value = " + value);
        result.success(value);
        return true;
    }

    private boolean updateToken() {
        String token = call.argument("token");
        int value = LiveSDKManager.getInstance().updateToken(token.getBytes());
        Log.i(Constants.tag, "updateToken returnValue=" + value);
        result.success(value);
        return true;
    }

    private boolean removeSubscribe() {
        String uid = call.argument("uid");
        String sid = call.argument("roomId");
        int returnValue = LiveSDKManager.getInstance().removeSubsribe(sid, uid);
        Log.d(Constants.tag, "removeSubsribe returnValue=" + returnValue);
        result.success(returnValue);
        return true;
    }

    private boolean addSubscribe() {
        String uid = call.argument("uid");
        String sid = call.argument("roomId");
        int returnValue = LiveSDKManager.getInstance().addSubscribe(sid, uid);
        Log.d(Constants.tag, "addSubscribe returnValue=" + returnValue);
        result.success(returnValue);
        return true;
    }

    private boolean joinRoom() {
        String token = call.argument("token");
        String roomId = call.argument("roomName");
        String uid = call.argument("uid");

        LiveSDKManager.getInstance().addThunderEventHandler(mThunderEventHandler);
        byte[] bytes = null;
        if (!TextUtils.isEmpty(token)) {
            bytes = token.getBytes();
        }
        int joinRes = LiveSDKManager.getInstance().joinRoom(bytes, roomId, uid);
        Log.d(Constants.tag, "joinRoom roomId= " + roomId + " uid = " + uid);
        result.success(joinRes);
        return true;
    }

    private boolean leaveRoom() {
        int value = LiveSDKManager.getInstance().leaveRoom();
        Log.d(Constants.tag, "leaveRoom");
        result.success(value);
        return true;
    }

    private boolean init() {
        if (isInit) {
            Log.d(Constants.tag, "init LiveSDK again,last init time: " + time);
        }

        Log.d(Constants.tag, "init LiveSDK");

        try {
            appId = call.argument("appId");
            int area = call.argument("area");
            boolean is64bitUid = call.argument("is64bitUid");
            // initRuntime
//            initRuntime(registrar.activity().getApplication(), true);

            LiveSDKManager.getInstance().initialize(registrar.activity().getApplication(), appId, 0);
            LiveSDKManager.getInstance().setArea(area);
            LiveSDKManager.getInstance().setUse64bitUid(is64bitUid);
            isInit = true;
            time = System.currentTimeMillis();
            result.success(Constants.FLUTTER_OK);
        } catch (Exception e) {
            e.printStackTrace();
            result.success(Constants.FLUTTER_FAIL);
        }
        return true;
    }

//    private void initRuntime(Application application, Boolean isDebug) {
//        /**
//         * 设置全局context
//         */
//        RuntimeInfo.INSTANCE.appContext(application)
//                /**
//                 * 设置包名
//                 */
//                .packageName(application.getPackageName())
//                /**
//                 * 保存进程名
//                 */
//                .processName(ProcessorUtils.INSTANCE.getMyProcessName())
//                /**
//                 * 设置是否是debug 模式
//                 */
//                .isDebuggable(isDebug)
//                /**
//                 * 保存当前进程是否是主进程
//                 */
//                .isMainProcess(FP.eq(RuntimeInfo.sPackageName, RuntimeInfo.sProcessName));
//    }

    private boolean enableVideo() {
        Boolean enable = (Boolean) call.arguments;
        if (enable != null) {
            int value = LiveSDKManager.getInstance().stopLocalVideoStream(!enable);
            result.success(value);
        } else {
            result.success(Constants.FLUTTER_FAIL);
        }
        return true;
    }

    private boolean enableAudioEngine() {
        int value = LiveSDKManager.getInstance().enableAudioEngine();
        result.success(value);
        return true;
    }

    private boolean disableAudioEngine() {
        int value = LiveSDKManager.getInstance().disableAudioEngine();
        result.success(value);
        return true;
    }

    private boolean registerVideoCaptureTextureObserver() {
        com.yy.mediaframework.gpuimage.custom.IGPUProcess iGPUProcess =
                new com.yy.mediaframework.gpuimage.custom.IGPUProcess() {
                    @Override
                    public void onInit(int textureTarget, int outputWidth, int outputHeight) {
                        if (ThunderEventCallback.getInstance().getGPUProcess() != null) {
                            ThunderEventCallback.getInstance().getGPUProcess().onInit(textureTarget, outputWidth,
                                    outputHeight);
                        }
                    }

                    @Override
                    public void onDraw(int i, FloatBuffer floatBuffer) {
                        if (ThunderEventCallback.getInstance().getGPUProcess() != null) {
                            ThunderEventCallback.getInstance().getGPUProcess().onDraw(i, floatBuffer);
                        }
                    }

                    @Override
                    public void onDestroy() {
                        if (ThunderEventCallback.getInstance().getGPUProcess() != null) {
                            ThunderEventCallback.getInstance().getGPUProcess().onDestroy();
                        }
                    }

                    @Override
                    public void onOutputSizeChanged(int width, int height) {
                        if (ThunderEventCallback.getInstance().getGPUProcess() != null) {
                            ThunderEventCallback.getInstance().getGPUProcess().onOutputSizeChanged(width, height);
                        }
                    }
                };
        result.success(LiveSDKManager.getInstance().registerVideoCaptureTextureObserver(iGPUProcess));
        return true;
    }

    private boolean registerVideoCaptureFrameObserver() {
        com.thunder.livesdk.video.IVideoCaptureObserver observer = (width, height, data, length, imageFormat) -> {
            if (ThunderEventCallback.getInstance().getVideoCaptureObserver() != null) {
                ThunderEventCallback.getInstance().getVideoCaptureObserver().onCaptureVideoFrame(width, height, data,
                        length, imageFormat);
            }
        };
        result.success(LiveSDKManager.getInstance().registerVideoCaptureFrameObserver(observer));
        return true;
    }

    private boolean registerVideoDecodeFrameObserver() {
        String uid = call.argument("uid");
        com.thunder.livesdk.video.IVideoDecodeObserver observer = (uid1, w, h, data, dateLen, renderTimeMs) -> {
            if (ThunderEventCallback.getInstance().getVideoDecodeObserver() != null) {
                ThunderEventCallback.getInstance().getVideoDecodeObserver().onVideoDecodeFrame(uid1, w, h, data,
                        dateLen, renderTimeMs);
            }
        };
        result.success(LiveSDKManager.getInstance().registerVideoDecodeFrameObserver(uid, observer));
        return true;
    }

    private boolean setEnableInEarMonitor() {
        boolean enable = call.argument("enable");
        result.success(LiveSDKManager.getInstance().setEnableInEarMonitor(enable));
        return true;
    }
}
