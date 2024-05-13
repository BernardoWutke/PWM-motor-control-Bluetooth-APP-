import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/bluetooth_provider.dart';

class BletoothView extends StatelessWidget {
  const BletoothView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              context.read<BluetoothBLEProvider>().mudarMenssagem("oi");
            },
            child: const Text('Conectado ?'),
          ),
        ),
        //se nao estiver conectado mostrar um botao para conectar
        //se estiver conectado mostrar um botao para desconectar
        floatingActionButton: context.watch<BluetoothBLEProvider>().isConnected
            ? FloatingActionButton(
                onPressed: () {
                  context.read<BluetoothBLEProvider>().disconnectDevice();
                },
                child: const Icon(Icons.stop),
              )
            : context.watch<BluetoothBLEProvider>().isLoaded == false
                ? FloatingActionButton(
                    onPressed: () {
                      context.read<BluetoothBLEProvider>().connectDevice();
                    },
                    child: const Icon(Icons.play_arrow),
                  )
                : FloatingActionButton(
                    onPressed: () {},
                    child: const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ));
  }
}
