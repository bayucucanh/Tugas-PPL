import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/dashboard/controller/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());
    DateTime? currentBackPressTime;
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          DateTime now = DateTime.now();

          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            Get.showSnackbar(const GetSnackBar(
              title: 'Keluar Aplikasi',
              message: 'Tekan sekali lagi untuk keluar!',
              duration: Duration(seconds: 2),
            ));
            return false;
          }

          return true;
        },
        child: DefaultScaffold(
          backgroundColor: Get.theme.backgroundColor,
          showAppBar: false,
          body: PageView.builder(
            itemCount: controller.pages.length,
            itemBuilder: (context, index) => controller.pages[index],
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: controller.getBottomNavbar,
        ),
      ),
    );
  }
}
