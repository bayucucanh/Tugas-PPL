import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/district.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/village.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/transfer_market/controller/add_promo.controller.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/new_student_form/additional_fields.dart';
import 'package:mobile_pssi/ui/transfer_market/pages/new_student_form/schedule_form_card.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class NewStudentForm extends GetView<AddPromoController> {
  const NewStudentForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Form(
          key: controller.newStudentFormKey,
          child: VStack([
            'Informasi'.text.semiBold.xl2.make(),
            'Masukan semua informasi yang dibutuhkan untuk membuat promosi form siswa baru dibawah.'
                .text
                .xs
                .gray500
                .make(),
            UiSpacer.verticalSpace(space: 10),
            TextFormField(
              controller: controller.studentForm.location,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Tempat Latihan',
                labelText: 'Tempat Latihan',
              ),
            ),
            TextFormField(
              controller: controller.studentForm.address,
              validator: ValidationBuilder(localeName: 'id').required().build(),
              decoration: const InputDecoration(
                hintText: 'Alamat',
                labelText: 'Alamat',
              ),
            ),
            UiSpacer.verticalSpace(space: 5),
            DropdownSearch<Province>(
              selectedItem: controller.studentForm.province.value,
              asyncItems: controller.studentForm.searchProvince,
              popupProps: PopupProps.modalBottomSheet(
                showSearchBox: true,
                isFilterOnline: true,
                title: 'Pilih Provinsi'.text.semiBold.lg.make().p12(),
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Cari Provinsi',
                    labelText: 'Cari Provinsi',
                  ),
                ),
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Provinsi',
                  labelText: 'Provinsi',
                ),
              ),
              onChanged: controller.studentForm.selectProvince,
              validator: (Province? province) {
                if (province?.id == null) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
            ),
            DropdownSearch<City>(
              selectedItem: controller.studentForm.city.value,
              asyncItems: controller.studentForm.searchCity,
              enabled: controller.studentForm.province.value.id != null,
              popupProps: PopupProps.modalBottomSheet(
                showSearchBox: true,
                isFilterOnline: true,
                title: 'Pilih Kota/Kabupaten'.text.semiBold.lg.make().p12(),
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Cari Kota/Kabupaten',
                    labelText: 'Cari Kota/Kabupaten',
                  ),
                ),
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Kota/Kabupaten',
                  labelText: 'Kota/Kabupaten',
                ),
              ),
              onChanged: controller.studentForm.selectCity,
              validator: (City? city) {
                if (city?.id == null) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
            ),
            DropdownSearch<District>(
              selectedItem: controller.studentForm.district.value,
              asyncItems: controller.studentForm.searchDistrict,
              enabled: controller.studentForm.city.value.id != null,
              popupProps: PopupProps.modalBottomSheet(
                showSearchBox: true,
                isFilterOnline: true,
                title: 'Pilih Kecamatan'.text.semiBold.lg.make().p12(),
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Cari Kecamatan',
                    labelText: 'Cari Kecamatan',
                  ),
                ),
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Kecamatan',
                  labelText: 'Kecamatan',
                ),
              ),
              onChanged: controller.studentForm.selectDistrict,
              validator: (District? district) {
                if (district?.id == null) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
            ),
            DropdownSearch<Village>(
              selectedItem: controller.studentForm.village.value,
              asyncItems: controller.studentForm.searchVillage,
              enabled: controller.studentForm.district.value.id != null,
              popupProps: PopupProps.modalBottomSheet(
                showSearchBox: true,
                isFilterOnline: true,
                title: 'Pilih Kelurahan'.text.semiBold.lg.make().p12(),
                searchFieldProps: const TextFieldProps(
                  decoration: InputDecoration(
                    hintText: 'Cari Kelurahan',
                    labelText: 'Cari Kelurahan',
                  ),
                ),
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  hintText: 'Kelurahan',
                  labelText: 'Kelurahan',
                ),
              ),
              onChanged: controller.studentForm.selectVillage,
              validator: (Village? village) {
                if (village?.id == null) {
                  return 'Tidak boleh kosong';
                }
                return null;
              },
            ),
            UiSpacer.verticalSpace(),
            HStack([
              VStack([
                'Jadwal Latihan'.text.semiBold.xl.make(),
                'Untuk menambahkan jadwal latihan anda bisa tambahkan dengan menekan tombol "Tambah Jadwal"'
                    .text
                    .xs
                    .gray500
                    .make(),
              ]).expand(),
              'Tambah Jadwal'
                  .text
                  .sm
                  .center
                  .white
                  .makeCentered()
                  .continuousRectangle(
                    height: 40,
                    width: 120,
                    backgroundColor: primaryColor,
                  )
                  .onTap(controller.studentForm.addSchedule),
            ]),
            ListView.builder(
              itemCount: controller.studentForm.schedulePractices.length,
              itemBuilder: (context, index) {
                final schedulePractice =
                    controller.studentForm.schedulePractices[index];
                return ScheduleFormCard(
                    scheduleForm: schedulePractice,
                    selectedDay: (selectedDay) => controller.studentForm
                        .selectedDay(schedulePractice, selectedDay),
                    deleteSchedule: index == 0
                        ? null
                        : () => controller.studentForm.removeSchedule(index));
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
            UiSpacer.verticalSpace(),
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
              controller: controller.studentForm.startUpFee,
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
                labelText: 'Biaya Pangkal',
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: controller.studentForm.monthlyFee,
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
                labelText: 'Biaya Bulanan',
              ),
              keyboardType: TextInputType.number,
            ),
            UiSpacer.verticalSpace(),
            HStack([
              VStack([
                'Tambahan Biaya'.text.semiBold.xl.make(),
                'Untuk menambahkan biaya tambahan lainnya anda bisa tambahkan dengan menekan tombol "Tambah Biaya"'
                    .text
                    .xs
                    .gray500
                    .make(),
              ]).expand(),
              'Tambah Biaya'
                  .text
                  .sm
                  .center
                  .white
                  .makeCentered()
                  .continuousRectangle(
                    height: 40,
                    width: 120,
                    backgroundColor: primaryColor,
                  )
                  .onTap(controller.studentForm.addNewField),
            ]),
            UiSpacer.verticalSpace(),
            controller.studentForm.additionalFields.isEmpty
                ? EmptyWithButton(
                    emptyMessage: 'Tidak ada Biaya Tambahan',
                    textButton: 'Tambah Biaya',
                    showButton: false,
                    onTap: controller.studentForm.addNewField,
                  )
                : ListView.builder(
                    itemCount: controller.studentForm.additionalFields.length,
                    itemBuilder: (context, index) {
                      final addField =
                          controller.studentForm.additionalFields[index];
                      return AdditionalFields(
                          additionalField: addField,
                          deleteField: () =>
                              controller.studentForm.removeField(index));
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
            UiSpacer.verticalSpace(space: 40),
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
      ),
    );
  }
}
