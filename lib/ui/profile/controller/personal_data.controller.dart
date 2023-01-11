import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/nationality.dart';
import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/nationality.request.dart';
import 'package:mobile_pssi/data/requests/region.request.dart';
import 'package:mobile_pssi/data/requests/user.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/ui/profile/controller/club_personal_data.controller.dart';
import 'package:mobile_pssi/ui/profile/controller/coach_personal_data.controller.dart';
import 'package:mobile_pssi/ui/profile/controller/player_personal_data.controller.dart';
import 'package:mobile_pssi/ui/profile/parts/city.bottomsheet.dart';
import 'package:mobile_pssi/ui/profile/parts/province.bottomsheet.dart';
import 'package:mobile_pssi/utils/date_picker.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PersonalDataController extends BaseController {
  final refreshController = RefreshController();
  final _userRequest = UserRequest();
  final formKey = GlobalKey<FormState>();
  final _nationalityRequest = NationalityRequest();
  final _regionRequest = RegionRequest();
  final _playerPersonalData = Get.put(PlayerPersonalDataController());
  final _coachPersonalData = Get.put(CoachPersonalDataController());
  final _clubPersonalData = Get.put(ClubPersonalDataController());
  final logoutBtn = false.obs;

  final fullname = TextEditingController();
  final genders = <Gender>[
    const Gender(id: 1, name: 'Laki-laki'),
    const Gender(id: 2, name: 'Perempuan'),
  ].obs;
  final selectedGender = const Gender().obs;
  final birthDate = TextEditingController();
  final phoneNumber = TextEditingController();
  final email = TextEditingController();
  final nik = TextEditingController();
  final photo = FileObservable().obs;
  File? ektp;
  final ektpSelected = false.obs;
  final nationalities = Resource<List<Nationality>>(data: []).obs;
  final address = TextEditingController();
  final provinces = Resource<List<Province>>(data: []).obs;
  final cities = Resource<List<City>>(data: []).obs;
  final selectedNationality = const Nationality().obs;
  final selectedProvince = const Province().obs;
  final cityTx = TextEditingController();
  final selectedCity = const City().obs;
  final uploadingData = false.obs;
  final loadProvince = false.obs;
  final loadCity = false.obs;
  final profile = const Profile().obs;

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() async {
    try {
      EasyLoading.show();
      await getNationalities();
      await getProfile();
      await getProvince();
      _isRedirectFromDashboard();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _isRedirectFromDashboard() {
    if (Get.arguments != null) {
      if (Get.arguments['show_verification_form'] != null) {
        if (Get.arguments['show_verification_form'] == true) {
          logoutBtn(true);
        }
      }
    }
  }

  @override
  getProfile() async {
    try {
      User user = await _userRequest.getProfile();
      Storage.save(ProfileStorage.user, user.toJson());

      userData(user);
      profile(user.profile);

      fullname.text = profile.value.name ?? '';
      birthDate.text = profile.value.dateOfBirth ?? '';
      email.text = userData.value.email ?? '';
      phoneNumber.text = userData.value.phoneNumber ?? '';
      if (!user.isClub) {
        nik.text = profile.value.nik ?? '';
        Gender? gender = genders.firstWhereOrNull(
            (gender) => gender.id == profile.value.gender?.id);
        selectGender(gender);
      }
      address.text = profile.value.address ?? '';
      cityTx.text = profile.value.city?.name ?? '';

      Nationality? defaultNationality = nationalities.value.data?.firstWhere(
          (e) => e.id == profile.value.nationality?.id,
          orElse: () => const Nationality());
      selectedNationality(defaultNationality);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  selectGender(Gender? gender) {
    selectedGender(gender);
  }

  getNationalities() async {
    var resp = await _nationalityRequest.getNationality();
    nationalities(resp);
  }

  selectNationality(Nationality? nationality) {
    selectedNationality(nationality);
  }

  getProvince() async {
    try {
      loadProvince(true);
      var resp = await _regionRequest.getProvince();
      resp.data?.map((data) {
        if (profile.value.province?.id == data.id) {
          selectedProvince(data);
          getCities(provinceId: data.id);
        }
      });
      provinces(resp);
      loadProvince(false);
    } catch (_) {
      loadProvince(false);
    }
  }

  selectProvince(Province? province) {
    getCities(provinceId: province?.id);
  }

  getCities({int? provinceId}) async {
    try {
      loadCity(true);
      var resp = await _regionRequest.getCity(provinceId: provinceId);
      resp.data?.map((data) {
        if (profile.value.city?.id == data.id) {
          selectedCity(data);
        }
      });
      cities(resp);
      loadCity(false);
    } catch (_) {
      loadCity(false);
    }
  }

  selectCity(City? city) {
    selectedCity(city);
    cityTx.text = city?.name ?? '-';
  }

  showCityDialog() async {
    var province = await Get.bottomSheet(
      ProvinceBottomSheet(controller: this),
      isScrollControlled: true,
    );

    if (province != null) {
      getCities(provinceId: province.id);
      var city = await Get.bottomSheet(
        CityBottomSheet(controller: this),
        isScrollControlled: true,
      );

      if (city != null) {
        selectCity(city);
      }
    }
  }

  openDateBirth(
    BuildContext context,
  ) async {
    DateTime? selectedDate = await DatePicker.getDate(context,
        initialDate: DateTime.now().subtract(const Duration(
          days: 365 * 60,
        )),
        firstDate: DateTime.now().subtract(const Duration(
          days: 365 * 60,
        )),
        lastDate: DateTime.now());
    if (selectedDate != null) {
      birthDate.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  selectEktp() async {
    FilePickerResult? selectFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      type: FileType.image,
    );

    if (selectFile != null) {
      ektp = File(selectFile.files.first.path!);
      ektpSelected(true);
    } else {
      ektp = null;
      ektpSelected(false);
    }
  }

  selectPhoto() async {
    FilePickerResult? selectFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: ['png', 'jpeg', 'jpg'],
      type: FileType.custom,
    );

    if (selectFile != null) {
      photo(FileObservable.filePickerResult(selectFile));
    } else {
      photo(null);
    }
  }

  saveData() async {
    try {
      PermissionStatus? permissionStatus = await Permission.storage.request();

      if (permissionStatus.isGranted) {
        if (formKey.currentState!.validate()) {
          uploadingData(true);
          EasyLoading.show();
          await _userRequest.saveProfile(await formDatatoJson());
          getProfile();
          EasyLoading.dismiss();
        }
      } else {
        getSnackbar('Informasi',
            'Mohon aktifkan permisi penyimpanan untuk dapat menyimpan data.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      uploadingData(false);
      getSnackbar('Pemberitahuan', e.toString());
    }
  }

  formDatatoJson() async {
    Map<String, dynamic> data = {
      'name': fullname.text,
      'gender': selectedGender.value.id,
      // 'email': email.text,
      'phone_number': phoneNumber.text,
      'date_of_birth': birthDate.text,
      'address': address.text,
      'city_id': selectedCity.value.id ?? profile.value.city?.id,
      'national_id':
          selectedNationality.value.id ?? profile.value.nationality?.id
    };

    if (!userData.value.isClub) {
      data['nik'] = nik.text;
    }

    if (profile.value.isPlayer == true) {
      data['parent_phone_number'] = playerData.parentPhoneNumber.text;
      data['weight'] = playerData.weight.text;
      data['height'] = playerData.height.text;
      data['dominant_foot'] = playerData.selectedFootDominant.value.id ??
          profile.value.dominantFoot?.id;
      data['position_id'] = playerData.selectedPosition.value.id;
      data['website'] = playerData.website.text;

      if (playerData.birthCertificate.value.name != null) {
        data['birt_certificate_document'] = await MultipartFile.fromFile(
            playerData.birthCertificate.value.path!,
            filename: basename(playerData.birthCertificate.value.path!));
      }

      if (playerData.kk.value.name != null) {
        data['kk_document'] = await MultipartFile.fromFile(
            playerData.kk.value.path!,
            filename: basename(playerData.kk.value.path!));
      }

      if (playerData.ijazah.value.name != null) {
        data['ijazah_document'] = await MultipartFile.fromFile(
            playerData.ijazah.value.path!,
            filename: basename(playerData.ijazah.value.path!));
      }

      if (playerData.raport.value.name != null) {
        data['raport_document'] = await MultipartFile.fromFile(
            playerData.raport.value.path!,
            filename: basename(playerData.raport.value.path!));
      }
    }

    if (userData.value.isCoach) {
      if (ektp?.path != null) {
        data['ktp'] = await MultipartFile.fromFile(ektp!.path,
            filename: basename(ektp!.path));
      }
      if (coachData.selectedSpecialist.isNotEmpty) {
        data['specialists[]'] =
            coachData.selectedSpecialist.map((e) => e.id).toList();
      }
    }

    if (userData.value.isClub) {
      if (clubData.klb != null) {
        data['klb_document'] = await MultipartFile.fromFile(clubData.klb!.path,
            filename: basename(clubData.klb!.path));
      }
    }

    if (photo.value.name != null) {
      data['photo'] =
          "data:image/${extension(photo.value.path!).replaceAll(".", "")};base64,${base64Encode(photo.value.bytesSync!)}";
    }
    return FormData.fromMap(data);
  }

  bool get completeData {
    if (userData.value.isClub) {
      if (userData.value.klb != null) {
        if (userData.value.klb?.status?.id != 2) {
          return true;
        }
      }
    } else if (userData.value.isCoach) {
      if (userData.value.ktp != null) {
        if (userData.value.ktp?.status?.id != 2) {
          return true;
        }
      }
    } else if (userData.value.isPlayer) {
      if (userData.value.player?.name.isBlank == false &&
          userData.value.player?.gender?.name != null &&
          userData.value.player?.dateOfBirth != null) {
        return true;
      }
    }
    return false;
  }

  PlayerPersonalDataController get playerData => _playerPersonalData;
  CoachPersonalDataController get coachData => _coachPersonalData;
  ClubPersonalDataController get clubData => _clubPersonalData;
}
