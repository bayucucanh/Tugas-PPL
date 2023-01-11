// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_pssi/ui/offering/controller/offer_list_club.controller.dart';
// import 'package:mobile_pssi/utils/ui.spacer.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:velocity_x/velocity_x.dart';

// class OfferListTeam extends GetView<OfferListController> {
//   static const routeName = '/clubs/offers/team/player';
//   const OfferListTeam({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Get.put(OfferListController());
//     return Scaffold(
//       appBar: AppBar(
//         title: 'Tawaran Team'.text.make(),
//       ),
//       body: Obx(
//         () => SmartRefresher(
//           controller: controller.refreshController,
//           enablePullDown: true,
//           enablePullUp: true,
//           onRefresh: controller.refreshData,
//           onLoading: controller.loadMore,
//           child: GridView.builder(
//               itemCount: controller.offerings.value.data?.length ?? 0,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisExtent: 220,
//               ),
//               itemBuilder: (context, index) {
//                 final offer = controller.offerings.value.data?[index];
//                 return VStack([
//                   (offer?.club?.name ?? '-')
//                       .text
//                       .semiBold
//                       .maxLines(2)
//                       .ellipsis
//                       .makeCentered()
//                       .expand(),
//                   UiSpacer.verticalSpace(space: 5),
//                   CachedNetworkImage(
//                     imageUrl: offer?.club?.photo == null
//                         ? offer!.club!.gravatar()
//                         : offer!.club!.photo!,
//                   ).wh(100, 100).cornerRadius(50).centered(),
//                   UiSpacer.verticalSpace(space: 5),
//                   'U18'.text.makeCentered(),
//                   'Elite Pro Academy'
//                       .text
//                       .sm
//                       .maxLines(2)
//                       .ellipsis
//                       .makeCentered()
//                       .expand(),
//                 ]).p12().card.make();
//               }).p12(),
//         ),
//       ),
//     );
//   }
// }
