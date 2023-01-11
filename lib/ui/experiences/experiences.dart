import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/experiences/controller/experiences.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:velocity_x/velocity_x.dart';

class Experiences extends GetView<ExperiencesController> {
  static const routeName = '/experiences';
  const Experiences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ExperiencesController());
    return DefaultScaffold(
      title: 'Pengalaman'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      actions: [
        if (controller.userData.value.id == controller.user.id)
          IconButton(
            onPressed: controller.addExperience,
            icon: const Icon(Icons.add_rounded),
          )
      ],
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: controller.experiences.value.data!.isEmpty
              ? controller.userData.value.id == controller.user.id
                  ? EmptyWithButton(
                      emptyMessage:
                          'Belum ada sertifikat pengalaman ditambahkan',
                      textButton: 'Tambah Sertifikat',
                      onTap: controller.addExperience,
                    )
                  : 'Belum ada sertifikat pengalaman'.text.makeCentered()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.experiences.value.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final experience =
                        controller.experiences.value.data?[index];
                    return ExpansionTile(
                      trailing:
                          controller.userData.value.id == controller.user.id
                              ? Chip(
                                  label: 'Hapus'.text.make(),
                                  onDeleted: () =>
                                      controller.deleteDialog(experience),
                                )
                              : null,
                      title: (experience?.name ?? '-').text.sm.semiBold.make(),
                      children: [
                        controller.imageTypes.contains(experience?.fileType)
                            ? experience?.file == null
                                ? 'Gambar tidak tersedia'.text.make()
                                : CachedNetworkImage(
                                        imageUrl: experience!.file!)
                                    .cornerRadius(10)
                                    .h(200)
                                    .p8()
                            : experience?.file == null
                                ? 'Berkas tidak tersedia'.text.make()
                                : Thumbnail(
                                    mimeType: 'application/pdf',
                                    widgetSize: 200,
                                    decoration: WidgetDecoration(
                                      backgroundColor: Colors.blueAccent,
                                      iconColor: Colors.red,
                                    ),
                                    dataResolver: () => controller
                                        .getPdfThumbnail(experience!.file!),
                                  ).p8(),
                        UiSpacer.verticalSpace(space: 10),
                        (experience?.description ?? '-').text.make(),
                      ],
                    ).card.make();
                  },
                ),
        ),
      ).p12(),
    );
  }
}
