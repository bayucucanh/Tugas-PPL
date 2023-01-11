import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/banners/controller/banner_list.controller.dart';
import 'package:mobile_pssi/ui/home/parts/card.slider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class BannerList extends GetView<BannerListController> {
  static const routeName = '/banners';
  const BannerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BannerListController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Banner'.text.make(),
      actions: [
        IconButton(
          onPressed: controller.newBanner,
          icon: const Icon(Icons.add_photo_alternate_rounded),
          tooltip: 'Tambah Banner Baru',
        ),
      ],
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: controller.banners!.isEmpty
              ? EmptyWithButton(
                  emptyMessage: 'Belum memiliki banner.',
                  textButton: 'Tambah Banner Baru',
                  onTap: controller.newBanner,
                )
              : ListView.builder(
                  itemCount: controller.banners?.length ?? 0,
                  itemBuilder: (context, index) {
                    final banner = controller.banners?[index];
                    return CardSlider(
                      banner: banner!,
                      user: controller.userData.value,
                      onDeleteBanner: () =>
                          controller.confirmDeleteBanner(banner),
                    ).marginSymmetric(vertical: 10);
                  },
                ),
        ).p12(),
      ),
    );
  }
}
