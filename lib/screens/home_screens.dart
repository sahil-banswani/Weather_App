import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wheather_app_rivaan/secrets.dart';
import 'package:wheather_app_rivaan/widget/additional_information.dart';
import 'package:wheather_app_rivaan/widget/hourly_forcast_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Nagpur';
      final result = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherApiKey'),
      );
      final data = jsonDecode(result.body);

      if (int.parse(data['cod']) != 200) {
        throw 'An unexpected error occur';
      }

      return data;
      // data['list'][0]['main']['temp']
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wheather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            child: const Icon(Icons.refresh),
            onTap: () {},
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
            );
          }

          final data = snapshot.data!;

          final currentWetherData = data['list'][0];
          final cloud = currentWetherData['weather'][0]['icon'];

          final currentTemp = (currentWetherData['main']['temp'] - 273).round();
          final currentCloud = "assets/weather/$cloud.png";

          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentPressure = currentWetherData['main']['pressure'];
          final currentWindSpeed = currentWetherData['wind']['speed'];
          final currentHumidity = currentWetherData['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // main Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            Text(
                              '$currentTemp *C',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Image.asset(
                              currentCloud,
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Text(
                              currentSky,
                              style: const TextStyle(fontSize: 20),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                //wether forcast height
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weather Forcast',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 1; i <= 6; i++)
                        HourlyForcastCard(
                          image:
                              data['list'][i]['weather'][0]['icon'].toString(),
                          time: data['list'][i]['dt'].toString(),
                          value: data['list'][i]['main']['temp'].toString(),
                        ),
                    ],
                  ),
                ),
                //wether forcast height
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    AdditionalInformationCard(
                        text: 'Humidity',
                        amount: currentHumidity.toString(),
                        icon: Icons.water_drop),
                    AdditionalInformationCard(
                        text: 'Wind Speed',
                        amount: currentWindSpeed.toString(),
                        icon: Icons.air),
                    AdditionalInformationCard(
                        text: 'Pressure',
                        amount: currentPressure.toString(),
                        icon: Icons.beach_access),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
