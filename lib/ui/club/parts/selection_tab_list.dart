import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/club/controller/vacancy.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class SelectionTabList extends GetView<VacancyController> {
  const SelectionTabList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller.refreshControllers[0],
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: controller.refreshSelection,
      onLoading: controller.loadMoreSelection,
      child: Obx(
        () => controller.selections!.isEmpty
            ? EmptyWithButton(
                emptyMessage: 'Anda belum pernah melamar pada lowongan klub',
                textButton: 'Cari Lowongan',
                onTap: controller.openSearchClub,
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.selections?.length ?? 0,
                itemExtent: 130,
                itemBuilder: (context, index) {
                  final selection = controller.selections?[index];
                  return VStack([
                    '# ${selection?.code ?? '-'}'
                        .text
                        .semiBold
                        .maxLines(2)
                        .ellipsis
                        .make(),
                    UiSpacer.verticalSpace(space: 5),
                    HStack([
                      CachedNetworkImage(
                        imageUrl: selection
                                    ?.selectionForm?.promotion?.club?.photo ==
                                null
                            ? selection!.selectionForm!.promotion!.club!
                                .gravatar()
                            : selection!.selectionForm!.promotion!.club!.photo!,
                        fit: BoxFit.cover,
                      ).wh(50, 50).cornerRadius(50),
                      UiSpacer.horizontalSpace(space: 5),
                      VStack([
                        (selection.selectionForm?.promotion?.club?.name ?? '-')
                            .text
                            .semiBold
                            .maxLines(2)
                            .ellipsis
                            .make(),
                        UiSpacer.verticalSpace(space: 5),
                        (selection.status?.name ?? '-')
                            .text
                            .sm
                            .white
                            .make()
                            .p(6)
                            .box
                            .roundedLg
                            .color(selection.status!.statusColor())
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
                                selection.selectionForm?.promotion)),
                        if (selection.status?.id == 0)
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
                                .onTap(() => controller
                                    .confirmCancelSelection(selection)),
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
