package com.yy.awen.flutterthunder.api;

import java.nio.FloatBuffer;

public interface IGPUProcess {
    void onInit(int textureTarget, int outputWidth, int outputHeight);

    void onDraw(int i, FloatBuffer floatBuffer);

    void onDestroy();

    void onOutputSizeChanged(int width, int height);
}
