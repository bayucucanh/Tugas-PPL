import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/help/controller/help_detail.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class HelpDetail extends GetView<HelpDetailController> {
  static const routeName = '/help/detail';
  const HelpDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HelpDetailController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: (controller.help?.title ?? '-').text.maxLines(1).ellipsis.make(),
      body: Markdown(
        data: controller.help?.content ?? '-',
        onTapLink: controller.openLink,
      ),
    );
  }
}
