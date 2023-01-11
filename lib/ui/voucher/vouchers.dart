import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/voucher/controller/voucher.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class Vouchers extends GetView<VoucherController> {
  static const routeName = '/vouchers';
  const Vouchers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VoucherController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Voucher'.text.make(),
      actions: [
        IconButton(
          onPressed: controller.addVoucher,
          icon: const Icon(
            Icons.add_rounded,
          ),
        ),
      ],
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: controller.vouchers!.isEmpty
              ? EmptyWithButton(
                  emptyMessage: 'Tidak ada voucher',
                  textButton: 'Buat Voucher',
                  onTap: controller.addVoucher,
                )
              : ListView.builder(
                  semanticChildCount: controller.vouchers?.length ?? 0,
                  itemCount: controller.vouchers?.length ?? 0,
                  itemExtent: 80,
                  itemBuilder: (context, index) {
                    final voucher = controller.vouchers?[index];
                    return Slidable(
                      key: ValueKey(voucher?.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) =>
                                controller.confirmDelete(voucher),
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Hapus',
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: (voucher?.name ?? '-').text.make(),
                        subtitle: VStack([
                          (voucher?.description ?? '-').text.sm.ellipsis.make(),
                        ]),
                        trailing:
                            (voucher?.code ?? '-').text.sm.semiBold.make(),
                        // onTap: () => controller.selectUser(user),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
