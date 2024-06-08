import 'dart:convert';

import 'package:get/get.dart';
import 'package:weather_app/app/constants/app.urls.dart';
import 'package:weather_app/app/pages/search/variables.dart';
import 'package:http/http.dart' as http;

class SearchPageController extends GetxController with SearchPageVariables {
  onSearch(String text) async {
    isLoading.value = true;
    await fetchWeatherData();
    isLoading.value = false;
  }

  Future<void> fetchWeatherData() async {
    final response = await http.get(Uri.parse(
        '${AppUrls.baseUrl}/weather?q=${searchText.value}&appid=${AppUrls.apiKey}&units=metric'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      searchData.value = data;
      searchData.refresh();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
