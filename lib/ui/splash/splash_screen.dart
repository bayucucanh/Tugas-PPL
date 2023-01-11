import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/ui/login/login_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  void goToLoginForm() {
    Get.offAllNamed(LoginScreen.routeName);
  }

  @override
  void initState() {
    _timer = Timer(const Duration(seconds: 3), goToLoginForm);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Image.asset(splashScreen).h(100),
        'Impian dalam genggaman'.text.color(primaryColor).italic.xl.make(),
      ],
      alignment: MainAxisAlignment.center,
      crossAlignment: CrossAxisAlignment.center,
    );
  }
}
