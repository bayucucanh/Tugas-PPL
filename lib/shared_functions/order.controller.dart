// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/order.dart';
import 'package:mobile_pssi/data/model/order_detail.dart';
import 'package:mobile_pssi/data/model/product.dart';
import 'package:mobile_pssi/data/model/voucher.dart';
import 'package:mobile_pssi/data/requests/order.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/services/midtrans/midtrans_service.dart';
import 'package:mobile_pssi/shared_functions/payment_queue.delegate.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/shared_ui/pending_payment_ios.dart';
import 'package:mobile_pssi/ui/payment/payment.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class OrderController extends BaseController {
  final _orderRequest = OrderRequest();
  final _paymentService = MidtransService.instance;
  final CurrencyTextInputFormatter currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );
  final _order = Order().obs;
  final _product = Product().obs;
  final _voucher = Voucher().obs;
  final inAppPurchase = InAppPurchase.instance;
  final isPurchased = false.obs;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  @override
  Future<void> onInit() async {
    getUserData();
    if (GetPlatform.isAndroid) {
      _paymentService.transactionFinishedCallback((result) {
        if (result.isTransactionCanceled) {
          _paymentService.changeOrderStatus(
              orderId: _order.value.code!,
              status: 4,
              message: 'Pembayaran Dibatalkan');
        }
      });
    } else if (GetPlatform.isIOS) {
      _initStoreInfo();
      _subscription = inAppPurchase.purchaseStream.listen((purchaseDetails) {
        _listenPurchaseUpdated(purchaseDetails);
      }, onDone: () {
        _subscription.cancel();
      }, onError: (err) {
        debugPrint(err);
      });
    }
    FirebaseMessaging.onMessage.listen((event) {
      Map<String, dynamic>? message = event.toMap();
      _handlePayment(message);
    });
    super.onInit();
  }

  Future<void> _initStoreInfo() async {
    if (GetPlatform.isIOS) {
      var iosPlatformAddition = inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
    }
  }

  _listenPurchaseUpdated(List<PurchaseDetails> purchaseDetails) async {
    if (purchaseDetails.isNotEmpty) {
      PurchaseDetails purchase = purchaseDetails[0];
      switch (purchase.status) {
        case PurchaseStatus.pending:
          getDialog(
            ConfirmationDefaultDialog(
              title: 'Menunggu Pembayaran',
              contentWidget:
                  PendingPaymentIos(vm: this, purchaseDetails: purchase),
              showCancel: false,
              showConfirm: false,
            ),
            barrierDismissible: true,
          );
          break;
        case PurchaseStatus.purchased:
          if (isPurchased.value == false) {
            isPurchased(true);
            _completeIosPurchase(purchase);
          }
          break;
        case PurchaseStatus.restored:
          break;
        case PurchaseStatus.error:
          if (Get.isDialogOpen!) {
            Get.back();
          }
          inAppPurchase.completePurchase(purchase);
          getSnackbar('Informasi', purchase.error!.message);
          break;
        case PurchaseStatus.canceled:
          if (Get.isDialogOpen!) {
            Get.back();
          }
          getSnackbar('Informasi', 'Pembayaran dibatalkan.');
          break;
      }

      if (purchase.pendingCompletePurchase) {
        inAppPurchase.completePurchase(purchase);
      }
    }
  }

  _completeIosPurchase(PurchaseDetails purchase) async {
    try {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      await _orderRequest.validateReceipt(
          purchase: purchase, price: _product.value.price!);
      if (Get.isOverlaysClosed) {
        Get.back();
      }
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  @override
  void onClose() {
    _closePaymentService();
    super.onClose();
  }

  _handlePayment(Map<String, dynamic>? message) async {
    Map<String, dynamic>? data = message?['data'];
    if (data != null) {
      if (data['event_type'] == 'payment') {
        switch (data['status']) {
          case '2':
            if (Get.isBottomSheetOpen!) {
              Get.back();
            }
            Get.back();
            break;
        }
      }
    }
  }

  _closePaymentService() async {
    _paymentService.removeTransactionFinishedCallback();
    if (GetPlatform.isIOS) {
      var iosPlatformAddition = inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(null);
    }
  }

  initialize({
    required Product product,
    Voucher? voucher,
  }) {
    _product(product);
    _voucher(voucher);
    getUserData();
  }

  _buyFromAppStore() async {
    try {
      ProductDetails productDetails = _product.value.toProductDetails();
      var transactions = await SKPaymentQueueWrapper().transactions();
      for (var skPaymentTransactionWrapper in transactions) {
        SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
      }
      switch (_product.value.productId) {
        case 'basic_membership':
        case 'intermediate_membership':
        case 'expert_membership':
        case 'talent_scouting_monthly':
        case 'talent_scouting_annual':
        case 'club_management':
        case 'club_membership_full_package':
          await inAppPurchase.buyNonConsumable(
              purchaseParam: PurchaseParam(
                  productDetails: productDetails,
                  applicationUserName: userData.value.username));
          break;
        case 'transfermarket_single':
        case 'transfermarket_double':
        case 'transfermarket_triple':
          await inAppPurchase.buyConsumable(
            purchaseParam: PurchaseParam(
                productDetails: productDetails,
                applicationUserName: userData.value.username),
          );
          break;
        default:
          throw ArgumentError.value(
              _product.value.name, '${_product.value.name} tidak diketahui');
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  void checkout({
    void Function(Order, Product)? onSettlement,
    void Function(Order, Product)? onDenied,
    void Function(Order, Product)? onExpired,
    void Function(Order, Product)? onCancel,
  }) async {
    try {
      EasyLoading.show();
      if (GetPlatform.isIOS) {
        _buyFromAppStore();
        return;
      }
      _order(await _orderRequest.create(
        order: Order(
          totalPrice: _product.value.price,
          orderDetails: [
            OrderDetail(
              productId: _product.value.id,
              name: _product.value.name,
              price: _product.value.price,
              quantity: 1,
            ),
          ],
        ),
        voucher: _voucher.value,
      ));
      EasyLoading.dismiss();

      if (totalPrice(_product.value, voucher: _voucher.value) == 'Gratis') {
        EasyLoading.show();
        await _orderRequest.freeOrder(orderCode: _order.value.code!);
        EasyLoading.dismiss();
        if (Get.isBottomSheetOpen!) {
          Get.back();
        }
      } else {
        _getMidtransService(
          onSettlement: onSettlement,
          onDenied: onDenied,
          onExpired: onExpired,
          onCancel: onCancel,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _getMidtransService({
    void Function(Order, Product)? onSettlement,
    void Function(Order, Product)? onDenied,
    void Function(Order, Product)? onExpired,
    void Function(Order, Product)? onCancel,
  }) async {
    if (F.isStaging && kReleaseMode) {
      var status = await Get.toNamed(Payment.routeName,
          arguments: _order.value.snapToken);
      if (status != null) {
        switch (status) {
          case TransactionResultStatus.capture:
          case TransactionResultStatus.settlement:
            try {
              EasyLoading.show();
              onSettlement!(_order.value, _product.value);
              EasyLoading.dismiss();
              if (Get.isBottomSheetOpen!) {
                Get.back();
              }
              Get.back();
            } catch (e) {
              EasyLoading.dismiss();
              getSnackbar('Informasi', e.toString());
            }
            break;
          case TransactionResultStatus.deny:
            onDenied!(_order.value, _product.value);
            break;
          case TransactionResultStatus.expire:
            onExpired!(_order.value, _product.value);
            break;
          case TransactionResultStatus.cancel:
            onCancel!(_order.value, _product.value);
            break;
        }
      }
    } else {
      _paymentService.pay(snapToken: _order.value.snapToken!);
    }
  }

  void changeOrderStatus(
      {required String orderId,
      required int status,
      required String message}) async {
    try {
      EasyLoading.show();
      await _orderRequest.changeOrderStatus(orderId: orderId, status: status);
      EasyLoading.dismiss();
      getSnackbar('Informasi', message);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  String? savedPrice(Product product, {Voucher? voucher}) {
    double totalPrice = product.price! + calculatePriceWithTax(product)!;
    double voucherPrice = calculateVoucher(totalPrice, voucher: voucher);
    return currencyFormatter.format(voucherPrice.toStringAsFixed(0));
  }

  String? totalPrice(Product product, {Voucher? voucher}) {
    if (calculatePriceWithTax(product) == null) {
      return null;
    }

    double productPrice = product.price!;
    double totalPrice = (productPrice + calculatePriceWithTax(product)!);
    if (voucher?.code != null) {
      totalPrice -= calculateVoucher(totalPrice, voucher: voucher);
    }
    if (totalPrice <= 0) {
      return 'Gratis';
    }

    String total = totalPrice.toStringAsFixed(0);

    if (product.currency != null) {
      if (product.currency == 'IDR') {
        return currencyFormatter.format(productPrice.toStringAsFixed(0));
      }
      return '${product.currency} $productPrice';
    }

    return currencyFormatter.format(total);
  }

  double calculateVoucher(double totalPrice, {Voucher? voucher}) {
    double calculatedByVoucher = totalPrice;
    if (voucher != null) {
      if (voucher.isPercentage == true) {
        calculatedByVoucher = totalPrice * (voucher.value! / 100);
      } else {
        calculatedByVoucher = (totalPrice - voucher.value!);
      }
    }
    return calculatedByVoucher;
  }

  double? calculatePriceWithTax(Product product) {
    if (product.isBlank == true) {
      return null;
    }
    double tax = 11 / 100; // 11% tax percentage
    double totalPrice = product.price!;
    double priceTax = totalPrice * tax;
    return priceTax;
  }
}
