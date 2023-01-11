import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/achievement/controller/achievement.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class AchievementList extends GetView<AchievementController> {
  static const routeName = '/achievements';
  const AchievementList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AchievementController());
    return DefaultScaffold(
      title: 'Penghargaan'.text.make(),
      actions: [
        if (controller.userData.value.id == controller.user.id)
          IconButton(
            onPressed: controller.addNewAchievement,
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
          child: controller.achievements.value.data!.isEmpty
              ? controller.userData.value.id == controller.user.id
                  ? EmptyWithButton(
                      emptyMessage: 'Belum ada penghargaan ditambahkan',
                      textButton: 'Tambah Penghargaan',
                      onTap: controller.addNewAchievement,
                    )
                  : 'Belum ada penghargaan'.text.makeCentered()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.achievements.value.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final achievement =
                        controller.achievements.value.data?[index];
                    return ListTile(
                      trailing:
                          controller.userData.value.id == controller.user.id
                              ? Chip(
                                  label: 'Hapus'.text.make(),
                                  onDeleted: () =>
                                      controller.deleteDialog(achievement),
                                )
                              : null,
                      title: (achievement?.name ?? '-').text.sm.semiBold.make(),
                      subtitle: (achievement?.year ?? '').text.make(),
                    ).card.make();
                  },
                ),
        ),
      ).p12(),
    );
  }
}
