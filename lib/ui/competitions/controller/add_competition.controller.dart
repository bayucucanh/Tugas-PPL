import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/extensions/format_timeofday.extension.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/date_picker.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class AddCompetitionController extends BaseController {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    turnOffGrouping: true,
    decimalDigits: 0,
    symbol: '',
    name: 'IDR',
  );
  final formKey = GlobalKey<FormState>();
  final _eventRequest = EventRequest();
  final banner = FileObservable().obs;
  final name = TextEditingController();
  final targets = <String>[].obs;
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final startTime = TextEditingController();
  final endTime = TextEditingController();
  final address = TextEditingController();
  final description = TextEditingController();
  final additionalDescription = TextEditingController();
  final speaker = TextEditingController();
  final price = TextEditingController();
  final speakerLabel = TextEditingController();
  final descriptionLabel = TextEditingController();
  final isUploading = false.obs;
  final toggleSelecteds = [
    true,
    false,
  ].obs;
  final isOnline = false.obs;
  final DateFormat _parseEventDate = DateFormat('dd MMMM yyyy');

  changeEventMode(int? value) {
    for (int i = 0; i < toggleSelecteds.length; i++) {
      toggleSelecteds[i] = i == value;
    }
    isOnline(value == 1 ? true : false);
    toggleSelecteds.refresh();
  }

  selectFile(FileObservable? file) {
    banner(file);
  }

  selectDateRange() async {
    DateTimeRange? eventDateTime = await DatePicker.getDateRange(Get.context!);
    if (eventDateTime != null) {
      DateFormat df = DateFormat('dd MMMM yyyy');
      startDate.text = df.format(eventDateTime.start);
      endDate.text = df.format(eventDateTime.end);
    }
  }

  selectTimeRange() async {
    await DatePicker.getRangeTime(Get.context!,
        title: 'Pilih Waktu Mulai dan Selesai Kompetisi',
        onSelect: (start, end) {
      startTime.text = start.formatTime();
      endTime.text = end.formatTime();
      Get.back();
    });
  }

  addTarget(String? target) {
    if (targets.contains(target)) {
      targets.remove(target);
    } else {
      targets.add(target!);
    }
  }

  bool checkTarget(String target) {
    if (targets.contains(target)) {
      return true;
    }
    return false;
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState?.save();
        EasyLoading.show();
        isUploading(true);
        FormData data = FormData.fromMap({
          'event_type': 'competition',
          'targets': targets.map((target) => {'name': target}).toList(),
          'banner': await MultipartFile.fromFile(banner.value.path!,
              filename: banner.value.name),
          'type': 'Kompetisi',
          'name': name.text,
          'description': description.text,
          'is_online': isOnline.value,
          'address': address.text,
          'start_date': _parseEventDate.parse(startDate.text),
          'end_date': _parseEventDate.parse(endDate.text),
          'start_time': startTime.text,
          'end_time': endTime.text,
          'additional_description_label':
              descriptionLabel.text.isEmpty ? null : descriptionLabel.text,
          'additional_description': additionalDescription.text,
          'speaker_label': speakerLabel.text.isEmpty ? null : speakerLabel.text,
          'speaker': speaker.text,
          'price': double.parse(_currencyFormatter.format(price.text)),
        });
        await _eventRequest.create(data: data);
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
}
