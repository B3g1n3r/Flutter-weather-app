import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/model.dart';
import 'package:weather/service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cityName = 'Chennai';
  int temperature = 30;
  String condition = 'sunny';

  double maxTemp = 30;
  double minTemp = 2;

  Service service = Service();
  Model model = Model();
  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final model = await service.fetchWeatherData('chennai');
    setState(() {
      setState(() {
        temperature = model.temperatureC.toInt();
        condition = model.condition;
        minTemp = model.mintemp;
        maxTemp = model.maxtemp;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness != Brightness.dark;

    return Scaffold(
      body: Center(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.bars,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                            Align(
                              child: Text(
                                'Weather app',
                                style: GoogleFonts.questrial(
                                    color: isDarkMode
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: size.height * 0.04),
                              ),
                            ),
                            FaIcon(
                              FontAwesomeIcons.circlePlus,
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.03,
                        ),
                        child: Align(
                          child: Text(
                            cityName,
                            style: GoogleFonts.questrial(
                                color: isDarkMode ? Colors.black : Colors.white,
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
                                      : temperature > 15 && temperature < 30
                                          ? Colors.deepPurple
                                          : Colors.pink,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.25),
                        child: Divider(
                            color: isDarkMode ? Colors.black : Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.005,
                        ),
                        child: Align(
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
                          child: Row(
                            children: [
                              //TODO: change weather forecast from local to api get
                              buildForecastToday(
                                "Now", //hour
                                temperature.toInt(), //temperature
                                20, //wind (km/h)
                                0, //rain chance (%)
                                FontAwesomeIcons.sun, //weather icon
                                size,
                                isDarkMode,
                              ),
                              buildForecastToday(
                                "15:00",
                                1,
                                10,
                                40,
                                FontAwesomeIcons.cloud,
                                size,
                                isDarkMode,
                              ),
                              buildForecastToday(
                                "16:00",
                                0,
                                25,
                                80,
                                FontAwesomeIcons.cloudRain,
                                size,
                                isDarkMode,
                              ),
                              buildForecastToday(
                                "17:00",
                                -2,
                                28,
                                60,
                                FontAwesomeIcons.snowflake,
                                size,
                                isDarkMode,
                              ),
                              buildForecastToday(
                                "18:00",
                                -5,
                                13,
                                40,
                                FontAwesomeIcons.cloudMoon,
                                size,
                                isDarkMode,
                              ),
                              buildForecastToday(
                                "19:00",
                                -8,
                                9,
                                60,
                                FontAwesomeIcons.snowflake,
                                size,
                                isDarkMode,
                              ),
                              buildForecastToday(
                                "20:00",
                                -13,
                                25,
                                50,
                                FontAwesomeIcons.snowflake,
                                size,
                                isDarkMode,
                              ),
                              buildForecastToday(
                                "21:00",
                                -14,
                                12,
                                40,
                                FontAwesomeIcons.cloudMoon,
                                size,
                                isDarkMode,
                              ),
                              buildForecastToday(
                                "22:00",
                                -15,
                                1,
                                30,
                                FontAwesomeIcons.moon,
                                size,
                                isDarkMode,
                              ),
                              buildForecastToday(
                                "23:00",
                                -15,
                                15,
                                20,
                                FontAwesomeIcons.moon,
                                size,
                                isDarkMode,
                              ),
                            ],
                          ),
                        ),
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
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              Padding(
                                padding: EdgeInsets.all(size.width * 0.005),
                                child: Column(
                                  children: [
                                    //TODO: change weather forecast from local to api get
                                    buildSevenDayForecast(
                                      "Today", //day
                                      minTemp, //min temperature
                                      maxTemp, //max temperature
                                      FontAwesomeIcons.cloud, //weather icon
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Wed",
                                      -5,
                                      5,
                                      FontAwesomeIcons.sun,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Thu",
                                      -2,
                                      7,
                                      FontAwesomeIcons.cloudRain,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Fri",
                                      3,
                                      10,
                                      FontAwesomeIcons.sun,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "San",
                                      1,
                                      12,
                                      FontAwesomeIcons.sun,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Sun",
                                      4,
                                      7,
                                      FontAwesomeIcons.cloud,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Mon",
                                      -2,
                                      1,
                                      FontAwesomeIcons.snowflake,
                                      size,
                                      isDarkMode,
                                    ),
                                    buildSevenDayForecast(
                                      "Tues",
                                      0,
                                      3,
                                      FontAwesomeIcons.cloudRain,
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

  Widget buildForecastToday(String time, int temp, int wind, int rainChance,
      IconData icon, size, bool isDarkMode) {
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
