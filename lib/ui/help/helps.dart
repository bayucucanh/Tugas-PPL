import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/help/controller/help.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class Helps extends GetView<HelpController> {
  static const routeName = '/help/manage';
  const Helps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HelpController());
    return DefaultScaffold(
      title: 'Kelola Bantuan'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      actions: [
        IconButton(
            onPressed: controller.addHelp,
            icon: const Icon(Icons.post_add_rounded))
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.helps!.isEmpty
              ? EmptyWithButton(
                  emptyMessage:
                      'Belum pernah membuat FAQ, yuk kita bikin biar pengguna ga kebingungan.',
                  showImage: true,
                  textButton: 'Tambah FAQ',
                  onTap: controller.addHelp,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.helps?.length ?? 0,
                  itemBuilder: (context, index) {
                    final faq = controller.helps?[index];
                    return ListTile(
                      title: (faq?.title ?? '-').text.sm.semiBold.make(),
                      onTap: () => controller.openHelp(faq),
                      trailing: HStack(
                        [
                          IconButton(
                            onPressed: () => controller.openEditHelp(faq),
                            icon: const Icon(Icons.edit_rounded),
                          ),
                          IconButton(
                            onPressed: () => controller.confirmDelete(faq),
                            icon: const Icon(
                              Icons.delete_forever_rounded,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
