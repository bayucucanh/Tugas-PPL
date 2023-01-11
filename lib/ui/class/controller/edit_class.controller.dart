import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/class_category.dart';
import 'package:mobile_pssi/data/model/class_level.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/status.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/data/requests/class_category.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/image_validator.dart';
import 'package:path/path.dart';

class EditClassController extends BaseController {
  final _classRequest = ClassRequest();
  final _categoryRequest = ClassCategoryRequest();
  final _classDetail = Class().obs;
  final editForm = GlobalKey<FormState>(debugLabel: 'Edit Class');
  final isPremium = false.obs;
  final toggleSelecteds = <bool>[
    false,
    false,
  ].obs;
  final className = TextEditingController();
  final description = TextEditingController();
  final levels = <ClassLevel>[].obs;
  final selectedLevel = ClassLevel().obs;
  final categories = Resource<List<ClassCategory>>(data: []).obs;
  final selectedCategory = ClassCategory().obs;
  final statuses = [
    const Status(id: 1, name: 'Aktif'),
    const Status(id: 2, name: 'Nonaktif'),
  ];
  final selectedStatus = const Status().obs;
  final thumbnail = TextEditingController();
  final thumbnailFile = FileObservable().obs;
  final uploadData = false.obs;
  final validUrlThumbnail = false.obs;
  final isUploading = false.obs;

  EditClassController() {
    _classDetail(Class.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    getUserData();
    _initialize();
    super.onInit();
    debounce(thumbnail.text.obs, onManualEditThumbnail);
  }

  _fetchDefaultValue() {
    isPremium(classDetail?.isPremiumContent);
    toggleSelecteds[0] = classDetail?.isFreeContent == true ? true : false;
    toggleSelecteds[1] = classDetail?.isPremiumContent == true ? true : false;
    className.text = classDetail?.name ?? '';
    description.text = classDetail?.description ?? '';
    changeLevel(levels
        .firstWhereOrNull((level) => level.id == classDetail?.classLevelId));
    changeCategory(categories.value.data?.firstWhereOrNull(
        (category) => category.id == classDetail?.classCategoryId));

    if (classDetail?.thumbnails?.hightQuality != null) {
      if (!classDetail!.thumbnails!.origin!.contains(F.hostname)) {
        thumbnail.text = classDetail?.thumbnails?.origin ?? '';
      }
    }
    checkUrlImageValid();
    changeStatus(statuses
        .firstWhereOrNull((status) => status.name == classDetail?.status));
  }

  _initialize() async {
    EasyLoading.show();
    await _fetchLevels();
    await _fetchCategories();
    _fetchDefaultValue();
    EasyLoading.dismiss();
  }

  _fetchLevels() async {
    try {
      levels(
          await _classRequest.getClassLevel(option: 'select', orderBy: 'asc'));
    } catch (_) {}
  }

  _fetchCategories() async {
    categories(await _categoryRequest.gets(option: 'select', orderBy: 'asc'));
  }

  changeLevel(ClassLevel? classLevel) {
    selectedLevel(classLevel);
  }

  changeCategory(ClassCategory? classCategory) {
    selectedCategory(classCategory);
  }

  changeStatus(Status? status) {
    selectedStatus(status);
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
      thumbnailFile(FileObservable.filePickerResult(pickedFile));
      thumbnail.text = basename(pickedFile.files.single.path!);
    }
  }

  onManualEditThumbnail(String? value) {
    if (value != null) {
      thumbnailFile(null);
      if (thumbnailFile.value.name == null) {
        if (value.isURL) {
          checkUrlImageValid();
        }
      }
    }
  }

  clearThumbnail() {
    thumbnail.clear();
    validUrlThumbnail(false);
    thumbnailFile(null);
  }

  formData() async {
    return FormData.fromMap({
      'name': className.text,
      'description': description.text,
      'is_premium': isPremium.value,
      'class_level_id': selectedLevel.value.id,
      'class_category_id': selectedCategory.value.id,
      'thumbnail': thumbnailFile.value.name == null
          ? null
          : await MultipartFile.fromFile(thumbnailFile.value.path!,
              filename: thumbnailFile.value.name),
      'thumbnail_url': thumbnail.text.isURL ? thumbnail.text : null,
      'status': selectedStatus.value.id,
    });
  }

  checkUrlImageValid() async {
    if (thumbnailFile.value.name == null) {
      if (thumbnail.text.isURL) {
        if (await ImageValidator().getImage(thumbnail.text)) {
          validUrlThumbnail(true);
        } else {
          validUrlThumbnail(false);
        }
      }
    }
  }

  editClass() async {
    try {
      if (editForm.currentState!.validate()) {
        isUploading(true);
        EasyLoading.show();
        await _classRequest.updateClass(
            classId: classDetail!.id, data: await formData());
        EasyLoading.dismiss();
        isUploading(false);
        Get.back(result: 'success');
        getSnackbar('Informasi', 'Berhasil mengubah data kelas');
      }
    } catch (e) {
      isUploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  Class? get classDetail => _classDetail.value;
}
