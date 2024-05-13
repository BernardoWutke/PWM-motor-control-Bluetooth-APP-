import 'package:drone_motores/providers/motores_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ConexaoMotorBluetooth {
  late BuildContext _context;

  int _motorRotor = 0;
  int _motorBomba = 0;

  ConexaoMotorBluetooth(BuildContext context) {
    _context = context;
  }
}
