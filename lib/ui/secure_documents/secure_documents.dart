import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/secure_documents/controller/secure_documents.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class SecureDocuments extends GetView<SecureDocumentsController> {
  static const routeName = '/secure-documents';
  const SecureDocuments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SecureDocumentsController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Verifikasi Dokumen Pengguna'.text.make(),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(() => controller.users!.isEmpty
            ? const EmptyWithButton(
                emptyMessage: 'Belum ada pengguna yang mengunggah dokumen',
                showButton: false,
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final user = controller.users?[index];
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundImage:
                          CachedNetworkImageProvider(user!.imageProfile),
                    ),
                    title: (user.profile?.name ?? '-').text.make(),
                    subtitle: (user.profile?.nik ?? '-').text.make(),
                    onTap: () => controller.openUser(user),
                  );
                },
                itemCount: controller.users?.length ?? 0,
              )),
      ),
    );
  }
}
