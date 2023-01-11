import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/subscription.dart';
import 'package:mobile_pssi/data/requests/subscribe.request.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ActiveSubscriptionController extends BaseController {
  final refreshController = RefreshController();
  final _subscribeRequest = SubscribeRequest();
  final _subscriptions = Resource<List<Subscription>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchSubscriptions();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _subscriptions.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      _fetchSubscriptions();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchSubscriptions() async {
    try {
      EasyLoading.show();
      var resp = await _subscribeRequest.activeSubscriptions(page: _page.value);

      _subscriptions.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  loadMore() {
    try {
      if (_page.value >= _subscriptions.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchSubscriptions();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  List<Subscription>? get subscriptions => _subscriptions.value.data;
}
