import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/ui/competitions/controller/competitions.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class Competitions extends GetView<CompetitionsController> {
  static const routeName = '/competitions';
  const Competitions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CompetitionsController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Kompetisi'.text.make(),
      actions: [
        IconButton(
            onPressed: controller.addCompetition, icon: const Icon(Icons.add))
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(() => controller.events!.isEmpty
            ? EmptyWithButton(
                emptyMessage: 'Belum ada kompetisi dibuat',
                showImage: true,
                onTap: controller.addCompetition,
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final event = controller.events?[index];
                  return Slidable(
                    key: ValueKey(event?.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              controller.confirmDelete(event),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                        ),
                      ],
                    ),
                    child: ImageCustom(
                      url: event!.banner!,
                      blurhash: event.blurhash,
                    )
                        .cornerRadius(20)
                        .onTap(() => controller.openDetail(event)),
                  ).p4();
                },
                itemCount: controller.events?.length ?? 0,
              )),
      ).p12(),
    );
  }
}
