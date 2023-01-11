import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/nationality.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/profile/club/club_personal_data.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_personal_data.dart';
import 'package:mobile_pssi/ui/profile/controller/personal_data.controller.dart';
import 'package:mobile_pssi/ui/profile/parts/profile.header_edit.dart';
import 'package:mobile_pssi/ui/profile/player/player_personal_data.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class PersonalData extends GetView<PersonalDataController> {
  static const routeName = '/profile/personal';
  const PersonalData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PersonalDataController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Data Pribadi'.text.make(),
      resizeToAvoidBottomInset: false,
      actions: [
        Obx(
          () => controller.logoutBtn.value == true
              ? IconButton(
                  onPressed: controller.logout,
                  icon: const Icon(Icons.logout_rounded))
              : UiSpacer.emptySpace(),
        ),
      ],
      body: Form(
        key: controller.formKey,
        child: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.getProfile,
          child: Obx(() {
            if (controller.userData.value.isPlayer) {
              return const PlayerPersonalData();
            } else if (controller.userData.value.isCoach) {
              return const CoachPersonalData();
            } else if (controller.userData.value.isClub) {
              return const ClubPersonalData();
            } else {
              return VStack([
                VStack([
                  MaterialBanner(
                      content:
                          'Apakah saya sudah terverifikasi oleh ${F.title}.'
                              .text
                              .sm
                              .make(),
                      actions: [
                        IconButton(
                          onPressed: null,
                          icon: Icon(
                              controller.userData.value.ktp?.id == null ||
                                      controller.userData.value.ktp?.id == 2
                                  ? Icons.close
                                  : Icons.check,
                              color:
                                  controller.userData.value.ktp?.id == null ||
                                          controller.userData.value.ktp?.id == 2
                                      ? Colors.red
                                      : Colors.green),
                        )
                      ]),
                  UiSpacer.verticalSpace(),
                ]),
                const ProfileHeaderEdit(),
                UiSpacer.verticalSpace(space: 40),
                'Informasi Data Diri'.text.semiBold.xl.make(),
                UiSpacer.verticalSpace(),
                (controller.userData.value.isClub
                        ? 'Nama Club'
                        : 'Nama Lengkap')
                    .text
                    .semiBold
                    .lg
                    .make(),
                TextFormField(
                  controller: controller.fullname,
                  validator:
                      ValidationBuilder(localeName: 'id').required().build(),
                  decoration: InputDecoration(
                    hintText: controller.profile.value.name ?? 'Belum Diisi',
                  ),
                ),
                if (!controller.userData.value.isClub)
                  VStack([
                    UiSpacer.verticalSpace(),
                    'Jenis Kelamin'.text.semiBold.lg.make(),
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
                      hint: (controller.profile.value.gender?.name ??
                              'Belum Diisi')
                          .text
                          .make(),
                      isExpanded: true,
                      onChanged: (Gender? gender) => controller.selectGender(gender),
                    ),
                  ]),
                UiSpacer.verticalSpace(),
                'Tanggal Lahir'.text.semiBold.lg.make(),
                TextFormField(
                  controller: controller.birthDate,
                  readOnly: true,
                  validator:
                      ValidationBuilder(localeName: 'id').required().build(),
                  decoration: InputDecoration(
                    hintText:
                        controller.profile.value.dateOfBirth ?? 'Belum Diisi',
                  ),
                  onTap: () => controller.openDateBirth(context),
                ),
                UiSpacer.verticalSpace(),
                'Nomor Telepon'.text.semiBold.lg.make(),
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: ValidationBuilder(localeName: 'id')
                      .required()
                      .phone()
                      .build(),
                  decoration: InputDecoration(
                    prefixText: '+62',
                    hintText:
                        controller.profile.value.phoneNumber ?? 'Belum Diisi',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                UiSpacer.verticalSpace(),
                'Email'.text.semiBold.lg.make(),
                TextFormField(
                  controller: controller.email,
                  validator: ValidationBuilder(localeName: 'id')
                      .required()
                      .email()
                      .build(),
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: controller.userData.value.email ?? 'Belum Diisi',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                UiSpacer.verticalSpace(),
                if (!controller.userData.value.isClub)
                  VStack([
                    'NIK'.text.semiBold.lg.make(),
                    TextFormField(
                      controller: controller.nik,
                      validator: ValidationBuilder(localeName: 'id')
                          .required()
                          .build(),
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
                                  : controller
                                          .userData.value.ktp?.status?.name ??
                                      '-')
                              .text
                              .color(controller.userData.value.ktp?.status
                                  ?.statusColor())
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
                                  imageUrl: controller.userData.value.ktp!.file
                                      .toString(),
                                ).h(200).cornerRadius(10).centered(),
                          UiSpacer.verticalSpace(space: 10),
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
                                  color: primaryColor)
                              .make(),
                        ]),
                      ),
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
                          hintStyle:
                              controller.profile.value.nationality == null
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
                      hint: (controller.profile.value.nationality?.name ??
                              'Belum Diisi')
                          .text
                          .make(),
                      isExpanded: true,
                      onChanged: (Nationality? nationality) =>
                              controller.selectNationality(nationality),
                    ),
                  ]),
                UiSpacer.verticalSpace(),
                'Alamat'.text.semiBold.lg.make(),
                TextFormField(
                  validator:
                      ValidationBuilder(localeName: 'id').required().build(),
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
                  validator:
                      ValidationBuilder(localeName: 'id').required().build(),
                  controller: controller.cityTx,
                  style: const TextStyle(
                    color: primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        controller.profile.value.city?.name ?? 'Belum Diisi',
                  ),
                  readOnly: true,
                  onTap: controller.showCityDialog,
                ),
                UiSpacer.verticalSpace(space: 40),
              ]).p12().scrollVertical();
            }
          }),
        ),
      ),
      bottomNavigationBar: 'Simpan Data'
              .text
              .white
              .semiBold
              .makeCentered()
              .continuousRectangle(height: 40, backgroundColor: primaryColor)
              .onTap(controller.saveData)
              .marginAll(20),
    );
  }
}
