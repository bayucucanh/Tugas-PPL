import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/transfer_market/controller/new_student_participant.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class NewStudentParticipants extends GetView<NewStudentParticipantController> {
  static const routeName = '/transfer/market/promo/new-student/participants';
  const NewStudentParticipants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NewStudentParticipantController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Daftar Peserta'.text.make(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Obx(
          () => HStack([
            'Total Peserta : ${controller.participants?.length ?? 0}'
                .text
                .make(),
            UiSpacer.horizontalSpace(space: 10),
            'Total Diterima : ${controller.totalAccepted}'.text.make(),
          ]).p12().card.make(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: controller.acceptAllDialog,
          child: 'Terima Semua'.text.make(),
        )
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(
          () => controller.participants!.isEmpty
              ? 'Belum ada peserta mendaftar.'.text.makeCentered()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.participants?.length ?? 0,
                  itemExtent: 80,
                  itemBuilder: (context, index) {
                    final participant = controller.participants?[index];
                    return HStack([
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          participant?.player?.photo == null
                              ? participant!.player!.gravatar()
                              : participant!.player!.photo!,
                        ),
                      ).wh(70, 70),
                      UiSpacer.horizontalSpace(space: 10),
                      VStack([
                        '#${participant.code ?? '-'}'
                            .text
                            .semiBold
                            .ellipsis
                            .make(),
                        (participant.player?.name ?? '-')
                            .text
                            .semiBold
                            .ellipsis
                            .make(),
                        VStack([
                          (participant.status?.name ?? '-')
                              .text
                              .white
                              .make()
                              .px8()
                              .box
                              .roundedLg
                              .color(participant.status!.statusColor())
                              .make(),
                          (participant.player?.age ?? '-').text.gray500.make(),
                        ]),
                      ]).expand(),
                      UiSpacer.horizontalSpace(space: 10),
                      if (participant.filterByStatus(0))
                        VStack([
                          'Terima'
                              .text
                              .white
                              .makeCentered()
                              .continuousRectangle(
                                  height: 30,
                                  width: 100,
                                  backgroundColor: primaryColor)
                              .onTap(
                                  () => controller.acceptDialog(participant)),
                          UiSpacer.verticalSpace(space: 5),
                          'Tolak'
                              .text
                              .color(primaryColor)
                              .makeCentered()
                              .continuousRectangle(
                                  height: 30,
                                  width: 100,
                                  borderSide:
                                      const BorderSide(color: primaryColor),
                                  backgroundColor: Colors.transparent)
                              .onTap(
                                  () => controller.rejectDialog(participant)),
                        ]),
                    ]).px12();
                  },
                ),
        ),
      ),
    );
  }
}
