import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/quick_reply.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/quick_reply.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/consulting/add_auto_text.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AutoTextsController extends BaseController {
  final _quickReplyRequest = QuickReplyRequest();
  final refreshController = RefreshController();
  final _quickReplies = Resource<List<QuickReply>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchQuickReplies();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _quickReplies.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchQuickReplies();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchQuickReplies() async {
    try {
      EasyLoading.show();
      var resp = await _quickReplyRequest.gets(page: _page.value);
      _quickReplies.update((val) {
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
      if (_page.value >= _quickReplies.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchQuickReplies();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  // edit(Consultation? consultation) {
  //   Get.toNamed(ConsultRoom.routeName, arguments: consultation);
  // }

  addAutoText() async {
    var data = await Get.toNamed(AddAutoText.routeName);
    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  confirmDelete(QuickReply? quickReply) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Hapus Auto Text',
      content:
          'Apakah anda yakin ingin menghapus ${quickReply?.shortcut ?? '-'}?',
      onConfirm: () => _delete(quickReply),
    ));
  }

  _delete(QuickReply? quickReply) async {
    try {
      EasyLoading.show();
      await _quickReplyRequest.remove(quickReplyId: quickReply!.id!);
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

  List<QuickReply>? get quickReplies => _quickReplies.value.data;
}
