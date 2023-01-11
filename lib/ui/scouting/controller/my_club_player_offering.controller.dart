import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/club_player_offering.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/shared_ui/pdf_reader/pdf_reader.dart';
import 'package:mobile_pssi/shared_ui/player.card.dart';
import 'package:mobile_pssi/ui/scouting/scouting_player_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class MyClubPlayerOfferingController extends BaseController {
  final refreshController = RefreshController();
  final _offeringRequest = OfferingRequest();
  final _offerings = Resource<List<ClubPlayerOffering>>(data: []).obs;
  final page = 1.obs;

  @override
  void onInit() {
    getUserData();
    _fetchOfferingPlayers();
    super.onInit();
  }

  refreshData() {
    try {
      page(1);
      _offerings.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchOfferingPlayers();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchOfferingPlayers() async {
    try {
      EasyLoading.show();
      var resp =
          await _offeringRequest.historyOfferingClubPlayers(page: page.value);
      _offerings.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  loadMore() {
    try {
      if (page.value >= _offerings.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchOfferingPlayers();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openDetailPlayer(Player? player) {
    Get.toNamed(ScoutingPlayerDetail.routeName, arguments: player?.toJson());
  }

  openConfirmation(ClubPlayerOffering offer) async {
    await getBottomSheet(
      VStack([
        'Konfirmasi Offering'.text.semiBold.lg.make(),
        UiSpacer.verticalSpace(),
        PlayerCard(player: offer.player!),
        UiSpacer.verticalSpace(space: 10),
        'Lihat Detil Profil'
            .text
            .white
            .makeCentered()
            .continuousRectangle(
              height: 40,
              backgroundColor: primaryColor,
            )
            .onTap(() => openDetailPlayer(offer.player)),
        UiSpacer.verticalSpace(),
        'Pemain ditawarkan untuk menjadi :'.text.make(),
        if (offer.offeringPositions != null ||
            offer.offeringPositions!.isNotEmpty)
          ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: offer.offeringPositions!
                .map((position) =>
                    (position.position?.name ?? '-').text.semiBold.make())
                .toList(),
          ),
        UiSpacer.verticalSpace(),
        'Deskripsi Penawaran'.text.semiBold.make(),
        (offer.offerText ?? '-').text.make(),
        UiSpacer.verticalSpace(),
        if (offer.offerFile != null)
          'Lihat Dokumen Penawaran'
              .text
              .white
              .makeCentered()
              .continuousRectangle(
                height: 40,
                backgroundColor: primaryColor,
              )
              .onInkTap(() => openDocument(offer.offerFile!)),
        if (offer.replyFile != null)
          VStack([
            UiSpacer.verticalSpace(),
            'Lihat Dokumen Balasan'
                .text
                .white
                .makeCentered()
                .continuousRectangle(
                  height: 40,
                  backgroundColor: primaryColor,
                )
                .onInkTap(() => openDocument(offer.replyFile!)),
          ]),
        if (offer.club?.id == userData.value.club?.id && offer.status?.id == 0)
          VStack([
            UiSpacer.verticalSpace(),
            'Batalkan Penawaran'
                .text
                .color(primaryColor)
                .makeCentered()
                .continuousRectangle(
                    height: 40,
                    borderSide: const BorderSide(color: primaryColor),
                    backgroundColor: Vx.white)
                .onTap(() => _cancelOfferingPlayer(offer)),
          ]),
        if (offer.club?.id == userData.value.club?.id && offer.status?.id == 1)
          VStack([
            UiSpacer.verticalSpace(),
            HStack(
              [
                'Tolak Tawaran'
                    .text
                    .color(primaryColor)
                    .make()
                    .p8()
                    .box
                    .border(color: primaryColor)
                    .roundedSM
                    .make()
                    .onTap(() => _dialogDeny(offer)),
                'Terima Tawaran'
                    .text
                    .white
                    .make()
                    .p8()
                    .box
                    .roundedSM
                    .color(primaryColor)
                    .make()
                    .onTap(() => _dialogReplyAccept(offer)),
              ],
              axisSize: MainAxisSize.max,
              alignment: MainAxisAlignment.spaceBetween,
            )
          ]),
      ]).p8().safeArea(top: false),
      isScrollControlled: true,
    );
  }

  openDocument(String offerFile) {
    Get.toNamed(PdfReader.routeName, arguments: offerFile);
  }

  _dialogReplyAccept(ClubPlayerOffering offer) {
    Get.dialog(
        ConfirmationDefaultDialog(
          cancelText: 'Batal',
          confirmText: 'Terima',
          title: 'Terima Tawaran Klub',
          content: "Apakah anda ingin menerima tawaran ?",
          onConfirm: () => _changeStatus(offer, 3),
        ),
        barrierDismissible: false);
  }

  _dialogDeny(ClubPlayerOffering offer) {
    Get.dialog(
        ConfirmationDefaultDialog(
          cancelText: 'Batal',
          confirmText: 'Tolak',
          title: 'Tolak Tawaran Klub',
          content: "Apakah anda ingin menolak tawaran ?",
          onConfirm: () => _changeStatus(offer, 2),
        ),
        barrierDismissible: false);
  }

  _changeStatus(ClubPlayerOffering offer, int status) async {
    try {
      EasyLoading.show();
      await _offeringRequest.transferPlayer(
          clubPlayerOfferId: offer.id,
          data: FormData.fromMap({
            'status': status,
          }));
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }

      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      refreshController.requestRefresh();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _cancelOfferingPlayer(ClubPlayerOffering? offering) async {
    try {
      EasyLoading.show();
      await _offeringRequest.cancelOfferingClubPlayer(offerId: offering!.id);
      _offerings.update((val) {
        val?.data?.remove(offering);
      });
      EasyLoading.dismiss();

      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
    } catch (_) {
      EasyLoading.dismiss();
    }
  }

  List<ClubPlayerOffering>? get offerings => _offerings.value.data;
}
