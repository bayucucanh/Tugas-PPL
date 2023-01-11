import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/requests/order.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class MidtransService {
  MidtransService._internal();

  static final MidtransService instance = MidtransService._internal();

  static late final MidtransSDK midtransSdk;

  void init() async {
    MidtransConfig config = MidtransConfig(
        clientKey: F.midtransClientKey,
        merchantBaseUrl: F.baseUrl,
        enableLog: F.isProduction ? false : true,
        environment: F.isProduction
            ? MidtransEnvironment.production
            : MidtransEnvironment.sandbox,
        colorTheme: ColorTheme(
          colorPrimary: primaryColor,
          colorSecondary: primaryColor,
          colorPrimaryDark: primaryColor,
        ));
    midtransSdk = await MidtransSDK.init(config: config);
    midtransSdk.setUIKitCustomSetting(
      setEnableAutoReadSms: true,
      skipCustomerDetailsPages: true,
      showPaymentStatus: true,
      saveCardChecked: true,
    );
  }

  void transactionFinishedCallback(Function(TransactionResult) callback) {
    midtransSdk.setTransactionFinishedCallback(callback);
  }

  void removeTransactionFinishedCallback() {
    midtransSdk.removeTransactionFinishedCallback();
  }

  void pay({required String snapToken}) async {
    await midtransSdk.startPaymentUiFlow(token: snapToken);
  }

  void changeOrderStatus(
      {required String orderId,
      required int status,
      required String message}) async {
    try {
      final orderRequest = OrderRequest();

      EasyLoading.show();
      await orderRequest.changeOrderStatus(orderId: orderId, status: status);
      EasyLoading.dismiss();
      getSnackbar('Informasi', message);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
