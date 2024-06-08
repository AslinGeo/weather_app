import 'package:flutter_svg/flutter_svg.dart';

class common {
  getCloudType(double temperature) {
    if (temperature > 25) {
      return SvgPicture.asset("assets/svg/cloud3.svg");
    } else if (temperature > 15) {
      return SvgPicture.asset("assets/svg/cloud2.svg");
    } else if (temperature > 5) {
      return SvgPicture.asset("assets/svg/cloud1.svg");
    } else {
      return SvgPicture.asset("assets/svg/cloud4.svg");
    }
  }
}
