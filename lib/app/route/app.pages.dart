import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:weather_app/app/pages/home/binding.dart';
import 'package:weather_app/app/pages/home/view.dart';
import 'package:weather_app/app/pages/search/bindings.dart';
import 'package:weather_app/app/pages/search/view.dart';
import 'package:weather_app/app/route/app.paths.dart';

class AppPages {
  AppPages._();
  static const String initial = AppPaths.home;

  static final routes = [
    GetPage(
        name: AppPaths.home, page: () => HomeView(), binding: HomeBindings()),
    GetPage(
        name: AppPaths.search,
        page: () => SearchPageView(),
        binding: SearchPageBindings()),
  ];
}
