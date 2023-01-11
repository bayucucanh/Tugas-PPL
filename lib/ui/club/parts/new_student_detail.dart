import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/club/controller/club_promo_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class NewStudentDetail extends GetView<ClubPromoDetailController> {
  const NewStudentDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        (controller.canApplyForm()
                ? controller.uploadData.value
                    ? 'Menunggu...'
                    : 'Gabung Peserta'
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
        'Informasi Siswa Baru'.text.semiBold.xl.make(),
        UiSpacer.verticalSpace(space: 10),
        'Tempat Latihan'.text.semiBold.make(),
        (controller.promo?.newStudentForm?.practiceLocation ?? '-').text.make(),
        UiSpacer.verticalSpace(space: 16),
        'Alamat Lengkap'.text.semiBold.make(),
        '${controller.promo?.newStudentForm?.address ?? '-'}, ${controller.promo?.newStudentForm?.village?.toCompleteAddress() ?? '-'}'
            .text
            .make(),
        UiSpacer.verticalSpace(space: 16),
        'Catatan '.text.semiBold.make(),
        (controller.promo?.newStudentForm?.notes ?? '-').text.make(),
        UiSpacer.verticalSpace(space: 16),
        HStack(
          [
            VStack([
              'Biaya Pangkal '.text.semiBold.make(),
              (controller.promo?.newStudentForm?.startUpFeePrice ?? '-')
                  .text
                  .make(),
            ]),
            VStack([
              'Biaya Bulanan '.text.semiBold.make(),
              (controller.promo?.newStudentForm?.monthlyFeePrice ?? '-')
                  .text
                  .make(),
            ]),
          ],
          alignment: MainAxisAlignment.spaceBetween,
          axisSize: MainAxisSize.max,
        ),
        UiSpacer.verticalSpace(space: 16),
        'Jadwal Latihan'.text.semiBold.lg.make(),
        UiSpacer.verticalSpace(space: 16),
        HStack(
          [
            'Hari'.text.semiBold.make(),
            'Jam Mulai'.text.semiBold.make(),
            'Jam Selesai'.text.semiBold.make(),
          ],
          alignment: MainAxisAlignment.spaceBetween,
          axisSize: MainAxisSize.max,
        ),
        controller.promo?.newStudentForm?.schedules == null ||
                controller.promo!.newStudentForm!.schedules!.isEmpty
            ? VStack([
                UiSpacer.verticalSpace(),
                'Tidak ada jadwal latihan tersedia'.text.makeCentered()
              ])
            : ListView.builder(
                itemBuilder: (context, index) {
                  final schedule =
                      controller.promo?.newStudentForm?.schedules?[index];
                  return HStack(
                    [
                      (schedule?.day?.name ?? '-').text.make(),
                      (schedule?.startTime ?? '-').text.make(),
                      (schedule?.endTime ?? '-').text.make(),
                    ],
                    alignment: MainAxisAlignment.spaceBetween,
                    axisSize: MainAxisSize.max,
                  );
                },
                itemCount:
                    controller.promo?.newStudentForm?.schedules?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
        UiSpacer.verticalSpace(space: 16),
        'Biaya Tambahan'.text.semiBold.lg.make(),
        UiSpacer.verticalSpace(space: 16),
        controller.promo?.newStudentForm?.additionalFields == null ||
                controller.promo!.newStudentForm!.additionalFields!.isEmpty
            ? VStack([
                UiSpacer.verticalSpace(),
                'Tidak ada biaya tambahan'.text.makeCentered()
              ])
            : ListView.builder(
                itemBuilder: (context, index) {
                  final field = controller
                      .promo?.newStudentForm?.additionalFields?[index];
                  return HStack(
                    [
                      (field?.name ?? '-').text.make(),
                      (field?.valuePrice ?? '-').text.make(),
                    ],
                    alignment: MainAxisAlignment.spaceBetween,
                    axisSize: MainAxisSize.max,
                  );
                },
                itemCount: controller
                        .promo?.newStudentForm?.additionalFields?.length ??
                    0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
      ]).p12(),
    );
  }
}
