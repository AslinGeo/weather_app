import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';

mixin SearchPageVariables {
  TextEditingController searchTextController = TextEditingController();
  final debouncer = Debouncer(milliseconds: 500);
  RxString searchText = "".obs;
  RxBool isLoading = false.obs;
  RxMap searchData = {}.obs;
}
