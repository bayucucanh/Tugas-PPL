import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/club/controller/vacancy.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class NewStudentTabList extends GetView<VacancyController> {
  const NewStudentTabList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller.refreshControllers[1],
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: controller.refreshStudent,
      onLoading: controller.loadMoreStudent,
      child: Obx(
        () => controller.newStudents!.isEmpty
            ? const EmptyWithButton(
                emptyMessage: 'Anda belum pernah melamar pada lowongan klub',
                textButton: 'Cari Lowongan',
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.newStudents?.length ?? 0,
                itemExtent: 130,
                itemBuilder: (context, index) {
                  final student = controller.newStudents?[index];
                  return VStack([
                    '# ${student?.code ?? '-'}'
                        .text
                        .semiBold
                        .maxLines(2)
                        .ellipsis
                        .make(),
                    UiSpacer.verticalSpace(space: 5),
                    HStack([
                      CachedNetworkImage(
                        imageUrl: student
                                    ?.newStudentForm?.promotion?.club?.photo ==
                                null
                            ? student!.newStudentForm!.promotion!.club!
                                .gravatar()
                            : student!.newStudentForm!.promotion!.club!.photo!,
                        fit: BoxFit.cover,
                      ).wh(50, 50).cornerRadius(50),
                      UiSpacer.horizontalSpace(space: 5),
                      VStack([
                        (student.newStudentForm?.promotion?.club?.name ?? '-')
                            .text
                            .semiBold
                            .maxLines(2)
                            .ellipsis
                            .make(),
                        UiSpacer.verticalSpace(space: 5),
                        (student.status?.name ?? '-')
                            .text
                            .sm
                            .white
                            .make()
                            .p(6)
                            .box
                            .roundedLg
                            .color(student.status!.statusColor())
                            .make(),
                      ]).expand(),
                      VStack([
                        'Lihat Detil'
                            .text
                            .white
                            .makeCentered()
                            .continuousRectangle(
                              height: 30,
                              width: 100,
                              backgroundColor: primaryColor,
                            )
                            .onTap(() => controller.openPromoDetail(
                                student.newStudentForm?.promotion)),
                        if (student.status?.id == 0)
                          VStack([
                            UiSpacer.verticalSpace(space: 5),
                            'Batalkan'
                                .text
                                .color(primaryColor)
                                .makeCentered()
                                .continuousRectangle(
                                    height: 30,
                                    width: 100,
                                    backgroundColor: Colors.transparent,
                                    borderSide:
                                        const BorderSide(color: primaryColor))
                                .onTap(() =>
                                    controller.confirmCancelStudent(student)),
                          ]),
                      ]),
                    ]),
                  ]).p12().card.make();
                },
              ).p12(),
      ),
    );
  }
}
