import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/constants/app.urls.dart';
import 'package:weather_app/app/pages/home/variables.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController
    with HomeVariables, GetTickerProviderStateMixin {
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  init() async {
    await fetchWeatherData();
    await fetchForecastData(true);
  }

  Future<void> fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        '${AppUrls.baseUrl}/weather?q=$place&appid=${AppUrls.apiKey}&units=metric'));

    if (response.statusCode == 200) {
      currentWeather.value = jsonDecode(response.body);
      currentWeather.refresh();
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> fetchForecastData(isHourly) async {
    final response = await http.get(Uri.parse(
        '${AppUrls.baseUrl}/onecall?lat=${currentWeather.value["coord"]["lat"]}&lon=${currentWeather.value["coord"]["lon"]}&exclude=current,minutely,daily,alerts&appid=${AppUrls.apiKey}&units=metric'));

    if (response.statusCode == 200) {
      if (isHourly) {
        forecast.value = jsonDecode(response.body)["hourly"].toList();
      } else {
        var data = jsonDecode(response.body);
        print(data);
        forecast.value = jsonDecode(response.body)['daily'].take(7).toList();
      }
      forecast.refresh();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}
