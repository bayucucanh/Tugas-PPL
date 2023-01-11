import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_pssi/data/remote/network.dart';
// import 'package:mobile_pssi/services/in_app_purchase/in_app_purchase.dart';
import 'package:mobile_pssi/ui/notification/controller/notification.controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<GetStorage>(GetStorage(), permanent: true);
    Get.put<Network>(Network(), permanent: true);
    // Get.put<InAppPurchaseService>(InAppPurchaseService(), permanent: true);

    Get.lazyPut(() => NotificationController());
  }
}
