import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/banner_image.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/banner.request.dart';
import 'package:mobile_pssi/ui/banners/new_banner.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BannerListController extends BaseController {
  final refreshController = RefreshController();
  final _bannerRequest = BannerRequest();
  final _banners = Resource<List<BannerImage>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    getUserData();
    _fetchBanners();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      _banners.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchBanners();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchBanners() async {
    try {
      EasyLoading.show();
      var resp = await _bannerRequest.getBanners(page: page.value);
      _banners.update((val) {
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
      if (page.value >= _banners.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchBanners();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  newBanner() async {
    var result = await Get.toNamed(NewBanner.routeName);

    if (result == 'success') {
      refreshController.requestRefresh();
    }
  }

  confirmDeleteBanner(BannerImage banner) {
    Get.defaultDialog(
      title: 'Hapus Banner',
      middleText: 'Apakah anda yakin akan menghapus banner ini?',
      textCancel: 'Batal',
      textConfirm: 'Hapus',
      buttonColor: primaryColor,
      cancelTextColor: primaryColor,
      onConfirm: () => _deleteBanner(banner),
    );
  }

  _deleteBanner(BannerImage banner) async {
    try {
      EasyLoading.show();
      await _bannerRequest.deleteBanner(bannerId: banner.id);
      _banners.update((val) {
        val?.data?.remove(banner);
      });
      if (Get.isDialogOpen!) {
        Get.back();
      }
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  List<BannerImage>? get banners => _banners.value.data;
}
