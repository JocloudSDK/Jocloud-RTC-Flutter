package com.yy.awen.flutterthunder.srceenrecord;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Surface;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.RequiresApi;

import com.thunder.livesdk.ScreenRecordSource;
import com.thunder.livesdk.ThunderRtcConstant;
import com.thunder.livesdk.ThunderVideoEncoderConfiguration;
import com.yy.awen.flutterthunder.sdk.LiveSDKManager;
import com.yy.awen.flutterthunder.utils.Constants;

import static com.thunder.livesdk.ThunderRtcConstant.RoomConfig.THUNDER_ROOMCONFIG_LIVE;
import static com.thunder.livesdk.ThunderRtcConstant.ThunderRtcProfile.THUNDER_PROFILE_DEFAULT;

public class ScreenRecordActivity extends Activity {

    private static final int REQUEST_CODE = 1001;

    private MediaProjection mMediaProjection;
    private MediaProjectionManager mMediaProjectionManager;
    private Intent screenCaptureIntent;
    private ScreenRecordSource mScreenRecordSource;

    private OrientationReceiver orientationReceiver = new OrientationReceiver();

    public class OrientationReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            boolean isHorizontalScreen = isHorizontalScreen();
            Log.d(Constants.tag, "ScreenRecordActivity OrientationReceiver onReceive: isHorizontalScreen=" + isHorizontalScreen);
            if (mScreenRecordSource != null && mScreenRecordSource.mScreenCapture != null) {
                //增加动态横竖屏开播
//                mScreenRecordSource.mScreenCapture.setIslandScape(isHorizontalScreen);
//                0:竖屏 1:横屏
                LiveSDKManager.getInstance().setVideoCaptureOrientation(isHorizontalScreen ?
                        ThunderRtcConstant.ThunderVideoCaptureOrientation.THUNDER_VIDEO_CAPTURE_ORIENTATION_LANDSCAPE : ThunderRtcConstant.ThunderVideoCaptureOrientation.THUNDER_VIDEO_CAPTURE_ORIENTATION_PORTRAIT);
                setConfig(mScreenRecordSource);
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //注册系统广播
        registerOrientationReceiver();
        setStatusBarFullTransparent();

        mMediaProjectionManager = (MediaProjectionManager) this.getSystemService(MEDIA_PROJECTION_SERVICE);
        screenCaptureIntent = mMediaProjectionManager.createScreenCaptureIntent();
        startActivityForResult(screenCaptureIntent, REQUEST_CODE);
    }

    private void registerOrientationReceiver() {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(APIConfig.CONFIGURATION_CHANGED);
        registerReceiver(orientationReceiver, intentFilter);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.d(Constants.tag, "ScreenRecordActivity onActivityResult requestCode=" + requestCode + ", resultCode="
                + resultCode + ", data=" + (data == null ? "null" : data.toString()));
        if (requestCode == REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                mMediaProjection = mMediaProjectionManager.getMediaProjection(resultCode, data);
                mScreenRecordSource = new ScreenRecordSource(mMediaProjection);
                LiveSDKManager.getInstance().setVideoCaptureOrientation(ThunderRtcConstant.ThunderVideoCaptureOrientation.THUNDER_VIDEO_CAPTURE_ORIENTATION_LANDSCAPE);
                setConfig(mScreenRecordSource);
                moveTaskToBack(true);
                ObserverManager.getInstance().sendMessage("success");
            } else {
//                Toast.makeText(this, "获取MediaProjection失败", Toast.LENGTH_SHORT).show();
                Log.d(Constants.tag, "ScreenRecordActivity onActivityResult 获取MediaProjection失败");
                ObserverManager.getInstance().sendMessage("fail");
                finish();
            }
        }
    }

    private void setConfig(ScreenRecordSource mScreenRecordSource) {
        LiveSDKManager.getInstance().setMediaMode(THUNDER_PROFILE_DEFAULT);
        LiveSDKManager.getInstance().setRoomMode(THUNDER_ROOMCONFIG_LIVE);

        ThunderVideoEncoderConfiguration configuration = new ThunderVideoEncoderConfiguration();
        configuration.playType = ThunderRtcConstant.ThunderPublishPlayType.THUNDERPUBLISH_PLAY_SCREENCAP;
        configuration.publishMode = ThunderRtcConstant.ThunderPublishVideoMode.THUNDERPUBLISH_VIDEO_MODE_DEFAULT;
        LiveSDKManager.getInstance().setVideoEncoderConfig(configuration);

        LiveSDKManager.getInstance().setCustomVideoSource(mScreenRecordSource);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (orientationReceiver != null) {
            unregisterReceiver(orientationReceiver);
        }
    }

    //设置返回按钮：不应该退出程序---而是返回桌面
    //复写onKeyDown事件
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            moveTaskToBack(true);
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    /**
     * 全透状态栏
     */
    protected void setStatusBarFullTransparent() {
        if (Build.VERSION.SDK_INT >= 21) {//21表示5.0
            Window window = getWindow();
            window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(Color.TRANSPARENT);
        } else if (Build.VERSION.SDK_INT >= 19) {//19表示4.4
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            //虚拟键盘也透明
            //getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
        }
    }

    //判断手机系统当前是否处于横竖屏状态
    private boolean isHorizontalScreen() {
        int angle = ((WindowManager) getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay().getRotation();
        Log.d(Constants.tag, "ScreenRecordActivity 手机屏幕 angle=" + angle);
        if (angle == Surface.ROTATION_90 || angle == Surface.ROTATION_270) {
            //如果屏幕旋转90°或者270°是判断为横屏，横屏规避不展示
            return true;
        }
        return false;
    }
}
