package com.example.flutter_refresh_rate

import android.app.Activity
import android.content.Context
import android.os.Build
import android.view.Display
import android.view.WindowManager
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterRefreshRatePlugin */
class FlutterRefreshRatePlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    companion object {
        private const val CHANNEL_NAME = "flutter_refresh_rate"
        private const val METHOD_GET_SUPPORTED_MODES = "getSupportedModes"
        private const val METHOD_GET_ACTIVE_MODE = "getActiveMode"
        private const val METHOD_GET_PLATFORM_VERSION = "getPlatformVersion"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            METHOD_GET_PLATFORM_VERSION -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            METHOD_GET_SUPPORTED_MODES -> {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                    result.error("UNSUPPORTED", "Android 6.0+ required for display modes", null)
                    return
                }
                if (activity == null) {
                    result.error("NO_ACTIVITY", "Activity not attached", null)
                    return
                }
                result.success(getSupportedModes())
            }
            METHOD_GET_ACTIVE_MODE -> {
                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                    result.error("UNSUPPORTED", "Android 6.0+ required for display modes", null)
                    return
                }
                if (activity == null) {
                    result.error("NO_ACTIVITY", "Activity not attached", null)
                    return
                }
                result.success(getActiveMode())
            }
            else -> result.notImplemented()
        }
    }

    @Suppress("DEPRECATION")
    @RequiresApi(Build.VERSION_CODES.M)
    private fun getDisplay(): Display {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            activity!!.display!!
        } else {
            val wm = activity!!.getSystemService(Context.WINDOW_SERVICE) as WindowManager
            wm.defaultDisplay
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun getSupportedModes(): List<Map<String, Any>> {
        val display = getDisplay()
        val modes = display.supportedModes
        val resultList = ArrayList<Map<String, Any>>()

        for (mode in modes) {
            val map = hashMapOf<String, Any>(
                "modeId" to mode.modeId,
                "width" to mode.physicalWidth,
                "height" to mode.physicalHeight,
                "refreshRate" to mode.refreshRate
            )
            resultList.add(map)
        }
        return resultList
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun getActiveMode(): Map<String, Any> {
        val mode = getDisplay().mode
        return hashMapOf(
            "modeId" to mode.modeId,
            "width" to mode.physicalWidth,
            "height" to mode.physicalHeight,
            "refreshRate" to mode.refreshRate
        )
    }

    // Activity lifecycle callbacks
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
