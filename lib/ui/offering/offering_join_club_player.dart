import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/offering/controller/offering_player.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class OfferingJoinClubPlayer extends GetView<OfferingPlayerController> {
  static const routeName = '/player/offer';
  const OfferingJoinClubPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OfferingPlayerController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: 'Tawaran Bergabung Klub'.text.make(),
        body: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.refreshData,
          child: VStack([
            HStack([
              'Informasi Tawaran'.text.semiBold.lg.make().expand(),
              (controller.playerOffering.value.status?.name ?? '-')
                  .text
                  .white
                  .make()
                  .p8()
                  .card
                  .color(controller.playerOffering.value.statusColor)
                  .make(),
            ]),
            UiSpacer.verticalSpace(),
            HStack(
              [
                if (controller.playerOffering.value.club != null)
                  controller.playerOffering.value.club?.verified?.id == 0
                      ? CachedNetworkImage(
                          imageUrl: controller
                                      .playerOffering.value.club?.photo ==
                                  null
                              ? controller.playerOffering.value.club!.gravatar()
                              : controller.playerOffering.value.club!.photo!,
                          fit: BoxFit.cover,
                        ).h(100).cornerRadius(10)
                      : CachedNetworkImage(
                          imageUrl: controller
                                      .playerOffering.value.club?.photo ==
                                  null
                              ? controller.playerOffering.value.club!.gravatar()
                              : controller.playerOffering.value.club!.photo!,
                          fit: BoxFit.cover,
                        ).h(100).cornerRadius(10).badge(
                            type: VxBadgeType.round,
                            size: 25,
                            color: primaryColor,
                            optionalWidget: const Icon(
                              Icons.verified_user_rounded,
                              color: Colors.white,
                            ),
                          ),
                UiSpacer.horizontalSpace(space: 20),
                VStack([
                  (controller.playerOffering.value.club?.name ?? '-')
                      .text
                      .semiBold
                      .xl
                      .make(),
                  'Alamat : ${controller.playerOffering.value.club?.address ?? '-'}'
                      .text
                      .make(),
                  'Dibentuk : ${controller.playerOffering.value.club?.dateOfBirthFormat ?? '-'}'
                      .text
                      .make(),
                  'Kota : ${controller.playerOffering.value.club?.city?.name ?? '-'}'
                      .text
                      .make(),
                  'Provinsi : ${controller.playerOffering.value.club?.province?.name ?? '-'}'
                      .text
                      .capitalize
                      .make(),
                ]).expand(),
              ],
              crossAlignment: CrossAxisAlignment.start,
            ),
            UiSpacer.verticalSpace(),
            'Anda ditawarkan untuk menjadi :'.text.make(),
            if (controller.playerOffering.value.offeringPositions != null)
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: controller.playerOffering.value.offeringPositions!
                    .map((position) =>
                        (position.position?.name ?? '-').text.semiBold.make())
                    .toList(),
              ),
            UiSpacer.verticalSpace(),
            'Deskripsi Penawaran'.text.semiBold.make(),
            (controller.playerOffering.value.offerText ?? '-').text.make(),
            UiSpacer.verticalSpace(),
            if (controller.playerOffering.value.offerFile != null)
              'Lihat Dokumen Penawaran'
                  .text
                  .white
                  .makeCentered()
                  .continuousRectangle(
                    height: 40,
                    backgroundColor: primaryColor,
                  )
                  .onInkTap(controller.openOfferingDocument),
          ]).p12().scrollVertical(),
        ),
        persistentFooterButtons: [
          if (controller.playerOffering.value.status?.id == 0)
            TextButtonTheme(
              data: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor,
                  textStyle: const TextStyle(
                    color: primaryColor,
                  ),
                ),
              ),
              child: ButtonBar(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      side: const BorderSide(color: primaryColor),
                    ),
                    onPressed: controller.dialogDeny,
                    child: const Text(
                      'Tolak',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.dialogAccept,
                    child: const Text('Terima'),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
