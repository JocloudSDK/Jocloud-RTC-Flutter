package com.example.flutterthunder

import android.util.Log
import com.yy.awen.flutterthunder.EventChannelManager
import com.yy.awen.flutterthunder.MethodCallManager
import com.yy.awen.flutterthunder.platform.LiveStreamViewPlugin
import com.yy.awen.flutterthunder.utils.Constants
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterthunderPlugin : MethodCallHandler, EventChannel.StreamHandler {

    private var methodManager: MethodCallManager? = null
    private var registrar: Registrar? = null

    constructor() {
        methodManager = MethodCallManager()
        methodManager?.init()
    }

    fun setRegistrar(registrar: Registrar) {
        this.registrar = registrar
    }

    override fun onCancel(p0: Any?) {
        EventChannelManager.setEventSink(null)
    }

    override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
        EventChannelManager.setEventSink(p1)
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutterthunder")
            val plugin = FlutterthunderPlugin()
            plugin.setRegistrar(registrar)
            channel.setMethodCallHandler(plugin)

            var eventChannel = EventChannel(registrar.messenger(), "flutterthunder_event_channel")
            eventChannel.setStreamHandler(plugin)

            LiveStreamViewPlugin.registerWith(registrar)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        var isDeal = methodManager?.onMethodCall(registrar, call, result)
        printLog(call, isDeal)
        if (!isDeal!!) {
            result.notImplemented()
        }
    }

    private fun printLog(call: MethodCall, isDeal: Boolean?) {
        val builder = StringBuilder()
        if (call.method.isNotEmpty()) {
            builder.append("method = ${call.method}, ")
        }
        try {
            if (call.arguments != null) {
                val map = call.arguments<Map<String, Any>>()
                map.forEach {
                    builder.append("${it.key} = ${it.value}, ")
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }

        builder.append(" isDeal = ${isDeal!!}")
        Log.d(Constants.tag, builder.toString())
    }
}
