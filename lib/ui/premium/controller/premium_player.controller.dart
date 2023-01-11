import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/banner_image.dart';
import 'package:mobile_pssi/data/model/product.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/voucher.dart';
import 'package:mobile_pssi/data/requests/banner.request.dart';
import 'package:mobile_pssi/data/requests/product.request.dart';
import 'package:mobile_pssi/data/requests/subscribe.request.dart';
import 'package:mobile_pssi/data/requests/voucher.request.dart';
import 'package:mobile_pssi/shared_functions/order.controller.dart';
import 'package:mobile_pssi/ui/premium/parts/premium_packages.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class PremiumPlayerController extends BaseController {
  final _productRequest = ProductRequest();
  final _bannerRequest = BannerRequest();
  final _voucherRequest = VoucherRequest();
  final _subscribeRequest = SubscribeRequest();
  final selectedSubscription = false.obs;
  final selectedProduct = Product().obs;
  final voucherCode = TextEditingController();
  final voucher = Voucher().obs;
  final _banners = Resource<List<BannerImage>>(data: []).obs;
  final _products = Resource<List<Product>>(data: []).obs;
  final _orderController = Get.put(OrderController());
  final isStoreAvailable = false.obs;

  @override
  void onInit() {
    _initialize();
    super.onInit();
  }

  _initialize() async {
    await getUserData();
    _getBanners();

    if (GetPlatform.isAndroid) {
      _getProducts();
    } else if (GetPlatform.isIOS) {
      _getIosProducts();
    }
  }

  _getBanners() async {
    try {
      _banners(await _bannerRequest.getBanners(limit: 6));
    } catch (_) {}
  }

  notNow() {
    Get.back();
  }

  _getProducts() async {
    try {
      EasyLoading.show();
      _products(await _productRequest.gets(
        option: 'select',
        filterBy: 'player',
        sortBy: 'price',
        orderBy: 'asc',
      ));
      EasyLoading.dismiss();
      isStoreAvailable(true);
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  _getIosProducts() async {
    try {
      EasyLoading.show();
      isStoreAvailable(await InAppPurchase.instance.isAvailable());

      const Set<String> kIds = <String>{
        'basic_membership',
        'intermediate_membership',
        'expert_membership',
      };
      if (isStoreAvailable.value) {
        final ProductDetailsResponse response =
            await InAppPurchase.instance.queryProductDetails(kIds);
        if (response.productDetails.isNotEmpty) {
          Resource<List<Product>> iosProducts = Resource<List<Product>>(
              data: response.productDetails
                  .map((e) => Product.fromIoStore(e))
                  .toList());
          _products(iosProducts);
        }
      } else {
        getSnackbar('Informasi', 'Tidak dapat terhubung ke app store.');
      }
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  showPackages() async {
    getBottomSheet(
      PremiumPackages(vm: this),
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  selectSubscription(Product? item) {
    selectedProduct(item);
  }

  void checkout() async {
    _orderController.initialize(
        product: selectedProduct.value, voucher: voucher.value);
    _orderController.checkout(onSettlement: (order, product) async {
      await _subscribeRequest.subscribePlayer(
          orderId: order.code!, productId: product.productId!);
    }, onDenied: (order, product) {
      _orderController.changeOrderStatus(
          orderId: order.code!, status: 5, message: 'Pembayaran Gagal');
    }, onExpired: (order, product) {
      _orderController.changeOrderStatus(
          orderId: order.code!, status: 3, message: 'Pembayaran Kadaluarsa');
    }, onCancel: (order, product) {
      _orderController.changeOrderStatus(
          orderId: order.code!, status: 4, message: 'Pembayaran Dibatalkan');
    });
  }

  applyPromo() async {
    try {
      EasyLoading.show();
      voucher(
          await _voucherRequest.applyVoucher(voucherCode: voucherCode.text));
      EasyLoading.dismiss();
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      showPackages();
    } catch (e) {
      EasyLoading.dismiss();
      voucher(Voucher());
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      showPackages();
      getSnackbar('Informasi', e.toString());
    }
  }

  OrderController get order => _orderController;
  List<BannerImage>? get banners => _banners.value.data;
  List<Product>? get products => _products.value.data;
}
