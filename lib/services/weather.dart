import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'api_keys.dart';
import 'location.dart'; // your Location class file



class NetworkHelper {
  final String url;
  const NetworkHelper(this.url);

  Future<Map<String, dynamic>> getData() async {
    final uri = Uri.parse(url);
    final res = await http.get(uri).timeout(const Duration(seconds: 15));

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw HttpException(
      'Request failed: ${res.statusCode} ${res.reasonPhrase}',
    );
  }
}

class WeatherModel {
  final String apiKey = weatherApiKey;
  final String openWeatherMapURl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<Map<String, dynamic>?> getLocationWeather() async {
    final location = Location();
    await location.getCurrentLocation();

    if (location.latitude == null || location.longitude == null) {
      // Could not get position (permissions off, GPS off, etc.)
      return null;
    }

    final url =
        '$openWeatherMapURl?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric';

    final networkHelper = NetworkHelper(url);
    final weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherEmoji(int condition, {required bool isNight}) {
    // Special-case clear sky
    if (condition == 800) {
      return isNight ? '🌙' : '☀️';
    }

    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition <= 804) {
      // Clouds: lighter/darker hint
      return isNight ? '☁️' : '⛅️';
    } else {
      return '🤷‍';
    }
  }

   String getMessage(int temp) {
    if (temp > 35) return '🔥 Stay hydrated';
    if (temp > 25) return 'It\'s 🍦 time';
    if (temp > 20) return 'Time for shorts and 👕';
    if (temp < 10) return 'You\'ll need 🧣 and 🧤';
    return 'Bring a 🧥 just in case';
  }

}
