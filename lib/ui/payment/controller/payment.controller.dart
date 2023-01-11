import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/flavors.dart';

class PaymentController extends BaseController {
  final token = ''.obs;
  final transactionStatus = TransactionResultStatus.cancel.obs;
  final progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseMessaging.onMessage.listen((event) {
      Map<String, dynamic>? message = event.toMap();
      _handlePayment(message);
    });
  }

  PaymentController() {
    token(Get.arguments);
  }

  back() {
    Get.back(result: transactionStatus);
  }

  onWebviewCreated(InAppWebViewController? controller) {
    controller?.addJavaScriptHandler(
        handlerName: 'Print',
        callback: (callback) {
          String? message = callback[0];
          if (message != null || message != 'undefined') {
            if (message == 'close') {
              Get.back(result: transactionStatus.value);
            } else {
              _handleResponse(message);
            }
          }
        });
    controller?.addJavaScriptHandler(
        handlerName: 'Android',
        callback: (callback) {
          String? message = callback[0];
          if (Platform.isAndroid) {
            if (message != null || message != 'undefined') {
              if (message == 'close') {
                Get.back(result: transactionStatus.value);
              } else {
                _handleResponse(message);
              }
            }
          }
        });
  }

  onProgressChanged(InAppWebViewController controller, int? pr) {
    if (pr != null) {
      progress(pr / 100);
    }
  }

  InAppWebViewInitialData? getInitialData() {
    return InAppWebViewInitialData(
      data: '''<html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script 
          type="text/javascript"
          src="https://app.sandbox.midtrans.com/snap/snap.js"
          data-client-key="${F.midtransClientKey}"
        ></script>
      </head>
      <body onload="setTimeout(function(){pay()}, 1000)">
        <script type="text/javascript">
            var Android;
            function pay() {
                snap.pay('${token.value}', {
                  // Optional
                  onSuccess: function(result) {
                    window.flutter_inappwebview.callHandler('Android', 'ok');
                    window.flutter_inappwebview.callHandler('Print', result);
                  },
                  // Optional
                  onPending: function(result) {
                    window.flutter_inappwebview.callHandler('Android', 'pending');
                    window.flutter_inappwebview.callHandler('Print', result);
                  },
                  // Optional
                  onError: function(result) {
                    window.flutter_inappwebview.callHandler('Android', 'error');
                    window.flutter_inappwebview.callHandler('Print', result);
                  },
                  onClose: function() {
                    window.flutter_inappwebview.callHandler('Android', 'close');
                    window.flutter_inappwebview.callHandler('Print', 'close');
                  }
                });
            }
        </script>
      </body>
    </html>''',
      mimeType: 'text/html',
    );
  }

  _handleResponse(String? message) {
    switch (message) {
      case 'ok':
        transactionStatus(TransactionResultStatus.settlement);
        break;
      case 'pending':
        transactionStatus(TransactionResultStatus.pending);
        break;
      case 'error':
      default:
        transactionStatus(TransactionResultStatus.deny);
        break;
    }
  }

  _handlePayment(Map<String, dynamic>? message) {
    Map<String, dynamic>? data = message?['data'];
    if (data != null) {
      if (data['event_type'] == 'payment') {
        switch (data['status']) {
          case '2':
            Get.back(result: TransactionResultStatus.settlement);
            break;
          case '3':
            Get.back(result: TransactionResultStatus.expire);
            break;
          case '4':
            Get.back(result: TransactionResultStatus.cancel);
            break;
        }
      }
    }
  }
}
