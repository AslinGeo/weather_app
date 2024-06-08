import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/app/constants/app.colors.dart';
import 'package:weather_app/app/constants/app.typography.dart';
import 'package:weather_app/app/constants/common.dart';
import 'package:weather_app/app/pages/home/controller.dart';
import 'package:weather_app/app/route/app.paths.dart';

class HomeView extends GetResponsiveView<HomeController> {
  HomeView({super.key}) {
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(context),
    );
  }

  body(context) {
    return Obx(() => controller.currentWeather.value.isNotEmpty &&
            controller.currentWeather.value != null
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background_image.png"),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                const SizedBox(
                  height: 38,
                ),
                weather(),
                bottom()
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(
              color: AppColors.mediumOrchid,
            ),
          ));
  }

  Widget bottom() {
    return Stack(
      children: [
        house(),
        Padding(
          padding: const EdgeInsets.only(top: 180),
          child: weatherCard(),
        )
      ],
    );
  }

  Widget house() {
    return Center(
      child: Image.asset(
        "assets/house.png",
        height: 340,
        width: 340,
      ),
    );
  }

  Widget weather() {
    return Column(
      children: [
        Text(
          controller.currentWeather.value["name"],
          style: AppTypography.boldTitle03.copyWith(color: AppColors.appWhite),
        ),
        Text(
          '${controller.currentWeather.value["main"]["temp"]}°',
          style: AppTypography.boldTitle01.copyWith(color: AppColors.appWhite),
        ),
        Text(
          controller.currentWeather.value['weather'][0]['description'],
          style: AppTypography.regularFootNote01
              .copyWith(color: AppColors.appWhite),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'H : ${controller.currentWeather.value["main"]["temp_min"]}°',
              style: AppTypography.regularFootNote01
                  .copyWith(color: AppColors.appWhite),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'L : ${controller.currentWeather.value["main"]["temp_max"]}°',
              style: AppTypography.regularFootNote01
                  .copyWith(color: AppColors.appWhite),
            ),
          ],
        )
      ],
    );
  }

  Widget weatherCard() {
    return Column(
      children: [
        weatherCardAppBar(),
        weatherCardBody(),
        weatherCardBottomBar()
      ],
    );
  }

  Widget weatherCardAppBar() {
    return DefaultTabController(
      length: 2,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.royalBlue, AppColors.mediumOrchid],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Center(
                child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: AppColors.appBlackDark.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(3),
                    ))),
            const SizedBox(
              height: 15,
            ),
            TabBar(
              onTap: (index) async {
                controller.forecast.clear();
                await controller.fetchForecastData(index == 0);
              },
              controller: controller.tabController,
              tabs: [
                Text(
                  "Hourly Forecast",
                  style: AppTypography.boldBodySubHeadline
                      .copyWith(color: AppColors.appWhite),
                ),
                Text(
                  "Weekly Forecast",
                  style: AppTypography.boldBodySubHeadline
                      .copyWith(color: AppColors.appWhite),
                )
              ],
              // labelColor: Colors.white,
              unselectedLabelColor: AppColors.mediumOrchid,
            ),
          ],
        ),
      ),
    );
  }

  Widget weatherCardBottomBar() {
    return Container(
      color: AppColors.deepBlue,
      height: 90,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 40,
              color: AppColors.appWhite,
            ),
            InkWell(
                onTap: () {
                  Get.bottomSheet(Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    height: 200,
                    child: bottomSheet(),
                  ));
                },
                child: Image.asset("assets/add_button.png")),
            InkWell(
              onTap: () {
                Get.toNamed(AppPaths.search);
              },
              child: Icon(
                Icons.search_rounded,
                size: 40,
                color: AppColors.appWhite,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget weatherCardBody() {
    return Obx(() => Container(
          decoration: BoxDecoration(color: AppColors.deepBlue),
          child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: controller.forecast.value.isNotEmpty &&
                        controller.forecast.value != null
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.forecast.value.length,
                        itemBuilder: (context, index) {
                          var data = controller.forecast[index];
                          // Convert timestamp to DateTime
                          var forecastTime =
                              DateTime.fromMillisecondsSinceEpoch(
                                  data['dt'] * 1000);
                          // Format the time as string
                          var formattedTime = DateFormat.jm()
                              .format(forecastTime); // e.g., "2:00 AM"
                          // Get temperature
                          var temperature = "${data['temp']}°";
                          return Row(
                            children: [
                              index == 0
                                  ? const SizedBox(
                                      width: 20,
                                    )
                                  : Container(),
                              individualCard(
                                  formattedTime, temperature, data['temp']),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          );
                        })
                    : Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mediumOrchid,
                        ),
                      ),
              )),
        ));
  }

  Widget individualCard(String time, String temp, tempString) {
    return Container(
      height: 150,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            blurRadius: 7, // Blur radius
            offset: Offset(0, 3), // Offset
          ),
        ],
        gradient: LinearGradient(
          colors: [AppColors.royalBlue, AppColors.mediumOrchid],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time,
              style: AppTypography.regularFootNote03
                  .copyWith(color: AppColors.appWhite),
            ),
            SizedBox(
              height: 30,
              child: common().getCloudType(tempString),
            ),
            Text(
              temp,
              style: AppTypography.regularFootNote03
                  .copyWith(color: AppColors.appWhite),
            ),
          ],
        ),
      ),
    );
  }

  bottomSheet() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    controller.placeController.clear();
                    Get.back();
                  },
                  child: Text(
                    "Cancel",
                    style: AppTypography.regularFootNote01
                        .copyWith(color: AppColors.appBlackDark),
                  ),
                ),
                Text(
                  "AddPlace",
                  style: AppTypography.regularFootNote01
                      .copyWith(color: AppColors.appBlackDark),
                ),
                InkWell(
                  onTap: () {
                    controller.place.value = controller.placeController.text;
                    controller.currentWeather.clear();
                    controller.placeController.clear();
                    Get.back();
                    controller.fetchWeatherData();
                  },
                  child: Text(
                    "Done",
                    style: AppTypography.regularFootNote01
                        .copyWith(color: AppColors.appBlackDark),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              controller: controller.placeController,
            ),
          )
        ],
      ),
    );
  }
}
