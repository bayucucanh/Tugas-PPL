import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/help.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/help.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/help/add_help.dart';
import 'package:mobile_pssi/ui/help/edit_help.dart';
import 'package:mobile_pssi/ui/help/help_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HelpController extends BaseController {
  final refreshController = RefreshController();
  final _helpRequest = HelpRequest();
  final _helps = Resource<List<Help>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchFaq();
    super.onInit();
  }

  refreshData() async {
    try {
      _page(1);
      _helps.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchFaq();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchFaq() async {
    try {
      EasyLoading.show();
      var resp = await _helpRequest.gets(page: _page.value);
      _helps.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() async {
    try {
      if (_page.value >= _helps.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchFaq();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  addHelp() async {
    var data = await Get.toNamed(AddHelp.routeName);

    if (data != null) {
      refreshController.requestRefresh();
    }
  }

  openHelp(Help? help) {
    Get.toNamed(HelpDetail.routeName, arguments: help?.toJson());
  }

  openEditHelp(Help? help) {
    Get.toNamed(EditHelp.routeName, arguments: help?.toJson());
  }

  confirmDelete(Help? help) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Hapus Bantuan',
      content: 'Apakah kamu yakin ingin menghapus ${help?.title ?? '-'}?',
      onConfirm: () => _delete(help),
    ));
  }

  _delete(Help? help) async {
    try {
      EasyLoading.show();
      await _helpRequest.remove(slug: help!.slug!);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      _helps.update((val) {
        val?.data?.remove(help);
      });
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  List<Help>? get helps => _helps.value.data;
}
