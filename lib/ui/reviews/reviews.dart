import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/reviews/controller/reviews.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class Reviews extends GetView<ReviewsController> {
  static const routeName = '/reviews';
  const Reviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ReviewsController());
    return DefaultScaffold(
      title: 'Semua Review'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: SmartRefresher(
        controller: controller.refreshController,
        onLoading: controller.loadMore,
        onRefresh: controller.refreshData,
        child: Obx(
          () => controller.reviews!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Belum memiliki review',
                  showButton: false,
                  showImage: true,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final review = controller.reviews?[index];
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(
                            review!.player!.imageProfile),
                      ),
                      title: VStack([
                        (review.player?.player?.name ?? '-')
                            .text
                            .sm
                            .ellipsis
                            .semiBold
                            .make(),
                        RatingBar.builder(
                          initialRating: review.rating ?? 0,
                          itemCount: 5,
                          minRating: 1,
                          maxRating: 5,
                          itemSize: 15,
                          ignoreGestures: true,
                          allowHalfRating: true,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star_rounded,
                            color: starColor,
                          ),
                          glow: true,
                          onRatingUpdate: (value) {},
                        )
                      ]),
                      subtitle: (review.description ?? '-')
                          .text
                          .sm
                          .maxLines(4)
                          .ellipsis
                          .make(),
                      isThreeLine: true,
                    )
                        .w(250)
                        .backgroundColor(
                            const Color.fromARGB(255, 231, 230, 230))
                        .cornerRadius(8)
                        .marginOnly(right: 10, bottom: 10);
                  },
                  itemCount: controller.reviews?.length ?? 0,
                ).p12(),
        ),
      ),
    );
  }
}
