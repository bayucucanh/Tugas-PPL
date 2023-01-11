import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class VerificationDataTab extends GetView<PersonalDataController> {
  const VerificationDataTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        'NIK'.text.semiBold.lg.make(),
        TextFormField(
          controller: controller.nik,
          validator: ValidationBuilder(localeName: 'id').required().build(),
          style: const TextStyle(
            color: primaryColor,
            fontStyle: FontStyle.italic,
          ),
          decoration: InputDecoration(
            hintText: controller.profile.value.nik ?? 'Belum Diisi',
          ),
          keyboardType: TextInputType.number,
        ),
        UiSpacer.verticalSpace(),
        HStack([
          'e-KTP'.text.semiBold.lg.make().expand(),
          VStack(
            [
              'Status Verifikasi'.text.semiBold.make(),
              (controller.userData.value.ktp?.id == null
                      ? ''
                      : controller.userData.value.ktp?.status?.name ?? '-')
                  .text
                  .color(controller.userData.value.ktp?.status?.statusColor())
                  .make()
            ],
            crossAlignment: CrossAxisAlignment.center,
          ),
        ]),
        UiSpacer.verticalSpace(space: 10),
        InkWell(
          onTap: controller.userData.value.ktp?.status?.id == 1
                  ? null
                  : controller.selectEktp,
          child: DottedBorder(
            color: primaryColor,
            radius: const Radius.circular(10),
            strokeCap: StrokeCap.butt,
            padding: const EdgeInsets.all(40),
            dashPattern: const [5],
            child: VStack([
              controller.userData.value.ktp?.file == null
                  ? const Icon(
                      Icons.description_rounded,
                      size: 48,
                      color: primaryColor,
                    ).centered()
                  : CachedNetworkImage(
                      imageUrl: controller.userData.value.ktp!.file.toString(),
                    ).h(200).cornerRadius(10).centered(),
              UiSpacer.verticalSpace(space: 10),
              if (controller.userData.value.ktp?.status?.id != 1)
                (controller.ektpSelected.value == false
                        ? 'Upload Disini'
                        : 'File Telah Dipilih')
                    .text
                    .color(primaryColor)
                    .makeCentered()
                    .box
                    .p16
                    .roundedSM
                    .border(
                        color:primaryColor)
                    .make(),
            ]),
          ),
        ),
        UiSpacer.verticalSpace(space: 40),
      ]).p12().scrollVertical(),
    );
  }
}
