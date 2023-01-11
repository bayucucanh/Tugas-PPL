import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/new_student_form/new_student_form.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AdditionalFields extends StatelessWidget {
  final AdditionalFieldForm additionalField;
  final Function()? deleteField;
  const AdditionalFields({
    Key? key,
    required this.additionalField,
    this.deleteField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HStack([
      TextFormField(
        controller: additionalField.fieldName,
        validator: ValidationBuilder(localeName: 'id').required().build(),
        decoration: const InputDecoration(
          hintText: 'Nama Biaya',
          labelText: 'Nama Biaya',
        ),
      ).expand(),
      UiSpacer.horizontalSpace(),
      TextFormField(
        controller: additionalField.fieldValue,
        inputFormatters: [
          CurrencyTextInputFormatter(
            symbol: 'Rp',
            locale: 'id',
            decimalDigits: 0,
          ),
        ],
        validator: ValidationBuilder(localeName: 'id').required().build(),
        decoration: const InputDecoration(
          hintText: 'Jumlah Biaya',
          labelText: 'Jumlah Biaya',
        ),
        keyboardType: TextInputType.number,
      ).expand(),
      IconButton(
          onPressed: deleteField,
          icon: const Icon(Icons.delete_forever_rounded))
    ]);
  }
}
