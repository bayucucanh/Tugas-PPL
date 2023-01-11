import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/test_parameter/parts/test_param.card.dart';
import 'package:mobile_pssi/ui/verify_performance/controller/test_parameter_list.controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class TestParameterList extends GetView<TestParameterListController> {
  static const routeName = '/test-parameter/list';
  const TestParameterList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(TestParameterListController());
    return DefaultScaffold(
      backgroundColor: Get.theme.backgroundColor,
      title: 'Verifikasi Test Parameter'.text.make(),
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: controller.refreshList,
          onLoading: controller.loadMore,
          child: controller.performances!.isEmpty
              ? 'Belum ada test parameter disubmit'.text.makeCentered()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.performances?.length,
                  itemBuilder: (context, index) {
                    final verifyParams = controller.performances?[index];
                    return TestParamCard(verifyParams: verifyParams!)
                        .p8()
                        .onInkTap(() => controller.openDetail(verifyParams));
                  },
                ).p12(),
        ),
      ),
    );
  }
}
