import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather/model.dart';

class Service {
  final apiKey = '57f91c6c6f7c46ef8dc82844232309';

  Future<Model> fetchWeatherData(String place) async {
    try {
      final query = {'key': apiKey, 
      'q': place, 
      'days': '7',
      };
      final uri = Uri.http('api.weatherapi.com','/v1/forecast.json', query);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return Model.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Couldn\'t fetch the weather data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
