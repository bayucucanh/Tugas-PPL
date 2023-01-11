import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/ui/profile/club/verification_data_tab.dart';
import 'package:mobile_pssi/ui/profile/player/personal_data_tab.dart';

class ClubPersonalDataController extends BaseController {
  final _totalTab = 0.obs;
  final _tabs = <Widget>[
    const Tab(
      text: 'Data Klub',
    ),
    const Tab(
      text: 'Data Verifikasi',
    ),
  ].obs;
  final _tabViews = <Widget>[
    const PersonalDataTab(),
    const VerificationDataTab(),
  ].obs;
  File? klb;
  final klbSelected = false.obs;

  @override
  void onInit() {
    _totalTab(_tabs.length);
    _initialize();
    super.onInit();
  }

  _initialize() {
    getUserData();
  }

  selectKlb() async {
    FilePickerResult? selectFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: [
        'pdf',
        'jpg',
        'png',
        'jpeg',
      ],
      type: FileType.custom,
    );

    if (selectFile != null) {
      klb = File(selectFile.files.first.path!);
      klbSelected(true);
    } else {
      klb = null;
      klbSelected(false);
    }
  }

  int get totalTab => _totalTab.value;
  List<Widget> get tabs => _tabs;
  List<Widget> get tabViews => _tabViews;
}
