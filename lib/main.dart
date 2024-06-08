import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/route/app.pages.dart';
import 'package:weather_app/app/route/app.paths.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppPaths.home,
      getPages: AppPages.routes,
    );
  }
}
