import 'package:flutter/material.dart';
import 'package:weather/homepage.dart';
import 'package:weather/model.dart';
import 'package:weather/service.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ),
  );
}

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => WeatherState();
}

class WeatherState extends State<Weather> {
  double temperature = 4999;
  String condition = 'nothig';
  double mintemp = 80;
  Service service = Service();
  Model model = Model();
  @override
  void initState() {
    super.initState();
    fetchweatherdata();
  }

  void fetchweatherdata() async {
    final model = await service.fetchWeatherData('chennai');
    setState(() {
      temperature = model.temperatureC;
      condition = model.condition;
     
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

          child: Column(
        children: [

          
          Text(
            temperature.toString(),
            style: const TextStyle(fontSize: 40),
          ),
          Text(
            condition.toString(),
            style: const TextStyle(fontSize: 40),
          ),
          Text(
            mintemp.toString(),
            style: const TextStyle(fontSize: 40),
          ),
        ],
      )),
    );
  }
}
