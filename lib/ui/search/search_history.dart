import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/search/controller/search.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchHistory extends GetView<SearchController> {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack([
        'Riwayat Pencarian'.text.semiBold.lg.make().expand(),
        'Hapus Pencarian'.text.sm.make().onTap(controller.removeSearchHistory),
      ]),
      UiSpacer.verticalSpace(),
      Obx(() => controller.searchHistory.isEmpty
          ? 'Belum ada riwayat pencarian'.text.makeCentered()
          : GridView.builder(
              itemCount: controller.searchHistory.length,
              semanticChildCount: controller.searchHistory.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140,
                mainAxisExtent: 40,
                mainAxisSpacing: 5,
              ),
              padding: EdgeInsets.zero,
              itemBuilder: (context, int index) => Chip(
                padding: EdgeInsets.zero,
                label: controller.searchHistory[index]
                    .toString()
                    .text
                    .white
                    .ellipsis
                    .make(),
                backgroundColor: primaryColor,
              ).onTap(
                () => controller.tapOnTag(controller.searchHistory[index]),
              ),
            )
              .box
              .withConstraints(const BoxConstraints(
                maxHeight: 170,
              ))
              .make())
    ]).p8();
  }
}
