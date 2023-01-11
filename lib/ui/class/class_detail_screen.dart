import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/ui/class/controller/class_detail.controller.dart';
import 'package:mobile_pssi/ui/class/parts/bottom.card.dart';
import 'package:mobile_pssi/ui/class/parts/summary_class_detail.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClassDetailScreen extends GetView<ClassDetailController> {
  static const routeName = '/class/detail';
  const ClassDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClassDetailController());
    return Obx(
      () => DefaultScaffold(
        centerTitle: false,
        backgroundColor: Get.theme.backgroundColor,
        title: VStack([
          (controller.classData.value.name ?? '-')
              .text
              .sm
              .semiBold
              .maxLines(1)
              .ellipsis
              .make(),
          '${controller.classData.value.status}'
              .text
              .sm
              .light
              .color(controller.classData.value.isActive
                  ? Colors.green
                  : Colors.red)
              .make(),
        ]),
        actions: [
          if (!controller.userData.value.hasRole('administrator'))
            IconButton(
              onPressed: controller.editClass,
              icon: const Icon(Icons.edit_rounded),
            ),
        ],
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              collapsedHeight: 260,
              pinned: true,
              floating: true,
              automaticallyImplyLeading: false,
              flexibleSpace: const SummaryClassDetail().p12(),
            ),
          ],
          body: SmartRefresher(
            controller: controller.refreshController,
            onRefresh: controller.refreshData,
            enablePullDown: true,
            enablePullUp: false,
            child: Obx(
              () => controller.classData.value.listVideo == null ||
                      controller.classData.value.listVideo!.isEmpty
                  ? EmptyWithButton(
                      emptyMessage: 'Belum ada video tersedia',
                      textButton: 'Tambah Video Baru',
                      showButton:
                          controller.userData.value.hasRole('administrator')
                              ? false
                              : true,
                      onTap: controller.openAddVideoForm,
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          controller.classData.value.listVideo?.length ?? 0,
                      itemBuilder: (context, index) {
                        final video =
                            controller.classData.value.listVideo?[index];
                        return ExpansionTile(
                          title: VStack([
                            HStack([
                              ImageCustom(
                                url: video!.thumbnails!.origin!,
                                blurhash: video.blurhash,
                              ).cornerRadius(10).wh(100, 100),
                              UiSpacer.horizontalSpace(space: 10),
                              VStack([
                                (video.name ?? '-')
                                    .text
                                    .semiBold
                                    .sm
                                    .ellipsis
                                    .make(),
                                UiSpacer.verticalSpace(space: 10),
                                HStack([
                                  const Icon(
                                    Icons.remove_red_eye_rounded,
                                    size: 12,
                                  ),
                                  UiSpacer.horizontalSpace(space: 5),
                                  '${video.totalView ?? 0}x dilihat'
                                      .text
                                      .xs
                                      .make(),
                                ]),
                                UiSpacer.verticalSpace(space: 5),
                                HStack([
                                  (video.isPremium ?? '-')
                                      .text
                                      .sm
                                      .white
                                      .make()
                                      .p4()
                                      .box
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .color(video.isPremiumStatus == true
                                          ? primaryColor
                                          : freeColor)
                                      .roundedSM
                                      .make(),
                                  if (video.hasTask == true)
                                    'Tugas'
                                        .text
                                        .sm
                                        .white
                                        .make()
                                        .p4()
                                        .box
                                        .margin(const EdgeInsets.symmetric(
                                            horizontal: 4))
                                        .color(primaryColor)
                                        .roundedSM
                                        .make(),
                                  (video.status ?? '-')
                                      .text
                                      .sm
                                      .white
                                      .make()
                                      .p4()
                                      .box
                                      .margin(const EdgeInsets.symmetric(
                                          horizontal: 4))
                                      .color(primaryColor)
                                      .roundedSM
                                      .make()
                                ])
                              ]),
                            ]),
                            UiSpacer.verticalSpace(space: 10),
                            HStack(
                              [
                                const Icon(
                                  Icons.date_range_rounded,
                                  color: Colors.white,
                                ),
                                (video.formatCreatedAt ?? '-')
                                    .text
                                    .sm
                                    .white
                                    .make(),
                                if (!controller.userData.value
                                    .hasRole('administrator'))
                                  HStack([
                                    const Icon(
                                      Icons.edit_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    UiSpacer.horizontalSpace(space: 5),
                                    'Ubah'.text.white.sm.make(),
                                  ]).onInkTap(
                                      () => controller.editVideo(video)),
                              ],
                              alignment: MainAxisAlignment.spaceEvenly,
                              axisSize: MainAxisSize.max,
                            ).p8().box.gray500.roundedSM.make(),
                          ]),
                          children: [BottomCard(video: video)],
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
