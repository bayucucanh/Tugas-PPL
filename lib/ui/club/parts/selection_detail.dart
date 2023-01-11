import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/club/controller/club_promo_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectionDetail extends GetView<ClubPromoDetailController> {
  const SelectionDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => VStack([
          (controller.canApplyForm()
                  ? controller.uploadData.value
                      ? 'Menunggu...'
                      : 'Ikut Seleksi'
                  : 'Tidak dapat bergabung')
              .text
              .white
              .makeCentered()
              .continuousRectangle(
                height: 40,
                backgroundColor:
                    controller.canApplyForm() ? primaryColor : Colors.grey,
              )
              .onTap(controller.canApplyForm()
                  ? controller.uploadData.value
                      ? null
                      : controller.participate
                  : null),
          UiSpacer.verticalSpace(),
          'Informasi Seleksi'.text.semiBold.xl.make(),
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
            VStack([
              'Waktu'.text.semiBold.make(),
              '${controller.promo?.selectionForm?.startTimeFormat ?? '-'} s/d ${controller.promo?.selectionForm?.endTimeFormat ?? '-'}'
                  .text
                  .make(),
            ]),
          ]),
          UiSpacer.verticalSpace(space: 16),
          HStack(
            [
              VStack([
                'Tahun Kelahiran'.text.semiBold.make(),
                (controller.promo?.selectionForm?.birthYears ?? '-')
                    .text
                    .make(),
              ]).expand(),
              VStack([
                'Kompetisi'.text.semiBold.make(),
                (controller.promo?.selectionForm?.competition ?? '-')
                    .text
                    .make(),
              ]).expand(),
            ],
            alignment: MainAxisAlignment.spaceBetween,
          ),
          UiSpacer.verticalSpace(space: 16),
          'Biaya Seleksi'.text.semiBold.make(),
          (controller.promo?.selectionForm?.selectionFeePrice ?? 'Gratis')
              .text
              .make(),
          UiSpacer.verticalSpace(space: 16),
          'Biaya'.text.semiBold.make(),
          (controller.promo?.selectionForm?.feePrice ?? '-').text.make(),
          UiSpacer.verticalSpace(space: 16),
          'Catatan'.text.semiBold.make(),
          (controller.promo?.selectionForm?.notes ?? '-').text.make(),
          UiSpacer.verticalSpace(space: 16),
        ]));
  }
}
