import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/extensions/numeral.extension.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/image_custom.dart';
import 'package:mobile_pssi/ui/history/controller/history.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class HistoryScreen extends GetView<HistoryController> {
  static const routeName = '/history';
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HistoryController());
    return DefaultScaffold(
      title: 'Riwayat'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onLoading: controller.loadNextPage,
        onRefresh: controller.refreshPage,
        child: VStack([
          HStack([
            'Riwayat Menonton'.text.lg.semiBold.make().expand(),
          ]),
          Obx(() => controller.history.value.data!.isEmpty
              ? 'Belum ada riwayat menonton'.text.makeCentered().py(40)
              : ListView.builder(
                  itemCount: controller.history.value.data?.length,
                  shrinkWrap: true,
                  itemExtent: 150,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final history = controller.history.value.data?[index];
                    return InkWell(
                      onTap: () => controller.openClass(history),
                      borderRadius: BorderRadius.circular(4),
                      child: VStack([
                        HStack([
                          ImageCustom(
                            url: history!.learning!.thumbnails!.origin!,
                            blurhash: history.learning?.blurhash,
                          ).wh(200, 120).cornerRadius(10),
                          UiSpacer.horizontalSpace(space: 10),
                          VStack([
                            '${history.learning?.className} - ${history.learning?.name}'
                                .text
                                .semiBold
                                .ellipsis
                                .maxLines(2)
                                .make(),
                            UiSpacer.verticalSpace(space: 10),
                            HStack([
                              const Icon(
                                Icons.face,
                                size: 14,
                                color: primaryColor,
                              ),
                              UiSpacer.horizontalSpace(space: 5),
                              (history.learning?.createdBy ?? '-')
                                  .text
                                  .sm
                                  .ellipsis
                                  .gray500
                                  .make()
                                  .expand(),
                            ]),
                            HStack([
                              const Icon(
                                Icons.remove_red_eye_rounded,
                                size: 14,
                                color: primaryColor,
                              ),
                              UiSpacer.horizontalSpace(space: 5),
                              UiSpacer.verticalSpace(space: 10),
                              '${history.learning?.totalView!.numeral()} views'
                                  .text
                                  .sm
                                  .gray500
                                  .make(),
                            ]),
                            UiSpacer.horizontalSpace(space: 5),
                            HStack([
                              const Icon(
                                Icons.date_range_rounded,
                                size: 14,
                                color: primaryColor,
                              ),
                              UiSpacer.horizontalSpace(space: 5),
                              '${history.createdAtFormat}'
                                  .text
                                  .sm
                                  .maxLines(2)
                                  .gray500
                                  .make()
                                  .expand(),
                            ]),
                          ]).expand(),
                        ]),
                        UiSpacer.divider(height: 15)
                      ]).box.p4.roundedSM.make(),
                    );
                  },
                ))
        ]).p12().scrollVertical(),
      ),
    );
  }
}
