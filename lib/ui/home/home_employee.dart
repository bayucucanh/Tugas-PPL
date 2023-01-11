import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/ui/home/competition_list.dart';
import 'package:mobile_pssi/ui/home/controller/employee.controller.dart';
import 'package:mobile_pssi/ui/home/employee_event_list.dart';
import 'package:mobile_pssi/ui/home/parts/academy-partner.button.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeEmployee extends GetView<EmployeeController> {
  const HomeEmployee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EmployeeController());
    return Obx(
      () => VStack([
        if (controller.userData.value.isCoach) const AcademyPartnerButton(),
        if (controller.userData.value.classificationUser != null)
          VStack([
            UiSpacer.verticalSpace(),
            MaterialBanner(
                content:
                    'Anda telah menjadi konsultan di ${F.title.toLowerCase()}'
                        .text
                        .sm
                        .make()
                        .p8(),
                actions: [
                  'Lihat Konsultasi'
                      .text
                      .semiBold
                      .color(primaryColor)
                      .make()
                      .onTap(controller.openConsulting),
                ]).py8().px16(),
          ]),
        UiSpacer.verticalSpace(),
        if (controller.menuController.menus.isNotEmpty)
          GridView(
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            shrinkWrap: true,
            children: controller.menuController.menus
                .map((element) => element)
                .toList(),
          ).p12().h(
              controller.userData.value.hasRole('administrator') ? 420 : 220),
        if (controller.userData.value.isCoach == true)
          const VStack([
            EmployeeEventList(),
            CompetitionList(),
          ]),
        // if (controller.userData.value.employee?.clubCoach != null)
        //   const ClubInformationGraph(),
      ]),
    );
  }
}
