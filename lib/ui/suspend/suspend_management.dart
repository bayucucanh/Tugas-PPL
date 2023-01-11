import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/suspend/controller/suspend_management.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class SuspendManagement extends GetView<SuspendManagementController> {
  static const routeName = '/suspends';
  const SuspendManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SuspendManagementController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Manajemen Suspend'.text.make(),
      actions: [
        IconButton(
            onPressed: controller.addSuspend,
            icon: const Icon(Icons.my_library_add_rounded))
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(() => controller.suspends!.isEmpty
            ? EmptyWithButton(
                emptyMessage: 'Belum ada suspend dibuat',
                showImage: true,
                onTap: controller.addSuspend,
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final suspend = controller.suspends?[index];
                  return Slidable(
                    key: ValueKey(suspend?.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              controller.confirmDelete(suspend),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: (suspend?.name ?? '-').text.make(),
                      subtitle: (suspend?.durationFormat ?? '-')
                          .text
                          .sm
                          .ellipsis
                          .maxLines(2)
                          .make(),
                    ),
                  );
                },
                itemCount: controller.suspends?.length ?? 0,
              )),
      ).p12(),
    );
  }
}
