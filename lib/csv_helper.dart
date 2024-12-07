// lib/csv_helper.dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:convert';

class CsvHelper {static Future<List<String>> loadCities() async {
  final rawData = await rootBundle.loadString('assets/forecast_results.csv');
  List<List<dynamic>> list = CsvToListConverter().convert(rawData);

  // Yüklenen veri
  print('Yüklenen CSV: $list');

  Set<String> cities = {};
  
  // Başlık satırını atlıyoruz (ilk satır)
  for (int i = 1; i < list.length; i++) {
    var row = list[i];
    if (row.isNotEmpty) {
      cities.add(row[0].toString());  // Sadece şehir ismini alıyoruz
    }
  }

  print('Şehirler: $cities');
  return cities.toList();
}



}
