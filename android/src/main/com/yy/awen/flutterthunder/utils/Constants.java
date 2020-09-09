package com.yy.awen.flutterthunder.utils;

public class Constants {

    public static final String tag = "FlutterThunder";
    public static final String androidViewName = "ThunderRenderView";

    public static final String register_name = "com.yy.FlutterThunderPlugin";
    private static final String sep = ".";

    public static final String broadcast_startLive = register_name + sep + "startLive";
    public static final String broadcast_watchLive = register_name + sep + "watchLive";
    public static final String broadcast_removeNativeView = register_name + sep + "removeNativeView";
    public static final String broadcast_setMultiVideoViewLayout = register_name + sep + "setMultiVideoViewLayout";

    public static final String command = "command";
    public static final String command_startPreview = "startPreview";
    public static final String command_startRemotePreview = "startRemotePreview";

    public static final int FLUTTER_OK = 0;
    public static final int FLUTTER_FAIL = -1;

    public static final String key = "broadcastName";
    public static final String value = "broadcastData";

    public static int room_mode = 3;

    public static final String key_token = "token";
    public static final String key_appId = "appId";
    public static final String key_roomId = "roomId";
    public static final String key_uid = "uid";
    public static final String key_sceneId = "sceneId";

}
