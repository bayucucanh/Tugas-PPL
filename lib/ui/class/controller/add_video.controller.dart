import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/skill.dart';
import 'package:mobile_pssi/data/requests/skill.request.dart';
import 'package:mobile_pssi/data/requests/video.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/image_validator.dart';
import 'package:path/path.dart';

class AddVideoController extends BaseController {
  final _videoRequest = VideoRequest();
  final _skillRequest = SkillRequest();
  final addForm = GlobalKey<FormState>(debugLabel: 'Add Video');
  final videoPremiums = [
    true,
    false,
  ].obs;
  final premium = false.obs;
  final videoTypes = [
    true,
    false,
  ].obs;
  final youtubeLinkTx = TextEditingController();
  final youtubeLink = true.obs;
  File? localVideo;
  final fileSelected = false.obs;
  final titleVideo = TextEditingController();
  final description = TextEditingController();
  final thumbnail = TextEditingController();
  File? thumbnailFile;
  final validUrlThumbnail = false.obs;
  final tasks = [
    true,
    false,
  ].obs;
  final hasTask = false.obs;
  final classData = Class().obs;
  final skills = Resource<List<Skill>>(data: []).obs;
  final selectedSkills = <Skill>[].obs;
  final isUploading = false.obs;

  AddVideoController() {
    classData(Class.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    getUserData();
    _fetchSkills();
    super.onInit();
  }

  _fetchSkills() async {
    try {
      EasyLoading.show();
      skills(await _skillRequest.getSkills());
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  changeVideoPremium(int? value) {
    for (int i = 0; i < videoPremiums.length; i++) {
      videoPremiums[i] = i == value;
    }
    premium(value == 1 ? true : false);
  }

  changeVideoType(int? value) {
    for (int i = 0; i < videoTypes.length; i++) {
      videoTypes[i] = i == value;
    }
    youtubeLink(value == 1 ? false : true);
    if (value == 1) {
      youtubeLinkTx.clear();
    } else {
      localVideo = null;
      fileSelected(false);
    }
  }

  changeTask(int? value) {
    for (int i = 0; i < tasks.length; i++) {
      tasks[i] = i == value;
    }
    hasTask(value == 1 ? true : false);
  }

  pickVideoFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      allowedExtensions: [
        'mp4',
        'mkv',
      ],
      dialogTitle: 'Pilih Video',
      type: FileType.custom,
    );

    if (pickedFile != null) {
      localVideo = File(pickedFile.files.single.path!);
      fileSelected(true);
    } else {
      localVideo = null;
      fileSelected(false);
    }
  }

  checkUrlImageValid() async {
    if (thumbnailFile == null) {
      if (thumbnail.text.isURL) {
        if (await ImageValidator().getImage(thumbnail.text)) {
          validUrlThumbnail(true);
        } else {
          validUrlThumbnail(false);
        }
      }
    }
  }

  pickImageFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      allowCompression: false,
      allowMultiple: false,
      dialogTitle: 'Pilih Thumbnail',
      allowedExtensions: [
        'jpeg',
        'jpg',
        'png',
      ],
      type: FileType.custom,
    );

    if (pickedFile != null) {
      thumbnailFile = File(pickedFile.files.single.path!);
      thumbnail.text = basename(pickedFile.files.single.path!);
    }
  }

  onManualEditThumbnail(String? value) {
    if (value != null) {
      thumbnailFile = null;
      if (thumbnailFile == null) {
        if (value.isURL) {
          checkUrlImageValid();
        }
      }
    }
  }

  clearThumbnail() {
    thumbnail.clear();
    validUrlThumbnail(false);
    thumbnailFile = null;
  }

  Future<FormData> formData() async {
    return FormData.fromMap({
      'name': titleVideo.text,
      'class_id': classData.value.id,
      'description': description.text,
      'is_premium': premium.value ? 1 : 0,
      'video_file': localVideo == null
          ? null
          : await MultipartFile.fromFile(localVideo!.path,
              filename: basename(localVideo!.path)),
      'video_url':
          youtubeLinkTx.text.isBlank == true ? null : youtubeLinkTx.text,
      'thumbnail': thumbnailFile == null
          ? null
          : "data:image/${extension(thumbnailFile!.path).replaceAll(".", "")};base64,${base64Encode(File(thumbnailFile!.path).readAsBytesSync())}",
      'thumbnail_url': thumbnail.text.isURL ? thumbnail.text : null,
      'has_task': hasTask.value ? 1 : 0,
      'skills[]': selectedSkills.isBlank == true
          ? null
          : selectedSkills.map((element) => element.id).toList(),
    });
  }

  selectSkills(List<Skill> skills) {
    selectedSkills.clear();
    selectedSkills.addAll(skills);
  }

  addVideo() async {
    try {
      if (addForm.currentState!.validate()) {
        EasyLoading.show();
        isUploading(true);
        Get.focusScope?.unfocus();
        await _videoRequest.createVideo(data: await formData());
        EasyLoading.dismiss();
        isUploading(false);
        Get.back(result: 'success');
      }
    } catch (e) {
      isUploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
