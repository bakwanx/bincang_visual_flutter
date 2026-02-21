package com.bincang_visual_flutter.id

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.content.ContextCompat


class MainActivity : FlutterActivity() {

    private val CHANNEL = "media_projection_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                when (call.method) {

                    "startService" -> {
                        val intent = Intent(this, MediaProjectionService::class.java)

                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            ContextCompat.startForegroundService(this, intent)
                        } else {
                            startService(intent)
                        }

                        result.success(null)
                    }

                    "stopService" -> {
                        val intent = Intent(this, MediaProjectionService::class.java)
                        stopService(intent)
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
