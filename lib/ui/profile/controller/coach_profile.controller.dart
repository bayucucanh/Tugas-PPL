import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/class.dart';
import 'package:mobile_pssi/data/model/consultation.dart';
import 'package:mobile_pssi/data/model/consultation_quota.dart';
import 'package:mobile_pssi/data/model/order.dart';
import 'package:mobile_pssi/data/model/order_detail.dart';
import 'package:mobile_pssi/data/model/rating_class.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/coach.request.dart';
import 'package:mobile_pssi/data/requests/consult.request.dart';
import 'package:mobile_pssi/data/requests/order.request.dart';
import 'package:mobile_pssi/data/requests/rating.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/services/midtrans/midtrans_service.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/class/add_class_screen.dart';
import 'package:mobile_pssi/ui/coach/coach_class.dart';
import 'package:mobile_pssi/ui/consulting/consult_room.dart';
import 'package:mobile_pssi/ui/payment/payment.dart';
import 'package:mobile_pssi/ui/premium/controller/premium_player.controller.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/ui/profile/coach/parts/consult_dialog.dart';
import 'package:mobile_pssi/ui/reviews/reviews.dart';
import 'package:mobile_pssi/ui/scouting/offer_form_coach.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:slider_button/slider_button.dart';
import 'package:velocity_x/velocity_x.dart';

class CoachProfileController extends BaseController {
  final refreshController = RefreshController();
  final _coach = User().obs;
  final _coachRequest = CoachRequest();
  final _consultRequest = ConsultRequest();
  final _orderRequest = OrderRequest();
  final _ratingRequest = RatingRequest();
  final coachList = Resource<List<User>>(data: []).obs;
  final classes = Resource<List<Class>>(data: []).obs;
  final reviews = Resource<List<RatingClass>>(data: []).obs;
  final loadingClasses = true.obs;
  final loadingReviews = true.obs;
  final canSavePlayer = false.obs;
  final isPremium = false.obs;
  final premiumController = Get.put(PremiumPlayerController());
  final _chat = TextEditingController();
  final _paymentService = MidtransService.instance;
  final onPaying = false.obs;
  final _order = Order().obs;

  CoachProfileController() {
    if (Get.arguments != null) {
      _coach(User.fromJson(Get.arguments));
    }
  }

  @override
  void onInit() {
    getUserData();
    initialize();
    FirebaseMessaging.onMessage.listen((event) {
      Map<String, dynamic>? message = event.toMap();
      _handlePayment(message);
    });
    super.onInit();
  }

  void refreshCoachProfile() {
    try {
      initialize();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  initialize() {
    _getProfile();
    _checkPremium();
    _checkSavedCoach();
    _getClassList();
    if (userData.value.isPlayer) {
      _getCoachList();
    }
    _getClassReviews();
  }

  _getProfile() async {
    try {
      _coach(await _coachRequest.getProfile(userId: _coach.value.id!));
      loadingClasses(false);
    } on Exception catch (_) {
      loadingClasses(false);
    }
  }

  _getClassList() async {
    try {
      classes(await _coachRequest.getClass(_coach.value.id!,
          limit: 4, activeClass: userData.value.isCoach ? true : false));
      loadingClasses(false);
    } on Exception catch (_) {
      loadingClasses(false);
    }
  }

  _getClassReviews() async {
    try {
      reviews(await _ratingRequest.getAllReviews(
          coachId:
              userData.value.isCoach && !userData.value.hasRole('administrator')
                  ? userData.value.id!
                  : coach.id!));
      loadingReviews(false);
    } on Exception catch (_) {
      loadingReviews(true);
    }
  }

  _checkPremium() async {
    isPremium(await hasSubscription());
  }

  void goToAddForm() {
    Get.toNamed(AddClassScreen.routeName);
  }

  _getCoachList() async {
    try {
      coachList(await _coachRequest.getCoachList(
          limit: 6, option: 'random', onlyPartner: true));
      coachList.update((val) {
        val?.data?.sort((a, b) {
          if (a.isOnline == true) {
            return 1;
          } else {
            if (b.isOnline == true) {
              return 1;
            }
            return 0;
          }
        });
      });
    } on Exception catch (_) {}
  }

  viewOtherCoach(User coach) {
    Get.back();
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.toNamed(CoachProfile.routeName, arguments: coach.toJson());
    });
  }

  _checkSavedCoach() {
    if (Storage.hasData(ProfileStorage.savedCoach)) {
      List<dynamic> coaches = Storage.get(ProfileStorage.savedCoach);
      dynamic found = coaches.firstWhere(
          (data) => data['id'] == _coach.value.id,
          orElse: () => null);
      if (found != null) {
        canSavePlayer(false);
      } else {
        canSavePlayer(true);
      }
    } else {
      canSavePlayer(true);
    }
  }

  saveCoach() {
    if (Storage.hasData(ProfileStorage.savedCoach)) {
      List<dynamic> coaches = Storage.get(ProfileStorage.savedCoach);
      dynamic found = coaches.firstWhere(
          (data) => data['id'] == _coach.value.id,
          orElse: () => null);
      if (found != null) {
        getSnackbar('Informasi', 'Pelatih ini sudah pernah disimpan');
      } else {
        coaches.add(coach.toJson());
        Storage.save(ProfileStorage.savedCoach, coaches);
        getSnackbar('Informasi', 'Pelatih sudah disimpan');
      }
    } else {
      List<dynamic> coaches = [
        coach.toJson(),
      ];
      Storage.save(ProfileStorage.savedCoach, coaches);
      getSnackbar('Informasi', 'Pelatih sudah disimpan');
    }
    _checkSavedCoach();
  }

  openOffer() {
    Get.toNamed(OfferFormCoach.routeName, arguments: coach.employee?.toJson());
  }

  openConsultation() async {
    try {
      EasyLoading.show();
      List<dynamic>? myQuota = await _consultRequest.getMyQuota(coach.id!);
      EasyLoading.dismiss();

      if (myQuota[1] <= 0) {
        getDialog(ConfirmationDefaultDialog(
          title: 'Kuota Konsultasi',
          content:
              'Kuota konsultasi anda habis, apakah anda ingin membeli kuota konsultasi?',
          confirmText: 'Top Up',
          cancelText: 'Batal',
          onConfirm: _showBuyQuotaForm,
        ));
      } else {
        _showQuotaUnused(myQuota[0]);
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _showQuotaUnused(List<ConsultationQuota> quotas) {
    getBottomSheet(
      VStack([
        'Gunakan Kuota Konsultasi'.text.semiBold.make(),
        UiSpacer.verticalSpace(),
        ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final quota = quotas[index];
            return ListTile(
              title: 'Konsultasi'.text.make(),
              subtitle: (quota.classification == null
                      ? 'Dapat digunakan untuk semua klasifikasi'
                      : 'Hanya dapat digunakan untuk klasifikasi ${quota.classification?.name ?? '-'}')
                  .text
                  .make(),
              trailing: TextButton(
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                  onPressed: () => _useCoupon(quota.id!),
                  child: 'Gunakan'.text.make()),
            );
          },
          itemCount: quotas.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
        UiSpacer.verticalSpace(space: 40),
      ]).p12().scrollVertical(),
    );
  }

  _useCoupon(int quotaId) {
    if (Get.isBottomSheetOpen!) {
      Get.back();
    }
    Get.dialog(ConsultDialog(
      controller: _chat,
      onTap: () => createRoomConsultation(quotaId),
    ));
  }

  _showBuyQuotaForm() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    final TextEditingController qtyText = TextEditingController(text: '1');
    getBottomSheet(
      VStack([
        HStack([
          'Beli Kuota Konsultasi'.text.semiBold.make().expand(),
          VStack(
            [
              'Kuantitas'.text.make(),
              TextFormField(
                controller: qtyText,
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                        onPressed: () => _decrement(qtyText),
                        icon: const Icon(Icons.remove)),
                    suffixIcon: IconButton(
                        onPressed: () => _increment(qtyText),
                        icon: const Icon(Icons.add))),
              )
            ],
            crossAlignment: CrossAxisAlignment.center,
          ).expand()
        ]),
        UiSpacer.verticalSpace(),
        SliderButton(
          action: () => _buyQuotaConsultation(qtyText),
          label: const Text('Geser untuk membeli'),
          backgroundColor: primaryColor.withOpacity(0.8),
          baseColor: Colors.white,
          buttonColor: primaryColor,
          icon: const Icon(
            Icons.navigate_next_rounded,
            color: Colors.white,
          ),
          highlightedColor: Colors.black,
          vibrationFlag: false,
          radius: 20,
        ).centered(),
        UiSpacer.verticalSpace(space: 40),
      ]).p12(),
    );
  }

  _increment(TextEditingController textController) {
    int currentValue = int.tryParse(textController.text)!;
    if (currentValue < 99) {
      currentValue++;
      textController.text = currentValue.toString();
    }
  }

  _decrement(TextEditingController textController) {
    int currentValue = int.tryParse(textController.text)!;
    if (currentValue > 1) {
      currentValue--;
      textController.text = currentValue.toString();
    }
  }

  _buyQuotaConsultation(TextEditingController qtyText) async {
    try {
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      EasyLoading.show();
      int qty = int.tryParse(qtyText.text)!;
      int totalPrice =
          _coach.value.classificationUser!.classification!.pricing! * qty;
      _order(await _orderRequest.create(
          order: Order(
              totalPrice: double.tryParse(totalPrice.toString()),
              orderDetails: [
            OrderDetail(
              productId: 99,
              name: 'Konsultasi',
              price: double.parse(_coach
                  .value.classificationUser!.classification!.pricing
                  .toString()),
              quantity: qty,
            ),
          ])));
      EasyLoading.dismiss();
      if (F.isStaging && kReleaseMode) {
        var status = await Get.toNamed(Payment.routeName,
            arguments: _order.value.snapToken);
        if (status != null) {
          switch (status) {
            case TransactionResultStatus.capture:
            case TransactionResultStatus.settlement:
              try {
                EasyLoading.show();
                await _consultRequest.addQuota(orderId: _order.value.code!);
                _paymentService.changeOrderStatus(
                    orderId: _order.value.code!,
                    status: 2,
                    message: 'Pembayaran Berhasil');
                EasyLoading.dismiss();
                if (Get.isBottomSheetOpen!) {
                  Get.back();
                }
                Get.back();
              } catch (e) {
                EasyLoading.dismiss();
                getSnackbar('Informasi', e.toString());
              }
              break;
            case TransactionResultStatus.deny:
              _paymentService.changeOrderStatus(
                  orderId: _order.value.code!,
                  status: 5,
                  message: 'Pembayaran Gagal');
              break;
            case TransactionResultStatus.expire:
              _paymentService.changeOrderStatus(
                  orderId: _order.value.code!,
                  status: 3,
                  message: 'Pembayaran Kadaluarsa');
              break;
            case TransactionResultStatus.cancel:
              _paymentService.changeOrderStatus(
                  orderId: _order.value.code!,
                  status: 4,
                  message: 'Pembayaran Dibatalkan');
              break;
          }
        }
      } else {
        _paymentService.pay(snapToken: _order.value.snapToken!);
      }
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  createRoomConsultation(int quotaId) async {
    try {
      EasyLoading.show();
      Consultation consultation = await _consultRequest.createRoom(
          coachUserId: coach.id!, message: _chat.text, quotaId: quotaId);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      Get.toNamed(ConsultRoom.routeName, arguments: consultation.toJson());
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _handlePayment(Map<String, dynamic>? message) {
    Map<String, dynamic>? data = message?['data'];
    if (data != null) {
      if (data['event_type'] == 'payment') {
        switch (data['status']) {
          case '2':
            Get.back();
            break;
          case '3':
            Get.back();
            break;
          case '4':
            Get.back();
            break;
        }
      }
    }
  }

  openCoachClass() {
    Get.toNamed(CoachClass.routeName, arguments: _coach.value.toJson());
  }

  openReviews() {
    Get.toNamed(Reviews.routeName, arguments: _coach.value.toJson());
  }

  User get coach => _coach.value;
}
