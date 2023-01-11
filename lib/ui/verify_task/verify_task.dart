import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/verify_task/controller/verify_task.controller.dart';
import 'package:mobile_pssi/ui/verify_task/parts/verify-list.card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class VerifyTask extends GetView<VerifyTaskController> {
  static const routeName = '/task/verify';
  const VerifyTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VerifyTaskController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Verifikasi Tugas'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshTask,
        onLoading: controller.loadMoreTask,
        child: Obx(
          () => controller.taskList.value.data!.isEmpty
              ? 'Belum ada tugas disubmit'.text.makeCentered()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.taskList.value.data?.length,
                  itemBuilder: (context, index) {
                    final task = controller.taskList.value.data?[index];
                    return VerifyListCard(task: task!)
                        .p8()
                        .onInkTap(() => controller.openDetail(task));
                  },
                ).p12(),
        ),
      ),
    );
  }
}
