import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/image_upload.dart';
import 'package:mobile_pssi/ui/events/controller/edit_event.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EditEvent extends GetView<EditEventController> {
  static const routeName = '/events/edit';
  const EditEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EditEventController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Ubah Event'.text.make(),
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
                selectLabel: 'Pilih Banner Event',
                changeLabel: 'Ubah Banner Event',
                placeholder: controller.event!.banner!,
                onSaved: controller.selectFile,
                validator: (val) {
                  return null;
                }),
            TextFormField(
              controller: controller.type,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Contoh: Seminar',
                labelText: 'Jenis Event',
              ),
            ),
            TextFormField(
              controller: controller.name,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Nama Event',
                labelText: 'Nama Event',
              ),
            ),
            TextFormField(
              controller: controller.description,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Deskripsi Event',
                labelText: 'Deskripsi Event',
              ),
              minLines: 3,
              maxLines: 3,
            ),
            UiSpacer.verticalSpace(),
            'Apakah event ini online atau offline/onsite?'.text.gray600.make(),
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
            if (controller.isOnline.value == true)
              VStack([
                UiSpacer.verticalSpace(),
                TextFormField(
                  controller: controller.urlMeeting,
                  validator: ValidationBuilder(localeName: 'id')
                      .required()
                      .url()
                      .build(),
                  decoration: const InputDecoration(
                    hintText: 'Contoh : https://meet.google.com/pwy-nafy-jme',
                    labelText: 'URL Meeting',
                  ),
                  keyboardType: TextInputType.url,
                ),
                UiSpacer.verticalSpace(),
              ]),
            HStack([
              TextFormField(
                controller: controller.startDate,
                validator:
                    ValidationBuilder(localeName: 'id').required().build(),
                decoration: const InputDecoration(
                  hintText: 'Mulai Tanggal Event',
                  labelText: 'Mulai Tanggal Event',
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
                  hintText: 'Selesai Tanggal Event',
                  labelText: 'Selesai Tanggal Event',
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
                  hintText: 'Mulai Waktu Event',
                  labelText: 'Mulai Waktu Event',
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
                  hintText: 'Selesai Waktu Event',
                  labelText: 'Selesai Waktu Event',
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
              decoration: InputDecoration(
                hintText: 'Harga Partisipasi',
                labelText: 'Harga Partisipasi',
                helperText:
                    'Harga sudah termasuk pajak ${controller.priceWithTax}',
              ),
              textAlign: TextAlign.end,
              onChanged: controller.onChangePrice,
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
                  'Event Diperuntukan'.text.make(),
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
