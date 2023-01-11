import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/home/controller/home_controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class DashboardStat extends GetView<HomeController> {
  const DashboardStat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => VStack([
          HStack(
            [
              SvgPicture.asset(
                'assets/images/athletic-soccer-player-svgrepo-com.svg',
                color: Colors.green.shade700,
              ).wh(30, 30),
              UiSpacer.horizontalSpace(space: 5),
              VStack([
                'Total Pemain'.text.sm.semiBold.make(),
                '${controller.dashboard.value.totalPlayers ?? '0'}'.text.make(),
              ]),
              UiSpacer.horizontalSpace(),
              SvgPicture.asset(
                'assets/images/soccer-player-svgrepo-com.svg',
                color: Colors.red.shade700,
              ).wh(30, 30),
              UiSpacer.horizontalSpace(space: 5),
              VStack([
                'Total Pelatih'.text.sm.semiBold.make(),
                '${controller.dashboard.value.totalCoaches ?? '0'}'.text.make(),
              ]),
              UiSpacer.horizontalSpace(),
              SvgPicture.asset('assets/images/ball-soccer-svgrepo-com.svg')
                  .wh(30, 30),
              UiSpacer.horizontalSpace(space: 5),
              VStack([
                'Total Klub'.text.sm.semiBold.make(),
                '${controller.dashboard.value.totalClub ?? '0'}'.text.make(),
              ]),
            ],
            axisSize: MainAxisSize.max,
            alignment: MainAxisAlignment.spaceEvenly,
          ),
          UiSpacer.verticalSpace(),
          HStack([
            'Total Tugas'.text.semiBold.sm.make().expand(),
            '${controller.dashboard.value.totalTasks ?? '0'}'.text.make(),
          ]),
          UiSpacer.divider(height: 5),
          HStack([
            'Verifikasi e-Learning'.text.semiBold.sm.make().expand(),
            '${controller.dashboard.value.verifiedTaskCount ?? '0'}'
                .text
                .make(),
          ]),
          UiSpacer.divider(height: 5),
          HStack([
            'Verifikasi Partner'.text.semiBold.sm.make().expand(),
            '${controller.dashboard.value.verifiedPartnerCount ?? '0'}'
                .text
                .make(),
          ]),
          UiSpacer.divider(height: 5),
          HStack([
            'Verifikasi Akun'.text.semiBold.sm.make().expand(),
            '${controller.dashboard.value.verifiedAccountCount ?? '0'}'
                .text
                .make(),
          ]),
        ])
            .p8()
            .h(190)
            .box
            .color(Get.theme.cardColor)
            .make()
            .cornerRadius(20)
            .p12()
            .wFull(context));
  }
}
