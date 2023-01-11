import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/order.dart';
import 'package:mobile_pssi/data/model/product.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/voucher.dart';
import 'package:mobile_pssi/data/requests/product.request.dart';
import 'package:mobile_pssi/data/requests/subscribe.request.dart';
import 'package:mobile_pssi/data/requests/voucher.request.dart';
import 'package:mobile_pssi/shared_functions/order.controller.dart';
import 'package:mobile_pssi/ui/premium/parts/club_packages.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ClubStoreController extends BaseController {
  final _productRequest = ProductRequest();
  final _voucherRequest = VoucherRequest();
  final _subscribeRequest = SubscribeRequest();
  final refreshController = RefreshController();
  final _products = Resource<List<Product>>(data: []).obs;
  final _page = 1.obs;
  final _order = Order().obs;
  final voucherCode = TextEditingController();
  final voucher = Voucher().obs;
  final _orderController = Get.put(OrderController());
  final InAppPurchase _iap = InAppPurchase.instance;
  final isStoreAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (GetPlatform.isAndroid) {
      _fetchProducts();
    } else if (GetPlatform.isIOS) {
      _getIosProducts();
    }
  }

  _getIosProducts() async {
    try {
      EasyLoading.show();
      isStoreAvailable(await _iap.isAvailable());

      const Set<String> kIds = <String>{
        'club_management',
        'club_membership_full_package',
        'talent_scouting_monthly_1',
        'talent_scouting_annual',
        'transfermarket_single',
        'transfermarket_double',
        'transfermarket_triple'
      };
      if (isStoreAvailable.value) {
        final ProductDetailsResponse response =
            await _iap.queryProductDetails(kIds);
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

  refreshData() {
    try {
      _page(1);
      _products.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      if (GetPlatform.isIOS) {
        _getIosProducts();
      } else {
        _fetchProducts();
      }
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchProducts() async {
    try {
      EasyLoading.show();
      var resp =
          await _productRequest.gets(page: _page.value, filterBy: 'club');
      _products.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      isStoreAvailable(true);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() {
    try {
      if (_page.value >= _products.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchProducts();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetail(Product? product) {
    getBottomSheet(ClubPackages(vm: this, product: product!));
  }

  void checkout(Product product) async {
    await _orderController.initialize(product: product, voucher: voucher.value);
    _orderController.checkout(onSettlement: (order, product) async {
      await _subscribeRequest.subscribeClub(
          orderId: order.code!, productId: product.productId!);
      _orderController.changeOrderStatus(
          orderId: order.code!, status: 2, message: 'Pembayaran Berhasil');
    }, onDenied: (order, product) {
      _orderController.changeOrderStatus(
          orderId: _order.value.code!, status: 5, message: 'Pembayaran Gagal');
    }, onExpired: (order, product) {
      _orderController.changeOrderStatus(
          orderId: _order.value.code!,
          status: 3,
          message: 'Pembayaran Kadaluarsa');
    }, onCancel: (order, product) {
      _orderController.changeOrderStatus(
          orderId: _order.value.code!,
          status: 4,
          message: 'Pembayaran Dibatalkan');
    });
  }

  applyPromo(Product? product) async {
    try {
      EasyLoading.show();
      voucher(
          await _voucherRequest.applyVoucher(voucherCode: voucherCode.text));
      EasyLoading.dismiss();
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      openDetail(product);
    } catch (e) {
      EasyLoading.dismiss();
      voucher(Voucher());
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      openDetail(product);
      getSnackbar('Informasi', e.toString());
    }
  }

  removeVoucher() {
    voucher(Voucher());
  }

  OrderController? get order => _orderController;
  List<Product>? get products => _products.value.data;
}
