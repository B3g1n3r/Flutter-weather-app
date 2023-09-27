class Model {
  final double temperatureC;
  final String condition;
  final List<double> maxtemp;
  final List<double> mintemp;

  Model(
      {this.temperatureC = 0,
      this.condition = 'sunny',
      this.maxtemp = const [],
      this.mintemp = const []});

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


    // final day2 = ;

    return Model(
      temperatureC: tempC,
      condition: conditionText,
      maxtemp: maxtempList,
      mintemp: mintempList
    );
  }
}
