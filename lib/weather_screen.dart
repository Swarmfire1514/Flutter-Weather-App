import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/weather-card.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String cityName = 'London';
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured!';
      }
      return data;
      //temp = data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh),
            )
          ],
        ),
        body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            //print(snapshot);
            //print(snapshot.runtimeType);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final data = snapshot.data!;
            final currentWeatherData = data['list'][0];

            final currentTemp = currentWeatherData['main']['temp'];
            final currentSky = currentWeatherData['weather'][0]['main'];
            final currPressure = currentWeatherData['main']['pressure'];
            final currWindSpeed = currentWeatherData['wind']['speed'];
            final currHumidity = currentWeatherData['main']['humidity'];
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  ///Main Card (Weather Now)
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              spacing: 16,
                              children: [
                                Text(
                                  cityName,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$currentTemp°K',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                Text(
                                  currentSky,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///Weather Forecast
                  const Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 105,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky = hourlyForecast['weather'][0]['main'];
                        final hourlyTemp = hourlyForecast['main']['temp'];
                        final time = DateTime.parse(hourlyForecast['dt_txt']);

                        return HourlyForecastCard(
                          time: DateFormat.Hm().format(time),
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          temperature: '${hourlyTemp.toString()}°K',
                        );
                      },
                    ),
                  ),

                  //Additional info
                  const Text('Additional Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currHumidity.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currWindSpeed.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currPressure.toString(),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
