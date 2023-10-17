import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:weather/homepage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String isGranted = 'denied';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestLocationPermission();
  }

  void requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<String> getCurrentLocation() async {
    String locationName = "Invalid Location";
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemark.isNotEmpty) {
        locationName = placemark[0].subLocality!;
      }
    } catch (e) {
      print(e);
    }
    return locationName;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: FutureBuilder(
          future: getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Scaffold(
                  body: Center(child: Text("LocationName : ${snapshot.data}")));
            }
          },
        ),
      ),
    );
  }
}
