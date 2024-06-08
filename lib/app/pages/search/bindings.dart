import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/pages/search/controller.dart';

class SearchPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchPageController());
  }
}
