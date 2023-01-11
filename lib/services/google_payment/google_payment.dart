// import 'package:get/get.dart';
// import 'package:pay/pay.dart';

// class GooglePayment {
//   static final Pay _payClient = Pay.withAssets([
//     'default_payment_profile_apple_pay.json',
//     'default_payment_profile_google_pay.json'
//   ]);

//   static Future<bool> canPay() async {
//     if (GetPlatform.isAndroid) {
//       return await _payClient.userCanPay(PayProvider.google_pay);
//     } else {
//       return await _payClient.userCanPay(PayProvider.apple_pay);
//     }
//   }

//   static Future<Map<String, dynamic>> showPaymentSelector(
//       List<PaymentItem> items) async {
//     return await _payClient.showPaymentSelector(
//       provider: PayProvider.google_pay,
//       paymentItems: items,
//     );
//   }
// }
