import 'package:flutter/material.dart';
import 'package:indiair/screens/airPage.dart';
import 'package:indiair/screens/request%20copy.dart';
import 'package:indiair/screens/request.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
          return MaterialApp(
            home:  ForecastPagee(),
            debugShowCheckedModeBanner: false,
          );
  }
}