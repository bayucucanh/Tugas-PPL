import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/product_management/controller/product_management.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductManagement extends GetView<ProductManagementController> {
  static const routeName = '/products';
  const ProductManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProductManagementController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Manajemen Produk'.text.make(),
      actions: const [
        // IconButton(
        //     onPressed: controller.add,
        //     icon: const Icon(Icons.my_library_add_rounded))
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(() => controller.products!.isEmpty
            ? EmptyWithButton(
                emptyMessage: 'Belum ada produk dibuat',
                showImage: true,
                onTap: controller.add,
                showButton: false,
              )
            : ListView.builder(
                shrinkWrap: true,
                itemExtent: 110,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final product = controller.products?[index];
                  return Slidable(
                    key: ValueKey(product?.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              controller.confirmDelete(product),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () => controller.edit(product),
                      title: (product?.name ?? '-').text.make(),
                      subtitle: VStack([
                        (product?.description ?? '-')
                            .text
                            .sm
                            .ellipsis
                            .maxLines(2)
                            .make(),
                        UiSpacer.verticalSpace(space: 10),
                        HStack(
                          [
                            (product?.typeFormat ?? '-')
                                .text
                                .sm
                                .ellipsis
                                .white
                                .maxLines(2)
                                .make()
                                .box
                                .p8
                                .roundedSM
                                .color(Colors.blueAccent)
                                .make(),
                            UiSpacer.horizontalSpace(space: 10),
                            '${product?.value ?? '-'} ${product?.unitFormat}'
                                .text
                                .sm
                                .ellipsis
                                .white
                                .maxLines(2)
                                .make()
                                .box
                                .p8
                                .roundedSM
                                .color(primaryColor)
                                .make(),
                            UiSpacer.horizontalSpace(space: 10),
                            (product?.priceFormat ?? '-')
                                .text
                                .sm
                                .ellipsis
                                .white
                                .maxLines(2)
                                .make()
                                .box
                                .p8
                                .roundedSM
                                .color(Colors.green)
                                .make()
                                .objectCenterRight(),
                          ],
                          alignment: MainAxisAlignment.spaceEvenly,
                          crossAlignment: CrossAxisAlignment.center,
                          axisSize: MainAxisSize.max,
                        ),
                        // onTap: () => controller.edit(product),
                      ]),
                    ),
                  );
                },
                itemCount: controller.products?.length ?? 0,
              )),
      ).p12(),
    );
  }
}
