package com.yy.awen.flutterthunder.srceenrecord;

import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.RequiresApi;

import com.thunder.livesdk.ThunderRtcConstant;
import com.yy.awen.flutterthunder.sdk.AbsThunderEventHandler;
import com.yy.awen.flutterthunder.sdk.LiveSDKManager;
import com.yy.awen.flutterthunder.utils.Constants;

import org.json.JSONObject;

public class RemoteService extends Service implements Observer {

    private String token;
    private String roomId;
    private String uid;
    private long sceneId;
    private Messenger replay;

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onCreate() {
        super.onCreate();
        ObserverManager.getInstance().addObserver(this);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d(Constants.tag, "RemoteService onDestroy");
        close();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return messager.getBinder();
    }

    private void callResultToMain(int code) {
        if (replay != null) {
            Message msg_client = IncomingHandler.obtainMessage();
            msg_client.what = code;
            try {
                replay.send(msg_client);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }

    Handler IncomingHandler = new Handler() {

        @Override
        public void handleMessage(Message msg) {
            String data = msg.getData().getString("msg");
            replay = msg.replyTo;
            Log.d(Constants.tag, "RemoteService handleMessage msg=" + msg.toString());
            switch (msg.what) {
                case APIConfig.MSG_TO_SERVER:
                    try {
                        JSONObject object = new JSONObject(data);
                        token = object.optString(Constants.key_token, "");
                        String appId = object.optString(Constants.key_appId, "");
                        roomId = object.optString(Constants.key_roomId, "");
                        uid = object.optString(Constants.key_uid, "");
                        sceneId = object.optLong(Constants.key_sceneId, 0);
                        if (TextUtils.isEmpty(appId) || TextUtils.isEmpty(roomId) || TextUtils.isEmpty(uid)) {
                            Log.d(Constants.tag, "RemoteService handleMessage APIConfig.MSG_TO_SERVER 传入的参数有错误");
                            callResultToMain(-1);
                            return;
                        }
                        initThunderSDk(appId, sceneId);
                        Intent intent = new Intent(RemoteService.this, ScreenRecordActivity.class);
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);
                    } catch (Exception e) {
                        e.printStackTrace();
                        callResultToMain(-1);
                    }
                    break;
                case APIConfig.ACTION_CLOSE_RECORD_PROCESS:
                    close();
                    System.exit(0);
                    android.os.Process.killProcess(android.os.Process.myPid());
                    break;
                default:
                    super.handleMessage(msg);
            }
        }

    };

    Messenger messager = new Messenger(IncomingHandler);

    private void initThunderSDk(String appId, long sceneId) {
        Log.d(Constants.tag, "initThunderSDk, appId=" + appId + ", sceneId=" + sceneId);
        LiveSDKManager.getInstance()
                .initialize(this.getApplication(), appId, sceneId);
        LiveSDKManager.getInstance().addThunderEventHandler(mThunderEventHandler);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void startPush() {
        //麦克风
        LiveSDKManager.getInstance().setAudioSourceType(ThunderRtcConstant.SourceType.THUNDER_PUBLISH_MODE_MIC);
        LiveSDKManager.getInstance().setAudioVolumeIndication(500, 16, 16, 3);
        LiveSDKManager.getInstance().enableCaptureVolumeIndication(500, 16, 16, 3);
        //业务逻辑
        LiveSDKManager.getInstance().stopAllRemoteAudioStreams(true);
        LiveSDKManager.getInstance().stopAllRemoteVideoStreams(true);
        LiveSDKManager.getInstance().stopLocalVideoStream(false);
    }

    private AbsThunderEventHandler mThunderEventHandler = new AbsThunderEventHandler() {
        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public void onJoinRoomSuccess(String room, String uid, int elapsed) {
            super.onJoinRoomSuccess(room, uid, elapsed);
            Log.d(Constants.tag, "RemoteService onJoinRoomSuccess roomId=" + room +
                    ", uid=" + uid);
            startPush();
        }

        @Override
        public void onRemoteAudioStopped(String uid, boolean stop) {
            super.onRemoteAudioStopped(uid, stop);
            Log.d(Constants.tag, "RemoteService onRemoteAudioStopped uid=" + uid +
                    ", stop=" + stop);
        }

        @Override
        public void onRemoteVideoStopped(String uid, boolean stop) {
            super.onRemoteVideoStopped(uid, stop);
            Log.d(Constants.tag, "RemoteService onRemoteVideoStopped  uid=" + uid +
                    ", stop=" + stop);
        }
    };

    private void close() {
        LiveSDKManager.getInstance().stopLocalVideoStream(true);
        LiveSDKManager.getInstance().stopVideoPreview();
        LiveSDKManager.getInstance().leaveRoom();
        LiveSDKManager.getInstance().removeThunderEventHandler(mThunderEventHandler);
        ObserverManager.getInstance().removeObserver(this);
    }

    @Override
    public void event(String msg) {
        if (TextUtils.isEmpty(msg)) {
            return;
        }

        switch (msg) {
            case "success":
                if (TextUtils.isEmpty(token)) {
                    LiveSDKManager.getInstance().joinRoom(null, roomId, uid);
                } else {
                    LiveSDKManager.getInstance().joinRoom(token.getBytes(), roomId, uid);
                }
                callResultToMain(0);
                break;
            case "fail":
                callResultToMain(-1);
//                android.os.Process.killProcess(android.os.Process.myPid());
                break;
        }

    }
}
