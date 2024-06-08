import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin HomeVariables {
  RxMap currentWeather = {}.obs;
  RxList forecast = [].obs;
  late TabController tabController;
  RxString place = "Thiruvananthapuram".obs;
  TextEditingController placeController = TextEditingController();
}
