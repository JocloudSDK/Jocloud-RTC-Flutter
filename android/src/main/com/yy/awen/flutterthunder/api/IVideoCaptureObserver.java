package com.yy.awen.flutterthunder.api;

public interface IVideoCaptureObserver {
    /**
     * 负责回调camera采集的原始yuv(NV21)给客户
     * @param imageFormat 视频图片格式 {@link android.graphics.ImageFormat}
     * @param width 视频数据宽
     * @param height 视频数据高
     * @param data  视频NV21数据
     * @param length 视频数据长度
     * */
    void onCaptureVideoFrame(int width, int height, byte[] data, int length, int imageFormat);
}
