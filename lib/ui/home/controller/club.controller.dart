import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/data/requests/subscribe.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/ui/events/event_detail.dart';
import 'package:mobile_pssi/ui/home/controller/menu.controller.dart';
import 'package:mobile_pssi/ui/premium/club_premium_store.dart';
import 'package:mobile_pssi/ui/scouting/coach_scouting.dart';
import 'package:mobile_pssi/ui/scouting/player_scouting.dart';
import 'package:mobile_pssi/ui/teams/team_screen.dart';
import 'package:mobile_pssi/ui/transfer_market/transfer_market.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class ClubController extends BaseController {
  final _subscribeRequest = SubscribeRequest();
  final menuController = Get.put(MenuController());
  final _eventRequest = EventRequest();
  final _eventList = Resource<List<Event>>(data: []).obs;
  final _eventLoading = true.obs;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  initialize() {
    getUserData();
    _getEventList();
  }

  _getEventList() async {
    try {
      _eventList(await _eventRequest.gets(limit: 5, target: 'klub'));
      _eventLoading(false);
    } on Exception catch (_) {}
  }

  openMyTeams() {
    Get.toNamed(TeamScreen.routeName);
  }

  openTransfermarket() async {
    try {
      EasyLoading.show();
      bool hasActiveSubscribe =
          await _subscribeRequest.hasActiveSubscribe(productIds: [4, 5, 6, 10]);
      EasyLoading.dismiss();
      if (!hasActiveSubscribe) {
        getSnackbar('Informasi',
            'Silahkan membeli paket ${F.title.toLowerCase()} terlebih dahulu.');
        return;
      }
      Get.toNamed(TransferMarket.routeName);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openPlayerScouting() async {
    try {
      EasyLoading.show();
      bool hasActiveSubscribe =
          await _subscribeRequest.hasActiveSubscribe(productIds: [7, 8, 10]);
      EasyLoading.dismiss();
      if (!hasActiveSubscribe) {
        getSnackbar('Informasi',
            'Silahkan membeli paket ${F.title.toLowerCase()} terlebih dahulu.');
        return;
      }
      Get.toNamed(PlayerScouting.routeName);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openCoachScouting() async {
    try {
      EasyLoading.show();
      bool hasActiveSubscribe =
          await _subscribeRequest.hasActiveSubscribe(productIds: [7, 8, 10]);
      EasyLoading.dismiss();
      if (!hasActiveSubscribe) {
        getSnackbar('Informasi',
            'Silahkan membeli paket ${F.title.toLowerCase()} terlebih dahulu.');
        return;
      }
      Get.toNamed(CoachScouting.routeName);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openClubStore() {
    Get.toNamed(ClubPremiumStore.routeName);
  }

  openEvent(Event? event) {
    Get.toNamed(EventDetail.routeName, arguments: event?.toJson());
  }

  bool get isLoadingEvent => _eventLoading.value;
  List<Event>? get events => _eventList.value.data;
}
