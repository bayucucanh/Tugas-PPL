import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/home/controller/employee.controller.dart';
import 'package:mobile_pssi/ui/home/parts/event.card.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EmployeeEventList extends GetView<EmployeeController> {
  const EmployeeEventList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        'Event'.text.semiBold.xl.make().expand(),
        'Lihat semua'
            .text
            .color(primaryColor)
            .sm
            .make()
            .onTap(controller.openEvents)
      ]),
      UiSpacer.verticalSpace(space: 10),
      Obx(
        () => controller.isLoadingEvent
            ? ''.text.make().skeleton(width: 230, height: 200)
            : controller.events!.isEmpty
                ? const EmptyWithButton(
                    emptyMessage: 'Kompetisi belum tersedia',
                    showButton: false,
                    showImage: true,
                  )
                : ListView.builder(
                    itemCount: controller.events?.length,
                    shrinkWrap: true,
                    itemExtent: 230,
                    itemBuilder: (context, index) => EventCard(
                      data: controller.events![index],
                      onTap: () =>
                          controller.openEvent(controller.events![index]),
                    ),
                    scrollDirection: Axis.horizontal,
                  ).h(240),
      ),
    ]).p12();
  }
}
