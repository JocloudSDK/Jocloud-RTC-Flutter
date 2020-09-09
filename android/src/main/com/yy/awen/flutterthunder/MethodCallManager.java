package com.yy.awen.flutterthunder;

import com.yy.awen.flutterthunder.api.Camera;
import com.yy.awen.flutterthunder.api.Live;
import com.yy.awen.flutterthunder.api.Platform;
import com.yy.awen.flutterthunder.api.IMethodCall;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class MethodCallManager {

    private List<IMethodCall> listeners = new ArrayList<>();

    public void init() {
        listeners.add(new Platform());
        listeners.add(new Camera());
        listeners.add(new Live());
    }

    public boolean onMethodCall(PluginRegistry.Registrar registrar, io.flutter.plugin.common.MethodCall call, MethodChannel.Result result) {
        for (IMethodCall listener : listeners) {
            if (listener.onMethodCall(registrar, call, result)) {
                return true;
            }
        }
        return false;
    }
}
