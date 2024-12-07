import 'dart:convert';  // For jsonDecode
import 'package:flutter/material.dart';
import 'package:indiair/screens/request%20copy.dart';
import 'package:indiair/screens/request.dart';

class Airpage extends StatefulWidget {
  final String city;  // Şehir adı
  final Map<String, dynamic> forecasts;  // Tahmin verileri

  // Yapıcı metod
  const Airpage({super.key, required this.city, required this.forecasts});

  @override
  State<Airpage> createState() => _AirpageState();
}

class _AirpageState extends State<Airpage> {
  late List<dynamic> aqiValues;

  @override
  void initState() {
    super.initState();

    // Tüm veriyi logla
    print("All Forecast Data: ${widget.forecasts}");

    // AQI verisini kontrol et
    if (widget.forecasts['AQI'] != null) {
      print("AQI Data: ${widget.forecasts['AQI']}");
    } else {
      print("AQI verisi mevcut değil");
    }

    // Print the data to verify its type
    print("AQI Data: ${widget.forecasts['AQI']}");

    // Check if 'AQI' is a string, and if so, decode it; otherwise, just use it as is
    if (widget.forecasts['AQI'] != null) {
      if (widget.forecasts['AQI'] is String) {
        // If it's a string, remove the quotes and decode it into a list
        try {
          // Remove the surrounding quotes and decode into a list
          String aqiString = widget.forecasts['AQI'];
          aqiString = aqiString.substring(1, aqiString.length - 1);  // Remove the quotes
          aqiValues = jsonDecode("[$aqiString]");  // Decode into a list
          print("Decoded AQI Values: $aqiValues");
        } catch (e) {
          print("Error decoding AQI: $e");
          aqiValues = [];  // Fallback to empty list on error
        }
      } else if (widget.forecasts['AQI'] is List) {
        // If it's already a list, use it directly
        aqiValues = List<dynamic>.from(widget.forecasts['AQI']);
        print("Using AQI Values directly: $aqiValues");
      } else {
        print("Unexpected type for AQI");
        aqiValues = [];  // Fallback to empty list if the type is not what we expect
      }
    } else {
      aqiValues = [];  // No AQI data found
      print("No AQI data found");
    }
  }

  @override
  Widget build(BuildContext context) {
    String airQuality = 'Veri yok';
  if (aqiValues.isNotEmpty) {
    airQuality = getAirQuality(0, aqiValues);  // Örneğin ilk AQI değeri ile kaliteyi al
  }

  // Hava kalitesine göre metinler
  String airQualityDescription = '';
  String healthMessage = '';

  switch (airQuality) {
  case '6':
    airQualityDescription = 'Çok Temiz';
    healthMessage = 'Bugün dışarıda vakit geçirmek için mükemmel bir gün!';
    break;
  case '5':
    airQualityDescription = 'İyi';
    healthMessage = 'Dışarıda vakit geçirebilirsiniz, ancak dikkatli olun.';
    break;
  case '4':
    airQualityDescription = 'Zararlı';
    healthMessage = 'Açık hava aktivitelerinden kaçının, özellikle hassas bireyler için risk oluşturabilir.';
    break;
  case '3':
    airQualityDescription = 'Çok Kirli';
    healthMessage = 'Dışarıda vakit geçirmek sağlık için tehlikeli olabilir. İçeride kalın.';
    break;
  case '2':
    airQualityDescription = 'Çok Kirli';
    healthMessage = 'Hava kalitesi çok kötü, dışarıda vakit geçirmekten kaçının.';
    break;
  case '1':
    airQualityDescription = 'Çok Zararlı';
    healthMessage = 'Çok kirli hava, dışarıda vakit geçirmemek en iyisi.';
    break;
  default:
    airQualityDescription = 'Veri Yok';
    healthMessage = 'Hava kalitesi verisi mevcut değil.';
    break;
}

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Şehir Adı ve Sıcaklık
            Center(
              child: Column(
                children: [
                  Text(
                    widget.city,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  aqiValues.isNotEmpty
                      ? Text(
                          getAirQuality(0, aqiValues) ,
                          style: const TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Veri yok',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                  const SizedBox(height: 10),
                   Text(
                     airQualityDescription,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Uyarı Bilgisi
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Uygulama Önerisi',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                   healthMessage,style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 10 Günlük Tahmin
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '10 Günlük Tahmin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children:  [
                          WeatherDayWidget(
                            day: "Bugün",
                            minTemp: getAirQuality(0, aqiValues),
                          ),
                          Divider(),
                          WeatherDayWidget(
                            day: "Çar",
                            minTemp: getAirQuality(1, aqiValues),
                          ),
                          Divider(),
                          WeatherDayWidget(
                            day: "Per",
                            minTemp: getAirQuality(2, aqiValues)
                          ),
                          Divider(),
                          WeatherDayWidget(
                            day: "Cum",
                            minTemp: getAirQuality(3, aqiValues)
                          ),
                          Divider(),
                          WeatherDayWidget(
                            day: "Cmt",
                            minTemp: getAirQuality(4, aqiValues)
                          ), Divider(),
                          WeatherDayWidget(
                            day: "Pzr",
                            minTemp: getAirQuality(5, aqiValues)
                          ), Divider(),
                          WeatherDayWidget(
                            day: "Pzt",
                            minTemp: getAirQuality(6, aqiValues)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Butonlar için Row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Arama butonu
                  ElevatedButton(
                    onPressed: () {
                      // SearchPage'e yönlendirme
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ForecastPagee()),
                      );
                    },
                    child: const Text('Arama'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 2, 2, 100), // Butonun rengi
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16,color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherDayWidget extends StatelessWidget {
  final String day;
  final String minTemp;

  const WeatherDayWidget({
    required this.day,
    required this.minTemp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            Text(
              minTemp,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}

String getAirQuality(int index, List<dynamic> aqiValues) {
  String airQuality = 'Veri yok';

  if (aqiValues.isNotEmpty && index < aqiValues.length) {
    double aqiValue = aqiValues[index].toDouble(); 
    if (aqiValue >= 0 && aqiValue <= 50) {
      airQuality= '6';
    } else if (aqiValue > 50 && aqiValue <= 100) {
      airQuality=  '5';
    } else if (aqiValue > 100 && aqiValue <= 200) {
      airQuality=  '4';
    } else if (aqiValue > 200 && aqiValue <= 300) {
      airQuality=  '3';
    } else if (aqiValue > 300 && aqiValue <= 400) {
      airQuality=  '2';
    } else {
      airQuality=  '1';
    }
  }
  
  return airQuality;
}

