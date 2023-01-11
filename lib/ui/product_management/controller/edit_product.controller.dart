import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/duration_name.dart';
import 'package:mobile_pssi/data/model/product.dart';
import 'package:mobile_pssi/data/requests/product.request.dart';
import 'package:mobile_pssi/extensions/tax.extension.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class EditProductController extends BaseController {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    turnOffGrouping: true,
    decimalDigits: 0,
    symbol: '',
    name: 'IDR',
  );
  final CurrencyTextInputFormatter _displayCurrency =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );
  final formKey = GlobalKey<FormState>();
  final _productRequest = ProductRequest();
  final _product = Product().obs;
  final name = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final duration = TextEditingController();
  final units = <DurationName>[
    DurationName(name: 'Hari', value: 'day'),
    DurationName(name: 'Bulan', value: 'month'),
    DurationName(name: 'Tahun', value: 'year'),
  ];
  final _selectedUnit = DurationName().obs;
  final isUploading = false.obs;
  final _priceWithTax = 0.0.obs;

  EditProductController() {
    _product(Product.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() {
    name.text = _product.value.name ?? '';
    description.text = _product.value.description ?? '';
    price.text = _product.value.priceFormat ?? '';
    duration.text = _product.value.value.toString();
    _previewPriceTax(_product.value.price);
    selectUnit(units
        .firstWhereOrNull((element) => element.value == _product.value.unit));
  }

  _previewPriceTax(double? price) {
    _priceWithTax(price?.addPriceTax() ?? 0.0);
  }

  onChangePrice(String value) {
    if (price.text.isNotEmpty) {
      _priceWithTax(double.parse(_currencyFormatter.format(price.text)));
      _previewPriceTax(_priceWithTax.value);
    }
  }

  selectUnit(DurationName? unit) {
    _selectedUnit(unit);
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        isUploading(true);
        await _productRequest.update(
          id: _product.value.id!,
          name: name.text,
          description: description.text,
          duration: int.parse(duration.text),
          price: double.parse(_currencyFormatter.format(price.text)),
          unit: _selectedUnit.value.value,
        );
        isUploading(false);
        EasyLoading.dismiss();

        Get.back(result: 'success');
      }
    } catch (e) {
      isUploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  Product? get product => _product.value;
  DurationName? get selectedUnit => _selectedUnit.value;
  String? get priceWithTax {
    return _displayCurrency.format(_priceWithTax.toStringAsFixed(0));
  }
}
