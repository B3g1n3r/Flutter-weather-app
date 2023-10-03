class Model {
  final double temperatureC;
  final String condition;
  final List<double> maxtemp;
  final List<double> mintemp;
  final List<double> precipitation;
  final List<double> temperature;
  final List<double> wind;
  final List<String> time;

  Model(
      {this.temperatureC = 0,
      this.condition = 'sunny',
      this.maxtemp = const [],
      this.mintemp = const [],
      this.precipitation = const [],
      this.temperature = const [],
      this.wind = const [],
      this.time = const []});

  factory Model.fromJson(Map<String, dynamic> json) {
    final tempC = (json['current']['temp_c'] as num).toDouble();
    final conditionText = json['current']['condition']['text'] as String;

    final forecastDays = json['forecast']['forecastday'] as List;

    final maxtempList = forecastDays.take(7).map((forecastDay) {
      final dayData = forecastDay['day'] as Map<String, dynamic>;
      return (dayData['maxtemp_c'] as num).toDouble();
    }).toList();

    final mintempList = forecastDays.take(7).map((forecastDay) {
      final dayData = forecastDay['day'] as Map<String, dynamic>;
      return (dayData['mintemp_c'] as num).toDouble();
    }).toList();

    final hour = json['forecast']['forecastday'][0]['hour'] as List;
    final allPrecip = hour.take(24).map((e) {
      final precip = e['chance_of_rain'] as int;
      return (precip).toDouble();
    }).toList();

    final temp = json['forecast']['forecastday'][0]['hour'] as List;
    final allTemp = temp.take(24).map(
      (e) {
        final temp = e['temp_c'] as num;
        return (temp).toDouble();
      },
    ).toList();

    final wind = json['forecast']['forecastday'][0]['hour'] as List;
    final allWind = wind.take(24).map(
      (e) {
        final wind = e['wind_kph'] as num;
        return (wind).toDouble();
      },
    ).toList();

    final time = json['forecast']['forecastday'][0]['hour'] as List;
    final allTime = time.take(24).map(
      (e) {
        final time = e['time'] as String;
        final hour = time.split(' ')[1];
        return (hour).toString();
      },
    ).toList();
    return Model(
        temperatureC: tempC,
        condition: conditionText,
        maxtemp: maxtempList,
        mintemp: mintempList,
        precipitation: allPrecip,
        temperature: allTemp,
        wind: allWind,
        time: allTime);
  }
}
