import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/class_level.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/class/controller/class.controller.dart';
import 'package:mobile_pssi/ui/class/parts/class.card.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClassScreen extends GetView<ClassController> {
  static const routeName = '/class';
  const ClassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClassController());
    return DefaultScaffold(
      title: 'Semua Kelas'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Obx(
          () => TextFormComponent(
            label: 'Cari kelas',
            controller: controller.query,
            prefixIcon: const Icon(
              Icons.search,
              color: primaryColor,
            ).onTap(controller.search),
            suffixIcon: HStack([
              if (controller.classLevels!.isNotEmpty)
                DropdownButton(
                  isExpanded: true,
                  isDense: true,
                  underline: const SizedBox(),
                  hint: controller.queryBlank.value == true
                      ? 'Semua Tingkat'.text.make()
                      : (controller.selectedLevel?.name ?? 'Semua Tingkat')
                          .text
                          .make(),
                  items: controller.classLevels
                      ?.map((e) => DropdownMenuItem(
                            value: e,
                            child: (e.name ?? '-').text.make(),
                          ))
                      .toList(),
                  onChanged: (ClassLevel? level) =>
                      controller.selectLevel(level),
                ).w(120),
              if (controller.queryBlank.value == false)
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
            onFieldSubmitted: (value) => controller.search(data: value),
          ),
        ),
      ),
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onLoading: controller.loadMore,
        onRefresh: controller.refreshData,
        child: Obx(
          () => controller.classes!.isEmpty
              ? 'Kelas belum tersedia'.text.makeCentered()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.classes?.length ?? 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemExtent: 180,
                  itemBuilder: (context, index) {
                    final classData = controller.classes?[index];
                    return ClassCard(
                      data: classData!,
                      onTap: () => controller.showClass(classData),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
