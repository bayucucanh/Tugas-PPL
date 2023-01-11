import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/class_category/controller/class_category_management.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class ClassCategoryManagement
    extends GetView<ClassCategoryManagementController> {
  static const routeName = '/class-category';
  const ClassCategoryManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ClassCategoryManagementController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Manajemen Kategori Kelas'.text.make(),
      actions: [
        IconButton(
            onPressed: controller.addClassCategory,
            icon: const Icon(Icons.my_library_add_rounded))
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: controller.refreshData,
        onLoading: controller.loadMore,
        child: Obx(() => controller.categories!.isEmpty
            ? EmptyWithButton(
                emptyMessage: 'Belum ada kategori kelas dibuat',
                showImage: true,
                onTap: controller.addClassCategory,
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final category = controller.categories?[index];
                  return Slidable(
                    key: ValueKey(category?.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              controller.confirmDelete(category),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: (category?.name ?? '-').text.make(),
                      subtitle: (category?.description ?? '-')
                          .text
                          .sm
                          .ellipsis
                          .maxLines(2)
                          .make(),
                      onTap: () => controller.editClassCategory(category),
                    ),
                  );
                },
                itemCount: controller.categories?.length ?? 0,
              )),
      ).p12(),
    );
  }
}
