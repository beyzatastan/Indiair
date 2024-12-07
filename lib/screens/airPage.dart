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
  late List<dynamic> aqiValues ;
  late List<String> days;

  @override
  void initState() {
    super.initState();
    // Tüm veriyi logla
    //print("All Forecast Data: ${widget.forecasts}");
    // AQI verisini kontrol et
    if (widget.forecasts['AQI'] != null) {
      print("AQI Data: ${widget.forecasts['AQI']}");
    } 
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
        //eğer zaten listeyse direkt kulllan
        aqiValues = List<dynamic>.from(widget.forecasts['AQI']);
        print("Using AQI Values directly: $aqiValues");
      } else {
        print("Unexpected type for AQI");
        aqiValues = [];  // Fallback to empty list if the type is not what we expect
      }
    } else {
      aqiValues = [45.47701519954735, 66.9428992021458, 67.69607638737966, 102.80952383505341, 71.40481898979807, 70.73993473441523, 52.9130725642852];  // No AQI data found
      print(aqiValues);
    }
  }

  @override
Widget build(BuildContext context) {
    //pop up değerleri ekrana sığsın diye
  String formatValue(double value) {
  return value.toStringAsFixed(2); // Sadece 4 ondalık basamak gösterir
}
String formatValueFromForecast(String key) {
  var value = widget.forecasts[key];
  
  if (value is List) {
    // Liste ise her bir öğeyi formatla
    return value.map((e) {
      if (e is double) {
        return formatValue(e);  // double ise formatla
      } else {
        return "Geçersiz Veri";  // Geçersiz tür durumunda
      }
    }).join(", ");
  } else if (value is double) {
    // Eğer sadece tek bir double ise
    return formatValue(value);
  } else {
    return "Veri yok";
  }
}
//verinin ilk değerini alma
String formatFirstValue(String key) {
  var value = widget.forecasts[key];
  
  if (value is List && value.isNotEmpty) {
    // İlk öğeyi formatla ve yazdır
    String formattedValue = formatValue(value[0]);
    print(formattedValue); // Konsola yazdır
    return formattedValue;
  } else {
    // Veri yoksa varsayılan bir değer döndür
     Map<String,String> defaultFormattedValue =  {"NO2": "21.68","PM10": "145.32","O3": "30.24", "PM2.5": "50.55","NO": "5.20","NH3": "7.12","CO": "30.50","SO2": "2.30"}; // Varsayılan değer
      return defaultFormattedValue[key] ?? "Veri yok";
  }
}

// Kullanımı
Text("NO2: ${formatValueFromForecast('NO2')}");


   // Hava kalitesine göre metinler
  // Örneğin ilk AQI değeri ile kaliteyi al
 String airQuality = '4';
  days = ["Bugün","Salı","Çarşamba","Perşembe","Cuma","Cumartesi","Pazar"];


  if (aqiValues.isNotEmpty) {
    airQuality = getAirQuality(0, aqiValues); 
  }

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
      healthMessage = 'Açık hava aktivitelerinden kaçının, özellikle hassas bireyler için risklidir.';
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Text(
                    widget.city,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    
                  ),
                  const SizedBox(height: 5),
                  aqiValues.isNotEmpty
                      ? Text(
                          getAirQuality(0, aqiValues),
                          style: const TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          '4',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
       title: Text("${widget.city} AQI Detayları",style: TextStyle(fontSize: 24,fontWeight:FontWeight.w700 )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("NO2: ${formatFirstValue('NO2')}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600 ),),
          Text("PM10: ${formatFirstValue('PM10')}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600 ),),
          Text("O3: ${formatFirstValue('O3')}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600 ),),
    Text("PM2.5: ${formatFirstValue('PM2.5')}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600 ),),
    Text("NO: ${formatFirstValue('NO')}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600 ),),
    Text("NH3: ${formatFirstValue('NH3')}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600 ),),
    Text("CO: ${formatFirstValue('CO')}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600 ),),
    Text("SO2: ${formatFirstValue('SO2')}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w600 ),),
        ],

          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close",style: TextStyle(fontSize: 24,color: Colors.lightBlueAccent,fontWeight:FontWeight.w700 )),
            ),
          ],
        );
      },
    );
  },
  child: Text("Show Details",style: TextStyle(color: Colors.lightBlueAccent,fontWeight:FontWeight.w600 ),),
),

                  const SizedBox(height: 5),
                  Text(
                    airQualityDescription,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Uygulama Önerisi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    healthMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                  bottom: Radius.circular(30)
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Haftalık Hava Tahmini',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      WeatherDayWidget(
                        day: days[0],
                        minTemp: getAirQuality(0, aqiValues),
                      ),
                      const Divider(),
                      WeatherDayWidget(
                        day: days[1],
                        minTemp: getAirQuality(1, aqiValues),
                      ),
                      const Divider(),
                      WeatherDayWidget(
                        day: days[2],
                        minTemp: getAirQuality(2, aqiValues),
                      ),
                      const Divider(),
                      WeatherDayWidget(
                        day: days[3],
                        minTemp: getAirQuality(3, aqiValues),
                      ),
                      const Divider(),
                      WeatherDayWidget(
                        day: days[4],
                        minTemp: getAirQuality(4, aqiValues),
                      ),
                      const Divider(),
                      WeatherDayWidget(
                        day: days[5],
                        minTemp: getAirQuality(5, aqiValues),
                      ),
                      const Divider(),
                      WeatherDayWidget(
                        day: days[6],
                        minTemp: getAirQuality(6, aqiValues),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 ElevatedButton(
                  onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForecastPagee()),
                 );
                  },
                style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.lightBlueAccent, // Butonun rengi
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                 shape: RoundedRectangleBorder( // Butonu daireye daha yakın yapmak için
                   borderRadius: BorderRadius.circular(50),
    ),
  ),
  child: const Icon(
    Icons.search, // Büyüteç simgesi
    color: Colors.white, // Simgenin rengi
    size: 24, // Simgenin boyutu
  ),
),

                ],
              ),
            ),
          ],
        ),
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
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            Text(
              minTemp,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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

