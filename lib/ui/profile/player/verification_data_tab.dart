import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/file_form.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class VerificationDataTab extends GetView<PersonalDataController> {
  const VerificationDataTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        HStack([
          VStack([
            'Dokumen Screening'.text.semiBold.lg.make(),
            'Dokumen dibawah akan di verifikasi oleh prima untuk proses screening yang dapat digunakan oleh klub.'
                .text
                .sm
                .gray500
                .make(),
            'File yang dapat di unggah berekstensi pdf.'
                .text
                .sm
                .semiBold
                .color(primaryColor)
                .make(),
          ]).expand(),
        ]),
        UiSpacer.verticalSpace(),
        HStack(
          [
            FileForm(
              label: 'Akta Kelahiran',
              onTap: controller.playerData.selectBirthCertificate,
              selectedFile: controller.playerData.birthCertificate.value,
            ).expand(),
            UiSpacer.horizontalSpace(space: 10),
            VStack(
              [
                'Status'.text.semiBold.make(),
                (controller.userData.value.birthCertificate?.id == null
                        ? 'Tidak ada file'
                        : controller.userData.value.birthCertificate?.status
                                ?.name ??
                            '-')
                    .text
                    .semiBold
                    .white
                    .sm
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            )
                .box
                .p8
                .roundedSM
                .color(controller.userData.value.birthCertificate?.status
                        ?.statusColor() ??
                    Colors.grey)
                .make()
                .onInkTap(controller.userData.value.birthCertificate?.id == null
                    ? null
                    : () => controller.playerData.openFileScreening(
                        controller.userData.value.birthCertificate?.file)),
          ],
        ),
        UiSpacer.verticalSpace(),
        HStack(
          [
            FileForm(
              label: 'Kartu Keluarga',
              onTap: controller.playerData.selectKk,
              selectedFile: controller.playerData.kk.value,
            ).expand(),
            UiSpacer.horizontalSpace(space: 10),
            VStack(
              [
                'Status'.text.semiBold.make(),
                (controller.userData.value.kkDocument?.id == null
                        ? 'Tidak ada file'
                        : controller.userData.value.kkDocument?.status?.name ??
                            '-')
                    .text
                    .semiBold
                    .white
                    .sm
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            )
                .box
                .p8
                .roundedSM
                .color(controller.userData.value.kkDocument?.status
                        ?.statusColor() ??
                    Colors.grey)
                .make()
                .onInkTap(controller.userData.value.kkDocument?.id == null
                    ? null
                    : () => controller.playerData.openFileScreening(
                        controller.userData.value.kkDocument?.file)),
          ],
        ),
        UiSpacer.verticalSpace(),
        if (controller.playerData.showIjazah.value == true)
          HStack([
            FileForm(
              label: 'Ijazah/NISN',
              onTap: controller.playerData.selectIjazah,
              selectedFile: controller.playerData.ijazah.value,
            ).expand(),
            UiSpacer.horizontalSpace(space: 10),
            VStack(
              [
                'Status'.text.semiBold.make(),
                (controller.userData.value.ijazah?.id == null
                        ? 'Tidak ada file'
                        : controller.userData.value.ijazah?.status?.name ?? '-')
                    .text
                    .semiBold
                    .white
                    .sm
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            )
                .box
                .p8
                .roundedSM
                .color(
                    controller.userData.value.ijazah?.status?.statusColor() ??
                        Colors.grey)
                .make()
                .onInkTap(controller.userData.value.ijazah?.id == null
                    ? null
                    : () => controller.playerData.openFileScreening(
                        controller.userData.value.ijazah?.file)),
          ]),
        UiSpacer.verticalSpace(),
        HStack([
          FileForm(
            label: 'Raport',
            onTap: controller.playerData.selectRaport,
            selectedFile: controller.playerData.raport.value,
          ).expand(),
          UiSpacer.horizontalSpace(space: 10),
          VStack(
            [
              'Status'.text.semiBold.make(),
              (controller.userData.value.raport?.id == null
                      ? 'Tidak ada file'
                      : controller.userData.value.raport?.status?.name ?? '-')
                  .text
                  .semiBold
                  .white
                  .sm
                  .make(),
            ],
            crossAlignment: CrossAxisAlignment.center,
          )
              .box
              .p8
              .roundedSM
              .color(controller.userData.value.raport?.status?.statusColor() ??
                  Colors.grey)
              .make()
              .onInkTap(controller.userData.value.raport?.id == null
                  ? null
                  : () => controller.playerData.openFileScreening(
                      controller.userData.value.raport?.file)),
        ]),
        UiSpacer.verticalSpace(space: 40),
      ]).p12().scrollVertical(),
    );
  }
}
