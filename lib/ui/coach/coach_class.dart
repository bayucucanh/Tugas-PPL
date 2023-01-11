import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/coach/controller/coach_class.controller.dart';
import 'package:mobile_pssi/ui/search/parts/search_class.card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachClass extends GetView<CoachClassController> {
  static const routeName = '/class/filter/coach';
  const CoachClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CoachClassController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Kelas '.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.classes!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Belum ada kelas',
                  showButton: false,
                  showImage: true,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final classData = controller.classes?[index];
                    return SearchClassCard(classData: classData!).onInkTap(
                      () => controller.showClass(classData),
                    );
                  },
                  itemCount: controller.classes?.length ?? 0,
                ),
        ),
      ),
    );
  }
}
