import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class_category.dart';
import 'package:mobile_pssi/data/model/class_level.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/status.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/data/requests/class_category.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/image_validator.dart';
import 'package:path/path.dart';

class AddClassController extends BaseController {
  final _classRequest = ClassRequest();
  final _categoryRequest = ClassCategoryRequest();
  final addForm = GlobalKey<FormState>(debugLabel: 'Add Class');
  final isPremium = false.obs;
  final toggleSelecteds = [
    true,
    false,
  ].obs;
  final className = TextEditingController();
  final description = TextEditingController();
  final levels = <ClassLevel>[].obs;
  ClassLevel? selectedLevel;
  final categories = Resource<List<ClassCategory>>(data: []).obs;
  ClassCategory? selectedCategory;
  final statuses = [
    const Status(id: 1, name: 'Aktif'),
    const Status(id: 2, name: 'Non-Aktif'),
  ];
  Status? selectedStatus;
  final thumbnail = TextEditingController();
  File? thumbnailFile;
  final uploadData = false.obs;
  final validUrlThumbnail = false.obs;
  final isUploading = false.obs;

  @override
  void onInit() {
    getUserData();
    _initialize();
    super.onInit();
    debounce(thumbnail.text.obs, onManualEditThumbnail);
  }

  _initialize() async {
    EasyLoading.show();
    await _fetchLevels();
    await _fetchCategories();
    EasyLoading.dismiss();
  }

  _fetchLevels() async {
    levels(await _classRequest.getClassLevel(option: 'select', orderBy: 'asc'));
  }

  _fetchCategories() async {
    categories(await _categoryRequest.gets(option: 'select', orderBy: 'asc'));
  }

  changeLevel(ClassLevel? classLevel) {
    selectedLevel = classLevel;
  }

  changeCategory(ClassCategory? classCategory) {
    selectedCategory = classCategory;
  }

  changeStatus(Status? status) {
    selectedStatus = status;
  }

  changeClassType(int? value) {
    for (int i = 0; i < toggleSelecteds.length; i++) {
      toggleSelecteds[i] = i == value;
    }
    isPremium(value == 1 ? true : false);
    toggleSelecteds.refresh();
  }

  pickImageFile() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowMultiple: false,
      dialogTitle: 'Pilih Thumbnail',
      type: FileType.image,
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

  formData() async {
    return FormData.fromMap({
      'name': className.text,
      'description': description.text,
      'is_premium': isPremium.value,
      'class_level_id': selectedLevel?.id,
      'class_category_id': selectedCategory?.id,
      'thumbnail': thumbnailFile == null
          ? null
          : await MultipartFile.fromFile(thumbnailFile!.path,
              filename: basename(thumbnailFile!.path)),
      'thumbnail_url': thumbnail.text.isURL ? thumbnail.text : null,
      'status': selectedStatus?.id,
    });
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

  addClass() async {
    if (addForm.currentState!.validate()) {
      try {
        EasyLoading.show();
        await _classRequest.createClass(await formData());
        EasyLoading.dismiss();
        Get.back();
        getSnackbar('Informasi', 'Berhasil menambahkan kelas');
      } catch (e) {
        EasyLoading.dismiss();
        getSnackbar('Informasi', e.toString());
      }
    }
  }
}
