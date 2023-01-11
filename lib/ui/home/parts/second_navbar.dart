import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/home/controller/home_controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class SecondNavbar extends GetView<HomeController> {
  const SecondNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: HStack(
        [
          IconButton(
            onPressed: controller.openScanner,
            icon: VStack(
              [
                const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Vx.white,
                  size: 20,
                ),
                UiSpacer.verticalSpace(space: 5),
                'Scan'.text.white.sm.semiBold.make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ),
            padding: EdgeInsets.zero,
          ),
          UiSpacer.verticalDivider(color: Vx.white, width: 10),
          VStack(
            [
              const Icon(
                FontAwesomeIcons.circleDollarToSlot,
                size: 18,
                color: Vx.white,
              ),
              UiSpacer.verticalSpace(space: 5),
              'Isi Saldo'.text.white.sm.semiBold.make(),
            ],
            crossAlignment: CrossAxisAlignment.center,
          ),
          UiSpacer.verticalDivider(color: Vx.white, width: 10),
          Obx(
            () => VStack(
              [
                const Icon(
                  FontAwesomeIcons.wallet,
                  size: 18,
                  color: Vx.white,
                ),
                UiSpacer.verticalSpace(space: 5),
                (controller.userBalance?.balanceFormat ?? 'Rp 0')
                    .text
                    .sm
                    .semiBold
                    .white
                    .make()
              ],
              crossAlignment: CrossAxisAlignment.center,
            ),
          ),
        ],
        alignment: MainAxisAlignment.spaceAround,
        crossAlignment: CrossAxisAlignment.center,
        axisSize: MainAxisSize.max,
      ).box.p4.roundedLg.color(primaryColor).make().p12(),
    ).h(80);
  }
}
