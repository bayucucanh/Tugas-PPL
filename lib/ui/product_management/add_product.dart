import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/product_management/controller/add_product.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddProduct extends GetView<AddProductController> {
  static const routeName = '/products/add';
  const AddProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddProductController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tambah Produk'.text.make(),
      actions: [
        TextButton(
          onPressed: controller.isUploading.value ? null : controller.save,
          child: 'Simpan'.text.make(),
        )
      ],
      body: Form(
        key: controller.formKey,
        child: VStack([
          TextFormField(
            controller: controller.name,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: 'Nama Produk',
              labelText: 'Nama Produk',
            ),
          ),
          TextFormField(
            controller: controller.description,
            decoration: const InputDecoration(
              hintText: 'Deskripsi',
              labelText: 'Deskripsi',
            ),
            minLines: 5,
            maxLines: 5,
          ),
          TextFormField(
            controller: controller.price,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: 'Harga',
              labelText: 'Harga',
            ),
            inputFormatters: [
              CurrencyTextInputFormatter(
                symbol: 'Rp',
                locale: 'id',
                decimalDigits: 0,
              ),
            ],
            keyboardType: const TextInputType.numberWithOptions(signed: true),
          ),
          HStack([
            TextFormField(
              controller: controller.unitValue,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Jumlah',
                labelText: 'Jumlah',
              ),
              keyboardType: const TextInputType.numberWithOptions(signed: true),
            ).expand(),
            UiSpacer.horizontalSpace(space: 16),
            DropdownButtonFormField(
              isExpanded: true,
              validator: (value) {
                if (controller.selectedUnit.value.isBlank == true) {
                  return 'Tidak boleh kosong.';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Unit',
                labelText: 'Unit',
              ),
              items: controller.units
                  .map((unit) => DropdownMenuItem(
                        value: unit,
                        child: (unit.name ?? '-').text.make(),
                      ))
                  .toList(),
              onChanged: controller.selectUnit,
            ).expand(),
          ]),
        ]).p12().scrollVertical(),
      ),
    );
  }
}
