import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/home/controller/player.controller.dart';
import 'package:mobile_pssi/ui/home/parts/class.card.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ClassList extends GetView<PlayerController> {
  const ClassList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        'Daftar Kelas Gratis'.text.semiBold.xl.make().expand(),
        'Lihat semua'
            .text
            .color(primaryColor)
            .sm
            .make()
            .onTap(() => controller.openList(premiumClass: false))
      ]),
      UiSpacer.verticalSpace(space: 10),
      Obx(
        () => controller.isLoadingFreeClass
            ? ''.text.make().skeleton(width: 230, height: 200)
            : controller.freeClasses.value.data!.isEmpty
                ? 'Kelas belum tersedia'.text.makeCentered().h(230)
                : ListView.builder(
                    itemCount: controller.freeClasses.value.data?.length,
                    shrinkWrap: true,
                    itemExtent: 245,
                    itemBuilder: (context, index) => ClassCard(
                      data: controller.freeClasses.value.data![index],
                      onTap: () => controller
                          .showClass(controller.freeClasses.value.data![index]),
                    ),
                    scrollDirection: Axis.horizontal,
                  ).h(245),
      ),
      HStack([
        'Daftar Kelas Premium'.text.semiBold.xl.make().expand(),
        'Lihat semua'
            .text
            .color(primaryColor)
            .sm
            .make()
            .onTap(() => controller.openList(premiumClass: true))
      ]),
      UiSpacer.verticalSpace(space: 10),
      Obx(
        () => controller.isLoadingPremiumClass
            ? ''.text.make().skeleton(width: 230, height: 200)
            : controller.premiumClasses.value.data!.isEmpty
                ? 'Kelas premium belum tersedia'.text.makeCentered().h(230)
                : ListView.builder(
                    itemCount: controller.premiumClasses.value.data?.length,
                    shrinkWrap: true,
                    itemExtent: 245,
                    itemBuilder: (context, index) => ClassCard(
                      data: controller.premiumClasses.value.data![index],
                      onTap: () => controller.showClass(
                          controller.premiumClasses.value.data![index]),
                    ),
                    scrollDirection: Axis.horizontal,
                  ).h(245),
      ),
    ]).px12().pOnly(top: 12);
  }
}
