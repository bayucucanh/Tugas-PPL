import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/day.dart';
import 'package:mobile_pssi/data/model/district.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/village.dart';
import 'package:mobile_pssi/data/requests/region.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class NewStudentFormController extends BaseController {
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    turnOffGrouping: true,
    decimalDigits: 0,
    symbol: '',
    name: 'IDR',
  );
  final _regionRequest = RegionRequest();
  final location = TextEditingController();
  final address = TextEditingController();
  final provinces = Resource<List<Province>>(data: []).obs;
  final province = const Province().obs;
  final cities = Resource<List<City>>(data: []).obs;
  final city = const City().obs;
  final districts = Resource<List<District>>(data: []).obs;
  final district = District().obs;
  final villages = Resource<List<Village>>(data: []).obs;
  final village = Village().obs;
  final notes = TextEditingController();
  final schedulePractices = <ScheduleForm>[].obs;
  final startUpFee = TextEditingController();
  final monthlyFee = TextEditingController();
  final additionalFields = <AdditionalFieldForm>[].obs;

  @override
  void onInit() {
    schedulePractices.add(
      ScheduleForm(
        startTime: TextEditingController(),
        endTime: TextEditingController(),
        days: getDaysOfWeek('id'),
      ),
    );
    super.onInit();
  }

  Future<List<Province>> searchProvince(String? value) async {
    return _regionRequest.getListProvince(search: value);
  }

  Future<List<City>> searchCity(String? value) async {
    return _regionRequest.getListCity(
        search: value, provinceId: province.value.id);
  }

  Future<List<District>> searchDistrict(String? value) async {
    return _regionRequest.getListDistrict(search: value, cityId: city.value.id);
  }

  Future<List<Village>> searchVillage(String? value) async {
    return _regionRequest.getListVillage(
        search: value, districtId: district.value.id);
  }

  selectProvince(Province? selectedProvince) {
    province(selectedProvince);
    city(const City());
    district(District());
    village(Village());
  }

  selectCity(City? selectedCity) {
    city(selectedCity);
    district(District());
    village(Village());
  }

  selectDistrict(District? selectedDistrict) {
    district(selectedDistrict);
    village(Village());
  }

  selectVillage(Village? selectedVillage) {
    village(selectedVillage);
  }

  addSchedule() {
    if (schedulePractices.length >= 7) {
      getSnackbar('Informasi', 'Maksimal jadwal latihan sudah tercapai.');
      return;
    }
    schedulePractices.add(
      ScheduleForm(
          startTime: TextEditingController(),
          endTime: TextEditingController(),
          days: getDaysOfWeek('id')),
    );
  }

  List<Day> getDaysOfWeek([String? locale]) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => index).map((value) {
      String day = DateFormat(DateFormat.WEEKDAY, locale)
          .format(firstDayOfWeek.add(Duration(days: value)));
      return Day(id: (value + 1), name: day);
    }).toList();
  }

  removeSchedule(int index) {
    schedulePractices.removeAt(index);
  }

  selectedDay(ScheduleForm? schedule, Day? selectedDay) {
    schedule?.day = selectedDay;
  }

  addNewField() {
    additionalFields.add(AdditionalFieldForm(
      fieldName: TextEditingController(),
      fieldValue: TextEditingController(),
    ));
  }

  removeField(int index) {
    additionalFields.removeAt(index);
  }

  toJson() {
    Map<String, dynamic> data = {
      'practice_location': location.text,
      'address': address.text,
      'village_id': village.value.id,
      'notes': notes.text,
      'schedules': schedulePractices.map((e) => e.toJson()).toList(),
      'start_up_fee': _currencyFormatter.format(startUpFee.text),
      'monthly_fee': _currencyFormatter.format(monthlyFee.text),
    };
    if (additionalFields.isNotEmpty) {
      data.addAll({
        'additional_fields': additionalFields
            .map((e) => e.toJson(formatter: _currencyFormatter))
            .toList()
      });
    }
    return data;
  }
}

class ScheduleForm {
  Day? day;
  TextEditingController? startTime;
  TextEditingController? endTime;
  List<Day> days;

  ScheduleForm({this.day, this.endTime, this.startTime, required this.days});

  toJson() => {
        'day': day?.id,
        'start_time': startTime?.text,
        'end_time': endTime?.text,
      };
}

class AdditionalFieldForm {
  TextEditingController? fieldName;
  TextEditingController? fieldValue;

  AdditionalFieldForm({this.fieldName, this.fieldValue});

  toJson({CurrencyTextInputFormatter? formatter}) => {
        'name': fieldName?.text,
        'value': formatter != null
            ? formatter.format(fieldValue!.text)
            : fieldValue?.text,
      };
}
