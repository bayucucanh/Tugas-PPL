
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/dominant_foot.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/position.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/ui/profile/player/other_data_tab.dart';
import 'package:mobile_pssi/ui/profile/player/personal_data_tab.dart';
import 'package:mobile_pssi/ui/profile/player/player_tab_data.dart';
import 'package:mobile_pssi/ui/profile/player/verification_data_tab.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PlayerPersonalDataController extends BaseController {
  final _totalTab = 0.obs;
  final _positionRequest = PositionRequest();
  final _tabs = <Widget>[
    const Tab(
      text: 'Personal Data',
    ),
    const Tab(
      text: 'Data Verifikasi',
    ),
    const Tab(
      text: 'Data Pemain',
    ),
    const Tab(
      text: 'Lain-lain',
    ),
  ].obs;
  final _tabViews = <Widget>[
    const PersonalDataTab(),
    const VerificationDataTab(),
    const PlayerTabData(),
    const OtherDataTab(),
  ].obs;

  final positions = Resource<List<PlayerPosition>>(data: []).obs;
  final selectedPosition = const PlayerPosition().obs;
  final profile = const Profile().obs;
  final height = TextEditingController();
  final weight = TextEditingController();
  final website = TextEditingController();
  final dominantFoots = <DominantFoot>[
    const DominantFoot(id: 1, name: 'Kaki Kanan'),
    const DominantFoot(id: 2, name: 'Kaki Kiri'),
    const DominantFoot(id: 3, name: 'Keduanya'),
  ];
  final selectedFootDominant = const DominantFoot().obs;
  final parentPhoneNumber = TextEditingController();
  final birthCertificate = FileObservable().obs;
  final kk = FileObservable().obs;
  final ijazah = FileObservable().obs;
  final showIjazah = false.obs;
  final raport = FileObservable().obs;

  @override
  void onInit() {
    _totalTab(_tabs.length);
    _initialize();
    super.onInit();
  }

  _initialize() async {
    getUserData();
    if (userData.value.isPlayer) {
      profile(userData.value.profile);
      await _getPlayerPositions();
      DominantFoot? dominantFoot = dominantFoots
          .firstWhereOrNull((e) => e.id == profile.value.dominantFoot?.id);
      selectDominantFoot(dominantFoot);
      height.text = profile.value.height?.value == null
          ? ''
          : profile.value.height!.value.toString();
      weight.text = profile.value.weight?.value == null
          ? ''
          : profile.value.weight!.value.toString();
      parentPhoneNumber.text = profile.value.parentPhoneNumber ?? '';
      website.text = profile.value.website ?? '';

      _checkForIjazah();
    }
  }

  _checkForIjazah() {
    if (profile.value.ageFormat != null) {
      if (profile.value.ageFormat! >= 12) {
        showIjazah(true);
      }
    }
  }

  _getPlayerPositions() async {
    var resp = await _positionRequest.getPlayerPositions();
    resp.data?.map((data) {
      if (profile.value.playerPosition?.id == data.id) {
        selectedPosition(data);
      }
    });
    positions(resp);
  }

  selectPlayerPosition(PlayerPosition? playerPosition) {
    selectedPosition(playerPosition);
  }

  selectDominantFoot(DominantFoot? dominantFoot) {
    selectedFootDominant(dominantFoot);
  }

  selectBirthCertificate() async {
    FilePickerResult? selectFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: [
        'pdf',
      ],
      type: FileType.custom,
    );

    if (selectFile != null) {
      birthCertificate(FileObservable.filePickerResult(selectFile));
    } else {
      birthCertificate(null);
    }
  }

  selectKk() async {
    FilePickerResult? selectFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: [
        'pdf',
      ],
      type: FileType.custom,
    );

    if (selectFile != null) {
      kk(FileObservable.filePickerResult(selectFile));
    } else {
      kk(null);
    }
  }

  selectIjazah() async {
    FilePickerResult? selectFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: [
        'pdf',
      ],
      type: FileType.custom,
    );

    if (selectFile != null) {
      ijazah(FileObservable.filePickerResult(selectFile));
    } else {
      ijazah(null);
    }
  }

  selectRaport() async {
    FilePickerResult? selectFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: [
        'pdf',
      ],
      type: FileType.custom,
    );

    if (selectFile != null) {
      raport(FileObservable.filePickerResult(selectFile));
    } else {
      raport(null);
    }
  }

  openFileScreening(String? url) async {
    if (url != null) {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      }
    }
  }

  int get totalTab => _totalTab.value;
  List<Widget> get tabs => _tabs;
  List<Widget> get tabViews => _tabViews;
}
