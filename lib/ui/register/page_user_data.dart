import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/styles.dart';
import 'package:mobile_pssi/ui/register/controller/register_controller.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:velocity_x/velocity_x.dart';

class PageUserData extends GetView<RegisterController> {
  const PageUserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack(
        [
          controller.selectedFile.value == true
              ? CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundImage: FileImage(File(controller.pic!.path)),
                ).wh(150, 150)
              : const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person_sharp,
                    color: Colors.white,
                    size: 120,
                  ),
                ).wh(150, 150),
          (controller.selectedFile.value == false
                  ? "add_photo".tr
                  : "replace_photo".tr)
              .text
              .textStyle(registerCaptionUnderlineStyles)
              .make()
              .onTap(controller.openPictureDialog)
              .p8(),
          Form(
            key: controller.formKeyUserData,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                      'Nama Lengkap ${controller.selectedUserType.value.name?.capitalize}',
                      textAlign: TextAlign.left,
                      style: loginTitleFontTextStyles),
                  TextFormComponent(
                    label:
                        'Nama Lengkap ${controller.selectedUserType.value.name?.capitalize}',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    controller: controller.fullNameController,
                    validator: (value) =>
                        value!.isBlank! ? 'fill_out_field'.tr : null,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text('Tanggal Lahir',
                      textAlign: TextAlign.left,
                      style: loginTitleFontTextStyles),
                  TextFormComponent(
                    label: controller.df.format(controller.selectedDate.value),
                    controller: controller.birthDateController,
                    onTap: () => controller.selectDate(),
                    textInputAction: TextInputAction.next,
                    showCursor: false,
                    readOnly: true,
                    suffixIcon: const Icon(Icons.date_range_sharp),
                    validator: (value) =>
                        value!.isBlank! ? 'fill_out_field'.tr : null,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text('No. Telepon Aktif',
                      textAlign: TextAlign.left,
                      style: loginTitleFontTextStyles),
                  TextFormComponent(
                    label: '08xxx',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: controller.phoneNumberController,
                    validator: (value) =>
                        value!.isBlank! ? 'fill_out_field'.tr : null,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text('Email',
                      textAlign: TextAlign.left,
                      style: loginTitleFontTextStyles),
                  TextFormComponent(
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: controller.emailController,
                    validator: (value) =>
                        value!.isBlank! ? 'fill_out_field'.tr : null,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          )
        ],
        alignment: MainAxisAlignment.start,
        crossAlignment: CrossAxisAlignment.center,
      ).scrollVertical(),
    );
  }
}
