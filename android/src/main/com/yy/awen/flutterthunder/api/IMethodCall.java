package com.yy.awen.flutterthunder.api;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public interface IMethodCall {
    boolean onMethodCall(PluginRegistry.Registrar registrar, MethodCall call, MethodChannel.Result result);
}
