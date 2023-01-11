import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/shared_ui/coach.card.dart';
import 'package:mobile_pssi/ui/search/controller/search.controller.dart';
import 'package:mobile_pssi/ui/search/parts/search_class.card.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchResult extends GetView<SearchController> {
  const SearchResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller.refreshController,
      onRefresh: controller.refreshData,
      onLoading: controller.loadMore,
      enablePullDown: true,
      enablePullUp: true,
      child: VStack([
        'Hasil Pencarian'.text.xl.semiBold.make(),
        UiSpacer.verticalSpace(),
        Obx(
          () => controller.searchResult.value.data!.isEmpty
              ? 'Pencarian ${controller.query.text} tidak ditemukan'
                  .text
                  .makeCentered()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.searchResult.value.data?.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final search = controller.searchResult.value.data?[index];
                    if (controller.searchType.value == SearchType.classData) {
                      return SearchClassCard(classData: search).onInkTap(
                        () => controller.showClass(search),
                      );
                    } else if (controller.searchType.value ==
                        SearchType.coach) {
                      User? user = search is User ? search : null;
                      return user == null
                          ? UiSpacer.emptySpace()
                          : CoachCard(coach: user.employee)
                              .p8()
                              .onTap(() => controller.openCoachDetail(user));
                    } else if (controller.searchType.value == SearchType.club) {
                      Club? club = search is Club ? search : null;
                      return ListTile(
                        onTap: () => controller.openClubDetail(club),
                        leading: CachedNetworkImage(
                          imageUrl: club?.photo == null
                              ? club!.gravatar()
                              : club!.photo!,
                        ).wh(100, 100),
                        title: (club.name ?? '-').text.semiBold.make(),
                        subtitle: VStack([
                          '${club.totalPlayers ?? '0'} pemain'.text.sm.make(),
                          (club.address ?? '0').text.sm.make(),
                        ]),
                      );
                    }
                    return UiSpacer.emptySpace();
                  },
                ),
        )
      ]).p12().scrollVertical(),
    );
  }
}
