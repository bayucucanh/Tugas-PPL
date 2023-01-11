import 'package:flutter/material.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:velocity_x/velocity_x.dart';

class PromoPerformance extends StatelessWidget {
  static const routeName = '/transfermarket/promo/stats';
  const PromoPerformance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO Create a statistic performance of log promotion
    return DefaultScaffold(
      title: 'Statistik Performa'.text.make(),
    );
  }
}
