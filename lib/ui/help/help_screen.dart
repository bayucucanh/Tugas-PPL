import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/help/controller/help.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class HelpScreen extends GetView<HelpController> {
  static const routeName = '/help';
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HelpController());
    return DefaultScaffold(
      title: 'Bantuan'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.helps!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Oops, belum ada bantuan nih.',
                  showImage: true,
                  showButton: false,
                )
              : ListView.builder(
                  itemCount: controller.helps?.length ?? 0,
                  itemBuilder: (context, index) {
                    final faq = controller.helps?[index];
                    return ListTile(
                      title: (faq?.title ?? '-').text.sm.semiBold.make(),
                      onTap: () => controller.openHelp(faq),
                      trailing: IconButton(
                        onPressed: () => controller.openHelp(faq),
                        icon: const Icon(
                          Icons.navigate_next_rounded,
                          color: primaryColor,
                        ),
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
