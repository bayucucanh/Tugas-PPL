import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/class/controller/my_class.controller.dart';
import 'package:mobile_pssi/ui/class/parts/my_class_progress.card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class MyClassScreen extends GetView<MyClassController> {
  const MyClassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MyClassController());
    return Obx(
      () => DefaultTabController(
        length: controller.tabs.length,
        initialIndex: controller.currentTab.value,
        child: DefaultScaffold(
          title: 'Kelasku'.text.make(),
          backgroundColor: Get.theme.backgroundColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            child: TabBar(
              isScrollable: true,
              onTap: controller.changeClassLevel,
              labelColor: Vx.white,
              tabs: controller.tabs
                  .map((tab) => Tab(
                        text: tab.name ?? '-',
                      ))
                  .toList(),
            ),
          ),
          body: SmartRefresher(
            controller: controller.refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: controller.refreshData,
            onLoading: controller.loadMore,
            child: controller.classes.value.data!.isEmpty
                ? EmptyWithButton(
                    emptyMessage:
                        'Belum pernah mengikuti kelas? Yuk kita cari kelas yang cocok buat kamu.',
                    textButton: 'Cari Kelas',
                    onTap: controller.goClasses,
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    semanticChildCount:
                        controller.classes.value.data?.length ?? 0,
                    itemCount: controller.classes.value.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final myClass = controller.classes.value.data![index];
                      return myClass.deletedAt == null
                          ? MyClassProgressCard(
                              myClass: myClass,
                              onRate: () =>
                                  controller.openRatingDialog(myClass),
                            ).onTap(() => controller.viewClass(myClass))
                          : VStack(
                              [
                                '${myClass.className} sudah ditutup permanen.'
                                    .text
                                    .center
                                    .sm
                                    .make(),
                                'Terimakasih telah mengikuti kelas ini.'
                                    .text
                                    .semiBold
                                    .make(),
                              ],
                              alignment: MainAxisAlignment.center,
                              crossAlignment: CrossAxisAlignment.center,
                            ).p12().card.gray100.make();
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
