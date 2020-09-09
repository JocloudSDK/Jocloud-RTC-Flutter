package com.yy.awen.flutterthunder.api;

import android.content.Intent;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.yy.awen.flutterthunder.utils.Constants;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class Platform implements IMethodCall {
    @Override
    public boolean onMethodCall(PluginRegistry.Registrar registrar, MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
            return true;
        } else if (call.method.equals("removeNativeView")) {
            int viewId = call.argument("viewId");
            Intent intent = new Intent(Constants.broadcast_removeNativeView);
            intent.putExtra("viewId", viewId);
            LocalBroadcastManager.getInstance(registrar.activity()).sendBroadcast(intent);
            result.success(Constants.FLUTTER_OK);
            return true;
        }
        return false;
    }
}
