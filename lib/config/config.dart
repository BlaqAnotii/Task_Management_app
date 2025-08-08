import 'network_config.dart';

enum Flavor {
  DEVELOPMENT,
  RELEASE,
}

class Config {
  static Flavor? appFlavor;

  static String get BASEURL {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return NetworkConfig.DEVELOP_BASE_URL;
      case Flavor.RELEASE:
        return NetworkConfig.BASE_URL;
      default:
        return '';
    }
  }

  static String get BASEAPI {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return NetworkConfig.DEVELOP_BASE_API;
      case Flavor.RELEASE:
        return NetworkConfig.BASE_API;
      default:
        return '';
    }
  }
}
