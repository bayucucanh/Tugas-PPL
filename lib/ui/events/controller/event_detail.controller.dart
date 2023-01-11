import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/event.dart';
import 'package:mobile_pssi/data/model/order.dart';
import 'package:mobile_pssi/data/model/order_detail.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/team.dart';
import 'package:mobile_pssi/data/model/voucher.dart';
import 'package:mobile_pssi/data/requests/event.request.dart';
import 'package:mobile_pssi/data/requests/order.request.dart';
import 'package:mobile_pssi/data/requests/team.request.dart';
import 'package:mobile_pssi/data/requests/voucher.request.dart';
import 'package:mobile_pssi/extensions/tax.extension.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/services/midtrans/midtrans_service.dart';
import 'package:mobile_pssi/shared_ui/default_scaffold.dart';
import 'package:mobile_pssi/ui/events/edit_event.dart';
import 'package:mobile_pssi/ui/events/event_participants.dart';
import 'package:mobile_pssi/ui/payment/payment.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:velocity_x/velocity_x.dart';

class EventDetailController extends BaseController {
  final refreshController = RefreshController();
  final _event = Event().obs;
  final _orderRequest = OrderRequest();
  final _eventRequest = EventRequest();
  final _teamRequest = TeamRequest();
  final _voucherRequest = VoucherRequest();
  final _order = Order().obs;
  final _paymentService = MidtransService.instance;
  final _isRegistered = false.obs;
  final _eventAvailable = false.obs;
  final voucherCode = TextEditingController();
  final _voucher = Voucher().obs;
  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter(
    locale: 'id',
    decimalDigits: 0,
    symbol: 'Rp ',
    name: 'IDR',
  );
  final _teams = Resource<List<Team>>(data: []).obs;
  final _team = const Team().obs;

  EventDetailController() {
    _event(Event.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _initialize();
    _paymentService.transactionFinishedCallback((result) {
      if (result.isTransactionCanceled) {
        _paymentService.changeOrderStatus(
            orderId: _order.value.code!,
            status: 4,
            message: 'Pembayaran Dibatalkan');
      }
    });
    FirebaseMessaging.onMessage.listen((event) {
      Map<String, dynamic>? message = event.toMap();
      _handlePayment(message);
    });
    super.onInit();
  }

  _initialize() async {
    await getUserData();
    _fetchDetail();
    _isEventAvailable();
    _checkRegisteredEvent();
    _fetchClubTeam();
  }

  _fetchClubTeam() async {
    if (userData.value.isClub) {
      try {
        var resp = await _teamRequest.getMyTeams(
            clubId: userData.value.club!.id!, option: 'select');
        _teams(resp);
      } catch (e) {
        Get.snackbar('Informasi', e.toString());
      }
    }
  }

  _checkRegisteredEvent() async {
    if (!userData.value.hasRole('administrator')) {
      try {
        await _eventRequest.checkEventRegistered(eventId: _event.value.id!);
        _isRegistered(true);
      } catch (_) {
        _isRegistered(false);
      }
    }
  }

  refreshData() {
    try {
      _initialize();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchDetail() async {
    try {
      EasyLoading.show();
      var resp = await _eventRequest.detail(eventId: _event.value.id!);
      _event(resp);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _isEventAvailable() async {
    try {
      await _eventRequest.eventAvailability(eventId: _event.value.id!);
      _eventAvailable(true);
    } catch (_) {
      _eventAvailable(false);
    }
  }

  shareEvent() async {
    final box = Get.context!.findRenderObject() as RenderBox?;
    String message =
        'Ada event terbaru dari prima academy, cek di aplikasi untuk lebih lanjut ${F.playstoreUrl}';
    await Share.share(
      message,
      subject: _event.value.name ?? '-',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  _selectTeam(Team? team) {
    _team(team);
    if (Get.isBottomSheetOpen!) {
      Get.back();
      confirmCheckout();
    }
  }

  confirmCheckout() async {
    try {
      await _eventRequest.eventAvailability(eventId: _event.value.id!);
      getBottomSheet(
        KeyboardVisibilityBuilder(
          builder: (context, visible) => AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: visible == true
                ? 440
                : userData.value.isClub
                    ? 340
                    : 260,
            child: DefaultScaffold(
              showAppBar: false,
              backgroundColor: Get.theme.backgroundColor,
              body: VStack([
                (event.name ?? '-').text.semiBold.make(),
                if (userData.value.isClub)
                  VStack([
                    UiSpacer.verticalSpace(space: 20),
                    DropdownButtonFormField(
                      decoration: InputDecoration(
                          hintText: 'Pilih Tim',
                          labelText: _team.value.id == null
                              ? 'Pilih Tim'
                              : _team.value.name,
                          isDense: true,
                          helperText: _team.value.id == null
                              ? null
                              : 'Total Pemain : ${_team.value.totalPlayers ?? 0}'),
                      items: _teams.value.data
                          ?.map((e) => DropdownMenuItem(
                                value: e,
                                child: (e.name ?? '-').text.make(),
                              ))
                          .toList(),
                      onChanged: _selectTeam,
                    ),
                  ]),
                UiSpacer.verticalSpace(space: 20),
                ListTile(
                  leading: const Icon(
                    Icons.discount_rounded,
                    color: primaryColor,
                  ),
                  title: TextFormField(
                    controller: voucherCode,
                    decoration: const InputDecoration(
                      hintText: 'Masukan kode voucher',
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                  subtitle: _voucher.value.code != null
                      ? VStack([
                          'Potongan diskon ${_voucher.value.formatValue()}.'
                              .text
                              .xs
                              .make(),
                          'Hemat ${(_currencyFormatter.format(calculateVoucher(_event.value.price!.addPriceTax()!).toStringAsFixed(0)))}'
                              .text
                              .xs
                              .bold
                              .make(),
                        ])
                      : null,
                  trailing: 'Gunakan'
                      .text
                      .color(primaryColor)
                      .make()
                      .onTap(applyPromo),
                ),
                UiSpacer.verticalSpace(),
                HStack([
                  VStack([
                    (totalPrice ?? '-').text.white.semiBold.make(),
                    'Sudah termasuk pajak 11%'.text.white.xs.make(),
                  ]).expand(),
                  'Lanjut Checkout'.text.white.make(),
                ])
                    .p8()
                    .continuousRectangle(
                        height: 55,
                        backgroundColor:
                            enableCheckout == true ? primaryColor : Vx.gray300)
                    .onInkTap(enableCheckout ? _checkout : null),
              ]).scrollVertical().p12().pOnly(bottom: visible ? 320 : 0),
            ),
          ),
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  _checkout() async {
    try {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      EasyLoading.show();
      _order(
        await _orderRequest.create(
          order: Order(
            totalPrice: userData.value.isClub
                ? (_event.value.price! * _team.value.totalPlayers!)
                : _event.value.price,
            orderDetails: [
              OrderDetail(
                productId: 98,
                eventId: _event.value.id,
                teamId: userData.value.isClub ? _team.value.id : null,
                name: _event.value.name,
                price: _event.value.price,
                quantity: userData.value.isClub ? _team.value.totalPlayers : 1,
              ),
            ],
          ),
          voucher: _voucher.value,
        ),
      );
      EasyLoading.dismiss();

      if (totalPrice == 'Gratis') {
        EasyLoading.show();
        await _orderRequest.freeOrder(orderCode: _order.value.code!);
        EasyLoading.dismiss();
        if (Get.isBottomSheetOpen!) {
          Get.back();
        }
      } else {
        if (F.isStaging && kReleaseMode) {
          var status = await Get.toNamed(Payment.routeName,
              arguments: _order.value.snapToken);
          if (status != null) {
            switch (status) {
              case TransactionResultStatus.capture:
              case TransactionResultStatus.settlement:
                try {
                  EasyLoading.show();
                  await _eventRequest.registerEvent(
                      orderCode: _order.value.code!);
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
      }
      refreshData();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _handlePayment(Map<String, dynamic>? message) async {
    Map<String, dynamic>? data = message?['data'];
    if (data != null) {
      if (data['event_type'] == 'payment') {
        switch (data['status']) {
          case '2':
            if (Get.isBottomSheetOpen!) {
              Get.back();
            }
            Get.back();
            break;
        }
      }
    }
  }

  applyPromo() async {
    try {
      EasyLoading.show();
      _voucher(
          await _voucherRequest.applyVoucher(voucherCode: voucherCode.text));
      EasyLoading.dismiss();
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      confirmCheckout();
    } catch (e) {
      EasyLoading.dismiss();
      _voucher(Voucher());
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      confirmCheckout();
      getSnackbar('Informasi', e.toString());
    }
  }

  double calculateVoucher(double totalPrice) {
    double? calculatedByVoucher;
    if (_voucher.value.isPercentage == true) {
      calculatedByVoucher = totalPrice * (_voucher.value.value! / 100);
    } else {
      calculatedByVoucher = (totalPrice - _voucher.value.value!);
    }
    return calculatedByVoucher;
  }

  String? get totalPrice {
    if (_event.value.price == null) {
      return null;
    }

    if (userData.value.isClub) {
      if (_team.value.totalPlayers == null) {
        return null;
      }
    }

    double totalPrice = userData.value.isClub
        ? (_event.value.price! * _team.value.totalPlayers!).addPriceTax()!
        : _event.value.price!.addPriceTax()!;

    if (userData.value.isClub) {
      if (_team.value.totalPlayers! <= 0) {
        return 'Tidak dapat mengkalkulasi';
      }
    }

    if (_voucher.value.code != null) {
      totalPrice -= calculateVoucher(totalPrice);
    }

    if (totalPrice <= 0) {
      return 'Gratis';
    }

    String total = totalPrice.toStringAsFixed(0);

    return _currencyFormatter.format(total);
  }

  editEvent() async {
    var data = await Get.toNamed(EditEvent.routeName, arguments: _event.value.toJson());

    if (data == 'success') {
      refreshController.requestRefresh();
    }
  }

  openParticipants() {
    Get.toNamed(EventParticipants.routeName, arguments: _event.value.toJson());
  }

  bool checkTarget(String target) {
    if (_event.value.target != null) {
      if (_event.value.target!.contains(target)) {
        return true;
      }
    }
    return false;
  }

  bool get enableCheckout {
    if (userData.value.isClub) {
      if (_team.value.id == null) {
        return false;
      }
      if (_team.value.totalPlayers == null || _team.value.totalPlayers! <= 0) {
        return false;
      }
      return true;
    } else {
      return true;
    }
  }

  Event get event => _event.value;
  bool get isRegistered => _isRegistered.value;
  bool get eventAvailable => _eventAvailable.value;
}
