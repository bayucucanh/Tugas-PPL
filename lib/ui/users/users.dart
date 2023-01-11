import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/reusable/text_form_component.dart';
import 'package:mobile_pssi/ui/users/controller/user.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class Users extends GetView<UserController> {
  static const routeName = '/users';
  const Users({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Pengguna'.text.make(),
      actions: [
        IconButton(
            onPressed: controller.newUser,
            icon: const Icon(Icons.person_add_rounded))
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: TextFormComponent(
          controller: controller.search,
          validator: (val) {
            return null;
          },
          onEditingComplete: () {
            Get.focusScope?.unfocus();
            controller.refreshData();
          },
          suffixIcon: IconButton(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.person_search_rounded),
          ),
          label: 'Cari E-mail atau Username Pengguna',
          textInputAction: TextInputAction.search,
        ).p12(),
      ),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshData,
          onLoading: controller.loadMore,
          child: controller.userList!.isEmpty
              ? const EmptyWithButton(
                  emptyMessage: 'Tidak ada pengguna',
                  textButton: 'Buat Pengguna',
                )
              : ListView.builder(
                  semanticChildCount: controller.userList?.length ?? 0,
                  itemCount: controller.userList?.length ?? 0,
                  itemExtent: 80,
                  itemBuilder: (context, index) {
                    final user = controller.userList?[index];
                    return ListTile(
                      leading: CircleAvatar(
                        foregroundImage:
                            CachedNetworkImageProvider(user!.imageProfile),
                        onForegroundImageError: (exception, stackTrace) =>
                            const Icon(Icons.broken_image_rounded).centered(),
                      ),
                      title: (user.username ?? '-').text.make(),
                      subtitle: VStack([
                        (user.email ?? '-').text.sm.ellipsis.make(),
                        (user.isPlayer == true
                                ? 'Pemain'
                                : user.isClub == true
                                    ? 'Klub'
                                    : user.hasMultiRole == true ||
                                            !user.isCoach == true
                                        ? 'Official'
                                        : 'Pelatih')
                            .text
                            .sm
                            .make(),
                      ]),
                      trailing: (user.createdTimeAgo ?? '-').text.xs.make(),
                      onTap: () => controller.openUserDetail(user),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
