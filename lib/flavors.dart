import 'package:flutter/foundation.dart';

enum Flavor {
  dev,
  staging,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Prima Academy Dev';
      case Flavor.staging:
        return 'Prima Academy Staging';
      case Flavor.prod:
        return 'Prima Academy';
      default:
        return 'title';
    }
  }

  static String get playstoreUrl =>
      'https://play.google.com/store/apps/details?id=com.kunci.mobile_pssi';

  static String get scheme {
    switch (appFlavor) {
      case Flavor.dev:
        return "https";
      case Flavor.staging:
      case Flavor.prod:
        return "https";
      default:
        throw Exception("Unknown Source Data");
    }
  }

  static String get hostname {
    switch (appFlavor) {
      case Flavor.dev:
        return "pssi-backend.test";
      case Flavor.staging:
        return "bepssi.kunci.co.id";
      case Flavor.prod:
        return "be.olahraga.kunci.co.id";
      default:
        throw Exception("Unknown Source Data");
    }
  }

  static String? get port {
    if (appFlavor == Flavor.dev) {
      return '8000';
    }
    return null;
  }

  static String get baseUrl {
    if (port != null) {
      return '$scheme://$hostname:$port';
    }
    return '$scheme://$hostname';
  }

  static String get urlApi {
    return "$baseUrl/api";
  }

  static String get pusherAuthUrl {
    return "$urlApi/broadcasting/auth";
  }

  static String get pusherApiKey {
    switch (appFlavor) {
      case Flavor.dev:
        return "123";
      case Flavor.staging:
        return "-v_.%7}3R#jhmD3bUCF78T}zLUH-*6";
      case Flavor.prod:
        return "e3_yyNfeU[!D#E[?mY_G/hwJ.@FX/C";
      default:
        throw Exception("Unknown Source Data");
    }
  }

  static String get pusherCluster {
    switch (appFlavor) {
      case Flavor.dev:
        return 'ap1';
      case Flavor.staging:
        return "ap1";
      case Flavor.prod:
        return "ap1";
      default:
        throw Exception("Unknown Source Data");
    }
  }

  static int get pusherPort => 6001;

  static String get midtransMerchantId => 'G171833514';
  static String get midtransClientKey {
    switch (appFlavor) {
      case Flavor.dev:
        return 'SB-Mid-client-ttKuX1nOuN-P0mS3';
      case Flavor.staging:
        return "SB-Mid-client-ttKuX1nOuN-P0mS3";
      case Flavor.prod:
        return "Mid-client-NoA7kJoQ3SBp5k4F";
      default:
        throw Exception("Unknown Source Data");
    }
  }

  static String? get vapidKey {
    if (kIsWeb) {
      return 'BMkNh53srGQoPVEySGS1TAAV90hejdkJquU9cyn9cTqOxU6QRPMA8KamdtY64UIs1V7ctVufzmi1dXtVSIIiXwE';
    }
    return null;
  }

  static bool get isDev => appFlavor == Flavor.dev;
  static bool get isStaging => appFlavor == Flavor.staging;
  static bool get isProduction => appFlavor == Flavor.prod;
}
