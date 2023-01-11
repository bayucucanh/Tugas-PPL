import 'package:bottom_inset_observer/bottom_inset_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/performance_test_verification.dart';
import 'package:mobile_pssi/data/model/performance_verification_form.dart';
import 'package:mobile_pssi/data/model/recommended.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/performance_test.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/ui/test_parameter/parts/form_verification.bottomsheet.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:pod_player/pod_player.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_url_validator/video_url_validator.dart';

class VerifyTestParamsController extends BaseController {
  final isLoadingVideo = false.obs;
  final _performanceRequest = PerformanceTestRequest();
  PodPlayerController? podPlayerController;
  final verifyDetail = PerformanceTestVerification().obs;
  final reason = TextEditingController();
  final mentalScore = TextEditingController();
  final recommendations = Resource<List<Recommended>>(data: []).obs;
  final selectRecommendation = const Recommended().obs;
  final urlValidator = VideoURLValidator();

  final recommendationEdit = false.obs;

  final verifyForm = GlobalKey<FormState>();
  final _techniqueItems = <PerformanceVerificationForm>[].obs;
  final _physicItems = <PerformanceVerificationForm>[].obs;
  final _attackItems = <PerformanceVerificationForm>[].obs;
  final _defendItems = <PerformanceVerificationForm>[].obs;

  final _viewInset = 0.0.obs;
  late BottomInsetObserver _insetObserver;

  VerifyTestParamsController() {
    verifyDetail(PerformanceTestVerification.fromJson(Get.arguments));
  }

  @override
  void onInit() {
    _insetObserver = BottomInsetObserver()..addListener(_keyboardHandle);
    _fetchDetail();
    _fetchRecommendeds();
    _filterTestPerformances();
    super.onInit();
  }

  @override
  void onClose() {
    podPlayerController?.dispose();
    _insetObserver.dispose();
    super.onClose();
  }

  void _keyboardHandle(BottomInsetChanges change) {
    _viewInset(change.currentInset);
  }

  _filterTestPerformances() {
    _techniqueItems(_getPerformanceVerificationByCategoryId(1));
    _physicItems(_getPerformanceVerificationByCategoryId(2));
    _attackItems(_getPerformanceVerificationByCategoryId(3));
    _defendItems(_getPerformanceVerificationByCategoryId(4));
  }

  _fetchRecommendeds() async {
    try {
      EasyLoading.show();
      recommendations(await _performanceRequest.getRecommendations());
      recommendations.update((val) {
        val?.data?.add(const Recommended(name: 'Belum ada rekomendasi'));
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  _fetchDetail() async {
    try {
      EasyLoading.show();

      verifyDetail(await _performanceRequest.getPerfomanceDetail(
          performanceTestVerificationId: verifyDetail.value.id!));
      setupVideo();
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  setupVideo() async {
    isLoadingVideo(true);
    podPlayerController = PodPlayerController(
        playVideoFrom: PlayVideoFrom.network(
            "${F.baseUrl}/assets/videos/default-video.mp4"),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          wakelockEnabled: true,
          isLooping: false,
        ));
    await podPlayerController?.initialise();
    isLoadingVideo(false);
  }

  bool isYoutubeVideoSource(String url) {
    if (urlValidator.validateYouTubeVideoURL(url: url)) {
      return true;
    } else {
      return false;
    }
  }

  changeRecommendation(Recommended? recommended) {
    selectRecommendation(recommended);
  }

  changeVideo(String? url) async {
    try {
      if (isYoutubeVideoSource(url!)) {
        if (podPlayerController?.isInitialised == true) {
          if (podPlayerController!.isVideoPlaying) {
            podPlayerController?.pause();
          }
          isLoadingVideo(true);
          podPlayerController?.changeVideo(
              playVideoFrom: PlayVideoFrom.youtube(url),
              playerConfig: playerConfig);
          isLoadingVideo(false);
        } else {
          isLoadingVideo(true);
          podPlayerController = PodPlayerController(
              playVideoFrom: PlayVideoFrom.youtube(url),
              podPlayerConfig: playerConfig)
            ..initialise();
          isLoadingVideo(false);
        }
      } else {
        if (url.contains(F.hostname)) {
          String token = Storage.get(ProfileStorage.token);
          if (podPlayerController?.isInitialised == true) {
            if (podPlayerController!.isVideoPlaying) {
              podPlayerController?.pause();
            }
            isLoadingVideo(true);
            podPlayerController?.changeVideo(
                playVideoFrom: PlayVideoFrom.network(url, httpHeaders: {
                  'Authorization': 'Bearer $token',
                }),
                playerConfig: playerConfig);
            isLoadingVideo(false);
          } else {
            isLoadingVideo(true);
            podPlayerController = PodPlayerController(
              playVideoFrom: PlayVideoFrom.network(url, httpHeaders: {
                'Authorization': 'Bearer $token',
              }),
              podPlayerConfig: playerConfig,
            )..initialise();
            isLoadingVideo(false);
          }
        } else {
          if (await canLaunchUrlString(url)) {
            await launchUrlString(url);
          }
        }
      }
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }

  openFormSheet() {
    if (verifyForm.currentState!.validate()) {
      getBottomSheet(FormVerificationBottomsheet(vm: this),
          isScrollControlled: true);
    } else {
      getSnackbar('Informasi', 'Masih ada data yang dikosongkan.');
    }
  }

  acceptDialog() {
    Get.defaultDialog(
      title: 'Verifikasi Test Parameters',
      content: const VStack([
        Text('Apakah anda yakin akan menerima test parameter ini?'),
      ]).p12(),
      actions: [
        ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            child: const Text(
              'Batal',
              style: TextStyle(color: primaryColor),
            )),
        ElevatedButton(
            onPressed: () => _verify(1), child: const Text('Verifikasi')),
      ],
    );
  }

  _verify(int status) async {
    try {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      EasyLoading.show();

      List<Map<String, dynamic>>? techniques =
          techniqueItems?.map((e) => e.toJson()).toList();

      List<Map<String, dynamic>>? physiques =
          physicItems?.map((e) => e.toJson()).toList();

      List<Map<String, dynamic>>? attackTactics =
          attackItems?.map((e) => e.toJson()).toList();

      List<Map<String, dynamic>>? defendTactics =
          defendItems?.map((e) => e.toJson()).toList();

      Map<String, dynamic> data = {
        'recommended_id': selectRecommendation.value.id,
        'scat_score': mentalScore.text,
        'performance_tests': List.from(techniques!)
          ..addAll(physiques!)
          ..addAll(attackTactics!)
          ..addAll(defendTactics!),
        'reason': reason.text,
        'status': status,
      };
      await _performanceRequest.verifyPerformance(
          performanceVerificationId: verifyDetail.value.id!, data: data);
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      recommendationEdit(false);
      _fetchDetail();
      EasyLoading.dismiss();
      if (status == 1) {
        showSuccessDialogVerify('Berhasil memverifikasi test parameters.');
      } else {
        showSuccessDialogVerify('Berhasil menolak test parameters.');
      }
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  showSuccessDialogVerify(String content) {
    Get.defaultDialog(
        title: 'Verifikasi Test Parameters',
        content: VStack([Text(content)]).p12(),
        actions: [
          ElevatedButton(onPressed: () => Get.back(), child: const Text('OK'))
        ]);
  }

  deniedDialog() {
    Get.defaultDialog(
      barrierDismissible: false,
      title: 'Tolak Test Parameters',
      content: const VStack([
        Text('Apakah anda yakin akan menolak test parameter ini?'),
      ]).p12(),
      actions: [
        ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            child: const Text(
              'Batal',
              style: TextStyle(color: primaryColor),
            )),
        ElevatedButton(onPressed: () => _verify(2), child: const Text('Tolak')),
      ],
    );
  }

  deniedTestParams() async {
    try {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      EasyLoading.show();
      // await _testParamsRequest.verifyTestParameters(verifyDetail.value.id!, 3,
      //     reason: reason.text);
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      _fetchDetail();
      showSuccessDialogVerify('Berhasil menolak test parameters.');
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  editRecommendation() {
    if (verifyDetail.value.status?.id == 0) {
      recommendationEdit.toggle();
    }
  }

  List<PerformanceVerificationForm>? _getPerformanceVerificationByCategoryId(
      int id) {
    if (verifyDetail.value.performanceTests!.isEmpty) {
      return [];
    }
    return verifyDetail.value.performanceTests
        ?.where((performanceTest) =>
            performanceTest.performanceItem?.performanceCategory?.id == id)
        .map((e) => PerformanceVerificationForm.fromPerformanceTest(e))
        .toList();
  }

  PodPlayerConfig get playerConfig => const PodPlayerConfig(
        autoPlay: false,
        wakelockEnabled: true,
        isLooping: false,
      );

  double get viewInset => _viewInset.value;
  List<PerformanceVerificationForm>? get techniqueItems => _techniqueItems;

  List<PerformanceVerificationForm>? get physicItems => _physicItems;

  List<PerformanceVerificationForm>? get attackItems => _attackItems;

  List<PerformanceVerificationForm>? get defendItems => _defendItems;
}
