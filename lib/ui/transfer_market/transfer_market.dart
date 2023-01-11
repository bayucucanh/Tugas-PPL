import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/data/model/new_student_form.dart';
import 'package:mobile_pssi/data/model/selection_form.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/transfer_market/controller/transfer_market.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class TransferMarket extends GetView<TransfermarketController> {
  static const routeName = '/transfermarket';
  const TransferMarket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TransfermarketController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Transfermarket'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        onLoading: controller.loadMore,
        onRefresh: controller.refreshData,
        enablePullDown: true,
        enablePullUp: true,
        child: Obx(
          () => controller.promotions!.isEmpty
              ? EmptyWithButton(
                  emptyMessage: controller.userData.value
                          .hasRole('administrator')
                      ? 'Tidak ada promosi tersedia'
                      : 'Anda belum mempunyai promosi, buat promosi sekarang juga untuk mendapatkan jangkauan lebih banyak.',
                  textButton: 'Buat Promo',
                  showButton: controller.userData.value.hasRole('administrator')
                      ? false
                      : true,
                  onTap: controller.userData.value.hasRole('administrator')
                      ? null
                      : controller.addNewPromo,
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final promotion = controller.promotions?[index];
                    return VStack([
                      HStack([
                        VStack([
                          (promotion?.promoLabel ?? '-').text.semiBold.make(),
                          (promotion?.formatCreatedAt ?? '-')
                              .text
                              .sm
                              .gray500
                              .make(),
                        ]).expand(),
                        (promotion?.status?.name ?? '-')
                            .text
                            .white
                            .sm
                            .make()
                            .px12()
                            .py4()
                            .box
                            .color(promotion!.status!.statusColor())
                            .roundedLg
                            .make(),
                      ]),
                      UiSpacer.divider(height: 20),
                      HStack([
                        const Icon(
                          Icons.track_changes_rounded,
                          size: 14,
                        ),
                        UiSpacer.horizontalSpace(space: 5),
                        (promotion.target?.capitalize ?? '-')
                            .text
                            .sm
                            .semiBold
                            .make(),
                        promotion.promoType == 1
                            ? resumeNewStudentForm(promotion.newStudentForm!)
                            : resumeSelectionForm(promotion.selectionForm!),
                      ]).scrollHorizontal()
                    ])
                        .p8()
                        .card
                        .color(Get.theme.cardColor)
                        .make()
                        .onInkTap(() => controller.openDetailPromo(promotion));
                  },
                  itemCount: controller.promotions?.length ?? 0,
                ),
        ).p12(),
      ),
      floatingActionButton: controller.userData.value.hasRole('administrator')
          ? null
          : FloatingActionButton.extended(
              onPressed: controller.addNewPromo,
              label: 'Buat Promo'.text.make()),
    );
  }

  resumeNewStudentForm(NewStudentForm studentForm) {
    return HStack([
      UiSpacer.horizontalSpace(space: 10),
      HStack([
        'Biaya Pangkal : '.text.sm.semiBold.make(),
        (studentForm.startUpFeePrice ?? '-').text.sm.make(),
      ]),
      UiSpacer.horizontalSpace(space: 10),
      HStack([
        'Biaya Bulanan : '.text.sm.semiBold.make(),
        (studentForm.monthlyFeePrice ?? '-').text.sm.make(),
      ]),
    ]);
  }

  resumeSelectionForm(SelectionForm selectionForm) {
    return HStack([
      UiSpacer.horizontalSpace(space: 10),
      HStack([
        'Biaya Seleksi : '.text.sm.semiBold.make(),
        (selectionForm.selectionFeePrice ?? 'Gratis').text.sm.make(),
      ]),
      UiSpacer.horizontalSpace(space: 10),
      HStack([
        'Biaya Tambahan: '.text.sm.semiBold.make(),
        (selectionForm.feePrice ?? '-').text.sm.make(),
      ]),
    ]);
  }
}
