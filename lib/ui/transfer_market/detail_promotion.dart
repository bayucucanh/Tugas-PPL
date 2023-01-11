import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/transfer_market/controller/detail_promo.controller.dart';
import 'package:mobile_pssi/ui/transfer_market/parts/detail_form_selection.dart';
import 'package:mobile_pssi/ui/transfer_market/parts/detail_form_student.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class DetailPromotion extends GetView<DetailPromoController> {
  static const routeName = '/promotions/detail';
  const DetailPromotion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DetailPromoController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Detil Promo'.text.make(),
      actions: [
        if (!controller.userData.value.hasRole('administrator'))
          IconButton(
            onPressed: controller.openParticipants,
            icon: const Icon(Icons.groups_outlined),
            tooltip: 'Lihat Peserta',
          ),
        // IconButton(
        //   onPressed: controller.openPerformance,
        //   icon: const Icon(Icons.bar_chart_rounded),
        //   tooltip: 'Lihat Statistik Performa',
        // ),
      ],
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullUp: false,
          enablePullDown: true,
          onRefresh: controller.refreshData,
          child: VStack([
            VStack(
              [
                'Informasi Promosi'.text.semiBold.lg.make(),
                UiSpacer.divider(height: 10),
                HStack([
                  'Tipe :'.text.semiBold.make(),
                  UiSpacer.horizontalSpace(space: 5),
                  (controller.promo?.promoLabel ?? '-').text.make(),
                ]),
                UiSpacer.verticalSpace(space: 16),
                VStack([
                  'Tanggal Pembuatan'.text.semiBold.make(),
                  UiSpacer.horizontalSpace(space: 5),
                  (controller.promo?.formatCreatedAt ?? '-').text.make(),
                ]),
                UiSpacer.verticalSpace(space: 16),
                HStack([
                  'Target :'.text.semiBold.make(),
                  UiSpacer.horizontalSpace(space: 5),
                  (controller.promo?.target?.capitalize ?? '-')
                      .text
                      .make()
                      .expand(),
                ]),
                UiSpacer.verticalSpace(space: 16),
                HStack([
                  'Status :'.text.semiBold.make(),
                  UiSpacer.horizontalSpace(space: 5),
                  (controller.promo?.status?.name ?? '-')
                      .text
                      .semiBold
                      .color(controller.promo?.status?.statusColor())
                      .make()
                      .expand(),
                  if (controller.promo?.status?.id != 3)
                    ButtonBar(
                      buttonPadding: EdgeInsets.zero,
                      children: [
                        if (controller.promo?.status?.id != 1)
                          IconButton(
                              onPressed: () => controller.changeStatus(1),
                              icon: const Icon(Icons.play_arrow_rounded)),
                        if (controller.promo?.status?.id != 2)
                          IconButton(
                              onPressed: () => controller.changeStatus(2),
                              icon: const Icon(Icons.pause_rounded)),
                        IconButton(
                          onPressed: controller.confirmStopPromotionDialog,
                          icon: const Icon(Icons.stop_rounded),
                        ),
                      ],
                    )
                ]),
              ],
              axisSize: MainAxisSize.max,
            ).p8().card.color(Get.theme.cardColor).make(),
            UiSpacer.verticalSpace(),
            (controller.promo?.promoType == 1
                    ? 'Informasi Form Siswa Baru'
                    : 'Informasi Form Seleksi')
                .text
                .semiBold
                .lg
                .make(),
            controller.promo?.promoType == 1
                ? const DetailFormStudent()
                : const DetailFormSelection(),
          ]),
        ).p12().safeArea(),
      ),
    );
  }
}
