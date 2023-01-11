import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/voucher/controller/active_voucher.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class MyVouchers extends GetView<ActiveVoucherController> {
  static const routeName = '/vouchers/my';
  const MyVouchers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ActiveVoucherController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Lihat Voucher'.text.make(),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: controller.vouchers!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Tidak ada voucher',
                  showButton: false,
                  showImage: true,
                )
              : ListView.builder(
                  semanticChildCount: controller.vouchers?.length ?? 0,
                  itemCount: controller.vouchers?.length ?? 0,
                  itemExtent: 80,
                  itemBuilder: (context, index) {
                    final voucher = controller.vouchers?[index];
                    return ListTile(
                      title: (voucher?.name ?? '-').text.semiBold.make(),
                      subtitle: VStack([
                        (voucher?.code ?? '-').text.xs.ellipsis.make(),
                        (voucher?.description ?? '-').text.xs.ellipsis.make(),
                      ]),
                      onTap: () => controller.selectVoucher(voucher),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
