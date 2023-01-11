import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/image_upload.dart';
import 'package:mobile_pssi/ui/competitions/controller/add_competition.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class AddCompetition extends GetView<AddCompetitionController> {
  static const routeName = '/competitions/add';
  const AddCompetition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddCompetitionController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tambah Kompetisi'.text.make(),
      resizeToAvoidBottomInset: false,
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.isUploading.value ? null : controller.save,
            child: 'Simpan'.text.make(),
          ),
        ),
      ],
      body: Obx(
        () => Form(
          key: controller.formKey,
          child: VStack([
            ImageUpload(
                context: context,
                selectLabel: 'Pilih Banner Kompetisi',
                changeLabel: 'Ubah Banner Kompetisi',
                onSaved: controller.selectFile,
                validator: (val) {
                  if (val?.name == null) {
                    return 'Banner tidak boleh kosong.';
                  }
                  return null;
                }),
            TextFormField(
              controller: controller.name,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Nama Kompetisi',
                labelText: 'Nama Kompetisi',
              ),
            ),
            TextFormField(
              controller: controller.description,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Deskripsi Kompetisi',
                labelText: 'Deskripsi Kompetisi',
              ),
              minLines: 3,
              maxLines: 3,
            ),
            UiSpacer.verticalSpace(),
            'Apakah kompetisi ini online atau offline/onsite?'
                .text
                .gray600
                .make(),
            UiSpacer.verticalSpace(space: 5),
            ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              selectedColor: Colors.white,
              selectedBorderColor: primaryColor,
              fillColor: primaryColor,
              isSelected: controller.toggleSelecteds.toList(),
              onPressed: (value) => controller.changeEventMode(value),
              children: [
                'Offline'.text.make().p8(),
                'Online'.text.make().p8(),
              ],
            ).h(40),
            UiSpacer.verticalSpace(),
            HStack([
              TextFormField(
                controller: controller.startDate,
                validator:
                    ValidationBuilder(localeName: 'id').required().build(),
                decoration: const InputDecoration(
                  hintText: 'Mulai Tanggal Kompetisi',
                  labelText: 'Mulai Tanggal Kompetisi',
                ),
                readOnly: true,
                onTap: controller.selectDateRange,
              ).expand(),
              UiSpacer.horizontalSpace(),
              TextFormField(
                controller: controller.endDate,
                validator:
                    ValidationBuilder(localeName: 'id').required().build(),
                decoration: const InputDecoration(
                  hintText: 'Selesai Tanggal Kompetisi',
                  labelText: 'Selesai Tanggal Kompetisi',
                ),
                readOnly: true,
                onTap: controller.selectDateRange,
              ).expand(),
            ]),
            HStack([
              TextFormField(
                controller: controller.startTime,
                validator:
                    ValidationBuilder(localeName: 'id').required().build(),
                decoration: const InputDecoration(
                  hintText: 'Mulai Waktu Kompetisi',
                  labelText: 'Mulai Waktu Kompetisi',
                ),
                readOnly: true,
                onTap: controller.selectTimeRange,
              ).expand(),
              UiSpacer.horizontalSpace(),
              TextFormField(
                controller: controller.endTime,
                validator:
                    ValidationBuilder(localeName: 'id').required().build(),
                decoration: const InputDecoration(
                  hintText: 'Selesai Waktu Kompetisi',
                  labelText: 'Selesai Waktu Kompetisi',
                ),
                readOnly: true,
                onTap: controller.selectTimeRange,
              ).expand(),
            ]),
            TextFormField(
              controller: controller.address,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Alamat',
                labelText: 'Alamat',
              ),
            ),
            TextFormField(
              controller: controller.speaker,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Contoh : Aria Muhamad/Tim Pelaksana A',
                labelText: 'Nama Pembicara/Pelaksana',
              ),
            ),
            TextFormField(
              controller: controller.additionalDescription,
              decoration: const InputDecoration(
                hintText: 'Deskripsi Tambahan',
                labelText: 'Deskripsi Tambahan',
              ),
              minLines: 5,
              maxLines: 5,
            ),
            TextFormField(
              controller: controller.price,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Harga Partisipasi',
                labelText: 'Harga Partisipasi',
              ),
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
            ExpansionTile(
                title: 'Pengaturan Tambahan'.text.make(),
                initiallyExpanded: true,
                tilePadding: EdgeInsets.zero,
                children: [
                  'Kompetisi Diperuntukan'.text.make(),
                  CheckboxListTile(
                    value: controller.checkTarget('pelatih'),
                    onChanged: (val) => controller.addTarget('pelatih'),
                    dense: true,
                    title: 'Pelatih'.text.make(),
                  ),
                  CheckboxListTile(
                    value: controller.checkTarget('pemain'),
                    onChanged: (val) => controller.addTarget('pemain'),
                    dense: true,
                    title: 'Pemain'.text.make(),
                  ),
                  CheckboxListTile(
                    value: controller.checkTarget('klub'),
                    onChanged: (val) => controller.addTarget('klub'),
                    dense: true,
                    title: 'Klub'.text.make(),
                  ),
                  TextFormField(
                    controller: controller.descriptionLabel,
                    decoration: const InputDecoration(
                      hintText: 'Default : Deskripsi',
                      labelText: 'Kustom Label Deskripsi',
                    ),
                  ),
                  TextFormField(
                    controller: controller.speakerLabel,
                    decoration: const InputDecoration(
                      hintText: 'Default : Pembicara',
                      labelText: 'Kustom Label Pembicara',
                    ),
                  ),
                ]),
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
