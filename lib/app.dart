import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/bindings/global_bindings.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/constant/theme.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/locales/custom_refresh_localizations_delegate.dart';
import 'package:mobile_pssi/locales/app_locales.dart';
import 'package:mobile_pssi/routes/routes.dart';
import 'package:mobile_pssi/ui/dashboard/dashboard_screen.dart';
import 'package:mobile_pssi/ui/splash/splash_screen.dart';
import 'package:mobile_pssi/utils/storage.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  bool get isLogin {
    if (Storage.hasData(ProfileStorage.token)) {
      return true;
    }
    return false;
  }

  Locale get languagePrefs {
    if (Storage.hasData('language_prefs')) {
      var locale = Storage.get('language_prefs');
      return Locale(locale['languageCode'], locale['countryCode']);
    }

    return const Locale('id', 'ID');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          statusBarColor: statusBarColor,
          systemNavigationBarColor: systemNavigationBarColor,
          statusBarIconBrightness: statusBarIconBrightness,
          statusBarBrightness: statusBarIconBrightness),
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: false,
        builder: (context, child) => FilesystemPickerDefaultOptions(
          fileTileSelectMode: FileTileSelectMode.wholeTile,
          theme: FilesystemPickerTheme(
            topBar: FilesystemPickerTopBarThemeData(
              backgroundColor: Get.theme.primaryColor,
            ),
          ),
          child: GetMaterialApp(
            localizationsDelegates: const [
              CustomRefreshLocalizations.delegate,
              GlobalMaterialLocalizations
                  .delegate, // uses `flutter_localizations`
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            useInheritedMediaQuery: true,
            title: F.title,
            initialBinding: GlobalBindings(),
            debugShowCheckedModeBanner: false,
            translations: AppLocale(),
            navigatorKey: Get.key,
            locale: languagePrefs,
            localeResolutionCallback:
                (Locale? locale, Iterable<Locale> supportedLocales) {
              return locale;
            },
            builder: EasyLoading.init(
              builder: (context, child) => Scaffold(
                resizeToAvoidBottomInset: false,
                body: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: true,
                  ),
                  child: child!,
                ),
              ),
            ),
            themeMode: ThemeMode.system,
            theme: MyTheme.general,
            darkTheme: MyTheme.darkMode,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: _analytics),
            ],
            initialRoute:
                !isLogin ? SplashScreen.routeName : DashboardScreen.routeName,
            getPages: pages,
          ),
        ),
      ),
    );
  }
}
