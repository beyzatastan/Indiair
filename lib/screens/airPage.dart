import 'package:flutter/material.dart';
import 'package:indiair/screens/searchPage.dart';

class Airpage extends StatefulWidget {
  const Airpage({super.key});

  @override
  State<Airpage> createState() => _AirpageState();
}


class _AirpageState extends State<Airpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Şehir Adı ve Sıcaklık
            const Center(
              child: Column(
                children: [
                  Text(
                    'Mumbai',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '%11',
                    style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Çok kirli',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Çok Zararlı',
                    style: TextStyle(
                      fontSize: 16,
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(
                    'Uygulama Önerisi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bugünlük planlarınızı ertelemelisiniz.Hava kirlilik oranı sağlığınız için risk teşkil ediyor',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
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
                        children: const [
                          WeatherDayWidget(
                            day: "Bugün",
                            minTemp: "%8",
                          ),
                          Divider(),
                          WeatherDayWidget(
                            day: "Çar",
                            minTemp: "%9",
                          ),
                          Divider(),
                          WeatherDayWidget(
                            day: "Per",
                            minTemp: "%7"
                          ),
                          Divider(),
                          WeatherDayWidget(
                            day: "Cum",
                            minTemp: "%10"
                          ),
                           Divider(),
                          WeatherDayWidget(
                            day: "Cmt",
                            minTemp: "%6"
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sayfaya ait buton
                  ElevatedButton(
                    onPressed: () {
                      // Buraya bir işlem ekleyebilirsiniz, örneğin sayfa yeniden yükleme veya başka bir işlem
                    },
                    child: const Text('Bu Sayfa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Butonun rengi
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  
                  // Arama butonu
                  ElevatedButton(
                    onPressed: () {
                      // SearchPage'e yönlendirme
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  SearchPage()),
                      );
                    },
                    child: const Text('Arama'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Butonun rengi
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 16),
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
