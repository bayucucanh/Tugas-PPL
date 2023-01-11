import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/requests/auth.request.dart';
import 'package:mobile_pssi/data/requests/user.request.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/login/login_screen.dart';
import 'package:mobile_pssi/ui/security_account/change_password.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/encode_apple_data.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SecurityAccountController extends BaseController {
  final _userRequest = UserRequest();
  final _authRequest = AuthRequest();
  final connectedGoogle = false.obs;
  final connectedFacebook = false.obs;
  final connectedApple = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'openid',
    ],
  );

  @override
  void onInit() {
    getProfile();
    getUserData();
    _checkSocialMedia();
    super.onInit();
  }

  _checkSocialMedia() {
    connectedGoogle(userData.value.googleId == null ? false : true);
    connectedFacebook(userData.value.fbId == null ? false : true);
    connectedApple(userData.value.appleId == null ? false : true);
  }

  toggleGoogle(bool? value) async {
    try {
      if (value == true) {
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

        String? uid;
        if (F.isDev) {
          uid = user.additionalUserInfo?.profile?['id'];
        } else {
          uid = user.additionalUserInfo?.profile?['sub'];
        }

        await _userRequest.connectSocialMedia(
            id: uid, provider: 'google', connecting: true);

        connectedGoogle(true);
      } else {
        await _userRequest.connectSocialMedia(
          provider: 'google',
          connecting: false,
        );
        connectedGoogle(false);
      }
    } catch (e) {
      getSnackbar("Informasi", e.toString());
    }
  }

  toggleFacebook(bool? value) async {
    try {
      if (value == true) {
        final LoginResult loginResult = await FacebookAuth.instance
            .login(permissions: ['public_profile', 'email']);

        if (loginResult.status == LoginStatus.success) {
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(loginResult.accessToken!.token);

          UserCredential user = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);

          String? uid;
          if (F.isDev) {
            uid = user.additionalUserInfo?.profile?['id'];
          } else {
            uid = user.additionalUserInfo?.profile?['sub'];
          }

          await _userRequest.connectSocialMedia(
              id: uid, provider: 'facebook', connecting: true);

          connectedFacebook(true);
        } else {
          await _userRequest.connectSocialMedia(
            provider: 'facebook',
            connecting: false,
          );
          connectedFacebook(false);
        }
      }
    } catch (e) {
      getSnackbar("Informasi", e.toString());
    }
  }

  toggleApple(bool? value) async {
    try {
      if (value == true) {
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

        String? uid;
        if (F.isDev) {
          uid = user.additionalUserInfo?.profile?['id'];
        } else {
          uid = user.additionalUserInfo?.profile?['sub'];
        }

        await _userRequest.connectSocialMedia(
            id: uid, provider: 'apple', connecting: true);

        connectedApple(true);
      } else {
        await _userRequest.connectSocialMedia(
          provider: 'apple',
          connecting: false,
        );
        connectedApple(false);
      }
    } catch (e) {
      getSnackbar("Informasi", e.toString());
    }
  }

  openChangePassword() {
    Get.toNamed(ChangePasswordScreen.routeName);
  }

  removeAccount() {
    getDialog(ConfirmationDefaultDialog(
      title: 'Penghapusan Akun',
      cancelText: 'Batal',
      confirmText: 'Hapus',
      content:
          'Apakah anda yakin ingin menghapus akun ini? Anda tidak dapat mengembalikan akun ini apabila sudah menekan tombol Hapus.',
      onConfirm: _deleteAccount,
    ));
  }

  _deleteAccount() async {
    try {
      EasyLoading.show();
      await _userRequest.deleteAccount();
      await _authRequest.logout();
      Storage.remove(ProfileStorage.token);
      Storage.remove(ProfileStorage.user);
      Get.offAllNamed(LoginScreen.routeName);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }
}
