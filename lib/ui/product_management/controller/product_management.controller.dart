import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/product.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/product.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/product_management/add_product.dart';
import 'package:mobile_pssi/ui/product_management/edit_product.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductManagementController extends BaseController {
  final refreshController = RefreshController();
  final _productRequest = ProductRequest();
  final _products = Resource<List<Product>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchProducts();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _products.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchProducts();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchProducts() async {
    try {
      EasyLoading.show();
      var resp = await _productRequest.gets(page: _page.value);
      _products.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
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

  add() async {
    var data = await Get.toNamed(AddProduct.routeName);
    if (data != null) {
      refreshController.requestRefresh();
    }
  }

  edit(Product? product) {
    Get.toNamed(EditProduct.routeName, arguments: product?.toJson());
  }

  confirmDelete(Product? product) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Hapus Produk',
      content: 'Apakah anda yakin ingin menghapus ${product?.name ?? '-'}?',
      onConfirm: () => _delete(product),
    ));
  }

  _delete(Product? product) async {
    try {
      EasyLoading.show();
      await _productRequest.remove(id: product!.id!);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      refreshController.requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  List<Product>? get products => _products.value.data;
}
