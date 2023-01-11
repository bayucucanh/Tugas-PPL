import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/remote/network.dart';
import 'package:mobile_pssi/data/requests/auth.request.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/data/requests/performance_test.request.dart';
import 'package:mobile_pssi/data/requests/subscribe.request.dart';
import 'package:mobile_pssi/data/requests/user.request.dart';
import 'package:mobile_pssi/services/notification_service.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/achievement/achievement_list.dart';
import 'package:mobile_pssi/ui/championships/championships.dart';
import 'package:mobile_pssi/ui/club/club_list.dart';
import 'package:mobile_pssi/ui/club/vacancy_list.dart';
import 'package:mobile_pssi/ui/coach/coach_list.dart';
import 'package:mobile_pssi/ui/competitions/all_events.dart';
import 'package:mobile_pssi/ui/consulting/consult_list.dart';
import 'package:mobile_pssi/ui/dashboard/controller/dashboard_controller.dart';
import 'package:mobile_pssi/ui/events/all_events.dart';
import 'package:mobile_pssi/ui/experiences/experiences.dart';
import 'package:mobile_pssi/ui/login/login_screen.dart';
import 'package:mobile_pssi/ui/offering/offer_list_club.dart';
import 'package:mobile_pssi/ui/offering/offer_team_coach_list.dart';
import 'package:mobile_pssi/ui/offering/offer_team_player_list.dart';
import 'package:mobile_pssi/ui/payment/payment_history.dart';
import 'package:mobile_pssi/ui/premium/premium_join_screen.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/ui/profile/player/player_profile.dart';
import 'package:mobile_pssi/ui/recent_educations/educations.dart';
import 'package:mobile_pssi/ui/shared_component/class_joined.dialog.dart';
import 'package:mobile_pssi/ui/shared_component/join_class.dialog.dart';
import 'package:mobile_pssi/ui/statistics/detail_statistic.dart';
import 'package:mobile_pssi/ui/test_parameter/test_parameter.dart';
import 'package:mobile_pssi/ui/watch/watch.screen.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';

abstract class BaseController extends GetxController {
  final userData = User().obs;
  final _authRequest = AuthRequest();
  final _userRequest = UserRequest();
  final _subscribeRequest = SubscribeRequest();
  final _performanceTestRequest = PerformanceTestRequest();
  final _classRequest = ClassRequest();
  final network = Get.find<Network>();
  final messaging = NotificationService.instance;

  getUserData() {
    var user = Storage.get(ProfileStorage.user);
    if (user == null) {
      Get.offAllNamed(LoginScreen.routeName);
      return;
    }
    if (user is User == false) {
      userData(User.fromJson(user));
    }
  }

  getProfile() async {
    try {
      EasyLoading.show();
      User user = await _userRequest.getProfile();
      EasyLoading.dismiss();
      Storage.save(ProfileStorage.user, user.toJson());
      getUserData();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  showClass(Class selectedClass) async {
    try {
      getUserData();
      if (!userData.value.isPlayer) {
        return;
      }
      EasyLoading.show();
      bool hasJoined =
          await _classRequest.checkJoinedClass(id: selectedClass.id!);
      EasyLoading.dismiss();
      if (selectedClass.isPremiumContent) {
        if (await hasSubscription()) {
          if (hasJoined) {
            Get.toNamed(WatchScreen.routeName,
                arguments: selectedClass.toJson());
          } else {
            _showJoinClassDialog(selectedClass);
          }
        } else {
          getDialog(ConfirmationDefaultDialog(
            title: 'Kelas Premium',
            content:
                'Kuota kelas premium telah habis, Apakah ingin membeli kuota premium?',
            onConfirm: () {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              Get.toNamed(PremiumJoinScreen.routeName);
            },
          ));
        }
      } else {
        if (hasJoined) {
          Get.toNamed(WatchScreen.routeName, arguments: selectedClass.toJson());
        } else {
          _showJoinClassDialog(selectedClass);
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _showJoinClassDialog(Class selectedClass) {
    Get.dialog(JoinClassDialog(
      onYes: () => _joinClassCofirmation(selectedClass: selectedClass),
    ));
  }

  _joinClassCofirmation({
    required Class selectedClass,
  }) async {
    try {
      EasyLoading.show();
      await _classRequest.joinClass(id: selectedClass.id!);
      EasyLoading.dismiss();
      Get.back();
      _showJoinedClassDialog(selectedClass);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _showJoinedClassDialog(Class selectedClass) {
    Get.dialog(
      ClassJoined(
        onYes: () {
          Get.back();
          Get.toNamed(WatchScreen.routeName, arguments: selectedClass.toJson());
        },
      ),
    );
  }

  openDetailStatistics() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(DetailStatistic.routeName);
  }

  openExperiences({User? user}) {
    if (Get.isOverlaysOpen) {
      Get.back();
    }
    if (user != null) {
      Get.toNamed(Experiences.routeName, arguments: user.toJson());
    } else {
      Get.toNamed(Experiences.routeName);
    }
  }

  openAchievements({User? user}) {
    if (Get.isOverlaysOpen) {
      Get.back();
    }
    if (user != null) {
      Get.toNamed(AchievementList.routeName, arguments: user.toJson());
    } else {
      Get.toNamed(AchievementList.routeName);
    }
  }

  openEducation({User? user}) {
    if (Get.isOverlaysOpen) {
      Get.back();
    }
    if (user != null) {
      Get.toNamed(Educations.routeName, arguments: user.toJson());
    } else {
      Get.toNamed(Educations.routeName);
    }
  }

  openChampionship({User? user}) {
    if (Get.isOverlaysOpen) {
      Get.back();
    }
    if (user != null) {
      Get.toNamed(Championships.routeName, arguments: user.toJson());
    } else {
      Get.toNamed(Championships.routeName);
    }
  }

  openSearchClub() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(ClubList.routeName);
  }

  openVacancies() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(VacancyList.routeName);
  }

  openTeamOffers() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    if (userData.value.isPlayer) {
      Get.toNamed(OfferTeamPlayerList.routeName);
    } else if (userData.value.isCoach) {
      Get.toNamed(OfferTeamCoachList.routeName);
    }
  }

  openOffersClub() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(OfferListClub.routeName);
  }

  openConsulting() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(ConsultList.routeName);
  }

  openPaymentHistory() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.toNamed(PaymentHistory.routeName);
  }

  openSettings() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    DashboardController.to.changePage(3);
  }

  openUpdateParameter() async {
    try {
      EasyLoading.show();
      await _performanceTestRequest.available(
          playerId: userData.value.player!.id!);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      Get.toNamed(TestParameter.routeName);
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openEvents() {
    Get.toNamed(AllEvents.routeName);
  }

  openCompetitions() {
    Get.toNamed(AllCompetition.routeName);
  }

  openCoaches() async {
    Get.toNamed(CoachList.routeName);
  }

  logout() {
    try {
      getDialog(ConfirmationDefaultDialog(
        title: 'Logout',
        content: 'Anda yakin untuk keluar akun?',
        onConfirm: () async {
          try {
            EasyLoading.show();
            await _authRequest.logout();
            Storage.remove(ProfileStorage.token);
            Storage.remove(ProfileStorage.user);
            Get.offAllNamed(LoginScreen.routeName);
            EasyLoading.dismiss();
          } catch (e) {
            EasyLoading.dismiss();
            getSnackbar('Informasi', e.toString());
          }
        },
      ));
    } on Exception catch (_) {
      EasyLoading.dismiss();
    }
  }

  openProfileDetail() {
    if (userData.value.isPlayer) {
      Get.toNamed(PlayerProfile.routeName);
    } else if (userData.value.isCoach) {
      Get.toNamed(CoachProfile.routeName, arguments: userData.value.toJson());
    }
  }

  Future<bool> hasSubscription() async {
    return await _subscribeRequest.hasSubscribe();
  }

  bool? get isMobileSize =>
      MediaQuery.of(Get.context!).size.shortestSide < 600 ? true : false;
}
