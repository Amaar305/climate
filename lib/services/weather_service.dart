import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../model/weather/weather_model.dart';
import 'api_keys.dart';

class WeatherService extends GetConnect implements GetxService {
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather?> getWeather(String cityName) async {
    try {
      final response =
          await get('$BASE_URL?q=$cityName&appid=$weatherApiKey&units=metric');

      if (response.statusCode == 200) {
        return Weather.fromJson(response.body);
      } else {
        null;
      }
    } catch (e) {
      toast('Couldn\'t get weather info');
      log('Error trying to get weather info');
      log(e);
      return null;
    }
    return null;
  }
}
