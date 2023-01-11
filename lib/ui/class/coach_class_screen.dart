import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/class/controller/coach_class.controller.dart';
import 'package:mobile_pssi/ui/class/parts/coach_class.card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachClassScreen extends GetView<CoachClassController> {
  static const routeName = '/class/coach';
  const CoachClassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CoachClassController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Semua Kelas'.text.make(),
      actions: [
        if (!controller.userData.value.hasRole('administrator'))
          IconButton(
            onPressed: controller.goToAddForm,
            icon: const Icon(
              Icons.add_rounded,
            ),
          ),
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onLoading: controller.loadMore,
        onRefresh: controller.refreshData,
        child: Obx(() => controller.classes!.isEmpty
            ? EmptyWithButton(
                emptyMessage: controller.userData.value.hasRole('administrator')
                    ? 'Belum tersedia kelas'
                    : 'Anda belum memiliki kelas, buat sekarang juga.',
                textButton: 'Tambah Kelas Baru',
                showButton: controller.userData.value.hasRole('administrator')
                    ? false
                    : true,
                onTap: controller.goToAddForm,
              )
            : ListView.builder(
                itemCount: controller.classes?.length ?? 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final classData = controller.classes?[index];
                  return Slidable(
                    key: ValueKey(classData?.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              controller.confirmDelete(classData),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                        ),
                      ],
                    ),
                    child: CoachClassCard(
                      data: controller.classes![index],
                      onTap: () =>
                          controller.getDetail(controller.classes![index]),
                    ),
                  );
                },
              )),
      ),
    );
  }
}
