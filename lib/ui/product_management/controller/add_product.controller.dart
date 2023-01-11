import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/subscribe_unit.dart';
import 'package:mobile_pssi/data/requests/product.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AddProductController extends BaseController {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    turnOffGrouping: true,
    decimalDigits: 0,
    symbol: '',
    name: 'IDR',
  );
  final formKey = GlobalKey<FormState>();
  final _productRequest = ProductRequest();
  final name = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final isUploading = false.obs;
  final units = <SubscribeUnit>[
    SubscribeUnit(id: 'month', name: 'Bulan'),
    SubscribeUnit(id: 'year', name: 'Tahun'),
  ].obs;
  final selectedUnit = SubscribeUnit().obs;
  final unitValue = TextEditingController();

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        isUploading(true);
        await _productRequest.create(
          productId: name.text,
          productName: name.text,
          description: description.text,
          price: double.parse(_currencyFormatter.format(price.text)),
          type: 1,
          unit: selectedUnit.value.id,
          value: int.tryParse(unitValue.text),
        );
        isUploading(false);
        EasyLoading.dismiss();

        Get.back(result: 'success');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  selectUnit(SubscribeUnit? unit) {
    selectedUnit(unit);
  }
}
