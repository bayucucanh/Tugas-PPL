import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/performance_form.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/performance_test.request.dart';
import 'package:mobile_pssi/data/requests/player.request.dart';
import 'package:mobile_pssi/data/requests/position.request.dart';
import 'package:mobile_pssi/observables/file_observable.dart';
import 'package:mobile_pssi/ui/test_parameter/attack_tactic_form.dart';
import 'package:mobile_pssi/ui/test_parameter/defend_tactic_form.dart';
import 'package:mobile_pssi/ui/test_parameter/mental_form.dart';
import 'package:mobile_pssi/ui/test_parameter/physic_form.dart';
import 'package:mobile_pssi/ui/test_parameter/technique_form.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

class TestParameterController extends BaseController {
  final _performanceTestRequest = PerformanceTestRequest();
  final _positionRequest = PositionRequest();
  final _playerRequest = PlayerRequest();
  final _player = const Player().obs;
  final confirmTest = false.obs;
  final techniqueForm = GlobalKey<FormState>(debugLabel: 'technique_form');
  final physicForm = GlobalKey<FormState>(debugLabel: 'physic_form');
  final attackTacticForm = GlobalKey<FormState>(debugLabel: 'attack_tactic');
  final defendTacticForm = GlobalKey<FormState>(debugLabel: 'defend_tactic');
  final mentalForm = GlobalKey<FormState>(debugLabel: 'mental_form');

  final _positionItems = Resource<List<PlayerPosition>>(data: []).obs;
  final _positionSelected = const PlayerPosition().obs;
  final _techniqueItems = Resource<List<PerformanceForm>>(data: []).obs;
  final _physicItems = Resource<List<PerformanceForm>>(data: []).obs;
  final _attackTacticItems = Resource<List<PerformanceForm>>(data: []).obs;
  final _defendTacticItems = Resource<List<PerformanceForm>>(data: []).obs;
  final _mentalItems = Resource<List<PerformanceForm>>(data: []).obs;
  final _tacticForm = PerformanceForm(
    linkText: TextEditingController(),
    fileVideo: FileObservable().obs,
  );

  @override
  void onInit() {
    _fetchPlayerData();
    _fetchPositions();
    _fetchPhsyicForm();
    _fetchMentalForm();
    super.onInit();
  }

  changeConfirmation(bool? confirm) {
    confirmTest(confirm);
  }

  changePosition(PlayerPosition? position) {
    _positionSelected(position);
  }

  _fetchPlayerData() {
    getUserData();

    if (Get.arguments != null) {
      _player(Player.fromJson(Get.arguments));
    } else {
      _player(userData.value.player);
    }
    _positionSelected(_player.value.position);
  }

  _fetchPositions() async {
    try {
      EasyLoading.show();
      _techniqueItems.update((val) {
        val?.data?.clear();
      });
      var resp = await _positionRequest.getPlayerPositions(
        option: 'select',
      );
      _positionItems.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchTechniqueForm() async {
    try {
      EasyLoading.show();
      _techniqueItems.update((val) {
        val?.data?.clear();
      });
      var resp = await _performanceTestRequest.getPerformanceItemByCategoryId(
        categoryId: 1,
        option: 'select',
        positionId: _positionSelected.value.id == 1 ? 1 : null,
      );
      _techniqueItems.update((val) {
        val?.data?.addAll(resp.data!.map((e) => PerformanceForm(
              performanceItem: e,
              linkText: TextEditingController(),
              fileVideo: FileObservable().obs,
            )));
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchPhsyicForm() async {
    try {
      EasyLoading.show();
      _physicItems.update((val) {
        val?.data?.clear();
      });
      var resp = await _performanceTestRequest.getPerformanceItemByCategoryId(
          categoryId: 2, option: 'select');
      _physicItems.update((val) {
        val?.data?.addAll(
          resp.data!.map(
            (e) => PerformanceForm(
                performanceItem: e,
                linkText: TextEditingController(),
                fileVideo: FileObservable().obs),
          ),
        );
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchTacticForm() async {
    try {
      EasyLoading.show();
      _attackTacticItems.update((val) {
        val?.data?.clear();
      });
      _defendTacticItems.update((val) {
        val?.data?.clear();
      });
      var attackResp =
          await _performanceTestRequest.getPerformanceItemByCategoryId(
        categoryId: 3,
        option: 'select',
        positionId: _positionSelected.value.id == 1 ? 1 : null,
      );
      _attackTacticItems.update((val) {
        val?.data?.addAll(attackResp.data!.map((e) => PerformanceForm(
            performanceItem: e,
            linkText: _tacticForm.linkText,
            fileVideo: _tacticForm.fileVideo)));
      });
      var defendResp =
          await _performanceTestRequest.getPerformanceItemByCategoryId(
        categoryId: 4,
        option: 'select',
        positionId: _positionSelected.value.id == 1 ? 1 : null,
      );
      _defendTacticItems.update((val) {
        val?.data?.addAll(defendResp.data!.map((e) => PerformanceForm(
            performanceItem: e,
            linkText: _tacticForm.linkText,
            fileVideo: _tacticForm.fileVideo)));
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchMentalForm() async {
    try {
      EasyLoading.show();
      _mentalItems.update((val) {
        val?.data?.clear();
      });
      var resp =
          await _performanceTestRequest.getScatQuestions(option: 'select');
      _mentalItems.update((val) {
        val?.data
            ?.addAll(resp.data!.map((e) => PerformanceForm(scatQuestion: e)));
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  openTechniqueForm() async {
    try {
      await _playerRequest.updatePosition(
          playerId: _player.value.id!, positionId: _positionSelected.value.id!);
      await _performanceTestRequest.available(playerId: _player.value.id!);
      await _fetchTechniqueForm();
      Get.toNamed(TechniqueForm.routeName);
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  openPhysicForm() async {
    if (techniqueForm.currentState!.validate()) {
      Get.focusScope?.unfocus();
      Get.toNamed(PhysicForm.routeName);
    }
  }

  openAttackTacticForm() {
    if (physicForm.currentState!.validate()) {
      Get.focusScope?.unfocus();
      _fetchTacticForm();
      Get.toNamed(AttackTacticForm.routeName);
    }
  }

  openDefendTacticForm() {
    if (attackTacticForm.currentState!.validate()) {
      Get.focusScope?.unfocus();
      Get.toNamed(DefendTacticForm.routeName);
    }
  }

  openMentalForm() {
    if (attackTacticForm.currentState!.validate()) {
      Get.focusScope?.unfocus();
      Get.toNamed(MentalForm.routeName);
    }
  }

  requestVerification() {
    if (mentalForm.currentState!.validate()) {
      Get.focusScope?.unfocus();
      uploadData();
    }
  }

  uploadData() async {
    try {
      EasyLoading.show(dismissOnTap: false);

      final techniques = [];

      _techniqueItems.value.data?.forEach((PerformanceForm form) {
        techniques.add({
          'performance_item_id': form.performanceItem?.id,
          'input_type': form.performanceItem?.inputType,
          'score': form.scoreText?.text,
          'link_url': form.linkText?.text,
          'video_file': form.fileVideo?.value.path == null
              ? null
              : MultipartFile.fromFileSync(form.fileVideo!.value.path!,
                  filename: form.fileVideo!.value.name),
        });
      });

      final physiques = [];
      _physicItems.value.data?.forEach((PerformanceForm form) {
        physiques.add({
          'performance_item_id': form.performanceItem?.id,
          'input_type': form.performanceItem?.inputType,
          'score': form.scoreText?.text,
          'link_url': form.linkText?.text,
          'video_file': form.fileVideo?.value.path == null
              ? null
              : MultipartFile.fromFileSync(form.fileVideo!.value.path!,
                  filename: form.fileVideo!.value.name),
        });
      });

      final attackTactic = [];
      _attackTacticItems.value.data?.forEach((PerformanceForm form) {
        attackTactic.add({
          'performance_item_id': form.performanceItem?.id,
          'input_type': form.performanceItem?.inputType,
          'link_url': form.linkText?.text,
          'video_file': form.fileVideo?.value.path == null
              ? null
              : MultipartFile.fromFileSync(form.fileVideo!.value.path!,
                  filename: form.fileVideo!.value.name),
        });
      });

      final defendTactic = [];
      _defendTacticItems.value.data?.forEach((PerformanceForm form) {
        defendTactic.add({
          'performance_item_id': form.performanceItem?.id,
          'input_type': form.performanceItem?.inputType,
          'link_url': form.linkText?.text,
          'video_file': form.fileVideo?.value.path == null
              ? null
              : MultipartFile.fromFile(form.fileVideo!.value.path!,
                  filename: form.fileVideo!.value.name),
        });
      });

      final mental = [];
      _mentalItems.value.data?.forEach((PerformanceForm form) {
        int? score;
        if (form.scatAnswer == 0) {
          score = form.scatQuestion?.rarely;
        } else if (form.scatAnswer == 1) {
          score = form.scatQuestion?.sometimes;
        } else if (form.scatAnswer == 2) {
          score = form.scatQuestion?.often;
        }
        mental.add({
          'scat_id': form.scatQuestion?.id,
          'score_scat': score,
        });
      });

      FormData data = FormData.fromMap({
        'player_id': _player.value.id,
        'technique': techniques,
        'physic': physiques,
        'attack_tactic': attackTactic,
        'defend_tactic': defendTactic,
        'mental': mental,
      });
      await _performanceTestRequest.requestVerification(data: data);
      EasyLoading.dismiss();
      showSuccessDialog();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  metalSelection(PerformanceForm performance, int indexAnswer) {
    performance.scatAnswer = indexAnswer;
  }

  showSuccessDialog() {
    Get.defaultDialog(
        title: 'Permintaan Verifikasi Berhasil!',
        content: const VStack([
          Text(
            'Parametermu akan langsung ter-update ketika data sudah terverifikasi',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Center(
            child: Icon(
              Icons.check,
              color: Colors.green,
              size: 48,
            ),
          ),
          Center(
            child: Text(
              'Klik "Selesai" untuk kembali ke Profil',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ]),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (Get.isDialogOpen!) {
                Get.back();
              }
              Get.back();
              Get.back();
              Get.back();
              Get.back();
              Get.back();
              Get.back();
            },
            child: const Text('Selesai'),
          )
        ]);
  }

  openLink(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  List<PlayerPosition>? get positionItems => _positionItems.value.data;
  PlayerPosition? get selectedPosition => _positionSelected.value;

  PerformanceForm? get tacticForm => _tacticForm;
  List<PerformanceForm>? get techniqueItems => _techniqueItems.value.data;
  List<PerformanceForm>? get phsyicItems => _physicItems.value.data;
  List<PerformanceForm>? get attackTacticItems => _attackTacticItems.value.data;
  List<PerformanceForm>? get defendTacticItems => _defendTacticItems.value.data;
  List<PerformanceForm>? get mentalItems => _mentalItems.value.data;
}
