import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/transfer_market/controller/detail_promo.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class DetailFormSelection extends GetView<DetailPromoController> {
  const DetailFormSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        UiSpacer.verticalSpace(),
        'Tempat Seleksi'.text.semiBold.make(),
        (controller.promo?.selectionForm?.location ?? '-').text.make(),
        UiSpacer.verticalSpace(space: 16),
        'Alamat Lengkap'.text.semiBold.make(),
        (controller.promo?.selectionForm?.address ?? '-').text.make(),
        UiSpacer.verticalSpace(space: 16),
        HStack([
          VStack([
            'Tanggal Seleksi'.text.semiBold.make(),
            '${controller.promo?.selectionForm?.formatStartDate ?? '-'} s/d ${controller.promo?.selectionForm?.formatEndDate ?? '-'}'
                .text
                .make(),
          ]).expand(),
          UiSpacer.horizontalSpace(space: 10),
          VStack([
            'Waktu'.text.semiBold.make(),
            '${controller.promo?.selectionForm?.startTimeFormat ?? '-'} s/d ${controller.promo?.selectionForm?.endTimeFormat ?? '-'}'
                .text
                .make(),
          ]),
        ]),
        UiSpacer.verticalSpace(space: 16),
        HStack([
          VStack([
            'Kuota Lolos'.text.semiBold.make(),
            '${controller.promo?.selectionForm?.passQuota ?? '-'} Orang'
                .text
                .make(),
          ]).expand(),
          VStack([
            'Kuota Peserta'.text.semiBold.make(),
            '${controller.promo?.selectionForm?.formQuota == null || controller.promo?.selectionForm?.formQuota == 0 ? 'Tidak ada batasan' : controller.promo?.selectionForm?.formQuota}'
                .text
                .make(),
          ]),
        ]),
        UiSpacer.verticalSpace(space: 16),
        'Tahun Kelahiran'.text.semiBold.make(),
        (controller.promo?.selectionForm?.birthYears ?? '-').text.make(),
        UiSpacer.verticalSpace(space: 16),
        'Kompetisi'.text.semiBold.make(),
        (controller.promo?.selectionForm?.competition ?? '-').text.make(),
        UiSpacer.verticalSpace(space: 16),
        'Biaya Seleksi'.text.semiBold.make(),
        (controller.promo?.selectionForm?.selectionFeePrice ?? 'Gratis')
            .text
            .make(),
        UiSpacer.verticalSpace(space: 16),
        'Biaya Tambahan'.text.semiBold.make(),
        (controller.promo?.selectionForm?.feePrice ?? '-').text.make(),
        UiSpacer.verticalSpace(space: 16),
        'Catatan'.text.semiBold.make(),
        (controller.promo?.selectionForm?.notes ?? '-').text.make(),
        UiSpacer.verticalSpace(space: 16),
      ]),
    );
  }
}
