package com.yy.awen.flutterthunder.api;

public interface IVideoDecodeObserver {
    /*
     * 负责回调解码后用于渲染的数据给客户(I420)
     * */
    void onVideoDecodeFrame(String uid, int w, int h, byte[] data, int dateLen, long renderTimeMs);

}
