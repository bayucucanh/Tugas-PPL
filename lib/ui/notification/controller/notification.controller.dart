import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/coach_offering.dart';
import 'package:mobile_pssi/data/model/learning_task.dart';
import 'package:mobile_pssi/data/model/message/message.dart';
import 'package:mobile_pssi/data/model/player_offering.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/class.request.dart';
import 'package:mobile_pssi/data/requests/notification.request.dart';
import 'package:mobile_pssi/ui/offering/offer_team_coach_list.dart';
import 'package:mobile_pssi/ui/offering/offer_team_player_list.dart';
import 'package:mobile_pssi/ui/offering/offering_join_club_coach.dart';
import 'package:mobile_pssi/ui/offering/offering_join_club_player.dart';
import 'package:mobile_pssi/ui/payment/payment_history.dart';
import 'package:mobile_pssi/ui/scouting/club_offerings/club_coach_offerings.dart';
import 'package:mobile_pssi/ui/scouting/club_offerings/club_player_offerings.dart';
import 'package:mobile_pssi/ui/subscriptions/my_subscriptions.dart';
import 'package:mobile_pssi/ui/task_detail/task_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationController extends BaseController {
  final refreshController = RefreshController();
  final _classRequest = ClassRequest();
  final _notificationRequest = NotificationRequest();
  final notifications = Resource<List<Message>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    getUserData();
    _fetchNotification();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      notifications.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchNotification();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchNotification() async {
    try {
      EasyLoading.show();
      var resp = await _notificationRequest.getNotifications(page: page.value);
      notifications.update((val) {
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
      if (page.value >= notifications.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchNotification();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  markAllNotification() async {
    try {
      EasyLoading.show();
      await _notificationRequest.markAllNotification();
      EasyLoading.dismiss();
      refreshController.requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  void redirect({required Message message}) async {
    if (message.readAt == null) {
      await _notificationRequest.readNotification(id: message.id);

      notifications.update((val) {
        Message? found =
            val?.data?.singleWhere((messages) => messages.id == message.id);
        found?.readAt = DateTime.now();
      });
    }

    switch (message.type) {
      case 'App\\Models\\PlayerOffering':
      case 'App\\Models\\CoachOffering':
        openOfferingClub(message);
        break;
      case 'App\\Models\\Subscription':
        Get.toNamed(MySubscriptions.routeName);
        break;
      case 'App\\Models\\Consultation':
        openConsulting();
        break;
      case 'App\\Models\\Order':
        Get.toNamed(PaymentHistory.routeName);
        break;
      case 'App\\Models\\ClubPlayerOffering':
        openPlayerOfferingTransfer(message);
        break;
      case 'App\\Models\\ClubCoachOffering':
        openCoachOfferingTransfer(message);
        break;
      case 'App\\Models\\LearningTask':
        openLearningTask(message);
        break;
      case 'App\\Models\\Classes':
        try {
          Class openedClass =
              await _classRequest.getDetail(id: int.parse(message.morphId!));
          showClass(openedClass);
        } catch (e) {
          getSnackbar('Informasi', e.toString());
        }
        break;
    }
  }

  openLearningTask(Message message) {
    Get.toNamed(TaskDetail.routeName,
        arguments: LearningTask.fromNotification(message.data).toJson());
  }

  openCoachOfferingTransfer(Message message) {
    if (message.data != null && userData.value.isClub) {
      Get.toNamed(ClubCoachOfferings.routeName);
    }
  }

  openPlayerOfferingTransfer(Message message) {
    if (message.data != null && userData.value.isClub) {
      Get.toNamed(ClubPlayerOfferings.routeName);
    }
  }

  openOfferingClub(Message message) {
    if (message.data != null && userData.value.isPlayer) {
      PlayerOffering? playerOffering = PlayerOffering.fromJson(message.data);
      if (message.data['status'] == 0) {
        Get.toNamed(OfferingJoinClubPlayer.routeName,
            arguments: playerOffering.toJson());
      }
    } else if (message.data != null && userData.value.isCoach) {
      CoachOffering? coachOffering = CoachOffering.fromJson(message.data);

      if (message.data['status'] == 0) {
        Get.toNamed(OfferingJoinClubCoach.routeName,
            arguments: coachOffering.toJson());
      }
    }
  }

  openOfferingTeam(Message message) {
    getUserData();
    if (userData.value.isPlayer) {
      Get.toNamed(OfferTeamPlayerList.routeName);
    } else if (userData.value.isCoach) {
      Get.toNamed(OfferTeamCoachList.routeName);
    }
  }
}
