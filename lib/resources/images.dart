import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppImages {
  static const lightLogo = "assets/images/light-logo.png";
  static const darkLogo = "assets/images/dark-logo.png";

  static String getAppLogo(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.light
        ? lightLogo
        : darkLogo;
  }
}
