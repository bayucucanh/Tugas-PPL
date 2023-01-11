import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/skill.dart';
import 'package:mobile_pssi/data/model/skill_video.dart';
import 'package:mobile_pssi/data/model/video.model.dart';
import 'package:mobile_pssi/data/requests/skill.request.dart';
import 'package:mobile_pssi/data/requests/video.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/image_validator.dart';
import 'package:path/path.dart';

class EditVideoController extends BaseController {
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
  final videoDetail = VideoModel().obs;
  final skills = Resource<List<Skill>>(data: []).obs;
  final selectedSkills = <Skill>[].obs;
  final isUploading = false.obs;

  EditVideoController() {
    videoDetail(VideoModel.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    getUserData();
    _fetchSkills();
    _initialize();
    super.onInit();
  }

  _initialize() {
    premium(videoDetail.value.isPremiumStatus);
    videoPremiums[0] =
        videoDetail.value.isPremiumStatus == false ? true : false;
    videoPremiums[1] = videoDetail.value.isPremiumStatus == true ? true : false;
    if (videoDetail.value.video?.isLocalProvider == false) {
      youtubeLink(true);
      videoTypes[0] = true;
      videoTypes[1] = false;
      youtubeLinkTx.text = videoDetail.value.video?.url ?? '';
    } else {
      youtubeLink(false);
      videoTypes[0] = false;
      videoTypes[1] = true;
    }
    titleVideo.text = videoDetail.value.name ?? '';
    description.text = videoDetail.value.description ?? '';
    hasTask(videoDetail.value.hasTask);
    tasks[0] = videoDetail.value.hasTask == true ? false : true;
    tasks[1] = videoDetail.value.hasTask == true ? true : false;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (videoDetail.value.videoSkills!.isNotEmpty) {
        selectedSkills(skills.value.data
            ?.where((skill) =>
                videoDetail.value.videoSkills?.firstWhere(
                    (videoSkill) => videoSkill.id == 3,
                    orElse: () => SkillVideo()) !=
                null)
            .toList());
      }
    });
    if (videoDetail.value.thumbnails?.hightQuality != null) {
      if (!videoDetail.value.thumbnails!.origin!.contains(F.hostname)) {
        thumbnail.text = videoDetail.value.thumbnails?.origin ?? '';
      }
    }
    checkUrlImageValid();
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
    if (value == 1) {
      premium(true);
    } else {
      premium(false);
    }
  }

  changeVideoType(int? value) {
    for (int i = 0; i < videoTypes.length; i++) {
      videoTypes[i] = i == value;
    }
    if (value == 1) {
      youtubeLink(false);
      youtubeLinkTx.clear();
    } else {
      youtubeLink(true);
      localVideo = null;
      fileSelected(false);
    }
  }

  changeTask(int? value) {
    for (int i = 0; i < tasks.length; i++) {
      tasks[i] = i == value;
    }
    if (value == 1) {
      hasTask(true);
    } else {
      hasTask(false);
    }
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
      'class_id': videoDetail.value.classId,
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
      'skills[]': selectedSkills.isEmpty == true
          ? null
          : selectedSkills.map((element) => element.id).toList(),
    });
  }

  selectSkills(List<Skill> skills) {
    selectedSkills.clear();
    selectedSkills.addAll(skills);
  }

  editVideo() async {
    try {
      if (addForm.currentState!.validate()) {
        EasyLoading.show();
        isUploading(true);
        Get.focusScope?.unfocus();
        await _videoRequest.editVideo(
            videoId: videoDetail.value.id!, data: await formData());
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
