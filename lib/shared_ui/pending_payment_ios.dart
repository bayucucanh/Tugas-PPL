import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobile_pssi/shared_functions/order.controller.dart';
import 'package:velocity_x/velocity_x.dart';

class PendingPaymentIos extends StatelessWidget {
  final OrderController vm;
  final PurchaseDetails purchaseDetails;
  const PendingPaymentIos(
      {Key? key, required this.vm, required this.purchaseDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VStack([
      'Mohon menunggu untuk melakukan pembayaran pada appstore.'
          .text
          .center
          .make(),
    ]);
  }
}
