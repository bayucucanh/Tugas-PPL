import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/document.request.dart';
import 'package:mobile_pssi/ui/secure_documents/user_documents.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SecureDocumentsController extends BaseController {
  final refreshController = RefreshController();
  final _documentRequest = DocumentRequest();
  final _users = Resource<List<User>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchUsers();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _users.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchUsers();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchUsers() async {
    try {
      EasyLoading.show();
      var resp = await _documentRequest.getUnverifiedSecureDocuments(
          page: _page.value);
      _users.update((val) {
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
      if (_page.value >= _users.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchUsers();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openUser(User? user) {
    Get.toNamed(UserDocuments.routeName, arguments: user?.toJson());
  }

  List<User>? get users => _users.value.data;
}
