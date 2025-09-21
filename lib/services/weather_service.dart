import 'package:climate/services/weather.dart';
import 'package:nb_utils/nb_utils.dart';

import 'api_keys.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>?> getWeather(String cityName) async {
    try {
      final response = await NetworkHelper(
        '$BASE_URL?q=$cityName&appid=$weatherApiKey&units=metric',
      ).getData();
      // await get);

      print(response);
      return response;
    } catch (e) {
      toast('Couldn\'t get weather info');
      log('Error trying to get weather info');
      log(e);
      return null;
    }
  }
}
