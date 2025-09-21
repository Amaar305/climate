import 'package:climate/screens/location_screen.dart';
import 'package:climate/services/weather.dart';
import 'package:climate/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:climate/utilities/constants.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String _city = '';
  int? _temp;
  String _icon = '';
  String _message = '';
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/city_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Icon(Icons.arrow_back_ios, size: 50.0),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: controller,
                  style: TextStyle(color: Colors.black),
                  decoration: kTextFieldInputDecoration,
                  // onChanged: (value) {
                  //   print(value);
                  // },
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    if (controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please write city name.'),
                        ),
                      );
                      return;
                    }

                    final query = controller.text.trim();
                    final data = await WeatherService().getWeather(query);

                    if (data == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('City not found.')),
                      );
                      return;
                    }

                    // Defensive parsing
                    final temp = (data['main']['temp'] as num).round();
                    final condition = (data['weather'][0]['id'] as num).toInt();
                    final iconCode =
                        (data['weather'][0]['icon'] as String?) ??
                        ''; // e.g. 01n / 01d
                    final isNight = iconCode.endsWith('n');
                    final city = (data['name'] ?? '') as String;

                    final wm = WeatherModel();

                    // Prefer local variables for navigation
                    final icon = wm.getWeatherEmoji(
                      condition,
                      isNight: isNight,
                    );
                    final message = wm.getMessage(temp);

                    // (Optional) keep your local UI in sync if you stay on this page
                    if (mounted) {
                      setState(() {
                        _temp = temp;
                        _icon = icon;
                        _message = message;
                        _city = city;
                      });
                    }

                    // Navigate using the computed values (not the state)
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LocationScreen(
                          city: city,
                          icon: icon,
                          message: message,
                          temp: temp,
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not fetch weather: $e')),
                    );
                  }
                },
                child: Text('Get Weather', style: kButtonTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
