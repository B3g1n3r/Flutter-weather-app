class Model {
  final double temperatureC;
  final String condition;
  final double maxtemp;
  final double mintemp;

  Model( {
    this.temperatureC = 0,
    this.condition = 'sunny',
    this.maxtemp =0, this.mintemp=0,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    final tempC = (json['current']['temp_c'] as num).toDouble();
    final conditionText = json['current']['condition']['text'] as String;
    final mintemp = (json['forecast']['forecastday'][0]['day']['mintemp_c'] as num).toDouble();
    final maxtemp = (json['forecast']['forecastday'][0]['day']['maxtemp_c'] as num).toDouble();


    return Model(
      temperatureC: tempC,
      condition: conditionText,
      maxtemp: maxtemp,
      mintemp: mintemp
    );
  }
}
