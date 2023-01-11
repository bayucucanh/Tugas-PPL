import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/home/controller/player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachList extends GetView<PlayerController> {
  const CoachList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        'Konsultasi dengan Ahlinya'.text.semiBold.xl.make().expand(),
        'Lihat semua'
            .text
            .color(primaryColor)
            .sm
            .make()
            .onTap(controller.openCoaches)
      ]),
      UiSpacer.verticalSpace(space: 10),
      Obx(
        () => controller.coachList.value.data!.isEmpty
            ? 'Belum ada pelatih terdaftar'.text.makeCentered()
            : ListView.builder(
                itemCount: controller.coachList.value.data?.length,
                padding: const EdgeInsets.only(top: 10),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemExtent: 140,
                itemBuilder: (context, index) {
                  final coach = controller.coachList.value.data?[index];
                  return VStack(
                    [
                      CircleAvatar(
                        foregroundImage:
                            CachedNetworkImageProvider(coach!.imageProfile),
                      ).wh(60, 60).badge(
                            color: coach.isOnline == true
                                ? Colors.green
                                : Colors.grey,
                          ),
                      UiSpacer.verticalSpace(space: 10),
                      (coach.employee?.name ?? '-')
                          .text
                          .semiBold
                          .sm
                          .center
                          .ellipsis
                          .maxLines(2)
                          .make(),
                      if (coach.specialists != null &&
                          coach.specialists!.isNotEmpty)
                        (coach.specialists?[0].name ?? '-')
                            .text
                            .sm
                            .center
                            .ellipsis
                            .maxLines(2)
                            .make(),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                  ).onTap(() => controller.openCoachProfile(coach));
                },
              ).h(140),
      ),
    ]).px12();
  }
}
