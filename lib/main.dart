import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget{
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return MaterialApp(
    home: WeatherScreen(),
    theme: ThemeData.dark(useMaterial3: true),
    debugShowCheckedModeBanner: false,
  );
  }
}
