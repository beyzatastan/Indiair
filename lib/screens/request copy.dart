import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:indiair/screens/airPage.dart';
import 'dart:convert';

class ForecastPagee extends StatefulWidget {
  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPagee> {
  Map<String, dynamic> forecasts = {};
  List<String> cities = [];
  List<String> filteredCities = [];
  final TextEditingController _controller = TextEditingController();

  // Flask API'den şehirleri al
  Future<void> fetchCities() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/cities'));

      if (response.statusCode == 200) {
        List<String> cityList = List<String>.from(json.decode(response.body));
        setState(() {
          cities = cityList;
          filteredCities = cities;
        });
      } else {
        _showErrorDialog('Error fetching cities.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  // Kullanıcı metin girdiğinde şehirleri filtrele
  void _filterCities(String query) {
    final filtered = cities.where((city) {
      return city.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCities = filtered;
    });
  }

  // Hata mesajlarını göstermek için
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Forecast verilerini şehire göre çek
  Future<void> fetchForecast(String city) async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/forecast?city=$city'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          forecasts = data['forecasts'];
        });
      } else {
        _showErrorDialog('Error fetching forecast.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCities(); // Uygulama başladığında şehirleri al
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecasts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter city name'),
              onChanged: _filterCities, // Arama her değiştiğinde çalışacak
            ),
            Expanded(
              child: filteredCities.isEmpty
                  ? Center(child: Text('No cities found'))
                  : ListView.builder(
                      itemCount: filteredCities.length,
                      itemBuilder: (context, index) {
                        final city = filteredCities[index];
                        return ListTile(
                          title: Text(city),
                          onTap: () {
                            fetchForecast(city); // Şehri seçtikten sonra tahmin verisini çek
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Airpage(
                                  city: city, 
                                  forecasts: forecasts, 
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            if (forecasts.isNotEmpty)
              Expanded(
                child: ListView(
                  children: forecasts.entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key), // Metric name
                      subtitle: Text(entry.value.toString()), // Forecast values
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
