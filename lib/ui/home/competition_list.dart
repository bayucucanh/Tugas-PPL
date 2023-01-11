import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/home/controller/home_controller.dart';
import 'package:mobile_pssi/ui/home/parts/event.card.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class CompetitionList extends GetView<HomeController> {
  const CompetitionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        'Kompetisi'.text.semiBold.xl.make().expand(),
        'Lihat semua'
            .text
            .color(primaryColor)
            .sm
            .make()
            .onTap(controller.openCompetitions)
      ]),
      UiSpacer.verticalSpace(space: 10),
      Obx(
        () => controller.isCompetitionLoading == true
            ? ''.text.make().skeleton(width: 230, height: 200)
            : controller.competitions!.isEmpty
                ? const EmptyWithButton(
                    emptyMessage: 'Kompetisi belum tersedia',
                    showButton: false,
                    showImage: true,
                  )
                : ListView.builder(
                    itemCount: controller.competitions?.length,
                    shrinkWrap: true,
                    itemExtent: 230,
                    itemBuilder: (context, index) => EventCard(
                      data: controller.competitions![index],
                      onTap: () =>
                          controller.openEvent(controller.competitions![index]),
                    ),
                    scrollDirection: Axis.horizontal,
                  ).h(240),
      ),
    ]).px12().pOnly(top: 10);
  }
}
