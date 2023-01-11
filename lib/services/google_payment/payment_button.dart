// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pay/pay.dart';

// class PaymentButton extends StatelessWidget {
//   final Function()? onPressed;
//   const PaymentButton({
//     Key? key,
//     this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GetPlatform.isAndroid
//         ? RawGooglePayButton(
//             onPressed: onPressed,
//             style: GooglePayButtonStyle.black,
//             type: GooglePayButtonType.pay,
//           )
//         : RawApplePayButton(
//             onPressed: onPressed,
//             style: ApplePayButtonStyle.black,
//             type: ApplePayButtonType.buy,
//           );
//   }
// }
