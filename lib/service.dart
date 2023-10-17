import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/model.dart';

class Service {
  final apiKey = '498f46af08db470a939174453230910';
Future<Model> fetchWeatherData(String place) async {
  try {
    final query = {
      'key': apiKey,
      'q': place,
      'days': '7',
    };
    final uri = Uri.http('api.weatherapi.com', '/v1/forecast.json', query);
    final response = await http.get(uri);

    final responseData = jsonDecode(response.body);

    if (responseData.containsKey('error')) {
      return Model(error: responseData['error']);
    } else if (responseData.containsKey('forecast')) {
      return Model.fromJson(responseData);
    } else {
      throw Exception('Unexpected response from the API');
    }
  } catch (e) {
    rethrow;
  }
}

}
