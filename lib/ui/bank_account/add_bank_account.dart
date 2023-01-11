import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/bank_account/controller/add_bank_account.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class AddBankAccount extends GetView<AddBankAccountController> {
  static const routeName = '/bank-accounts/new';
  const AddBankAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddBankAccountController());
    return DefaultScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tambah Rekening'.text.make(),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.uploading.value ? null : controller.upload,
            child: 'Simpan'.text.make(),
          ),
        ),
      ],
      body: Form(
        key: controller.formKey,
        child: VStack(
          [
            TextFormField(
              validator: ValidationBuilder(localeName: 'id').required().build(),
              controller: controller.accountNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Nomor Rekening ', labelText: 'Nomor Rekening'),
            ),
            Obx(
              () => DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: 'Pilih Bank',
                  labelText: 'Pilih Bank',
                ),
                items: controller.banks
                    ?.map((e) => DropdownMenuItem(
                          value: e,
                          child: (e.bankName ?? '-').text.make(),
                        ))
                    .toList(),
                onChanged: controller.selectBank,
                isExpanded: true,
              ),
            ),
          ],
        ),
      ).p12(),
    );
  }
}
