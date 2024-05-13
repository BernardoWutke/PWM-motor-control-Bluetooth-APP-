package com.example.drone_motores


import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.RequiresPermission
import com.harrysoft.androidbluetoothserial.BluetoothManager
import com.harrysoft.androidbluetoothserial.BluetoothSerialDevice;
import com.harrysoft.androidbluetoothserial.SimpleBluetoothDeviceInterface
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.schedulers.Schedulers
import java.util.concurrent.TimeUnit


class BluethoothConfig(context: Context, bluethootEventChannel: BluethootEventChannel) {
    val esp32Mac = "08:D1:F9:E7:15:2E"

    private var msgBuffer: String = "00:00"

    private  val listaDispositivos = mutableListOf<HashMap<String,String>>()
    val  bluetoothManager: BluetoothManager = BluetoothManager.getInstance();

    val bluethootEventChannel: BluethootEventChannel = bluethootEventChannel

    @RequiresPermission(value = "android.permission.BLUETOOTH_CONNECT")
    fun getDispositivosPareados() : List<HashMap<String,String>> {

          val dispositivosPareados = bluetoothManager.pairedDevicesList
            for (dispositivo in dispositivosPareados) {
                listaDispositivos.add(hashMapOf("nome" to dispositivo.name, "mac" to dispositivo.address))
            }

          return listaDispositivos
    }


    fun mudarMsg(message: String = "0:0") {
        msgBuffer = message
    }

    //função que envia msg a cada 500 ms depois que a conexão é estabelecida
    private val compositeDisposableMsg = CompositeDisposable()
    private fun enviarMensagemContinua() {
        val disposable = Observable.interval(500, TimeUnit.MILLISECONDS)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe {
                deviceInterface!!.sendMessage(msgBuffer)
            }
        compositeDisposableMsg.add(disposable)
    }

    fun pauseEnvioMensagemContinua() {
        compositeDisposableMsg.clear()
    }


    private val compositeDisposable = CompositeDisposable()
    private var deviceInterface: SimpleBluetoothDeviceInterface? = null

    fun connectDevice(mac: String) {
        if (!requestBluetoothPermissionGranted()) {
            requestBluetoothPermission()
        } else {
            compositeDisposable.add(bluetoothManager.openSerialDevice(mac)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(this::onConnected, this::onError)
            )
        }
    }
    @RequiresPermission(value = "android.permission.BLUETOOTH_SCAN")
    private fun onConnected(device: BluetoothSerialDevice) {
        deviceInterface = device.toSimpleDeviceInterface()
        deviceInterface!!.setListeners(this::onMessageReceived, this::onMessageSent, this::onError)
        deviceInterface!!.sendMessage("Hello world!\n")

        Log.i("Bluetooth", "CONECTADO")
        enviarMensagemContinua()
        bluethootEventChannel.setMsg(1)
    }

    private fun onMessageSent(message: kotlin.String?) {
        Log.i("Bluetooth", "Message sent: $message")
        bluethootEventChannel.setMsg(1)
    }

    private fun onMessageReceived(message: kotlin.String?) {
        Log.i("Bluetooth", "Message received: $message")

    }

    private fun onError(error: kotlin.Throwable?) {
        Log.e("Bluetooth", "Error em tempo de execução: $error")
        disconnect()
        bluethootEventChannel.setMsg(0)
    }

    fun disconnect() {
        pauseEnvioMensagemContinua()
        bluetoothManager.closeDevice(esp32Mac); // Close by mac
        bluethootEventChannel.setMsg(0)
    }



    val context: Context = context

    private fun requestBluetoothPermissionGranted(): Boolean {
        return(  ContextCompat.checkSelfPermission(
            context,
            android.Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_GRANTED
                && ContextCompat.checkSelfPermission(
            context,
            android.Manifest.permission.BLUETOOTH_SCAN ) == PackageManager.PERMISSION_GRANTED
                && ContextCompat.checkSelfPermission(
            context,
            android.Manifest.permission.BLUETOOTH ) == PackageManager.PERMISSION_GRANTED
                )


    }

    private fun requestBluetoothPermission() {
        ActivityCompat.requestPermissions(
            context as MainActivity,
            arrayOf(
                android.Manifest.permission.BLUETOOTH_CONNECT,
                android.Manifest.permission.BLUETOOTH_SCAN,
                android.Manifest.permission.BLUETOOTH
            ),
            REQUEST_ENABLE_BT
        )
    }

    companion object {
        const val REQUEST_ENABLE_BT = 1
    }



}


