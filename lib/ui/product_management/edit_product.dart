import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/product_management/controller/edit_product.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProduct extends GetView<EditProductController> {
  static const routeName = '/products/edit';
  const EditProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EditProductController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: 'Ubah Produk'.text.make(),
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
                hintText: 'Deskripsi Produk',
                labelText: 'Deskripsi Produk',
              ),
              minLines: 5,
              maxLines: 5,
            ),
            TextFormField(
              controller: controller.price,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: InputDecoration(
                hintText: 'Harga',
                labelText: 'Harga',
                helperText:
                    'Harga termasuk pajak 11% : ${controller.priceWithTax ?? ''}',
              ),
              onChanged: controller.onChangePrice,
              textAlign: TextAlign.end,
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
                controller: controller.duration,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Durasi',
                  labelText: 'Durasi',
                ),
              ).expand(),
              UiSpacer.horizontalSpace(),
              DropdownButtonFormField(
                items: controller.units
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: (e.name ?? '-').text.make(),
                        ))
                    .toList(),
                onChanged: controller.selectUnit,
                decoration: InputDecoration(
                  hintText: controller.selectedUnit?.name ?? 'Unit',
                ),
              ).expand(),
            ]),
          ]).p12(),
        ),
      ),
    );
  }
}
