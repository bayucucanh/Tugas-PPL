import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerPersonalData extends GetView<PersonalDataController> {
  const PlayerPersonalData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: controller.playerData.totalTab,
        child: VStack([
          TabBar(
            tabs: controller.playerData.tabs,
            isScrollable: true,
          ),
          TabBarView(
            children: controller.playerData.tabViews,
          ).expand(),
        ]),
      ),
    );
  }
}
