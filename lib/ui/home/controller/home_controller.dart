import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/balance.dart';
import 'package:mobile_pssi/data/model/banner_image.dart';
import 'package:mobile_pssi/data/model/dashboard.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/banner.request.dart';
import 'package:mobile_pssi/data/requests/dashboard.request.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/data/requests/notification.request.dart';
import 'package:mobile_pssi/data/requests/user.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/profile_dialog.dart';
import 'package:mobile_pssi/ui/events/event_detail.dart';
import 'package:mobile_pssi/ui/home/controller/club.controller.dart';
import 'package:mobile_pssi/ui/home/controller/employee.controller.dart';
import 'package:mobile_pssi/ui/home/controller/menu.controller.dart';
import 'package:mobile_pssi/ui/home/controller/player.controller.dart';
import 'package:mobile_pssi/ui/notification/notification_screen.dart';
import 'package:mobile_pssi/ui/profile/personal_data.dart';
import 'package:mobile_pssi/ui/scanner/scanner.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeController extends BaseController {
  static HomeController get to => Get.put(HomeController());
  final scrollController = ScrollController();
  final refreshController = RefreshController();
  final _userRequest = UserRequest();
  final _bannerRequest = BannerRequest();
  final _dashboardRequest = DashboardRequest();
  final _notificationRequest = NotificationRequest();
  final _playerController = Get.put(PlayerController());
  final _menuController = Get.put(MenuController());
  final _employeeController = Get.put(EmployeeController());
  final _clubController = Get.put(ClubController());
  final dashboard = Dashboard().obs;
  final _banners = Resource<List<BannerImage>>(data: []).obs;
  final unreadMessage = 0.obs;
  final _eventRequest = EventRequest();
  final _competitionList = Resource<List<Event>>(data: []).obs;
  final _competitionLoading = true.obs;
  final _target = ''.obs;
  final _userBalance = Balance(balance: 0.0).obs;
  final _loadingBanner = false.obs;

  @override
  void onInit() {
    getUserData();
    _checkTarget();
    _initialize();
    super.onInit();
  }

  _initialize() async {
    _getBanners();
    _fetchUnreadNumbers();
    _getBalance();
    if (userData.value.isPlayer) {
      _playerController.initialize();
    } else if (userData.value.isCoach) {
      await getProfile();
      _employeeController.menuController.refreshMenu();
    } else if (userData.value.isClub) {
      _clubController.initialize();
    }
    getDashboardStatus();
    _showVerificationForm();
    _getCompetitionList();
  }

  refreshHome() async {
    try {
      _initialize();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshCompleted();
    }
  }

  _checkTarget() {
    if (userData.value.isPlayer) {
      _target('pemain');
    } else if (userData.value.isCoach) {
      _target('pelatih');
    } else if (userData.value.isClub) {
      _target('klub');
    }
  }

  _getCompetitionList() async {
    try {
      _competitionList(await _eventRequest.gets(
          limit: 5, target: _target.value, eventType: 'competition'));
      _competitionLoading(false);
    } on Exception catch (_) {
      _competitionLoading(true);
    }
  }

  _getBanners() async {
    try {
      _loadingBanner(true);
      var resp = await _bannerRequest.getBanners(limit: 6);

      if (resp.data!.isEmpty) {
        _banners.update((val) {
          val?.data?.clear();
          Uri? uri = Uri.tryParse(F.baseUrl);
          String url =
              '${uri?.scheme}://${uri?.host}/assets/images/default-banner.png';
          if (F.isDev) {
            url =
                '${uri?.scheme}://${uri?.host}:${uri?.port}/assets/images/default-banner.png';
          }
          val?.data?.add(BannerImage(title: F.title, imageUrl: url));
        });
      } else {
        _banners(resp);
      }
      _loadingBanner(false);
    } catch (_) {
      _loadingBanner(false);
    }
  }

  _fetchUnreadNumbers() async {
    try {
      unreadMessage(await _notificationRequest.totalUnreadNotification());
    } catch (_) {}
  }

  openNotification() async {
    await Get.toNamed(NotificationScreen.routeName);
    _fetchUnreadNumbers();
  }

  getDashboardStatus() async {
    if (userData.value.hasRole('administrator')) {
      try {
        dashboard(await _dashboardRequest.getDashboardStats());
      } catch (_) {}
    }
  }

  showProfileDialog() {
    getUserData();
    Get.dialog(ProfileDialog(vm: _menuController));
  }

  _showVerificationForm() {
    if (userData.value.isCoach && !userData.value.hasRole('administrator')) {
      if (userData.value.ktp?.status?.id != 1) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAllNamed(PersonalData.routeName, arguments: {
            'show_verification_form': true,
          });
        });
      }
    } else if (userData.value.isClub &&
        !userData.value.hasRole('administrator')) {
      if (userData.value.klb?.status?.id != 1) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAllNamed(PersonalData.routeName, arguments: {
            'show_verification_form': true,
          });
        });
      }
    }
  }

  _getBalance() async {
    try {
      _userBalance(await _userRequest.getBalance());
    } catch (_) {}
  }

  openEvent(Event? event) {
    Get.toNamed(EventDetail.routeName, arguments: event?.toJson());
  }

  openLink(String? url) async {
    if (url != null) {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      }
    }
  }

  openScanner() {
    Get.toNamed(Scanner.routeName);
  }

  List<BannerImage>? get banners => _banners.value.data;
  bool? get isLoadingBanner => _loadingBanner.value;
  List<Event>? get competitions => _competitionList.value.data;
  bool? get isCompetitionLoading => _competitionLoading.value;
  Balance? get userBalance => _userBalance.value;
}
