package com.yy.awen.flutterthunder.api;

public class ThunderEventCallback {

    private static ThunderEventCallback ins = new ThunderEventCallback();

    private IGPUProcess mGPUProcess;

    private IVideoCaptureObserver mVideoCaptureObserver;

    private IVideoDecodeObserver mVideoDecodeObserver;

    public static ThunderEventCallback getInstance() {
        return ins;
    }

    public void setGPUProcess(IGPUProcess process) {
        mGPUProcess = process;
    }

    public IGPUProcess getGPUProcess() {
        return mGPUProcess;
    }

    public IVideoCaptureObserver getVideoCaptureObserver() {
        return mVideoCaptureObserver;
    }

    public void setVideoCaptureObserver(IVideoCaptureObserver mVideoCaptureObserver) {
        this.mVideoCaptureObserver = mVideoCaptureObserver;
    }

    public IVideoDecodeObserver getVideoDecodeObserver() {
        return mVideoDecodeObserver;
    }

    public void setVideoDecodeObserver(IVideoDecodeObserver mVideoDecodeObserver) {
        this.mVideoDecodeObserver = mVideoDecodeObserver;
    }

}
