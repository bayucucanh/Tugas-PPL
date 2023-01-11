import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/class_category.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/latest_watch.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/data/requests/class_category.request.dart';
import 'package:mobile_pssi/data/requests/coach.request.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/ui/class/class_screen.dart';
import 'package:mobile_pssi/ui/dashboard/controller/dashboard_controller.dart';
import 'package:mobile_pssi/ui/events/event_detail.dart';
import 'package:mobile_pssi/ui/premium/premium_join_screen.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/ui/watch/watch.screen.dart';

class PlayerController extends BaseController {
  final _classRequest = ClassRequest();
  final _coachRequest = CoachRequest();
  final _eventRequest = EventRequest();
  final _topicRequest = ClassCategoryRequest();
  final freeClasses = Resource<List<Class>>(data: []).obs;
  final premiumClasses = Resource<List<Class>>(data: []).obs;
  final _loadingFreeClasses = true.obs;
  final _loadingPremiumClasses = true.obs;
  final topics = Resource<List<ClassCategory>>(data: []).obs;
  final _loadingTopic = true.obs;
  final latestWatches = Resource<List<LatestWatch>>(data: []).obs;
  final coachList = Resource<List<User>>(data: []).obs;
  final isPremiumSubscribe = false.obs;
  final _eventList = Resource<List<Event>>(data: []).obs;
  final _eventLoading = true.obs;

  @override
  void onInit() {
    getUserData();
    initialize();
    super.onInit();
  }

  initialize() {
    _isSubscribed();
    _getEventList();
    if (userData.value.isPlayer) {
      _getSkills();
      _getFreeClassList();
      _getPremiumClassList();
      _getLatestWatchVideos();
      _getCoachList();
    }
  }

  _getSkills() async {
    try {
      topics(await _topicRequest.gets(option: 'select'));
      _loadingTopic(false);
    } on Exception catch (_) {}
  }

  _getFreeClassList() async {
    try {
      freeClasses(await _classRequest.getClass(
          limit: 5, filter: 'has_video', onlyPremium: false));
      _loadingFreeClasses(false);
    } on Exception catch (_) {}
  }

  _getPremiumClassList() async {
    try {
      premiumClasses(await _classRequest.getClass(
          limit: 5, filter: 'has_video', onlyPremium: true));
      _loadingPremiumClasses(false);
    } on Exception catch (_) {}
  }

  _getEventList() async {
    try {
      _eventList(await _eventRequest.gets(limit: 5, target: 'pemain'));
      _eventLoading(false);
    } on Exception catch (_) {}
  }

  _getLatestWatchVideos() async {
    try {
      latestWatches(await _classRequest.latestWatchVideos());
    } on Exception catch (_) {}
  }

  _getCoachList() async {
    try {
      coachList(await _coachRequest.getCoachList(
          limit: 6, onlyPartner: true, option: 'select'));
    } on Exception catch (_) {}
  }

  _isSubscribed() async {
    try {
      isPremiumSubscribe(await hasSubscription());
    } catch (_) {
      isPremiumSubscribe(false);
    }
  }

  openList({bool? premiumClass, ClassCategory? category}) {
    Get.toNamed(ClassScreen.routeName, arguments: premiumClass, parameters: {
      'class_category_id': category?.id == null ? '' : category!.id.toString(),
    });
  }

  allWatchesVideo() {
    DashboardController.to.changePage(2);
  }

  openClass(LatestWatch? latestWatch) {
    Get.toNamed(WatchScreen.routeName, arguments: latestWatch?.toClass().toJson());
  }

  openPremiumJoin() async {
    await Get.toNamed(PremiumJoinScreen.routeName);
    _isSubscribed();
  }

  openCoachProfile(User coach) {
    Get.toNamed(CoachProfile.routeName, arguments: coach.toJson());
  }

  openEvent(Event? event) {
    Get.toNamed(EventDetail.routeName, arguments: event?.toJson());
  }

  bool get isLoadingTopic => _loadingTopic.value;
  bool get isLoadingFreeClass => _loadingFreeClasses.value;
  bool get isLoadingPremiumClass => _loadingPremiumClasses.value;
  bool get isLoadingEvent => _eventLoading.value;
  List<Event>? get events => _eventList.value.data;
}
