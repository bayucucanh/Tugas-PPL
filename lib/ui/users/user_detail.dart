import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/users/controller/user_detail.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class UserDetail extends GetView<UserDetailController> {
  static const routeName = '/users/detail';
  const UserDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserDetailController());
    return Obx(
      () => DefaultScaffold(
        backgroundColor: Get.theme.backgroundColor,
        title: (controller.userDetail.username ?? '-').text.make(),
        body: SmartRefresher(
          controller: controller.refreshController,
          enablePullUp: false,
          enablePullDown: true,
          onRefresh: controller.refreshData,
          child: VStack([
            if (controller.userDetail.suspendUser != null)
              VStack([
                MaterialBanner(
                  backgroundColor: primaryColor,
                  content: controller.userDetail.suspendUser
                      .toString()
                      .text
                      .white
                      .make(),
                  actions: [
                    TextButton(
                        onPressed: controller.confirmLiftSuspend,
                        child: 'Batal'.text.make())
                  ],
                ),
                UiSpacer.verticalSpace(),
              ]),
            HStack([
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  controller.userDetail.imageProfile,
                ),
                child: controller.userDetail.suspendUser != null
                    ? const Banner(
                        message: 'Suspended',
                        location: BannerLocation.bottomEnd)
                    : UiSpacer.emptySpace(),
              ).wh(100, 100),
              UiSpacer.horizontalSpace(space: 10),
              VStack(
                [
                  (controller.userDetail.profile?.name ?? '-').text.make(),
                  (controller.userDetail.email ?? '-').text.gray500.sm.make(),
                  (controller.userDetail.phoneNumber ?? '-')
                      .text
                      .gray500
                      .sm
                      .make(),
                  (controller.userDetail.profile?.website ?? '-')
                      .text
                      .gray500
                      .sm
                      .make(),
                ],
                alignment: MainAxisAlignment.start,
                crossAlignment: CrossAxisAlignment.start,
              ).expand(),
            ]),
            UiSpacer.verticalSpace(),
            'Hak Akses'.text.semiBold.xl.make(),
            (controller.userDetail.roles?.map((e) => e.name).join(', ') ?? '-')
                .text
                .make(),
            if (controller.editAvailable.value &&
                !controller.userDetail.isPlayer &&
                !controller.userDetail.isClub)
              MultiSelectDialogField(
                onConfirm: controller.selectAccess,
                validator: (values) {
                  if (values.isBlank == true) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
                title: const Text('Pilih Hak Akses'),
                listType: MultiSelectListType.CHIP,
                selectedColor: primaryColor,
                searchable: true,
                selectedItemsTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                items: controller.roles!
                    .map((e) => MultiSelectItem(e, e.name ?? '-'))
                    .toList(),
              ),
          ]).p12().scrollVertical(),
        ),
        floatingActionButton: HStack([
          if (!controller.userDetail.isPlayer)
            FloatingActionButton.extended(
              onPressed: controller.editAvailable.value
                  ? controller.save
                  : controller.editUser,
              icon: controller.editAvailable.value
                  ? const Icon(Icons.save_rounded)
                  : const Icon(Icons.edit_rounded),
              label: (controller.editAvailable.value
                      ? 'Simpan Perubahan'
                      : 'Ubah Data')
                  .text
                  .make(),
            ),
          UiSpacer.horizontalSpace(space: 10),
          if (controller.userDetail.suspendUser == null)
            FloatingActionButton.extended(
              heroTag: 'ban',
              onPressed: controller.confirmSuspend,
              label: 'Suspend'.text.make(),
            ),
        ]),
      ),
    );
  }
}
