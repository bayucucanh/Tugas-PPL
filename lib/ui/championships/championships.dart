import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/championships/controller/championships.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class Championships extends GetView<ChampionshipsController> {
  static const routeName = '/championships';
  const Championships({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChampionshipsController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Kejuaraan'.text.make(),
      actions: [
        if (controller.userData.value.id == controller.user.id)
          IconButton(
            onPressed: controller.addChampionship,
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
          child: controller.championships.value.data!.isEmpty
              ? controller.userData.value.id == controller.user.id
                  ? EmptyWithButton(
                      emptyMessage: 'Belum ada kejuaraan ditambahkan',
                      textButton: 'Tambah Kejuaraan',
                      onTap: controller.addChampionship,
                    )
                  : 'Belum ada kejuaraan'.text.makeCentered()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.championships.value.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final championship =
                        controller.championships.value.data?[index];
                    return ListTile(
                        trailing:
                            controller.userData.value.id == controller.user.id
                                ? Chip(
                                    label: 'Hapus'.text.make(),
                                    onDeleted: () =>
                                        controller.deleteDialog(championship),
                                  )
                                : null,
                        title:
                            (championship?.name ?? '-').text.sm.semiBold.make(),
                        subtitle: VStack([
                          (championship?.position ?? '-').text.make(),
                          UiSpacer.verticalSpace(space: 5),
                          (championship?.year ?? '').text.make()
                        ]));
                  },
                ),
        ),
      ).p12(),
    );
  }
}
