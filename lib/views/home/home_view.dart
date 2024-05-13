import 'package:drone_motores/providers/bluetooth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/motores_provider.dart';
import '../../shared/colors.dart';
import 'components/menu_home_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.colorPrimary,
        appBar: AppBar(
          title: const Text('Controle de Rotações',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: AppColors.colorTitleMenuPrimaryHome,
          toolbarHeight: 100,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Builder(builder: (context) {
                return MenuHomePage(
                    title: "Rotor Principal",
                    value: context
                        .watch<MotoresProvider>()
                        .currentSliderValuePuverizador,
                    titleBodyColor: AppColors.colorTitleMenuPrimaryHome,
                    bodyColor: AppColors.colorCaixaMenu,
                    barColor: AppColors.colorTitleMenuPrimaryHome,
                    increment: () {
                      context
                          .read<MotoresProvider>()
                          .incrementRotorPuverizador();
                    },
                    decrement: () {
                      context
                          .read<MotoresProvider>()
                          .decrementRotorPuverizador();
                    },
                    onChangedSlider: (double value) {
                      context
                          .read<MotoresProvider>()
                          .setCurrentSliderValuePuverizador(value.toInt());
                    });
              }),
              Builder(builder: (context) {
                return MenuHomePage(
                    title: "Rotor Bomba",
                    value: context
                        .watch<MotoresProvider>()
                        .currentSliderValueBomba,
                    titleBodyColor: AppColors.colorTitleMenuPrimaryHome,
                    bodyColor: AppColors.colorCaixaMenu,
                    barColor: AppColors.colorTitleMenuPrimaryHome,
                    increment: () {
                      context.read<MotoresProvider>().incrementRotorBomba();
                    },
                    decrement: () {
                      context.read<MotoresProvider>().decrementRotorBomba();
                    },
                    onChangedSlider: (double value) {
                      context
                          .read<MotoresProvider>()
                          .setCurrentSliderValueBomba(value.toInt());
                    });
              }),
            ],
          ),
        ),
        floatingActionButton: context.watch<BluetoothBLEProvider>().isConnected
            ? FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  context.read<BluetoothBLEProvider>().disconnectDevice();
                },
                child: const Icon(Icons.stop),
              )
            : context.watch<BluetoothBLEProvider>().isLoaded == false
                ? FloatingActionButton(
                    backgroundColor: AppColors.colorFloatingButton,
                    onPressed: () {
                      context.read<BluetoothBLEProvider>().connectDevice();
                    },
                    child: const Icon(Icons.play_arrow),
                  )
                : FloatingActionButton(
                    backgroundColor: AppColors.colorFloatingButton,
                    onPressed: () {},
                    child: const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ));
  }
}
