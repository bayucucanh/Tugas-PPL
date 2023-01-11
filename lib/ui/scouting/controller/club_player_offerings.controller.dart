import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/club_player_offering.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/shared_ui/pdf_reader/pdf_reader.dart';
import 'package:mobile_pssi/shared_ui/player.card.dart';
import 'package:mobile_pssi/ui/scouting/scouting_player_detail.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/ui.spacer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:velocity_x/velocity_x.dart';

class ClubPlayerOfferingsController extends BaseController {
  final refreshController = RefreshController();
  final _offeringRequest = OfferingRequest();
  final _offerings = Resource<List<ClubPlayerOffering>>(data: []).obs;
  final page = 1.obs;
  final file = FileObservable().obs;

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
      var resp = await _offeringRequest.clubPlayerOfferings(page: page.value);
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
    if (file.value.name != null) {
      file(FileObservable());
    }
    await getBottomSheet(
      ListView(
        padding: EdgeInsets.zero,
        children: [
          HStack([
            'Konfirmasi Offering'.text.semiBold.lg.make().expand(),
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.close_rounded,
                color: primaryColor,
              ),
              tooltip: 'Tutup',
            ),
          ]),
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
          if (offer.clubReference?.id == userData.value.club?.id &&
              offer.status?.id == 0)
            Obx(
              () => VStack([
                UiSpacer.verticalSpace(),
                'Pilih File Balasan'.text.semiBold.make(),
                if (file.value.path != null)
                  Thumbnail(
                    mimeType: 'application/pdf',
                    widgetSize: 150,
                    decoration: WidgetDecoration(
                      backgroundColor: Colors.blueAccent,
                      iconColor: Colors.red,
                    ),
                    dataResolver: () => file.value.asUint8List,
                  ).centered(),
                UiSpacer.verticalSpace(space: 10),
                TextFormField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: primaryColor,
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      hintText: (file.value.path == null
                          ? 'Pilih File'
                          : 'Ubah File')),
                  validator: (value) {
                    if (file.value.path == null) {
                      return 'File tidak boleh kosong';
                    }
                    return null;
                  },
                  onTap: _selectFile,
                  readOnly: true,
                ),
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
            ),
        ],
      ).h(Get.height * 0.9).p8().safeArea(top: false),
      isScrollControlled: true,
    );
    file.update((val) {
      val = null;
    });
  }

  _selectFile() async {
    FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(
      allowCompression: false,
      allowMultiple: false,
      allowedExtensions: [
        'pdf',
      ],
      type: FileType.custom,
    );

    if (selectedFile != null) {
      file(FileObservable.filePickerResult(selectedFile));
    }
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
          onConfirm: () => _changeStatus(offer, 1),
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
            'reply_file': file.value.path != null
                ? await MultipartFile.fromFile(file.value.path!,
                    filename: file.value.name)
                : null
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

  List<ClubPlayerOffering>? get offerings => _offerings.value.data;
}
