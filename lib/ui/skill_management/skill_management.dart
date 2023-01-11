import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/skill_management/controller/skill_management.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class SkillManagement extends GetView<SkillManagementController> {
  static const routeName = '/skills';
  const SkillManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SkillManagementController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Manajemen Keahlian'.text.make(),
      actions: [
        IconButton(
            onPressed: controller.addSkill,
            icon: const Icon(Icons.my_library_add_rounded))
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(() => controller.skills!.isEmpty
            ? EmptyWithButton(
                emptyMessage: 'Belum ada keahlian dibuat',
                showImage: true,
                onTap: controller.addSkill,
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final skill = controller.skills?[index];
                  return Slidable(
                    key: ValueKey(skill?.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              controller.confirmDelete(skill),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: (skill?.name ?? '-').text.make(),
                      subtitle: (skill?.description ?? '-')
                          .text
                          .sm
                          .ellipsis
                          .maxLines(2)
                          .make(),
                      onTap: () => controller.editSkill(skill),
                    ),
                  );
                },
                itemCount: controller.skills?.length ?? 0,
              )),
      ).p12(),
    );
  }
}
