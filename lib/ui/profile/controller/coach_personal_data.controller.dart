import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/specialist.dart';
import 'package:mobile_pssi/data/requests/specialist.request.dart';
import 'package:mobile_pssi/ui/profile/coach/verification_data_tab.dart';
import 'package:mobile_pssi/ui/profile/player/personal_data_tab.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class CoachPersonalDataController extends BaseController {
  final _totalTab = 0.obs;
  final _specialistRequest = SpecialistRequest();
  final _tabs = <Widget>[
    const Tab(
      text: 'Personal Data',
    ),
    const Tab(
      text: 'Data Verifikasi',
    ),
  ].obs;
  final _tabViews = <Widget>[
    const PersonalDataTab(),
    const VerificationDataTab(),
  ].obs;
  final _specialists = Resource<List<Specialist>>(data: []).obs;
  final _selectedSpecialist = <Specialist>[].obs;

  @override
  void onInit() {
    _totalTab(_tabs.length);
    _initialize();
    super.onInit();
  }

  _initialize() {
    getUserData();
    if (userData.value.isCoach) {
      _fetchSpecialists();
    }
  }

  _fetchSpecialists() async {
    try {
      EasyLoading.show();
      _specialists(await _specialistRequest.gets(option: 'select'));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  selectSpecialist(List<Specialist> specialists) {
    _selectedSpecialist.assignAll(specialists);
  }

  int get totalTab => _totalTab.value;
  List<Widget> get tabs => _tabs;
  List<Widget> get tabViews => _tabViews;
  List<Specialist>? get specialists => _specialists.value.data;
  List<Specialist> get selectedSpecialist => _selectedSpecialist;
}
