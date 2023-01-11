import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/secure_documents/controller/user_documents.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class UserDocuments extends GetView<UserDocumentsController> {
  static const routeName = '/secure-documents/user/documents';
  const UserDocuments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserDocumentsController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: (controller.user?.profile?.name ?? '-').text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.documents!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Tidak ada dokumen pada pengguna ini.',
                  showButton: false,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final document = controller.documents?[index];
                    return HStack([
                      (document?.name ?? '-').text.make().expand(),
                      ButtonBar(
                        children: [
                          IconButton(
                              onPressed: () => controller.openDialog(document),
                              icon: const Icon(Icons.remove_red_eye_rounded)),
                        ],
                      ),
                    ]);
                  },
                  itemCount: controller.documents?.length ?? 0,
                ),
        ),
      ).p12(),
    );
  }
}
