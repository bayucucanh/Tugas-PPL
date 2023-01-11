import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/age_group.dart';
import 'package:mobile_pssi/data/model/gender.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class NewTeamController extends BaseController {
  final formKey = GlobalKey<FormState>(debugLabel: 'new_team');
  final _teamRequest = TeamRequest();
  final teamName = TextEditingController();
  final _image = FileObservable().obs;
  final ageGroups = Resource<List<AgeGroup>>(data: []).obs;
  final selectedAgeGroup = const AgeGroup().obs;
  final genders = <Gender>[
    const Gender(id: 1, name: 'Pria'),
    const Gender(id: 2, name: 'Wanita'),
    const Gender(id: 3, name: 'Campuran'),
  ].obs;
  final selectedGender = const Gender().obs;
  final isUploading = false.obs;

  @override
  void onInit() {
    _fetchAgeGroups();
    super.onInit();
  }

  changeGender(Gender? gender) {
    selectedGender(gender);
  }

  _fetchAgeGroups() async {
    try {
      EasyLoading.show();
      var resp = await _teamRequest.fetchAgeGroups(option: 'select');
      ageGroups.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  changeAgeGroup(AgeGroup? ageGroup) {
    selectedAgeGroup(ageGroup);
  }

  selectFile(FileObservable? file) {
    _image(file);
  }

  save() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        isUploading(true);
        FormData data = FormData.fromMap({
          'image': _image.value.name == null
              ? null
              : await MultipartFile.fromFile(_image.value.path!,
                  filename: _image.value.name),
          'name': teamName.text,
          'age_group_id': selectedAgeGroup.value.id,
          'gender': selectedGender.value.id,
        });
        await _teamRequest.createTeam(data: data);
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
