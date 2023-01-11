import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileHeaderEdit extends GetView<PersonalDataController> {
  const ProfileHeaderEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        controller.photo.value.name == null
            ? CachedNetworkImage(
                imageUrl: controller.profile.value.photo == null
                    ? controller.userData.value.gravatar()
                    : controller.profile.value.photo.toString(),
                fit: BoxFit.cover,
              ).cornerRadius(100).wh(100, 100).centered()
            : Image.file(
                controller.photo.value.toFile,
                fit: BoxFit.cover,
              ).cornerRadius(100).wh(100, 100).centered(),
        UiSpacer.verticalSpace(),
        'Ganti Foto'.text.semiBold.lg.underline.makeCentered(),
      ]).onTap(controller.selectPhoto),
    );
  }
}
