import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/ui/search/controller/search.controller.dart';
import 'package:mobile_pssi/ui/search/search_history.dart';
import 'package:mobile_pssi/ui/search/search_result.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchScreen extends GetView<SearchController> {
  static const routeName = '/search';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: 'Cari'.text.make(),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: TextFormComponent(
                label: 'cari kelas/pelatih/klub',
                controller: controller.query,
                prefixIcon: const Icon(
                  Icons.search,
                  color: primaryColor,
                ).onTap(controller.search),
                suffixIcon: HStack([
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Vx.black,
                      fontSize: 14,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: SearchType.classData,
                        child: 'Kelas'.text.make(),
                      ),
                      DropdownMenuItem(
                        value: SearchType.coach,
                        child: 'Pelatih'.text.make(),
                      ),
                      DropdownMenuItem(
                        value: SearchType.club,
                        child: 'Klub'.text.make(),
                      ),
                    ],
                    onChanged: controller.selectSearchType,
                    value: controller.searchType.value,
                  ).w(120),
                  if (controller.queryBlank.value != true)
                    HStack([
                      UiSpacer.horizontalSpace(space: 10),
                      const Icon(
                        Icons.cancel_rounded,
                        color: Colors.black,
                      ).onTap(controller.resetForm),
                    ]),
                ]),
                textInputAction: TextInputAction.search,
                validator: (value) =>
                    value!.isEmpty ? 'Kata kunci tidak boleh kosong.' : null,
                onEditingComplete: () {
                  Get.focusScope?.unfocus();
                  controller.search();
                }).py8()),
        body: Visibility(
          visible: controller.queryBlank.value == true,
          maintainState: false,
          replacement: const SearchResult(),
          child: const VStack([
            SearchHistory(),
          ]).scrollVertical(),
        ),
      ),
    );
  }
}
