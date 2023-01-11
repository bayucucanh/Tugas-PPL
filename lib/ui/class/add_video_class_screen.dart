import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/class/controller/add_video.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:path/path.dart';
import 'package:velocity_x/velocity_x.dart';

class AddVideoClassScreen extends GetView<AddVideoController> {
  static const routeName = '/class/video/add';
  const AddVideoClassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AddVideoController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Tambah Video Baru'.text.make(),
      resizeToAvoidBottomInset: false,
      actions: [
        Obx(
          () => TextButton(
            onPressed:
                controller.isUploading.value ? null : controller.addVideo,
            child: 'Simpan'
                .text
                .color(
                    controller.isUploading.value ? Colors.grey : Colors.white)
                .make(),
          ),
        ),
      ],
      body: Obx(
        () => Form(
          key: controller.addForm,
          child: VStack([
            'Video Premium?'.text.semiBold.lg.make(),
            'Apakah video ini hanya boleh dilihat oleh pemain premium?'
                .text
                .xs
                .gray500
                .make(),
            UiSpacer.verticalSpace(space: 10),
            ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              selectedColor: Colors.white,
              selectedBorderColor: primaryColor,
              fillColor: primaryColor,
              isSelected: controller.videoPremiums.toList(),
              onPressed: (value) => controller.changeVideoPremium(value),
              children: [
                'Video Gratis'.text.make().p8(),
                'Video Premium'.text.make().p8(),
              ],
            ).h(40),
            UiSpacer.verticalSpace(),
            'Tipe Video'.text.semiBold.lg.make(),
            'Anda dapat memilih sumber data file lokal apabila akun anda merupakan premium.'
                .text
                .xs
                .gray500
                .make(),
            UiSpacer.verticalSpace(space: 10),
            ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              selectedColor: Colors.white,
              selectedBorderColor: primaryColor,
              fillColor: primaryColor,
              isSelected: controller.videoTypes.toList(),
              onPressed: (value) => controller.changeVideoType(value),
              children: [
                'Link Youtube'.text.make().p8(),
                'File Lokal'.text.make().p8(),
              ],
            ).h(40),
            UiSpacer.verticalSpace(),
            Visibility(
              visible: controller.youtubeLink.value,
              replacement: VStack([
                (controller.fileSelected.value == false
                        ? 'Belum ada file video dipilih'
                        : controller.localVideo == null
                            ? 'Belum ada file video dipilih'
                            : basename(controller.localVideo!.path))
                    .text
                    .make(),
                UiSpacer.verticalSpace(space: 10),
                (controller.fileSelected.value == false
                        ? 'Pilih Video'
                        : 'Ubah Video')
                    .text
                    .white
                    .makeCentered()
                    .continuousRectangle(
                      height: 40,
                      backgroundColor: controller.fileSelected.value == false
                          ? primaryColor
                          : Colors.grey,
                    )
                    .onInkTap(controller.pickVideoFile),
              ]),
              child: TextFormField(
                controller: controller.youtubeLinkTx,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'URL video tidak boleh kosong';
                  }
                  if (!value.isURL) {
                    return 'Link URL tidak valid';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'URL Video *',
                ),
              ),
            ),
            UiSpacer.verticalSpace(),
            TextFormField(
              textInputAction: TextInputAction.done,
              controller: controller.titleVideo,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Judul video tidak boleh kosong';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintText: 'Judul Video *',
              ),
            ),
            UiSpacer.verticalSpace(),
            TextFormField(
              textInputAction: TextInputAction.done,
              controller: controller.description,
              decoration: const InputDecoration(
                hintText: 'Deskripsi Video',
              ),
              minLines: 5,
              maxLines: 5,
              maxLength: 250,
            ),
            UiSpacer.verticalSpace(),
            TextFormField(
              controller: controller.thumbnail,
              textInputAction: TextInputAction.done,
              onEditingComplete: controller.checkUrlImageValid,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Thumbnail tidak boleh kosong';
                }

                if (controller.thumbnailFile == null) {
                  if (!value.isURL) {
                    return 'Thumbnail url tidak valid';
                  }

                  if (controller.validUrlThumbnail.value == false) {
                    return 'Url gambar tidak valid';
                  }
                }
                return null;
              },
              onChanged: controller.onManualEditThumbnail,
              decoration: InputDecoration(
                hintText: 'Thumbnail (URL atau File) *',
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
            'Berikan Tugas?'.text.semiBold.lg.make(),
            'Apabila anda ingin memberikan tugas untuk video ini pilih "YA" jika tidak pilih "Tidak"'
                .text
                .xs
                .gray500
                .make(),
            UiSpacer.verticalSpace(space: 10),
            ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              selectedColor: Colors.white,
              selectedBorderColor: primaryColor,
              fillColor: primaryColor,
              isSelected: controller.tasks.toList(),
              onPressed: (value) => controller.changeTask(value),
              children: [
                'Tidak'.text.make().p8(),
                'Ya'.text.make().p8(),
              ],
            ).h(40),
            UiSpacer.verticalSpace(),
            'Topik'.text.semiBold.lg.make(),
            MultiSelectDialogField(
              onConfirm: controller.selectSkills,
              listType: MultiSelectListType.CHIP,
              selectedColor: primaryColor,
              searchable: true,
              selectedItemsTextStyle: const TextStyle(
                color: Colors.white,
              ),
              items: controller.skills.value.data!
                  .map((e) => MultiSelectItem(e, e.name ?? '-'))
                  .toList(),
            ),
          ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
