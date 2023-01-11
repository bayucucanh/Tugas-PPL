import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class OtherDataTab extends GetView<PersonalDataController> {
  const OtherDataTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        'Website'.text.semiBold.lg.make(),
        TextFormField(
          validator: ValidationBuilder(localeName: 'id').url().build(),
          controller: controller.playerData.website,
          style: const TextStyle(
            color: primaryColor,
            fontStyle: FontStyle.italic,
          ),
          decoration: InputDecoration(
            hintText: controller.profile.value.website == null
                ? 'Belum Diisi'
                : controller.profile.value.website?.toString(),
          ),
          keyboardType: TextInputType.url,
        ),
      ]).p12().scrollVertical(),
    );
  }
}
