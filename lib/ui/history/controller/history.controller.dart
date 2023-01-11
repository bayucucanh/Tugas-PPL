import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/log_video.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/ui/watch/watch.screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HistoryController extends BaseController {
  final RefreshController refreshController = RefreshController();
  final page = 1.obs;
  final _classRequest = ClassRequest();
  final history = Resource<List<LogVideo>>(data: []).obs;

  @override
  void onInit() {
    _fetchLatestWatch();
    super.onInit();
  }

  refreshPage() {
    try {
      page(1);
      history.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchLatestWatch();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchLatestWatch() async {
    try {
      var resp =
          await _classRequest.watchHistory(page: page.value, orderBy: 'desc');
      history.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
    } catch (_) {}
  }

  loadNextPage() {
    try {
      page(page.value + 1);
      if (page.value >= history.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _fetchLatestWatch();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openClass(LogVideo? latestWatch) {
    Get.toNamed(WatchScreen.routeName,
        arguments: latestWatch?.learning?.toClass().toJson());
  }
}
