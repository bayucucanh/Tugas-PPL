import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/rating_class.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/rating.request.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReviewsController extends BaseController {
  final _ratingRequest = RatingRequest();
  final refreshController = RefreshController();
  final _reviews = Resource<List<RatingClass>>(data: []).obs;
  final _page = 1.obs;
  final _coach = User().obs;

  ReviewsController() {
    _coach(User.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _getClassReviews();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _reviews.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _getClassReviews();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _getClassReviews() async {
    try {
      EasyLoading.show();
      _reviews(await _ratingRequest.getAllReviews(
          coachId: _coach.value.id!, page: _page.value));
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() async {
    try {
      if (_page.value >= _reviews.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _getClassReviews();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  List<RatingClass>? get reviews => _reviews.value.data;
}
