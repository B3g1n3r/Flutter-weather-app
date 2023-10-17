import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/model.dart';
import 'package:weather/service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cityName = "Chennai";

  int temperature = 30;
  String condition = 'sunny';
  bool isSearch = false;
  String? errorMessage = 'error';
  Service service = Service();
  Model model = Model();
  List<double> minTemps = List.filled(7, 2.0);
  List<double> maxTemps = List.filled(7, 30.0);
  List<double> precipitation = List.filled(24, 0);
  List<double> hourlytemperatures = List.filled(24, 30.0);
  List<double> windSpeed = List.filled(24, 0);
  List<String> time = List.filled(24, '00:00');
  List<IconData> icons = List.filled(24, FontAwesomeIcons.sun);
  bool isLoading = false;

  double minTemp = 0;
  double maxTemp = 0;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    fetchWeather(cityName);
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
    });
    final model = await service.fetchWeatherData(city);
    setState(() {
      isLoading = false;
    });
    errorMessage = model.error?['message'];

    if (model.error != null) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text('Invalid Location'),
            content: Text(
              '$errorMessage' + '\nor \nSpelling mismatch',
              textAlign: TextAlign.center, // You can adjust alignment as needed
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  fetchWeather('Chennai');
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.questrial(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          );
        }),
      );
    } else {
      setState(() {
        temperature = model.temperatureC.toInt();
        condition = model.condition;
        cityName = city;

        for (var i = 0; i < 7; i++) {
          if (i < model.mintemp.length) {
            minTemps[i] = model.mintemp[i];
          }
          if (i < model.maxtemp.length) {
            maxTemps[i] = model.maxtemp[i];
          }
        }
        for (var p = 0; p < 24; p++) {
          precipitation[p] = model.precipitation[p];
          hourlytemperatures[p] = model.temperature[p];
          windSpeed[p] = model.wind[p];
          time[p] = model.time[p];
        }
        minTemp = model.mintemp[0];
        maxTemp = model.maxtemp[0];
      });
    }
  }

  void requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      String location = await getCurrentLocation();
      setState(() {
        cityName = location;
      });
    }
  }

  Future<String> getCurrentLocation() async {
    String locationName = 'Invalid location';
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      locationName = placemark[0].subLocality!;
    } catch (e) {
      print(e);
    }
    return locationName;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness != Brightness.dark;

    DateTime date = DateTime.now();
    List<String> days = List.generate(7,
        (index) => DateFormat('EEE').format(date.add(Duration(days: index))));

    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading Weather Data...',
                      style: TextStyle(
                        color: isDarkMode ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.01,
                                vertical: size.width * 0.05,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: !isSearch,
                                    child: FaIcon(
                                      FontAwesomeIcons.bars,
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Visibility(
                                        visible: !isSearch,
                                        child: Align(
                                          child: Text(
                                            'Weather app',
                                            style: GoogleFonts.questrial(
                                              color: isDarkMode
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: size.height * 0.04,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: isSearch,
                                        child: Container(
                                          width: size.width * 0.9,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? Colors.grey
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: TextFormField(
                                            onFieldSubmitted: (value) {
                                              fetchWeather(value);
                                              setState(() {
                                                cityName = value;
                                                isSearch = !isSearch;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Search Location',
                                              border: InputBorder.none,
                                              icon: const Icon(
                                                FontAwesomeIcons
                                                    .magnifyingGlass,
                                                color: Colors.black,
                                              ),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      isSearch = !isSearch;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            style: GoogleFonts.questrial(
                                              color: Colors.black,
                                              fontSize: size.height * 0.025,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: !isSearch,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isSearch = !isSearch;
                                        });
                                        if (kDebugMode) {
                                          print('$isSearch');
                                        }
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.searchLocation,
                                        color: isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: size.height * 0.01,
                              ),
                              child: Align(
                                child: Text(
                                  cityName,
                                  style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: size.height * 0.06,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: size.height * 0.005,
                              ),
                              child: Align(
                                child: Text(
                                  'Today',
                                  style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.black54
                                          : Colors.white54,
                                      fontSize: size.height * 0.035,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: size.height * 0.03,
                              ),
                              child: Align(
                                child: Text(
                                  '$temperature˚C',
                                  style: GoogleFonts.questrial(
                                    fontSize: size.height * 0.11,
                                    color: temperature < 0
                                        ? Colors.blue
                                        : temperature > 0 && temperature <= 15
                                            ? Colors.indigo
                                            : temperature > 15 &&
                                                    temperature < 30
                                                ? Colors.deepPurple
                                                : Colors.pink,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.25),
                              child: Divider(
                                  color:
                                      isDarkMode ? Colors.black : Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * 0.005,
                                  left: size.width * 0.07),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  condition,
                                  style: GoogleFonts.questrial(
                                      fontSize: size.height * 0.03,
                                      color: isDarkMode
                                          ? Colors.black54
                                          : Colors.white54),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: size.height * 0.03,
                                bottom: size.height * 0.01,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$minTemp˚C', // min temperature
                                    style: GoogleFonts.questrial(
                                      color: minTemp <= 0
                                          ? Colors.blue
                                          : minTemp > 0 && minTemp <= 15
                                              ? Colors.indigo
                                              : minTemp > 15 && minTemp < 30
                                                  ? Colors.deepPurple
                                                  : Colors.pink,
                                      fontSize: size.height * 0.03,
                                    ),
                                  ),
                                  Text(
                                    '/',
                                    style: GoogleFonts.questrial(
                                      color: isDarkMode
                                          ? Colors.black54
                                          : Colors.white54,
                                      fontSize: size.height * 0.03,
                                    ),
                                  ),
                                  Text(
                                    '$maxTemp˚C', //max temperature
                                    style: GoogleFonts.questrial(
                                      color: maxTemp <= 0
                                          ? Colors.blue
                                          : maxTemp > 0 && maxTemp <= 15
                                              ? Colors.indigo
                                              : maxTemp > 15 && maxTemp < 30
                                                  ? Colors.deepPurple
                                                  : Colors.pink,
                                      fontSize: size.height * 0.03,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(size.width * 0.005),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: buildMultipleForecastsRow(
                                      time,
                                      hourlytemperatures,
                                      windSpeed,
                                      precipitation,
                                      FontAwesomeIcons.sun,
                                      size,
                                      isDarkMode)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                                vertical: size.height * 0.02,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Colors.white.withOpacity(0.05),
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: size.height * 0.02,
                                          left: size.width * 0.03,
                                        ),
                                        child: Text(
                                          '7-day forecast',
                                          style: GoogleFonts.questrial(
                                            color: isDarkMode
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: size.height * 0.025,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(size.width * 0.005),
                                      child: Column(
                                        children: [
                                          buildSevenDayForecast(
                                            "Today",
                                            minTemps[0],
                                            maxTemps[0],
                                            FontAwesomeIcons.cloud,
                                            size,
                                            isDarkMode,
                                          ),
                                          buildSevenDayForecast(
                                            days[1],
                                            minTemps[1],
                                            maxTemps[1],
                                            FontAwesomeIcons.sun,
                                            size,
                                            isDarkMode,
                                          ),
                                          buildSevenDayForecast(
                                            days[2],
                                            minTemps[2],
                                            maxTemps[2],
                                            FontAwesomeIcons.cloudRain,
                                            size,
                                            isDarkMode,
                                          ),
                                          buildSevenDayForecast(
                                            days[3],
                                            minTemps[3],
                                            maxTemps[3],
                                            FontAwesomeIcons.sun,
                                            size,
                                            isDarkMode,
                                          ),
                                          buildSevenDayForecast(
                                            days[4],
                                            minTemps[4],
                                            maxTemps[4],
                                            FontAwesomeIcons.sun,
                                            size,
                                            isDarkMode,
                                          ),
                                          buildSevenDayForecast(
                                            days[5],
                                            minTemps[5],
                                            maxTemps[5],
                                            FontAwesomeIcons.cloud,
                                            size,
                                            isDarkMode,
                                          ),
                                          buildSevenDayForecast(
                                            days[6],
                                            minTemps[6],
                                            maxTemps[6],
                                            FontAwesomeIcons.snowflake,
                                            size,
                                            isDarkMode,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Row buildMultipleForecastsRow(
    List<String> times,
    List<double> temperatures,
    List<double> windSpeeds,
    List<double> precipitations,
    IconData icon,
    Size size,
    bool isDarkMode,
  ) {
    List<Widget> forecasts = [];

    for (var p = 0; p < 24; p++) {
      IconData icon;

      if (precipitation[p] < 10) {
        icon = FontAwesomeIcons.cloud;
      } else if (precipitation[p] < 25) {
        icon = FontAwesomeIcons.cloudRain;
      } else if (precipitation[p] < 50) {
        icon = FontAwesomeIcons.cloudShowersHeavy;
      } else {
        icon = FontAwesomeIcons.cloudSunRain;
      }

      forecasts.add(
        buildForecastToday(
          times[p],
          temperatures[p],
          windSpeeds[p],
          precipitations[p],
          icon,
          size,
          isDarkMode,
        ),
      );
    }

    return Row(
      children: forecasts,
    );
  }

  Widget buildForecastToday(String time, double temp, double wind,
      double rainChance, IconData icon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.025),
      child: Column(children: [
        Text(
          time,
          style: GoogleFonts.questrial(
              color: isDarkMode ? Colors.black : Colors.white,
              fontSize: size.height * 0.02),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.005),
          child: FaIcon(
            icon,
            color: isDarkMode ? Colors.black : Colors.white,
          ),
        ),
        Text(
          '$temp˚C',
          style: GoogleFonts.questrial(
            color: isDarkMode ? Colors.black : Colors.white,
            fontSize: size.height * 0.025,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
              ),
              child: FaIcon(
                FontAwesomeIcons.wind,
                color: Colors.grey,
                size: size.height * 0.03,
              ),
            ),
          ],
        ),
        Text(
          '$wind km/h',
          style: GoogleFonts.questrial(
            color: Colors.grey,
            fontSize: size.height * 0.02,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
              ),
              child: FaIcon(
                FontAwesomeIcons.umbrella,
                color: Colors.blue,
                size: size.height * 0.03,
              ),
            ),
          ],
        ),
        Text(
          '$rainChance %',
          style: GoogleFonts.questrial(
            color: Colors.blue,
            fontSize: size.height * 0.02,
          ),
        ),
      ]),
    );
  }

  Widget buildSevenDayForecast(String time, double minTemp, double maxTemp,
      IconData weatherIcon, size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(
        size.height * 0.005,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.02,
                ),
                child: Text(
                  time,
                  style: GoogleFonts.questrial(
                    color: isDarkMode ? Colors.black : Colors.white,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.25,
                ),
                child: FaIcon(
                  weatherIcon,
                  color: isDarkMode ? Colors.black : Colors.white,
                  size: size.height * 0.03,
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.15,
                  ),
                  child: Text(
                    '$minTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.black38 : Colors.white38,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                  ),
                  child: Text(
                    '$maxTemp˚C',
                    style: GoogleFonts.questrial(
                      color: isDarkMode ? Colors.black : Colors.white,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: isDarkMode ? Colors.black : Colors.white,
          ),
        ],
      ),
    );
  }
}
