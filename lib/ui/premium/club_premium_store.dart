import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/premium/controller/club_store.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubPremiumStore extends GetView<ClubStoreController> {
  static const routeName = '/club/store';
  const ClubPremiumStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubStoreController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: '${F.title} Store'.text.sm.ellipsis.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(() => controller.isStoreAvailable.value
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final product = controller.products?[index];
                  return VStack(
                    [
                      (product?.name ?? '-').text.center.make(),
                      UiSpacer.verticalSpace(),
                      (product?.priceWithTax ?? '-').text.semiBold.make(),
                    ],
                    alignment: MainAxisAlignment.center,
                    crossAlignment: CrossAxisAlignment.center,
                  ).card.make().onInkTap(() => controller.openDetail(product));
                },
                itemCount: controller.products?.length ?? 0)
            : EmptyWithButton(
                emptyMessage: GetPlatform.isIOS
                    ? 'Maaf, app store belum tersedia pada daerah anda.'
                    : 'Maaf, paket premium belum tersedia pada daerah anda.',
                showButton: false,
                showImage: true,
              )),
      ),
    );
  }
}
