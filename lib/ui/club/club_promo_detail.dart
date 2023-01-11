import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/club/controller/club_promo_detail.controller.dart';
import 'package:mobile_pssi/ui/club/parts/new_student_detail.dart';
import 'package:mobile_pssi/ui/club/parts/selection_detail.dart';
import 'package:mobile_pssi/ui/reusable/bottomsheet_component.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubPromoDetail extends GetView<ClubPromoDetailController> {
  static const routeName = '/club/promo/detail';
  const ClubPromoDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClubPromoDetailController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Detil'.text.make(),
      body: Obx(
        () => VStack([
          Hero(
            tag: '${controller.promo?.id}_${controller.promo?.club?.name}',
            child: CachedNetworkImage(
              imageUrl: controller.promo?.club?.photo == null
                  ? controller.promo!.club!.gravatar()
                  : controller.promo!.club!.photo!,
            ).h(180).centered(),
          ),
          UiSpacer.verticalSpace(),
          (controller.promo?.club?.name ?? '-')
              .text
              .xl3
              .semiBold
              .makeCentered(),
        ]),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) => BottomSheetComponent(
          child: SmartRefresher(
            controller: controller.refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: controller.refreshData,
            child: controller.promo?.promoType == 1
                ? const NewStudentDetail()
                : const SelectionDetail(),
          ).h(450),
        ),
        backgroundColor: whiteGreyBgColor,
        enableDrag: false,
        elevation: 30,
      ),
    );
  }
}
