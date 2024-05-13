import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class BluetoothBLEProvider extends ChangeNotifier {
  final MethodChannel _channel =
      const MethodChannel('com.example.drone/bluetooth');

  final EventChannel _eventChannel =
      const EventChannel('com.example.drone/bluetoothEvent');

  Stream get bluetoothStream => _eventChannel.receiveBroadcastStream().cast();

  bool _isConnected = false;
  bool _isLoaded = false;

  bool get isConnected => _isConnected;
  bool get isLoaded => _isLoaded;

  void setIsConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  void seTisLoaded(bool value) {
    print("setando");
    _isLoaded = value;
    notifyListeners();
  }

  BluetoothBLEProvider() {
    bluetoothStream.listen((event) {
      _isLoaded = false;
      print(event);
      if (event.toString() == "1") {
        _isConnected = true;
        notifyListeners();
      } else if (event.toString() == "0") {
        _isConnected = false;
        notifyListeners();
      }
    });
  }

  Future<void> scanDevices() async {
    try {
      final devices = await _channel.invokeMethod('scanDevices');
      print(devices);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> connectDevice() async {
    if (_isConnected == false && _isLoaded == false) {
      seTisLoaded(true);
      try {
        await _channel.invokeMethod('connectDevice');
      } on PlatformException catch (e) {
        print(e);
      }
    } else if (_isConnected == true) {
      print("Já está conectado");
    } else {
      print("Erro ao conectar");
    }
  }

  Future<void> mudarMenssagem(String msg) async {
    try {
      //key = message
      await _channel.invokeMethod('mudarMenssagem', {"message": msg});
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> disconnectDevice() async {
    try {
      await _channel.invokeMethod('disconnectDevice');
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
