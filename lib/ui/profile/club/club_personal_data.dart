import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubPersonalData extends GetView<PersonalDataController> {
  const ClubPersonalData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: controller.coachData.totalTab,
        child: VStack([
          MaterialBanner(
              content: 'Apakah saya sudah terverifikasi oleh ${F.title}.'
                  .text
                  .sm
                  .make(),
              actions: [
                IconButton(
                  onPressed: null,
                  icon: Icon(
                      controller.userData.value.klb?.id == null ||
                              controller.userData.value.klb?.id == 2
                          ? Icons.close
                          : Icons.check,
                      color: controller.userData.value.klb?.id == null ||
                              controller.userData.value.klb?.id == 2
                          ? Colors.red
                          : Colors.green),
                )
              ]),
          TabBar(
            tabs: controller.clubData.tabs,
            isScrollable: true,
          ),
          TabBarView(
            children: controller.clubData.tabViews,
          ).expand(),
        ]),
      ),
    );
  }
}
