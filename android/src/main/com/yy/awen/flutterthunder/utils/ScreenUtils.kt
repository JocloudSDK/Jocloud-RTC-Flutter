package com.yy.awen.flutterthunder.utils

import android.content.Context

class ScreenUtils {

    companion object {

        fun getDensityDpi(context: Context):Int {
            return context.resources.displayMetrics.densityDpi
        }

        fun getDensity(context: Context):Float {
            return context.resources.displayMetrics.density
        }

        fun getWidth(context: Context):Int {
            return context.resources.displayMetrics.widthPixels
        }
    }
}