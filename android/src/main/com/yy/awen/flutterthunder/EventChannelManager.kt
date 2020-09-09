package com.yy.awen.flutterthunder

import android.util.Log
import com.yy.awen.flutterthunder.utils.Constants
import io.flutter.plugin.common.EventChannel

object EventChannelManager  {

    private var sink: EventChannel.EventSink? = null

    fun setEventSink(sink: EventChannel.EventSink?) {
        this.sink = sink
    }

    fun sendMessage(map: Map<String,Any>) {
        if(sink == null) {
            Log.e(Constants.tag,"EventSink is null")
        } else {
            sink!!.success(map)
        }
    }
}