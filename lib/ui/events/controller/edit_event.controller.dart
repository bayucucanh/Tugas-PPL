import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/extensions/format_timeofday.extension.dart';
import 'package:mobile_pssi/extensions/tax.extension.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/date_picker.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class EditEventController extends BaseController {
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
  final _eventRequest = EventRequest();
  final _event = Event().obs;
  final targets = <String>[].obs;
  final banner = FileObservable().obs;
  final name = TextEditingController();
  final type = TextEditingController();
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
  final urlMeeting = TextEditingController();
  final DateFormat _parseEventDate = DateFormat('dd MMMM yyyy');
  final _priceWithTax = 0.0.obs;

  EditEventController() {
    _event(Event.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _setDefaultValue();
    super.onInit();
  }

  _setDefaultValue() {
    type.text = _event.value.type ?? '';
    name.text = _event.value.name ?? '';
    description.text = _event.value.description ?? '';
    changeEventMode(_event.value.isOnline == true ? 1 : 0);
    startDate.text = _event.value.startDateFormat ?? '';
    endDate.text = _event.value.endDateFormat ?? '';
    startTime.text = _event.value.startTime == null
        ? ''
        : _event.value.startTime!.formatTime();
    endTime.text =
        _event.value.endTime == null ? '' : _event.value.endTime!.formatTime();
    address.text = _event.value.address ?? '';
    speaker.text = _event.value.speaker ?? '';
    additionalDescription.text = _event.value.additionalDescription ?? '';
    price.text = _event.value.priceWithoutTaxFormat ?? '';
    _previewPriceTax(_event.value.price);
    descriptionLabel.text = _event.value.additionalDescriptionLabel ?? '';
    speakerLabel.text = _event.value.speakerLabel ?? '';
    if (_event.value.target != null) {
      targets.addAll(_event.value.target!.split(','));
    }
    if (isOnline.value == true) {
      urlMeeting.text = _event.value.meetingUrl ?? '';
    }
  }

  _previewPriceTax(double? price) {
    _priceWithTax(price?.addPriceTax() ?? 0.0);
  }

  changeEventMode(int? value) {
    for (int i = 0; i < toggleSelecteds.length; i++) {
      toggleSelecteds[i] = i == value;
    }
    toggleSelecteds.refresh();
    isOnline(value == 1 ? true : false);
    if (value == 0) {
      urlMeeting.clear();
    }
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
        title: 'Pilih Waktu Mulai dan Selesai Event', onSelect: (start, end) {
      startTime.text = start.formatTime();
      endTime.text = end.formatTime();
      Get.back();
    });
  }

  onChangePrice(String value) {
    if (price.text.isNotEmpty) {
      _priceWithTax(double.parse(_currencyFormatter.format(price.text)));
      _previewPriceTax(_priceWithTax.value);
    }
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState?.save();
        EasyLoading.show();
        isUploading(true);
        FormData data = FormData.fromMap({
          'event_type': _event.value.eventType,
          'targets': targets.map((target) => {'name': target}).toList(),
          'banner': banner.value.name == null
              ? null
              : await MultipartFile.fromFile(banner.value.path!,
                  filename: banner.value.name),
          'type': type.text,
          'name': name.text,
          'description': description.text,
          'is_online': isOnline.value,
          'meeting_url': isOnline.value == true ? urlMeeting.text : null,
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
        await _eventRequest.update(eventId: _event.value.id!, data: data);
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

  Event? get event => _event.value;
  String? get priceWithTax {
    return _displayCurrency.format(_priceWithTax.toStringAsFixed(0));
  }
}
