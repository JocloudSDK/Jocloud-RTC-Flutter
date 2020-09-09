package com.yy.awen.flutterthunder.platform;

import com.yy.awen.flutterthunder.utils.Constants;

import io.flutter.plugin.common.PluginRegistry;

public class LiveStreamViewPlugin {
    public static void registerWith(PluginRegistry.Registrar registrar) {
        LiveStreamViewFactory factory = new LiveStreamViewFactory(registrar.messenger());
        registrar.platformViewRegistry().registerViewFactory(Constants.androidViewName, factory);
    }
}
