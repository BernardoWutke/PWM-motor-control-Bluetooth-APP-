package com.example.drone_motores
import android.content.Context
import io.flutter.plugin.common.EventChannel


class BluethootEventChannel(context: Context): EventChannel.StreamHandler {


    private var msg : Int = 0
    //toda vez que a msg for alterada, o evento é disparado
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private  fun sendEvent(msg: Int) {
        //enviar como inteiro
        eventSink?.success(msg)
    }

    fun setMsg(msg: Int) {
        this.msg = msg
        sendEvent(msg)
    }




}