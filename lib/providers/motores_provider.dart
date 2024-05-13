import 'package:drone_motores/providers/bluetooth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MotoresProvider extends ChangeNotifier {
  int _rotorPuverizador = 0;
  int _rotorBomba = 0;

  int get currentSliderValuePuverizador => _rotorPuverizador;
  int get currentSliderValueBomba => _rotorBomba;

  late BuildContext _context;

  MotoresProvider(BuildContext context) {
    _context = context;
    _enviarValorFormatado();
  }

  void _enviarValorFormatado() {
    final bluetoothProvider = _context.read<BluetoothBLEProvider>();
    bluetoothProvider.mudarMenssagem(
        "P${_rotorPuverizador.toString().padLeft(3, '0')}B${_rotorBomba.toString().padLeft(3, '0')}\n");
  }

  void setCurrentSliderValuePuverizador(
    value,
  ) {
    _rotorPuverizador = value;
    _enviarValorFormatado();
    notifyListeners();
  }

  void setCurrentSliderValueBomba(int value) {
    _rotorBomba = value;
    _enviarValorFormatado();
    notifyListeners();
  }

  void incrementRotorPuverizador() {
    if (_rotorPuverizador < 100) _rotorPuverizador++;
    _enviarValorFormatado();
    notifyListeners();
  }

  void decrementRotorPuverizador() {
    if (_rotorPuverizador > 0) _rotorPuverizador--;
    _enviarValorFormatado();
    notifyListeners();
  }

  void incrementRotorBomba() {
    if (_rotorBomba < 100) _rotorBomba++;
    _enviarValorFormatado();
    notifyListeners();
  }

  void decrementRotorBomba() {
    if (_rotorBomba > 0) _rotorBomba--;
    _enviarValorFormatado();
    notifyListeners();
  }
}
