import 'dart:convert';
import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/constant/styles.dart';
import 'package:mobile_pssi/data/model/otp_model.dart';
import 'package:mobile_pssi/data/model/register_player_model.dart';
import 'package:mobile_pssi/data/model/user_type.dart';
import 'package:mobile_pssi/utils/date_picker.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:path/path.dart';

class RegisterController extends BaseController {
  final indexStepper = 0.obs;

  final formKeyUserData = GlobalKey<FormState>(debugLabel: 'userData');
  final formKeyCredentials = GlobalKey<FormState>(debugLabel: 'credentials');
  final formKeyOTP = GlobalKey<FormState>(debugLabel: 'otp');

  final pageController = PageController(
    initialPage: 0,
  );
  final currentIndex = 0.obs;

  Future<bool> onBackPressed() async {
    backPage();
    return currentIndex.value < 0 ? true : false;
  }

  void nextPage() {
    if (currentIndex.value < 3) {
      int nextPage = currentIndex.value + 1;
      currentIndex(nextPage);
      pageController.nextPage(
          duration: const Duration(milliseconds: 333), curve: Curves.linear);
      setTitle();
      update();
    }
  }

  void backPage() {
    if (currentIndex.value > 0) {
      int previousPage = currentIndex.value - 1;
      currentIndex(previousPage);

      pageController.previousPage(
          duration: const Duration(milliseconds: 333), curve: Curves.linear);
      setTitle();
      update();
    } else {
      Get.back();
    }
  }

  void doRegister() async {
    try {
      Get.focusScope?.unfocus();
      EasyLoading.show();
      var response = await network.post(
        '/auth/register',
        body: {
          'user_type': selectedUserType.value.id,
          'name': fullNameController.text.toString(),
          'email': emailController.text.toString(),
          'phone_number': phoneNumberController.text.toString(),
          'date_of_birth': birthDateController.text.toString(),
          'username': usernameController.text.toString(),
          'password': passwordController.text.toString(),
          'confirm_password': confirmPasswordController.text.toString(),
          'photo':
              "data:image/${extension(pic!.path).replaceAll(".", "")};base64,${base64Encode(File(pic!.path).readAsBytesSync())}",
        },
        headers: {'Accept': 'application/json'},
      );
      RegisterPlayerModel convertToModel =
          RegisterPlayerModel.fromJson(response?.data);

      if (convertToModel.data != null) {
        Storage.save(ProfileStorage.token, convertToModel.token);
        getSnackbar("Register", convertToModel.message ?? "Register Complete");
        nextPage();
        EasyLoading.dismiss();
        update();
      } else {
        getSnackbar(
            "Register Failed", convertToModel.message ?? 'Cant Register');
        EasyLoading.dismiss();
        update();
      }
    } on Exception catch (e) {
      // dismissLoading();
      EasyLoading.dismiss();
      getSnackbar("Register Failed", e.toString());
      Fimber.e(toString(), ex: e);
      update();
    }
  }

  void confirmOTP() async {
    try {
      Get.focusScope?.unfocus();
      EasyLoading.show();
      var response = await network.post(
        '/auth/check-otp',
        body: {
          'email': emailController.text,
          'otp': otpController.text,
        },
        headers: {'Accept': 'application/json'},
      );
      OtpModel convertToModel = OtpModel.fromJson(response?.data);
      if (response?.statusCode == 200) {
        getSnackbar("Register", convertToModel.message ?? "Register Complete");
        Get.close(1);
        EasyLoading.dismiss();
        update();
      } else {
        getSnackbar(
            "Register Failed", convertToModel.message ?? 'Cant Register');
        EasyLoading.dismiss();
        update();
      }
    } on Exception catch (e) {
      EasyLoading.dismiss();
      getSnackbar("Register Failed", e.toString());
      Fimber.e(toString(), ex: e);
      update();
    }
  }

  void resentOTP() async {
    try {
      Get.focusScope?.unfocus();
      EasyLoading.show();
      var response = await network.post(
        '/auth/resend-otp',
        body: {'email': emailController.text},
        headers: {'Accept': 'application/json'},
      );
      OtpModel convertToModel = OtpModel.fromJson(response?.data);
      if (response?.statusCode == 200) {
        getSnackbar("Register", convertToModel.message ?? "Register Complete");
        EasyLoading.dismiss();
        update();
      } else {
        getSnackbar(
            "Register Failed", convertToModel.message ?? 'Cant Register');
        EasyLoading.dismiss();
        update();
      }
    } on Exception catch (e) {
      // dismissLoading();
      EasyLoading.dismiss();
      getSnackbar("Register Failed", e.toString());
      Fimber.e(toString(), ex: e);
      update();
    }
  }

  void setTitle() {
    switch (currentIndex.value) {
      case 1:
        titlePage.value = "2. Isi Data ${selectedUserType.value.name}";
        break;
      case 2:
        titlePage.value = "3. Buat Akun";
        break;
      case 3:
        titlePage.value = "4. Konfirmasi";
        break;
      default:
        titlePage.value = "1. Pilih User";
    }
  }

  Widget nextButton() {
    if (currentIndex.value == 0) {
      return SizedBox(
        width: Get.width * 0.8,
        child: ElevatedButton(
          onPressed: () {
            if (selectedUserType.value.id != null) {
              nextPage();
            }
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  selectedUserType.value.id == null
                      ? Colors.grey
                      : primaryColor)),
          child: Text(
            "choose_user".tr,
            style: buttonTextStyle,
          ),
        ),
      );
    } else if (currentIndex.value == 1) {
      return SizedBox(
        width: Get.width * 0.8,
        child: ElevatedButton(
          onPressed: () {
            if (pic == null) {
              getSnackbar("Profile Picture", 'unselected_profile_pic'.tr);
            }
            if (formKeyUserData.currentState != null) {
              formKeyUserData.currentState!.validate() && pic != null
                  ? nextPage()
                  : null;
            }
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  formKeyUserData.currentState != null
                      ? primaryColor
                      : Colors.grey)),
          child: Text(
            "next".tr,
            style: buttonTextStyle,
          ),
        ),
      );
    } else if (currentIndex.value == 2) {
      return SizedBox(
        width: Get.width * 0.8,
        child: ElevatedButton(
          onPressed: () {
            if (formKeyCredentials.currentState != null) {
              formKeyCredentials.currentState!.validate() ? doRegister() : null;
            }
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  formKeyCredentials.currentState != null
                      ? primaryColor
                      : Colors.grey)),
          child: Text(
            "next".tr,
            style: buttonTextStyle,
          ),
        ),
      );
    } else {
      return SizedBox(
        width: Get.width * 0.8,
        child: ElevatedButton(
          onPressed: () {
            if (selectedUserType.value.id != null) {
              if (timerCountdown.value > 0) {
                confirmOTP();
              } else {
                resentOTP();
              }
            }
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  selectedUserType.value.id == null
                      ? Colors.grey
                      : primaryColor)),
          child: timerCountdown.value > 0
              ? Text(
                  "next".tr,
                  style: buttonTextStyle,
                )
              : Text(
                  "resent_otp".tr,
                  style: buttonTextStyle,
                ),
        ),
      );
    }
  }

  // PAGE 1
  final userTypes = [
    UserType(
      id: 2,
      name: 'Pemain',
      imagePath: pemainImage,
      title: 'Daftar Sebagai Pemain',
      description:
          'Anda akan mendapatkan fitur : \n 1. e-Learning (Video Pembelajaran) \n 2. Test kemampuan parameter \n 3. Konsultasi dengan Pelatih',
    ),
    UserType(
      id: 1,
      name: 'Pelatih',
      imagePath: pelatihImage,
      title: 'Daftar Sebagai Pelatih',
      description:
          'Anda akan mendapatkan fitur : \n 1. Konsultasi Ahli dalam Aplikasi (Prima Academy Partner) \n 2. Seminar Pendidikan Kepelatihan',
    ),
    UserType(
      id: 3,
      name: 'Club',
      imagePath: pelatihImage,
      title: 'Daftar Sebagai Klub',
      description:
          'Anda akan mendapatkan fitur : \n 1. Manajemen Klub (Membuat Tim) \n 2. Transfermarket \n 3. Player/Coach Scouting',
    ),
  ];
  final selectedUserType = UserType().obs;

  final titlePage = "1. Pilih User".obs;

  void selectUserType(UserType userType) {
    selectedUserType(userType);
    update();
  }

  //PAGE 2
  final fullNameController = TextEditingController();
  final selectedDate = DateTime.now().obs;
  final selectedCountryNumber = "+62".obs;
  final birthDateController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();

  final df = DateFormat('yyyy-MM-dd');

  void selectDate() async {
    final DateTime? selected = await DatePicker.getDate(Get.context!,
        initialDate: selectedDate.value,
        firstDate: DateTime(1990),
        lastDate: DateTime(DateTime.now().year + 1));

    if (selected != null && selected != selectedDate.value) {
      selectedDate.value = selected;
      birthDateController.text = df.format(selected);
    }
    update();
  }

  void selectContryNumber(String newValue) {
    selectedCountryNumber.value = newValue;
    update();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? pic;
  final selectedFile = false.obs;

  openPictureDialog() {
    Get.dialog(AlertDialog(
      title: Text("choose_image".tr),
      actions: [
        ElevatedButton(
            onPressed: () {
              Get.back();
              _getFromCamera();
            },
            child: const Text("Camera")),
        ElevatedButton(
            onPressed: () {
              Get.back();
              _getFromGallery();
            },
            child: const Text("Gallery"))
      ],
    ));
  }

  void _getFromCamera() async {
    // Capture a photo
    pic = await _picker.pickImage(source: ImageSource.camera);

    if (pic != null) {
      selectedFile(true);
    } else {
      selectedFile(false);
    }
  }

  void _getFromGallery() async {
    // Pick an image
    pic = await _picker.pickImage(source: ImageSource.gallery);
    if (pic != null) {
      selectedFile(true);
    } else {
      selectedFile(false);
    }
  }

  // PAGE 3
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final passwordVisibility = true.obs;
  final confirmPasswordVisibility = true.obs;

  void togglePasswordVisibility() {
    passwordVisibility.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisibility.toggle();
  }

  // PAGE 4
  final otpController = TextEditingController();
  final timerCountdown = 300.obs;
}
