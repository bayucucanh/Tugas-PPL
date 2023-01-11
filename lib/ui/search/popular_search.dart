import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/search/controller/search.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class PopularSearch extends GetView<SearchController> {
  const PopularSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      'Paling Sering Dicari'.text.semiBold.lg.make(),
      UiSpacer.verticalSpace(),
      GridView(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          mainAxisExtent: 40,
          mainAxisSpacing: 5,
        ),
        padding: EdgeInsets.zero,
        children: [
          'Persib',
          'Kelas Gratis',
          'Latihan Dribble',
          'Pelatih Terbaik',
          'Agus Subagja',
          'Pemain Baru'
        ]
            .map((e) => Chip(
                  padding: EdgeInsets.zero,
                  label: e.text.white.ellipsis.make(),
                  backgroundColor: primaryColor,
                ).onTap(() => controller.tapOnTag(e)))
            .toList(),
      ).h(170)
    ]).p8();
  }
}
