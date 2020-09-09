package com.yy.awen.flutterthunder.platform;

import android.content.Context;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class LiveStreamViewFactory extends PlatformViewFactory {

    public LiveStreamViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        return new LiveStreamView(context, id);
    }
}
