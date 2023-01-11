import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/consulting/controller/consult_list.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ConsultList extends GetView<ConsultListController> {
  static const routeName = '/consulting';
  const ConsultList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ConsultListController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Konsultasi'.text.make(),
      actions: [
        if (controller.userData.value.isCoach)
          IconButton(
              onPressed: controller.openAutoTexts,
              icon: const Icon(Icons.quickreply_rounded))
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        onLoading: controller.loadMore,
        onRefresh: controller.refreshData,
        enablePullUp: true,
        enablePullDown: true,
        child: Obx(
          () => controller.consultations!.isEmpty
              ? EmptyWithButton(
                  emptyMessage: controller.userData.value.isCoach
                      ? 'Belum ada pemain yang meminta konsultasi'
                      : 'Belum memiliki riwayat konsultasi',
                  textButton: 'Cari Pelatih',
                  onTap: controller.openCoaches,
                  showButton: controller.userData.value.isCoach ? false : true,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.consultations?.length ?? 0,
                  itemBuilder: (context, index) {
                    final consult = controller.consultations?[index];
                    return HStack([
                      CachedNetworkImage(
                        imageUrl: controller.userData.value.isCoach
                            ? consult!.createdBy!.imageProfile
                            : consult!.consultWith!.imageProfile,
                        fit: BoxFit.cover,
                      ).wh(70, 70).cornerRadius(35),
                      UiSpacer.horizontalSpace(space: 10),
                      VStack([
                        (controller.userData.value.isCoach
                                ? consult.createdBy?.profile?.name ?? '-'
                                : consult.consultWith?.profile?.name ?? '-')
                            .text
                            .semiBold
                            .make(),
                        UiSpacer.verticalSpace(space: 5),
                        HStack([
                          const Icon(
                            FontAwesomeIcons.calendar,
                            size: 12,
                          ),
                          UiSpacer.horizontalSpace(space: 5),
                          (consult.createdAtFormat ?? '-').text.xs.make(),
                        ]),
                        UiSpacer.verticalSpace(space: 5),
                        (consult.latestMessage?.message ?? '-')
                            .text
                            .xs
                            .ellipsis
                            .fontWeight(consult.latestMessage?.readAt == null
                                ? FontWeight.bold
                                : FontWeight.normal)
                            .maxLines(2)
                            .make(),
                      ]).expand(),
                      UiSpacer.horizontalSpace(space: 5),
                      (consult.latestMessage?.formatHourOnly ?? '-')
                          .text
                          .sm
                          .gray500
                          .make(),
                    ]).p8().onInkTap(() => controller.openChat(consult));
                  }).p12(),
        ),
      ),
    );
  }
}
