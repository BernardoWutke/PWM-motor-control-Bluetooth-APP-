package com.example.drone_motores

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresPermission
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){



        @RequiresPermission(value = "android.permission.BLUETOOTH_CONNECT")
        override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

            val bluetoothEventChannel = BluethootEventChannel(this)
            val bluetoothManager = BluethoothConfig(context  ,bluetoothEventChannel)

            super.configureFlutterEngine(flutterEngine)
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.drone/bluetooth").setMethodCallHandler { call, result ->
                val devices = bluetoothManager.getDispositivosPareados()


                if (call.method == "scanDevices") {

                    if (devices.isNotEmpty()) {
                        result.success(devices)
                    } else {
                        result.error("UNAVAILABLE", "Scan Devices Error !", null)
                    }

                } else if(call.method == "requestPermission"){
                    if (ContextCompat.checkSelfPermission(this@MainActivity, Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_DENIED)
                    {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
                        {
                            ActivityCompat.requestPermissions(this@MainActivity, arrayOf(Manifest.permission.BLUETOOTH_CONNECT), 2)
                        }
                    }

                } else if (call.method == "connectDevice") {
                    val mac = bluetoothManager.esp32Mac
                    Log.i("Bluetooth", "Connecting to $mac")
                    val res = bluetoothManager.connectDevice(mac)
                    Log.i("ola", "resultado =>>>>>>>>>>>> $res")
                    result.success("Connected")

                } else if (call.method == "mudarMenssagem") {
                    val message = call.argument<String>("message")
                    if (message != null) {
                        bluetoothManager.mudarMsg(message)
                        result.success("Message Sent")
                    } else {
                        result.error("UNAVAILABLE", "Send Message Error !", null)
                    }

                } else if (call.method == "disconnectDevice") {
                    bluetoothManager.disconnect()
                    result.success("Disconnected")

                } else {
                    result.notImplemented()
                }
            }

            EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.drone/bluetoothEvent").setStreamHandler(
                bluetoothEventChannel
            )


        }






}
