import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/class/controller/scanner_player_class.controller.dart';
import 'package:mobile_pssi/ui/class/parts/my_class_progress.card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ScannedPlayerClass extends GetView<ScannerPlayerClassController> {
  static const routeName = '/class/qrcode';
  const ScannedPlayerClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ScannerPlayerClassController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Kelas Diikuti Pemain'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.classes.value.data!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Pemain ini belum pernah mengikuti kelas',
                  showButton: false,
                  showImage: true,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  semanticChildCount:
                      controller.classes.value.data?.length ?? 0,
                  itemCount: controller.classes.value.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final myClass = controller.classes.value.data![index];
                    return myClass.deletedAt == null
                        ? MyClassProgressCard(
                            myClass: myClass,
                          )
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
    );
  }
}
