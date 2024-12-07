import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForecastPage extends StatefulWidget {
  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  Map<String, dynamic> forecasts = {};

  // Fetch forecast data from Flask API
  Future<void> fetchForecast(String city) async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/forecast?city=$city'));

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          forecasts = data['forecasts'];
        });
      } else {
        _showErrorDialog('City not found or an error occurred.');
         }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

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
              decoration: InputDecoration(hintText: 'Enter city name'),
              onSubmitted: (city) {
                fetchForecast(city);
              },
            ),
            Expanded(
              child: forecasts.isEmpty
                  ? Center(child: Text('No forecast data available'))
                  : ListView(
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