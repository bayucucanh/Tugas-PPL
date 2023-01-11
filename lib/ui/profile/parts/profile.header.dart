import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileHeader extends GetView<PersonalDataController> {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        CachedNetworkImage(
          imageUrl: controller.profile.value.photo == null
              ? controller.userData.value.gravatar()
              : controller.profile.value.photo.toString(),
          fit: BoxFit.cover,
        ).cornerRadius(100).wh(100, 100).centered(),
        UiSpacer.verticalSpace(),
        (controller.profile.value.name ?? '-').text.semiBold.lg.makeCentered(),
        (controller.userData.value.phoneNumber ?? '-')
            .text
            .gray500
            .makeCentered(),
        (controller.userData.value.email ?? '-').text.gray500.makeCentered(),
        UiSpacer.verticalSpace(space: 10),
        if (controller.completeData != true)
          '*Silahkan Lengkapi Data Diri yang belum Terisi!'
              .text
              .sm
              .red500
              .makeCentered(),
      ]),
    );
  }
}
