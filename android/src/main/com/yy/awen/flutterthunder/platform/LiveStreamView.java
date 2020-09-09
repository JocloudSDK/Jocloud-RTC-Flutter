package com.yy.awen.flutterthunder.platform;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.thunder.livesdk.ThunderMultiVideoViewParam;
import com.thunder.livesdk.ThunderVideoCanvas;
import com.thunder.livesdk.video.ThunderPlayerMultiView;
import com.thunder.livesdk.video.ThunderPlayerView;
import com.thunder.livesdk.video.ThunderPreviewView;
import com.yy.awen.flutterthunder.sdk.LiveSDKManager;
import com.yy.awen.flutterthunder.utils.Constants;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

public class LiveStreamView implements PlatformView {

    private int id;
    private Context context;
    private FrameLayout frameLayout;
    private ThunderPlayerMultiView thunderPlayerMultiView;

    public static class MultiPlayerViewParamHolder {
        static Map<Integer, ThunderMultiVideoViewParam> mThunderMultiVideoViewParams = new HashMap<>();

        public static void put(int viewId, ThunderMultiVideoViewParam param) {
            if (viewId >= 0 && param != null) {
                mThunderMultiVideoViewParams.put(viewId, param);
            }
        }

        public static ThunderMultiVideoViewParam get(int viewId) {
            if (mThunderMultiVideoViewParams.containsKey(viewId)) {
                return mThunderMultiVideoViewParams.get(viewId);
            }
            return null;
        }

        public static void remove(int viewId) {
            if (viewId >= 0 && mThunderMultiVideoViewParams.containsKey(viewId)) {
                mThunderMultiVideoViewParams.remove(viewId);
            }
        }

        public static boolean contains(int viewId) {
            return mThunderMultiVideoViewParams.containsKey(viewId);
        }

        public static void clear() {
            if (mThunderMultiVideoViewParams != null) {
                mThunderMultiVideoViewParams.clear();
            }
        }
    }

    private BroadcastReceiver receiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent == null)
                return;
            String action = intent.getAction();
            switch (action) {
                case Constants.broadcast_startLive:
                    dealStartLive(intent);
                    break;
                case Constants.broadcast_watchLive:
                    dealWatchLive(intent);
                    break;
                case Constants.broadcast_removeNativeView:
                    dealRemoveNativeView(intent);
                    break;
                case Constants.broadcast_setMultiVideoViewLayout:
                    dealSetMultiPlayerViewLayout(intent);
                    break;
            }
        }
    };

    private void dealWatchLive(Intent intent) {
        String command = intent.getStringExtra(Constants.command);
        if (TextUtils.isEmpty(command)) {
            return;
        }
        if (command.equals(Constants.command_startRemotePreview)) {
            String uid = intent.getStringExtra("uid");
            int renderMode = intent.getIntExtra("renderMode", 2);
            int viewId = intent.getIntExtra("viewId", -1);
            int index = intent.getIntExtra("index", -1);
            Log.d(Constants.tag, "dealWatchLive:viewId " + viewId);
            Log.d(Constants.tag, "dealWatchLive:id " + id);

            if (viewId == id) {
                addRemoteVideoView(uid, renderMode, index);
            }
        }
    }

    private void dealStartLive(Intent intent) {
        String command = intent.getStringExtra(Constants.command);
        if (TextUtils.isEmpty(command)) {
            return;
        }
        if (command.equals(Constants.command_startPreview)) {
            String uid = intent.getStringExtra("uid");
            int renderMode = intent.getIntExtra("renderMode", 1);
            int viewId = intent.getIntExtra("viewId", -1);
            int index = intent.getIntExtra("index", -1);
            if (viewId == id) {
                addLocalVideoView(uid, renderMode, index);
            }
        }
    }

    private void dealRemoveNativeView(Intent intent) {
        int viewId = intent.getIntExtra("viewId", -1);
        if (viewId < 0) {
            Log.d(Constants.tag, "LiveStreamView dealRemoveNativeView call failed: viewId = " + viewId);
            return;
        }
        if (viewId == id && frameLayout != null && frameLayout.isAttachedToWindow()) {
            frameLayout.removeAllViews();
        }
    }

    private void dealSetMultiPlayerViewLayout(Intent intent) {
        int viewId = intent.getIntExtra("viewId", -1);
//        if (viewId == id && frameLayout != null) {
//            int count = frameLayout.getChildCount();
//            if (count > 0) {
//                ThunderPlayerMultiView multiView = null;
//                for (int i = 0; i < count; i++) {
//                    View childView = frameLayout.getChildAt(i);
//                    if (childView != null && childView instanceof ThunderPlayerMultiView) {
//                        multiView = (ThunderPlayerMultiView) childView;
//                        break;
//                    }
//                }
//                if (multiView != null) {
//                    Log.d(Constants.tag, "LiveStreamView dealSetMultiPlayerViewLayout viewId = " + viewId);
//                    setMultiVideoViewLayoutParams(multiView);
//                }
//            }
//        }
        if (thunderPlayerMultiView != null && viewId == id && MultiPlayerViewParamHolder.contains(id)) {
            ThunderMultiVideoViewParam param = MultiPlayerViewParamHolder.get(id);
            if (param != null) {
                param.mView = thunderPlayerMultiView;
                int value = LiveSDKManager.getInstance().setMultiVideoViewLayout(param);
                Log.d(Constants.tag, "LiveStreamView dealSetMultiVideoViewLayout value = " + value);

//                MultiPlayerViewParamHolder.remove(id);
            }
        }
    }

    private void setMultiVideoViewLayoutParams(ThunderPlayerMultiView multiView) {
        if (multiView != null && MultiPlayerViewParamHolder.contains(id)) {
            ThunderMultiVideoViewParam param = MultiPlayerViewParamHolder.get(id);
            if (param != null) {
                param.mView = multiView;
                int result = LiveSDKManager.getInstance().setMultiVideoViewLayout(param);
                Log.d(Constants.tag, "LiveStreamView setMultiVideoViewLayoutParams viewId = " + id + ", result = " + result);

//                MultiPlayerViewParamHolder.remove(id);
            }
        }
    }

    public LiveStreamView(Context context, int id) {
        Log.d(Constants.tag, "LiveStreamView init, viewId = " + id);

        this.id = id;
        this.context = context;

        IntentFilter filter = new IntentFilter();
        filter.addAction(Constants.broadcast_startLive);
        filter.addAction(Constants.broadcast_watchLive);
        filter.addAction(Constants.broadcast_removeNativeView);
        filter.addAction(Constants.broadcast_setMultiVideoViewLayout);
        LocalBroadcastManager.getInstance(context).registerReceiver(receiver, filter);

        frameLayout = new FrameLayout(context);
    }

    @Override
    public View getView() {
        return frameLayout;
    }

    @Override
    public void dispose() {
        Log.d(Constants.tag, "LiveStreamView dispose()");

        LocalBroadcastManager.getInstance(context).unregisterReceiver(receiver);
        MultiPlayerViewParamHolder.clear();

        frameLayout.removeAllViews();
    }

    private void addLocalVideoView(String uid, int renderMode, int index) {
        Log.d(Constants.tag, "LiveStreamView addLocalVideoView uid = " + uid
                + ", renderMode = " + renderMode + ", index = " + index);

        frameLayout.removeAllViews();
        ThunderPreviewView previewView = new ThunderPreviewView(context);
        ThunderVideoCanvas videoCanvas = new ThunderVideoCanvas(previewView,
                renderMode, uid, index);
        LiveSDKManager.getInstance().setLocalVideoCanvas(videoCanvas);
        frameLayout.addView(previewView, FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
    }

    private void addRemoteVideoView(String remoteUid, int renderMode, int seatIndex) {
        Log.d(Constants.tag, "LiveStreamView addRemoteVideoView remoteUid = " + remoteUid
                + ", renderMode = " + renderMode + ", seatIndex = " + seatIndex
                + ", roomMode = " + Constants.room_mode + ", viewId = " + id);

        if (Constants.room_mode == 3) {
            if (thunderPlayerMultiView == null) {
                frameLayout.removeAllViews();
                thunderPlayerMultiView = new ThunderPlayerMultiView(context);
                frameLayout.addView(thunderPlayerMultiView,
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT);
            }
            ThunderVideoCanvas thunderVideoCanvas = new ThunderVideoCanvas(thunderPlayerMultiView, renderMode, remoteUid, seatIndex);
            setMultiVideoViewLayoutParams(thunderPlayerMultiView);
            LiveSDKManager.getInstance().setRemoteVideoCanvas(thunderVideoCanvas);
//            frameLayout.removeAllViews();
//            ThunderPlayerMultiView multiView = new ThunderPlayerMultiView(context);
//            ThunderVideoCanvas videoCanvas = new ThunderVideoCanvas(multiView, renderMode, remoteUid, seatIndex);
//            setMultiVideoViewLayoutParams(multiView);
//            LiveSDKManager.getInstance().setRemoteVideoCanvas(videoCanvas);
//            frameLayout.addView(multiView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        } else {
            frameLayout.removeAllViews();
            ThunderPlayerView playerView = new ThunderPlayerView(context);
            ThunderVideoCanvas videoCanvas = new ThunderVideoCanvas(playerView, renderMode, remoteUid, seatIndex);
            LiveSDKManager.getInstance().setRemoteVideoCanvas(videoCanvas);
            frameLayout.addView(playerView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        }
    }
}
