import 'dart:math';

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/image_path.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/user.dart' as m_user;
import 'package:mobile_pssi/data/model/user_type.dart';
import 'package:mobile_pssi/data/requests/auth.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/services/notification_service.dart';
import 'package:mobile_pssi/ui/dashboard/dashboard_screen.dart';
import 'package:mobile_pssi/ui/forgot_password/forgot_password.dart';
import 'package:mobile_pssi/utils/custom_firebase_auth.exception.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/encode_apple_data.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginController extends BaseController {
  final _authRequest = AuthRequest();
  final formKey = GlobalKey<FormState>(debugLabel: 'login');

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordVisibility = true.obs;
  final isPlatformIos = false.obs;

  final isLoadingNative = false.obs;
  final isLoadingGoogle = false.obs;
  final isLoadingApple = false.obs;
  final isLoadingFacebook = false.obs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'openid',
    ],
  );

  final userTypes = [
    UserType(id: 1, name: 'Pelatih', imagePath: pelatihImage),
    UserType(id: 2, name: 'Pemain', imagePath: pemainImage),
    UserType(id: 3, name: 'Club', imagePath: pelatihImage),
  ];

  final appleSignInAvailable = false.obs;

  @override
  void onInit() {
    _checkPlatform();
    _checkAppleSignInAvailability();
    super.onInit();
  }

  _checkPlatform() {
    if (GetPlatform.isIOS) {
      isPlatformIos(true);
    }
  }

  void _checkAppleSignInAvailability() async {
    appleSignInAvailable(await SignInWithApple.isAvailable());
  }

  void togglePasswordVisibility() {
    passwordVisibility.toggle();
  }

  void doLogin() async {
    try {
      isLoadingNative(true);
      if (!formKey.currentState!.validate()) {
        isLoadingNative(false);
        return;
      }
      _checkLogin();
      Get.focusScope?.unfocus();
      isLoadingNative(false);
    } on Exception catch (e) {
      isLoadingNative(false);
      getSnackbar("Login Failed", e.toString());
      EasyLoading.dismiss();
      Fimber.e(toString(), ex: e);
    }
  }

  void _checkLogin({
    String loginProvider = 'native',
    String? id,
    String? birthDate,
    String? email,
    String? name,
    String? phoneNumber,
    String? photo,
    int? userType,
    bool? isFirstTime = true,
  }) async {
    try {
      EasyLoading.show();

      String? token =
          await NotificationService.instance.getToken(vapidKey: F.vapidKey);

      Response<dynamic>? response;
      if (loginProvider == 'native') {
        response = await _authRequest.login(
          username: usernameController.text,
          password: passwordController.text,
          token: token,
        );
      } else {
        response = await _authRequest.loginWithSocialMedia(
          provider: loginProvider,
          id: id!,
          token: token,
          birthDate: birthDate,
          email: email,
          name: name,
          phoneNumber: phoneNumber,
          photo: photo,
          userType: userType,
          register: isFirstTime,
        );
      }

      if (response?.statusCode == 200) {
        m_user.User user = m_user.User.fromJson(response?.data['data']);
        Storage.save(ProfileStorage.token, response?.data['token']);
        Storage.save(ProfileStorage.user, user.toJson());
        // WsClient.instance.init();
        getSnackbar("Login Success", "Login sukses sebagai ${user.username}");

        /// route to dashboard
        EasyLoading.dismiss();
        Get.offAllNamed(DashboardScreen.routeName);
      } else {
        getSnackbar("Login Failed", response?.data['message'] ?? 'cant login');
        EasyLoading.dismiss();
      }
    } catch (e) {
      getSnackbar("Login Failed", e.toString());
      EasyLoading.dismiss();
    }
  }

  void signInWithGoogle() async {
    try {
      isLoadingGoogle(true);
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);

      bool isRegistered =
          await _authRequest.isRegistered(email: user.user?.email);

      String? uid;
      if (F.isStaging || F.isDev) {
        uid = user.additionalUserInfo?.profile?['id'];
      } else {
        uid = user.additionalUserInfo?.profile?['sub'];
      }

      if (isRegistered) {
        _checkLogin(
          loginProvider: 'google',
          id: uid,
          email: user.user?.email,
          isFirstTime: false,
        );
      } else {
        UserType userType = await getUserType();
        _checkLogin(
          loginProvider: 'google',
          id: uid,
          birthDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          email: user.user?.email,
          name: user.user?.displayName,
          phoneNumber: user.user?.phoneNumber,
          photo: user.user?.photoURL,
          userType: userType.id,
        );
      }
      await FirebaseAuth.instance.signOut();
      isLoadingGoogle(false);
    } catch (e) {
      isLoadingGoogle(false);
      getSnackbar("Login Failed", e.toString());
      CustomFirebaseAuthException.error(e);
    }
  }

  void signInWithFacebook() async {
    try {
      isLoadingFacebook(true);
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ['public_profile', 'email']);

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        UserCredential user = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        bool isRegistered =
            await _authRequest.isRegistered(email: user.user?.email);

        String? uid;
        if (F.isStaging || F.isDev) {
          uid = user.additionalUserInfo?.profile?['id'];
        } else {
          uid = user.additionalUserInfo?.profile?['sub'];
        }

        if (isRegistered) {
          _checkLogin(
            loginProvider: 'facebook',
            id: uid,
            email: user.user?.email,
            isFirstTime: false,
          );
        } else {
          UserType userType = await getUserType();
          _checkLogin(
            loginProvider: 'facebook',
            id: uid,
            birthDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            email: user.user?.email,
            name: user.user?.displayName,
            phoneNumber: user.user?.phoneNumber,
            photo: user.user?.photoURL,
            userType: userType.id,
          );
        }
        isLoadingFacebook(false);
      }
    } on FirebaseAuthException catch (e) {
      isLoadingFacebook(false);
      getSnackbar("Login Failed", e.toString());
      CustomFirebaseAuthException.error(e);
    }
  }

  void signInWithApple() async {
    try {
      isLoadingApple(true);
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final appleCredential =
          await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ], nonce: nonce);

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      bool isRegistered =
          await _authRequest.isRegistered(email: user.user?.email);

      String? uid;
      if (F.isStaging || F.isDev) {
        uid = user.additionalUserInfo?.profile?['sub'];
      } else {
        uid = user.additionalUserInfo?.profile?['sub'];
      }

      if (isRegistered) {
        _checkLogin(
          loginProvider: 'apple',
          id: uid,
          email: user.user?.email,
          isFirstTime: false,
        );
      } else {
        UserType userType = await getUserType();
        _checkLogin(
          loginProvider: 'apple',
          id: uid,
          birthDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          email: user.user?.email,
          name: getRandomName(),
          phoneNumber: user.user?.phoneNumber,
          photo: user.user?.photoURL,
          userType: userType.id,
        );
      }
      isLoadingApple(false);
    } on FirebaseAuthException catch (e) {
      isLoadingApple(false);
      getSnackbar("Login Failed", e.toString());
      CustomFirebaseAuthException.error(e);
    }
  }

  Future<UserType> getUserType() async {
    return await Get.defaultDialog(
      title: 'Pilih User',
      barrierDismissible: false,
      content: SizedBox(
        height: 200,
        child: Column(
          children: userTypes
              .map((userType) => ListTile(
                    leading: Image.asset(
                      userType.imagePath!,
                      width: 100,
                    ),
                    title: Text(userType.name ?? '-'),
                    onTap: () => Get.back(result: userType),
                  ))
              .toList(),
        ),
      ),
    );
  }

  openPrivacy() async {
    if (await canLaunchUrlString(
        'https://kunci-transformasi-digital.github.io/privacy/')) {
      await launchUrlString(
          'https://kunci-transformasi-digital.github.io/privacy/');
    }
  }

  openTos() async {
    String url;
    if (GetPlatform.isAndroid) {
      url =
          'https://kunci-transformasi-digital.github.io/privacy/terms-of-use.html';
    } else {
      url = 'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';
    }

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  String getRandomName() {
    Random random = Random.secure();
    int uniqueId = random.nextInt(90000) + 10000;
    return 'user_$uniqueId';
  }

  goToForgotPassword() {
    Get.toNamed(ForgotPassword.routeName);
  }
}
