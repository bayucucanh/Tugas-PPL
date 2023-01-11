import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/coach/controller/coaches.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachList extends GetView<CoachesController> {
  static const routeName = '/coach/list';
  const CoachList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CoachesController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Pelatih'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.coaches!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Belum ada pelatih terdaftar',
                  showButton: false,
                  showImage: true,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final coach = controller.coaches?[index];
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage:
                            CachedNetworkImageProvider(coach!.imageProfile),
                      ).badge(
                        color:
                            coach.isOnline == true ? Colors.green : Colors.grey,
                      ),
                      title: (coach.profile?.name ?? '-').text.make(),
                      subtitle:
                          (coach.classificationUser?.todaySchedule != null)
                              ? HStack([
                                  const Icon(
                                    Icons.work_history_rounded,
                                    size: 16,
                                  ),
                                  UiSpacer.horizontalSpace(space: 5),
                                  (coach.classificationUser?.todaySchedule
                                              ?.workTime ??
                                          '-')
                                      .text
                                      .sm
                                      .make()
                                ])
                              : 'Tidak ada jadwal konsultasi untuk hari ini'
                                  .text
                                  .xs
                                  .make(),
                      onTap: () => controller.openCoach(coach),
                    );
                  },
                  itemCount: controller.coaches?.length ?? 0,
                ),
        ),
      ),
    );
  }
}
