import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/transfer_market/controller/add_promo.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class NewSelectionForm extends GetView<AddPromoController> {
  const NewSelectionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: controller.selectionFormKey,
        child: VStack([
          'Informasi Seleksi'.text.semiBold.lg.make(),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.selectionForm.location,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: 'Lokasi Trial',
              labelText: 'Lokasi Trial',
            ),
          ),
          TextFormField(
            controller: controller.selectionForm.address,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: 'Alamat',
              labelText: 'Alamat',
            ),
          ),
          HStack([
            TextFormField(
              readOnly: true,
              controller: controller.selectionForm.startDate,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'dd/MM/yyyy',
                labelText: 'Tanggal Mulai',
              ),
              onTap: () => controller.selectionForm.selectRangeDate(context),
            ).expand(),
            UiSpacer.horizontalSpace(),
            TextFormField(
              readOnly: true,
              controller: controller.selectionForm.endDate,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'dd/MM/yyyy',
                labelText: 'Tanggal Selesai',
              ),
              onTap: () => controller.selectionForm.selectRangeDate(context),
            ).expand(),
          ]),
          HStack(
            [
              TextFormField(
                controller: controller.selectionForm.startTime,
                validator:
                    ValidationBuilder(localeName: 'id').required().build(),
                decoration: const InputDecoration(
                  hintText: 'hh:mm',
                  labelText: 'Waktu Mulai',
                ),
                readOnly: true,
                onTap: () => controller.selectionForm.selectTimeRange(context),
              ).expand(),
              UiSpacer.horizontalSpace(),
              TextFormField(
                controller: controller.selectionForm.endTime,
                validator:
                    ValidationBuilder(localeName: 'id').required().build(),
                decoration: const InputDecoration(
                  hintText: 'hh:mm',
                  labelText: 'Waktu Selesai',
                ),
                readOnly: true,
                onTap: () => controller.selectionForm.selectTimeRange(context),
              ).expand(),
            ],
            alignment: MainAxisAlignment.spaceEvenly,
          ),
          UiSpacer.verticalSpace(),
          'Informasi Kebutuhan'.text.semiBold.lg.make(),
          UiSpacer.verticalSpace(),
          TextFormField(
            controller: controller.selectionForm.birthYears,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: '2003, 2004, 2005',
              labelText: 'Tahun Kelahiran',
            ),
          ),
          TextFormField(
            controller: controller.selectionForm.competition,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: 'Kompetisi',
              labelText: 'Kompetisi',
            ),
          ),
          TextFormField(
            controller: controller.selectionForm.passQuota,
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: '0',
              labelText: 'Kuota Lolos',
            ),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: controller.selectionForm.selectionFee,
            inputFormatters: [
              CurrencyTextInputFormatter(
                symbol: 'Rp',
                locale: 'id',
                decimalDigits: 0,
              ),
            ],
            decoration: const InputDecoration(
              hintText: 'Kosongkan untuk tidak ada biaya seleksi',
              labelText: 'Biaya Seleksi',
            ),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: controller.selectionForm.notes,
            decoration: const InputDecoration(
              hintText: 'Catatan',
              labelText: 'Catatan',
            ),
            minLines: 5,
            maxLines: 5,
          ),
          TextFormField(
            controller: controller.selectionForm.fee,
            inputFormatters: [
              CurrencyTextInputFormatter(
                symbol: 'Rp',
                locale: 'id',
                decimalDigits: 0,
              ),
            ],
            validator: ValidationBuilder(localeName: 'id').required().build(),
            decoration: const InputDecoration(
              hintText: '0',
              labelText: 'Biaya Tambahan',
            ),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            controller: controller.selectionForm.formQuota,
            decoration: const InputDecoration(
              hintText: 'Kosongkan Untuk Tidak Terbatas',
              labelText: 'Kuota Peserta',
            ),
            keyboardType: TextInputType.number,
          ),
          UiSpacer.verticalSpace(space: 20),
        ]).p12().scrollVertical().safeArea(),
      ),
      persistentFooterButtons: [
        controller.uploading.value
            ? const CircularProgressIndicator().centered()
            : 'Buat Promo'
                .text
                .white
                .makeCentered()
                .continuousRectangle(
                  height: 40,
                  backgroundColor: primaryColor,
                )
                .onTap(controller.createPromo),
      ],
    );
  }
}
