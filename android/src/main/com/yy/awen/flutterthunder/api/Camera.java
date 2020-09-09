package com.yy.awen.flutterthunder.api;

import android.util.Log;

import com.yy.awen.flutterthunder.sdk.LiveSDKManager;
import com.yy.awen.flutterthunder.utils.Constants;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class Camera implements IMethodCall {

    @Override
    public boolean onMethodCall(PluginRegistry.Registrar registrar, MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("switchFrontCamera")) {
            boolean bFront = call.argument("bFront");
            int value = LiveSDKManager.getInstance().switchFrontCamera(bFront);
            Log.i(Constants.tag, "switchFrontCamera value=" + value);
            result.success(value);
            return true;
        }
        return false;
    }
}
