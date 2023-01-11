import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/academy_partner/controller/academy_partners.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class AcademyPartners extends GetView<AcademyPartnersController> {
  static const routeName = '/partners';
  const AcademyPartners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AcademyPartnersController());
    return DefaultScaffold(
      title: 'Verifikasi Partner'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(() => controller.partners!.isEmpty
            ? const EmptyWithButton(
                emptyMessage: 'Belum ada partner yang ingin bergabung',
                showButton: false,
                showImage: true,
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final partner = controller.partners?[index];
                  return ListTile(
                    leading: CircleAvatar(
                      foregroundImage: CachedNetworkImageProvider(
                          partner?.employee?.photo == null
                              ? partner!.employee!.gravatar()
                              : partner!.employee!.photo!),
                    ),
                    title: (partner.employee?.name ?? '-').text.make(),
                    subtitle: 'Terakhir diubah : ${partner.updatedFormat}'
                        .text
                        .xs
                        .make(),
                    trailing: IconButton(
                      onPressed: () => controller.openPartner(partner),
                      icon: const Icon(
                        Icons.navigate_next_rounded,
                      ),
                    ).box.roundedLg.color(Get.theme.backgroundColor).make(),
                    onTap: () => controller.openProfile(partner.employee),
                  );
                },
                itemCount: controller.partners?.length ?? 0,
              )),
      ),
    );
  }
}
