import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/offering.request.dart';
import 'package:mobile_pssi/data/requests/position.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';

class OfferFormPlayerController extends BaseController {
  final _offerRequest = OfferingRequest();
  final _positionRequest = PositionRequest();
  final formKey = GlobalKey<FormState>();
  final player = const Player().obs;
  final positions = Resource<List<PlayerPosition>>(data: []).obs;
  final selectedPositions = <PlayerPosition>[].obs;
  final offerText = TextEditingController();
  final file = FileObservable().obs;
  final uploading = false.obs;

  OfferFormPlayerController() {
    player(Player.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _fetchPositions();
    super.onInit();
  }

  _fetchPositions() async {
    try {
      EasyLoading.show();
      var resp = await _positionRequest.getPlayerPositions();
      positions.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  selectPositions(List<PlayerPosition> positions) {
    selectedPositions.clear();
    selectedPositions.addAll(positions);
  }

  offer() async {
    try {
      if (formKey.currentState!.validate()) {
        EasyLoading.show();
        uploading(true);
        await _offerRequest.offerPlayer(
          playerId: player.value.id,
          positions: selectedPositions.isBlank == true
              ? null
              : selectedPositions.map((position) => position.id).toList(),
          offerText: offerText.text,
          offerFile: file.value.toFile,
        );
        EasyLoading.dismiss();
        getSnackbar('Informasi', 'Berhasil menawarkan pemain.');
        uploading(false);
      }
    } catch (e) {
      uploading(false);
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  selectFile() async {
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
}
