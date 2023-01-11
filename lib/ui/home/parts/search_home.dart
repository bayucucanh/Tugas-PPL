import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/ui/search/controller/search.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchHome extends GetView<SearchController> {
  const SearchHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SearchController());
    return TextFormComponent(
      label: 'cari kelas/pelatih/klub',
      controller: controller.query,
      expands: true,
      maxLines: null,
      prefixIcon: IconButton(
        onPressed: controller.showSearchScreen,
        icon: const Icon(Icons.search),
        color: primaryColor,
      ),
      suffixIcon: HStack([
        DropdownButtonFormField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
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
      ]),
      textInputAction: TextInputAction.search,
      validator: (value) =>
          value!.isEmpty ? 'Kata kunci tidak boleh kosong.' : null,
      onEditingComplete: controller.showSearchScreen,
    );
  }
}
