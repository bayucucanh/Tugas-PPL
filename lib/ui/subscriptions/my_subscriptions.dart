import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/subscriptions/parts/active_subscriptions.dart';
import 'package:mobile_pssi/ui/subscriptions/parts/inactive_subscriptions.dart';
import 'package:velocity_x/velocity_x.dart';

class MySubscriptions extends StatelessWidget {
  static const routeName = '/subscriptions/my';
  const MySubscriptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Berlangganan'.text.make(),
      backgroundColor: Get.theme.backgroundColor,
      body: DefaultTabController(
          length: 2,
          child: VStack([
            const TabBar(tabs: [
              Tab(
                text: 'Aktif',
              ),
              Tab(
                text: 'Tidak Aktif',
              ),
            ]),
            const TabBarView(children: [
              ActiveSubscriptions(),
              InactiveSubscriptions(),
            ]).expand()
          ])),
    );
  }
}
