import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/subscriptions/controller/inactive_subscription.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class InactiveSubscriptions extends GetView<InactiveSubscriptionController> {
  const InactiveSubscriptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InactiveSubscriptionController());
    return Obx(
      () => SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: controller.subscriptions!.isEmpty
            ? const EmptyWithButton(
                emptyMessage: 'Tidak memiliki langganan',
                showButton: false,
                showImage: true,
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  final subscription = controller.subscriptions?[index];
                  return HStack([
                    VStack([
                      (subscription?.product?.name ?? '-').text.semiBold.make(),
                      UiSpacer.verticalSpace(space: 10),
                      (subscription?.product?.description ?? '-')
                          .text
                          .gray500
                          .sm
                          .make(),
                      UiSpacer.verticalSpace(),
                      (subscription?.expiredFormat ?? '-')
                          .text
                          .sm
                          .color(primaryColor)
                          .make(),
                    ]).expand(),
                    VStack([
                      (subscription?.expiredTime ?? '-').text.sm.make(),
                    ])
                  ]).p12().card.make();
                },
                itemCount: controller.subscriptions?.length ?? 0,
              ),
      ),
    );
  }
}
