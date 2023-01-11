import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/voucher/controller/add_voucher.controller.dart';
import 'package:mobile_pssi/utils/rules.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddVoucher extends GetView<AddVoucherController> {
  static const routeName = '/voucher/add';
  const AddVoucher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddVoucherController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Voucher Baru'.text.make(),
      resizeToAvoidBottomInset: false,
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.isUploading.value ? null : controller.save,
            child: 'Simpan'.text.make(),
          ),
        ),
      ],
      body: Form(
        key: controller.formKey,
        child: VStack([
          TextFormField(
            controller: controller.name,
            decoration: const InputDecoration(
              hintText: 'Nama Voucher',
              labelText: 'Nama Voucher',
            ),
            validator: (value) {
              return FormRules.validate(rules: [
                'required',
              ], value: value);
            },
          ),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.description,
            decoration: const InputDecoration(
              hintText: 'Deskripsi Voucher',
              labelText: 'Deskripsi Voucher',
            ),
            minLines: 3,
            maxLines: 3,
            maxLength: 150,
          ),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.code,
            decoration: InputDecoration(
                hintText: 'Kode Voucher',
                labelText: 'Kode Voucher',
                suffixIcon: IconButton(
                    onPressed: controller.generateCode,
                    icon: const Icon(Icons.generating_tokens_rounded))),
            maxLength: 8,
            validator: (value) {
              return FormRules.validate(rules: [
                'required',
              ], value: value);
            },
          ),
          TextFormField(
            controller: controller.voucherValue,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Nilai Voucher',
              labelText: 'Nilai Voucher',
              prefixText: controller.isPercentage.value ? null : 'Rp.',
              suffixText: controller.isPercentage.value ? '%' : null,
            ),
            textAlign: controller.isPercentage.value
                ? TextAlign.right
                : TextAlign.left,
            textInputAction: TextInputAction.done,
            validator: (value) {
              return FormRules.validate(rules: [
                'required',
              ], value: value);
            },
          ),
          UiSpacer.verticalSpace(),
          ExpansionTile(
            title: 'Pengaturan Tambahan'.text.make(),
            initiallyExpanded: true,
            tilePadding: EdgeInsets.zero,
            onExpansionChanged: controller.onExpansionChanged,
            children: [
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: 'Pilih Peruntukan',
                ),
                items: controller.targets
                    .map((target) => DropdownMenuItem(
                        value: target, child: (target.name ?? '-').text.make()))
                    .toList(),
                onChanged: controller.selectTarget,
              ),
              TextFormField(
                controller: controller.validFrom,
                keyboardType: TextInputType.datetime,
                onTap: controller.openValidDate,
                decoration: const InputDecoration(
                  hintText: 'Mulai valid',
                  labelText: 'Mulai valid',
                ),
                readOnly: true,
                textInputAction: TextInputAction.done,
              ),
              TextFormField(
                controller: controller.expired,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  hintText: 'Tanggal Kadaluarsa',
                  labelText: 'Tanggal Kadaluarsa',
                ),
                onTap: controller.openExpiredDate,
                readOnly: true,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ]).p12().scrollVertical(),
      ),
    );
  }
}
