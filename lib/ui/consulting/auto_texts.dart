import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/shared_ui/empty_with_button.dart';
import 'package:mobile_pssi/ui/consulting/controller/auto_texts.controller.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class AutoTexts extends GetView<AutoTextsController> {
  static const routeName = '/consulting/auto-text';
  const AutoTexts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AutoTextsController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Auto Text'.text.make(),
      actions: [
        IconButton(
            onPressed: controller.addAutoText, icon: const Icon(Icons.add)),
      ],
      body: SmartRefresher(
        controller: controller.refreshController,
        onLoading: controller.loadMore,
        onRefresh: controller.refreshData,
        enablePullUp: true,
        enablePullDown: true,
        child: Obx(
          () => controller.quickReplies!.isEmpty
              ? EmptyWithButton(
                  emptyMessage: 'Belum memiliki auto text',
                  textButton: 'Buat Auto Text',
                  onTap: controller.addAutoText,
                  showImage: true,
                )
              : VStack([
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.quickReplies?.length ?? 0,
                      itemBuilder: (context, index) {
                        final quickReply = controller.quickReplies?[index];
                        return Slidable(
                          key: ValueKey(quickReply?.id),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) =>
                                    controller.confirmDelete(quickReply),
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Hapus',
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: (quickReply?.shortcut ?? '-').text.sm.make(),
                            subtitle: quickReply?.message == null
                                ? 'File attachment'.text.make()
                                : (quickReply?.message ?? '-').text.sm.make(),
                          ),
                        );
                      }),
                  UiSpacer.verticalSpace(),
                  if (controller.quickReplies!.isNotEmpty)
                    'Untuk menggunakan ketik "/" pada keyboard.'
                        .text
                        .gray500
                        .sm
                        .make(),
                ]).p12().scrollVertical(),
        ),
      ),
    );
  }
}
