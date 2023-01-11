import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/recent_educations/controller/educations.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class Educations extends GetView<EducationsController> {
  static const routeName = '/educations';
  const Educations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(EducationsController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Riwayat Pendidikan'.text.make(),
      actions: [
        if (controller.userData.value.id == controller.user.id)
          IconButton(
            onPressed: controller.addEducation,
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
          child: controller.educations.value.data!.isEmpty
              ? controller.userData.value.id == controller.user.id
                  ? EmptyWithButton(
                      emptyMessage: 'Belum ada riwayat pendidikan ditambahkan',
                      textButton: 'Tambah Riwayat Pendidikan',
                      onTap: controller.addEducation,
                    )
                  : 'Belum ada riwayat pendidikan'.text.makeCentered()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.educations.value.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final education = controller.educations.value.data?[index];
                    return ListTile(
                        trailing:
                            controller.userData.value.id == controller.user.id
                                ? Chip(
                                    label: 'Hapus'.text.make(),
                                    onDeleted: () =>
                                        controller.deleteDialog(education),
                                  )
                                : null,
                        title: (education?.schoolName ?? '-')
                            .text
                            .sm
                            .semiBold
                            .make(),
                        subtitle: VStack([
                          (education?.isFormal == true
                                  ? 'Formal'
                                  : 'Non-Formal')
                              .text
                              .make(),
                          UiSpacer.verticalSpace(space: 5),
                          (education?.degree ?? '').text.make()
                        ]));
                  },
                ),
        ),
      ).p12(),
    );
  }
}
