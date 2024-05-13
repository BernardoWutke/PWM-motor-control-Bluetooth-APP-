import 'package:drone_motores/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/bluetooth_provider.dart';
import 'providers/motores_provider.dart';
import 'views/bluetooth/bluetooth_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BluetoothBLEProvider()),
        ChangeNotifierProvider(create: (context) => MotoresProvider(context))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}
