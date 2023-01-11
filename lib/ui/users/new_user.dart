import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/users/controller/new_user.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class NewUser extends GetView<NewUserController> {
  static const routeName = '/users/new';
  const NewUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NewUserController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Pengguna Baru'.text.make(),
      resizeToAvoidBottomInset: false,
      actions: [
        TextButton(
          onPressed: controller.createAccount,
          child: 'Buat Akun'.text.make(),
        ),
      ],
      body: Obx(
        () => Form(
          key: controller.formKey,
          child: VStack([
            'Tipe Akun'.text.semiBold.lg.make(),
            'Tipe akun diperuntukan untuk memilih pengguna apa yang akan dibuat.\nCatatan: Tipe pengguna karyawan dapat memiliki banyak akses.'
                .text
                .sm
                .gray500
                .make(),
            DropdownButtonFormField(
              validator: (value) {
                if (controller.selectedUserType.value.id == null) {
                  return 'Harus pilih salah satu';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Pilih Tipe Pengguna',
                labelText: 'Pilih Tipe Pengguna',
              ),
              items: controller.userTypes
                  .map((userType) => DropdownMenuItem(
                        value: userType,
                        child: (userType.name ?? '-').text.make(),
                      ))
                  .toList(),
              onChanged: controller.selectUserType,
            ),
            if (controller.selectedUserType.value.id == 1)
              MultiSelectDialogField(
                onConfirm: controller.selectAccess,
                validator: (values) {
                  if (controller.selectedRoles.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
                buttonText: const Text('Pilih Hak Akses'),
                title: const Text('Pilih Hak Akses'),
                listType: MultiSelectListType.CHIP,
                selectedColor: primaryColor,
                searchable: true,
                selectedItemsTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                items: controller.roles!
                    .map((e) => MultiSelectItem(e, e.name ?? '-'))
                    .toList(),
              ),
            UiSpacer.verticalSpace(),
            'Data Pengguna'.text.semiBold.lg.make(),
            TextFormField(
              controller: controller.username,
              maxLength: 20,
              validator:
                  ValidationBuilder(localeName: 'id').minLength(6).build(),
              decoration: const InputDecoration(
                hintText: 'Username',
                labelText: 'Username',
              ),
            ),
            TextFormField(
              controller: controller.email,
              validator: ValidationBuilder(localeName: 'id').email().build(),
              decoration: const InputDecoration(
                hintText: 'E-mail',
                labelText: 'E-mail',
              ),
            ),
            TextFormField(
              controller: controller.phoneNumber,
              validator: ValidationBuilder(localeName: 'id').phone().build(),
              decoration: const InputDecoration(
                hintText: 'Nomor Handphone',
                labelText: 'Nomor Handphone',
              ),
            ),
            UiSpacer.verticalSpace(space: 15),
            ElevatedButton(
              onPressed: controller.generatePasswordButton,
              child: 'Generate Kata Sandi'.text.make(),
            ).objectCenterRight(),
            TextFormField(
              controller: controller.password,
              validator:
                  ValidationBuilder(localeName: 'id').minLength(8).build(),
              decoration: const InputDecoration(
                hintText: 'Kata Sandi',
                labelText: 'Kata Sandi',
              ),
            ),
            TextFormField(
              controller: controller.rePassword,
              validator:
                  ValidationBuilder(localeName: 'id').minLength(8).build(),
              decoration: const InputDecoration(
                hintText: 'Ulangi Kata Sandi',
                labelText: 'Ulangi Kata Sandi',
              ),
            ),
            UiSpacer.verticalSpace(),
            'Biodata'.text.semiBold.xl.make(),
            TextFormField(
              controller: controller.name,
              validator: (value) {
                if (value.isEmptyOrNull) {
                  return 'Masukan tidak boleh kosong';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Nama Lengkap',
                labelText: 'Nama Lengkap',
              ),
            ),
            TextFormField(
              controller: controller.birthOfDate,
              validator: (value) {
                if (value.isEmptyOrNull) {
                  return 'Masukan tidak boleh kosong';
                }
                return null;
              },
              readOnly: true,
              onTap: controller.selectDate,
              decoration: const InputDecoration(
                hintText: 'Tanggal Lahir',
                labelText: 'Tanggal Lahir',
              ),
            ),
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
