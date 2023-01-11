import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/ui/events/controller/event_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:velocity_x/velocity_x.dart';

class EventDetail extends GetView<EventDetailController> {
  static const routeName = '/event/detail';
  const EventDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EventDetailController());
    return DefaultScaffold(
      title: (controller.event.name ?? '-').text.ellipsis.sm.make(),
      backgroundColor: Get.theme.backgroundColor,
      actions: controller.userData.value.hasRole('administrator')
          ? [
              IconButton(
                onPressed: controller.openParticipants,
                icon: const Icon(Icons.group),
                tooltip: 'Peserta Event',
              ),
              IconButton(
                onPressed: controller.editEvent,
                icon: const Icon(Icons.edit),
                tooltip: 'Ubah Event',
              ),
            ]
          : null,
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullUp: false,
        enablePullDown: true,
        onRefresh: controller.refreshData,
        child: Obx(
          () => VStack([
            ZStack([
              ImageCustom(
                url: controller.event.banner!,
                blurhash: controller.event.blurhash,
              ).wFull(context).cornerRadius(20),
              IconButton(
                icon: const Icon(
                  Icons.share_rounded,
                ),
                color: Vx.white,
                onPressed: controller.shareEvent,
              ).box.width(40).color(primaryColor).roundedFull.make().positioned(
                    right: 0,
                    bottom: 0,
                  ),
            ])
                .p8()
                .box
                .color(Get.theme.backgroundColor)
                .make()
                .h(255)
                .wFull(context),
            VStack(
              [
                if (controller.eventAvailable == false)
                  MaterialBanner(
                      content: 'Event ini sudah tidak tersedia'.text.make(),
                      actions: const [
                        Icon(
                          Icons.info_outline_rounded,
                          color: primaryColor,
                        )
                      ]),
                if (controller.isRegistered == true)
                  MaterialBanner(
                      content: 'Anda sudah memiliki tiket.'.text.make(),
                      actions: const [
                        Icon(
                          Icons.info_outline_rounded,
                          color: primaryColor,
                        )
                      ]),
                VStack([
                  (controller.event.type ?? '-').text.xl.semiBold.make(),
                  UiSpacer.divider(height: 10),
                  (controller.event.name ?? '-').text.semiBold.lg.make(),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.streetview_rounded,
                      color: primaryColor,
                    ),
                    title: 'Tipe Event'.text.make(),
                    subtitle: VStack([
                      (controller.event.isOnline == true ? 'Online' : 'Onsite')
                          .text
                          .make(),
                      if (controller.userData.value.hasRole('administrator') &&
                          controller.event.isOnline == true)
                        (controller.event.meetingUrl ??
                                'Belum ada link meeting')
                            .text
                            .make(),
                    ]),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.place_rounded,
                      color: primaryColor,
                    ),
                    title: 'Alamat'.text.make(),
                    subtitle: (controller.event.address ?? '-').text.make(),
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.event,
                      color: primaryColor,
                    ),
                    title: 'Tanggal Acara'.text.make(),
                    subtitle:
                        '${controller.event.startDateFormat ?? '-'} - ${controller.event.endDateFormat}'
                            .text
                            .make(),
                  ),
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.view_timeline_rounded,
                      color: primaryColor,
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: 'Waktu Acara'.text.make(),
                    subtitle:
                        '${controller.event.startTimeFormat ?? '-'} - ${controller.event.endTimeFormat}'
                            .text
                            .make(),
                  ),
                ]).p8().card.make(),
                VStack([
                  (controller.event.additionalDescriptionLabel ?? 'Detail')
                      .text
                      .lg
                      .semiBold
                      .make(),
                  UiSpacer.divider(height: 10),
                  ReadMoreText(
                    controller.event.additionalDescription ?? '-',
                    trimLength: 150,
                    trimMode: TrimMode.Length,
                  ),
                ]).p8().card.make(),
                VStack([
                  (controller.event.speakerLabel ?? 'Pembicara')
                      .text
                      .lg
                      .semiBold
                      .make(),
                  UiSpacer.divider(height: 10),
                  (controller.event.speaker ?? '-').text.make(),
                ]).p8().card.make(),
                HStack([
                  VStack([
                    'Harga'.text.lg.semiBold.make(),
                    UiSpacer.divider(height: 10),
                    '${controller.event.priceFormat ?? '-'}/org'
                        .text
                        .color(primaryColor)
                        .semiBold
                        .make(),
                  ]).expand(),
                  if (controller.userData.value.hasRole('administrator') ==
                          false &&
                      controller.eventAvailable == true)
                    HStack([
                      UiSpacer.horizontalSpace(space: 10),
                      'Checkout'
                          .text
                          .white
                          .makeCentered()
                          .continuousRectangle(
                              height: 40,
                              width: 100,
                              backgroundColor: controller.isRegistered == true
                                  ? Vx.gray300
                                  : primaryColor)
                          .onTap(controller.isRegistered == true
                              ? null
                              : controller.confirmCheckout),
                    ]),
                ]).p8().card.make(),
                if (controller.userData.value.hasRole('administrator'))
                  VStack([
                    'Event Diperuntukan'.text.make(),
                    CheckboxListTile(
                      value: controller.checkTarget('pelatih'),
                      onChanged: (val) {},
                      dense: true,
                      title: 'Pelatih'.text.make(),
                    ),
                    CheckboxListTile(
                      value: controller.checkTarget('pemain'),
                      onChanged: (val) {},
                      dense: true,
                      title: 'Pemain'.text.make(),
                    ),
                    CheckboxListTile(
                      value: controller.checkTarget('klub'),
                      onChanged: (val) {},
                      dense: true,
                      title: 'Klub'.text.make(),
                    ),
                  ]).p8().card.make(),
              ],
            ),
          ]).safeArea(),
        ),
      ),
    );
  }
}
