import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/scouting/controller/saved_coach.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:velocity_x/velocity_x.dart';

class SavedCoach extends GetView<SavedCoachController> {
  static const routeName = '/scouting/saved/coach';
  const SavedCoach({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SavedCoachController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Pelatih Tersimpan'.text.make(),
      body: Obx(
        () => controller.coaches.isEmpty
            ? EmptyWithButton(
                emptyMessage: 'Tidak memiliki pelatih tersimpan.',
                onTap: controller.goScoutingCoach,
                textButton: 'Cari Pelatih',
              )
            : ListView.builder(
                itemCount: controller.coaches.length,
                itemBuilder: (context, index) {
                  final coach = controller.coaches[index];
                  return Slidable(
                    key: ValueKey(coach.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) =>
                              controller.deleteSavedCoach(coach),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Hapus',
                        ),
                      ],
                    ),
                    child: HStack([
                      VStack(
                        [
                          CachedNetworkImage(
                            imageUrl: coach.employee?.photo == null
                                ? coach.employee!.gravatar()
                                : coach.employee!.photo!,
                            fit: BoxFit.cover,
                          ).wh(75, 75).cornerRadius(80),
                        ],
                        crossAlignment: CrossAxisAlignment.center,
                      ),
                      UiSpacer.horizontalSpace(),
                      VStack([
                        (coach.employee?.name ?? '-')
                            .text
                            .semiBold
                            .maxLines(2)
                            .ellipsis
                            .make(),
                        (coach.employee?.age ?? '').text.sm.make(),
                        (coach.employee?.nationality?.name ?? '')
                            .text
                            .sm
                            .make(),
                        (coach.employee?.city?.name ?? '').text.sm.make(),
                      ]).expand()
                    ]).p8().onInkTap(() => controller.getDetail(coach)),
                  );
                }),
      ),
    );
  }
}
