import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:weather_app/app/constants/app.colors.dart';
import 'package:weather_app/app/constants/app.typography.dart';
import 'package:weather_app/app/constants/common.dart';
import 'package:weather_app/app/pages/search/controller.dart';

class SearchPageView extends GetResponsiveView<SearchPageController> {
  SearchPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.darkSlateBlue, AppColors.midnightBlue])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: myAppBar(),
        body: body(context),
      ),
    );
  }

  myAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_new_sharp,
            color: AppColors.appWhite,
          )),
      title: Text(
        "Weather",
        style: AppTypography.boldTitle03.copyWith(color: AppColors.appWhite),
      ),
    );
  }

  Widget body(context) {
    return Obx(() => Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            searchBar(context),
            const SizedBox(
              height: 20,
            ),
            controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.mediumOrchid,
                    ),
                  )
                : controller.searchData.isEmpty
                    ? Container()
                    : searchBody()
          ],
        ));
  }

  Widget searchBar(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
          height: 40,
          decoration: BoxDecoration(
              color: AppColors.appWhite.withOpacity(0.82),
              borderRadius: BorderRadius.circular(5)),
          child: TextField(
            onChanged: (value) {
              controller.searchText.value = value;
              controller.debouncer
                  .run(() => controller.onSearch(value.toString()));
            },
            // autofocus: true,
            controller: controller.searchTextController,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 7.0),
              prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Icon(Icons.search_rounded)),
              hintText: 'Search for a city or airport',
              border: InputBorder.none,
            ),
          )),
    );
  }

  Widget searchBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Stack(
        children: [
          SvgPicture.asset("assets/svg/bg.svg"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.searchData.value["main"]["temp"]}°',
                      style: AppTypography.boldTitle03
                          .copyWith(color: AppColors.appWhite),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'H : ${controller.searchData.value["main"]["temp_min"]}°',
                          style: AppTypography.regularFootNote03
                              .copyWith(color: AppColors.appWhite),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'L : ${controller.searchData.value["main"]["temp_max"]}°',
                          style: AppTypography.regularFootNote03
                              .copyWith(color: AppColors.appWhite),
                        ),
                      ],
                    ),
                    Text(
                      controller.searchData.value["name"],
                      style: AppTypography.boldTitle03
                          .copyWith(color: AppColors.appWhite),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 30,
                      child: common().getCloudType(
                          controller.searchData.value["main"]["temp"]),
                    ),
                    Text(
                      controller.searchData.value["weather"][0]["description"],
                      style: AppTypography.regularFootNote01
                          .copyWith(color: AppColors.appWhite),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
