import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/payment/controller/payment_history.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentHistory extends GetView<PaymentHistoryController> {
  static const routeName = '/payment/history';
  const PaymentHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PaymentHistoryController());
    return DefaultScaffold(
      title: 'Riwayat Pembayaran'.text.makeCentered(),
      backgroundColor: Get.theme.backgroundColor,
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.histories.value.data!.isEmpty
              ? VStack(
                  [
                    SvgPicture.asset('assets/images/undraw_empty_re_opql.svg')
                        .h(150),
                    UiSpacer.verticalSpace(),
                    'Belum ada riwayat pembayaran'.text.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                ).centered()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.histories.value.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final order = controller.histories.value.data?[index];
                    return HStack([
                      VxBox(
                        child: Icon(
                          order?.transferType == 'in'
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: order?.transferType == 'in'
                              ? Vx.green500
                              : primaryColor,
                        ),
                      ).border(color: Vx.gray300).roundedSM.make(),
                      UiSpacer.horizontalSpace(),
                      VStack([
                        '#${order?.code ?? '-'}'.text.medium.semiBold.make(),
                        (order?.status?.name ?? '-')
                            .text
                            .xs
                            .color(order?.status?.paymentStatusColor())
                            .make(),
                        (order?.createdAtFormat ?? '-').text.xs.make(),
                      ]).expand(),
                      UiSpacer.horizontalSpace(space: 10),
                      HStack(
                        [
                          (order?.transferType == 'in' ? '+' : '-')
                              .text
                              .color(order?.transferType == 'in'
                                  ? Vx.green500
                                  : primaryColor)
                              .semiBold
                              .make(),
                          (order?.totalPriceFormat ?? '-')
                              .text
                              .semiBold
                              .color(order?.transferType == 'in'
                                  ? Vx.green500
                                  : primaryColor)
                              .make(),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      )
                    ]).p12().card.make();
                  }),
        ),
      ),
    );
  }
}
