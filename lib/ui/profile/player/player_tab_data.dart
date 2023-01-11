import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/dominant_foot.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerTabData extends GetView<PersonalDataController> {
  const PlayerTabData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack(
        [
          'Tinggi Badan'.text.semiBold.lg.make(),
          TextFormField(
            controller: controller.playerData.height,
            style: const TextStyle(
              color: primaryColor,
              fontStyle: FontStyle.italic,
            ),
            decoration: InputDecoration(
              suffixText: controller.profile.value.height?.unit ?? 'cm',
            ),
            keyboardType: TextInputType.number,
          ),
          UiSpacer.verticalSpace(),
          'Berat Badan'.text.semiBold.lg.make(),
          TextFormField(
            controller: controller.playerData.weight,
            style: const TextStyle(
              color: primaryColor,
              fontStyle: FontStyle.italic,
            ),
            decoration: InputDecoration(
              suffixText: controller.profile.value.weight?.unit ?? 'kg',
            ),
            keyboardType: TextInputType.number,
          ),
          UiSpacer.verticalSpace(),
          'Kaki Dominan'.text.semiBold.lg.make(),
          DropdownButtonFormField(
            decoration: InputDecoration(
                hintStyle: controller.profile.value.dominantFoot == null
                    ? const TextStyle(
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                      )
                    : null),
            items: controller.playerData.dominantFoots
                .map((data) => DropdownMenuItem(
                      value: data,
                      child: (data.name ?? '-').text.make(),
                    ))
                .toList(),
            hint: (controller.profile.value.dominantFoot?.name ?? 'Belum Diisi')
                .text
                .make(),
            isExpanded: true,
            onChanged: (DominantFoot? data) =>
                controller.playerData.selectDominantFoot(data),
          ),
          UiSpacer.verticalSpace(),
          'Posisi Pemain'.text.semiBold.lg.make(),
          DropdownButtonFormField(
            decoration: InputDecoration(
                hintStyle: controller.profile.value.playerPosition == null
                    ? const TextStyle(
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                      )
                    : null),
            items: controller.playerData.positions.value.data!
                .map((data) => DropdownMenuItem(
                      value: data,
                      child: (data.name ?? '-').text.make(),
                    ))
                .toList(),
            hint:
                (controller.profile.value.playerPosition?.name ?? 'Belum Diisi')
                    .text
                    .make(),
            isExpanded: true,
            onChanged: controller.playerData.selectPlayerPosition,
          ),
        ],
      ).p12().scrollVertical(),
    );
  }
}
