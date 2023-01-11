import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/nationality.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:mobile_pssi/ui/profile/parts/profile.header_edit.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class PersonalDataTab extends GetView<PersonalDataController> {
  const PersonalDataTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => VStack([
        const ProfileHeaderEdit(),
        UiSpacer.verticalSpace(space: 40),
        'Informasi Data Diri'.text.semiBold.xl.make(),
        UiSpacer.verticalSpace(),
        HStack([
          '*'.text.red400.make(),
          UiSpacer.horizontalSpace(space: 5),
          (controller.userData.value.isClub ? 'Nama Klub' : 'Nama Lengkap')
              .text
              .semiBold
              .lg
              .make()
        ]),
        TextFormField(
          controller: controller.fullname,
          validator: ValidationBuilder(localeName: 'id').required().build(),
          decoration: InputDecoration(
            hintText: controller.profile.value.name ?? 'Belum Diisi',
          ),
        ),
        UiSpacer.verticalSpace(),
        if (!controller.userData.value.isClub)
          VStack([
            HStack([
              '*'.text.red400.make(),
              UiSpacer.horizontalSpace(space: 5),
              'Jenis Kelamin'.text.semiBold.lg.make(),
            ]),
            DropdownButtonFormField(
              validator: (Gender? gender) {
                if (controller.selectedGender.value.id == null) {
                  return 'Masukan tidak boleh kosong.';
                }
                return null;
              },
              decoration: InputDecoration(
                  hintStyle: controller.profile.value.gender == null
                      ? const TextStyle(
                          color: primaryColor,
                          fontStyle: FontStyle.italic,
                        )
                      : null),
              items: controller.genders
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: (gender.name ?? '-').text.make(),
                      ))
                  .toList(),
              hint: (controller.profile.value.gender?.name ?? 'Belum Diisi')
                  .text
                  .make(),
              isExpanded: true,
              onChanged: (Gender? gender) => controller.selectGender(gender),
            ),
            UiSpacer.verticalSpace(),
          ]),
        HStack([
          '*'.text.red400.make(),
          UiSpacer.horizontalSpace(space: 5),
          'Tanggal Lahir'.text.semiBold.lg.make(),
        ]),
        TextFormField(
            controller: controller.birthDate,
            readOnly: true,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: InputDecoration(
              hintText: controller.profile.value.dateOfBirth ?? 'Belum Diisi',
            ),
            onTap: () => controller.openDateBirth(context)),
        UiSpacer.verticalSpace(),
        'Nomor Telepon'.text.semiBold.lg.make(),
        TextFormField(
          controller: controller.phoneNumber,
          validator:
              ValidationBuilder(localeName: 'id').required().phone().build(),
          decoration: InputDecoration(
            prefixText: '+62',
            hintText: controller.profile.value.phoneNumber ?? 'Belum Diisi',
          ),
          keyboardType: TextInputType.phone,
        ),
        UiSpacer.verticalSpace(),
        'Email'.text.semiBold.lg.make(),
        TextFormField(
          controller: controller.email,
          validator:
              ValidationBuilder(localeName: 'id').required().email().build(),
          enabled: false,
          decoration: InputDecoration(
            hintText: controller.userData.value.email ?? 'Belum Diisi',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        UiSpacer.verticalSpace(),
        'Kewarganegaraan'.text.semiBold.lg.make(),
        DropdownButtonFormField(
            validator: (Nationality? nationality) {
              if (controller.selectedNationality.value.id == null) {
                return 'Masukan tidak boleh kosong.';
              }
              return null;
            },
            decoration: InputDecoration(
                hintStyle: controller.profile.value.nationality == null
                    ? const TextStyle(
                        color: primaryColor,
                        fontStyle: FontStyle.italic,
                      )
                    : null),
            items: controller.nationalities.value.data
                ?.map((nationality) => DropdownMenuItem(
                      value: nationality,
                      child: (nationality.name ?? '-').text.make(),
                    ))
                .toList(),
            hint: (controller.profile.value.nationality?.name ?? 'Belum Diisi')
                .text
                .make(),
            isExpanded: true,
            onChanged: (Nationality? nationality) =>
                controller.selectNationality(nationality)),
        if (controller.userData.value.isCoach)
          Obx(
            () => VStack([
              UiSpacer.verticalSpace(),
              'Spesialis'.text.semiBold.lg.make(),
              (controller.userData.value.specialists
                          ?.map((e) => (e.name ?? '-')) ??
                      [])
                  .join(', ')
                  .text
                  .make(),
              MultiSelectDialogField(
                onConfirm: controller.coachData.selectSpecialist,
                validator: (values) {
                  if (values?.isEmpty == true) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
                title: const Text('Pilih Spesialis'),
                listType: MultiSelectListType.CHIP,
                selectedColor: primaryColor,
                searchable: true,
                selectedItemsTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                initialValue: controller.userData.value.specialists,
                items: controller.coachData.specialists!
                    .map((e) => MultiSelectItem(e, e.name ?? '-'))
                    .toList(),
              ),
            ]),
          ),
        UiSpacer.verticalSpace(),
        'Alamat'.text.semiBold.lg.make(),
        TextFormField(
          validator: ValidationBuilder(localeName: 'id').required().build(),
          controller: controller.address,
          style: const TextStyle(
            color: primaryColor,
            fontStyle: FontStyle.italic,
          ),
          decoration: InputDecoration(
            hintText: controller.profile.value.address ?? 'Belum Diisi',
          ),
        ),
        UiSpacer.verticalSpace(),
        'Kota'.text.semiBold.lg.make(),
        TextFormField(
          validator: ValidationBuilder(localeName: 'id').required().build(),
          controller: controller.cityTx,
          style: const TextStyle(
            color: primaryColor,
            fontStyle: FontStyle.italic,
          ),
          decoration: InputDecoration(
            hintText: controller.profile.value.city?.name ?? 'Belum Diisi',
          ),
          readOnly: true,
          onTap: controller.showCityDialog,
        ),
        UiSpacer.verticalSpace(space: 40),
      ]).p12().scrollVertical(),
    );
  }
}
