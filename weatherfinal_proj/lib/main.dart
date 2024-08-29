import 'package:flutter/material.dart';
import 'package:weatherfinal_proj/ex00/screens/weather_screen_ex00.dart';
import 'package:weatherfinal_proj/ex01/screens/weather_screen_ex01.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const WeatherScreenEx01(),
    );
  }
}
