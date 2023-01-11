import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/class_category.dart';
import 'package:mobile_pssi/data/model/class_level.dart';
import 'package:mobile_pssi/data/model/status.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/ui/class/controller/edit_class.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class EditClass extends GetView<EditClassController> {
  static const routeName = '/class/edit';
  const EditClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EditClassController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: 'Ubah Kelas'.text.make(),
        resizeToAvoidBottomInset: false,
        actions: [
          TextButton(
            onPressed: controller.isUploading.value == true
                ? null
                : controller.editClass,
            child: 'Simpan'
                .text
                .color(
                    controller.isUploading.value ? Colors.grey : Colors.white)
                .make(),
          ),
        ],
        body: Form(
          key: controller.editForm,
          child: VStack([
            'Tipe Kelas'.text.semiBold.lg.make(),
            UiSpacer.verticalSpace(space: 10),
            ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              selectedColor: Colors.white,
              selectedBorderColor: primaryColor,
              fillColor: primaryColor,
              isSelected: controller.toggleSelecteds.toList(),
              onPressed: (value) => controller.changeClassType(value),
              children: [
                'Kelas Gratis'.text.make().p8(),
                'Kelas Premium'.text.make().p8(),
              ],
            ).h(40),
            UiSpacer.verticalSpace(),
            TextFormField(
              textInputAction: TextInputAction.done,
              controller: controller.className,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Nama kelas tidak boleh kosong';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Nama Kelas',
              ),
            ),
            UiSpacer.verticalSpace(),
            TextFormField(
              textInputAction: TextInputAction.newline,
              controller: controller.description,
              decoration: const InputDecoration(
                hintText: 'Deskripsi',
              ),
              minLines: 5,
              maxLines: 5,
            ),
            UiSpacer.verticalSpace(),
            controller.levels.isEmpty
                ? ''.text.make().skeleton(height: 40)
                : DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: controller.selectedLevel.value.name ?? 'Level',
                    ),
                    validator: (ClassLevel? value) {
                      if (controller.selectedLevel.value.id == null) {
                        return 'Level harus dipilih';
                      }
                      return null;
                    },
                    items: controller.levels
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: (e.name ?? '-').text.make(),
                            ))
                        .toList(),
                    onChanged: controller.changeLevel,
                  ),
            UiSpacer.verticalSpace(),
            DropdownButtonFormField<ClassCategory>(
              decoration: InputDecoration(
                hintText: controller.selectedCategory.value.name ?? 'Kategori',
              ),
              validator: (value) {
                if (controller.selectedCategory.value.id == null) {
                  return 'Kategori harus dipilih';
                }
                return null;
              },
              items: controller.categories.value.data!
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: (e.name ?? '-').text.make(),
                      ))
                  .toList(),
              onChanged: controller.changeCategory,
            ),
            UiSpacer.verticalSpace(),
            ImageCustom(
              url: controller.classDetail!.thumbnails!.origin!,
              blurhash: controller.classDetail?.blurhash,
            ).h(180).wFull(context).centered(),
            UiSpacer.verticalSpace(),
            TextFormField(
              controller: controller.thumbnail,
              textInputAction: TextInputAction.done,
              onEditingComplete: controller.checkUrlImageValid,
              validator: (value) {
                if (controller.thumbnailFile.value.name == null) {
                  if (value.isNotEmptyAndNotNull) {
                    if (value!.isURL) {
                      return 'Thumbnail url tidak valid';
                    }

                    if (controller.validUrlThumbnail.value == false) {
                      return 'Url gambar tidak valid';
                    }
                  }
                }
                return null;
              },
              onChanged: controller.onManualEditThumbnail,
              decoration: InputDecoration(
                hintText: 'Thumbnail (URL atau File)',
                suffixIcon: HStack([
                  IconButton(
                      onPressed: controller.pickImageFile,
                      icon: const Icon(Icons.upload_file_rounded)),
                  IconButton(
                    onPressed: controller.clearThumbnail,
                    icon: const Icon(Icons.clear),
                  ),
                ]),
              ),
            ),
            UiSpacer.verticalSpace(),
            DropdownButtonFormField<Status>(
              decoration: InputDecoration(
                hintText: controller.selectedStatus.value.name ?? 'Status',
              ),
              validator: (value) {
                if (controller.selectedStatus.value.id == null) {
                  return 'Status harus dipilih';
                }
                return null;
              },
              items: controller.statuses
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: (e.name ?? '-').text.make(),
                      ))
                  .toList(),
              onChanged: controller.changeStatus,
            ),
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
