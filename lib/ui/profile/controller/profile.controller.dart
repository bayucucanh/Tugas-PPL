import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/profile.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/user.request.dart';
import 'package:mobile_pssi/ui/about/about_screen.dart';
import 'package:mobile_pssi/ui/help/help_screen.dart';
import 'package:mobile_pssi/ui/profile/personal_data.dart';
import 'package:mobile_pssi/ui/security_account/security_account.dart';
import 'package:mobile_pssi/ui/subscriptions/my_subscriptions.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileController extends BaseController {
  final _userRequest = UserRequest();
  final profile = const Profile().obs;
  final isGettingAppInfo = false.obs;
  final appVersion = '1.0'.obs;

  @override
  void onInit() {
    getUserData();
    getProfile();
    _getAppVersion();
    super.onInit();
  }

  _refreshProfile() async {
    try {
      EasyLoading.show();
      User user = await _userRequest.getProfile();
      Storage.save(ProfileStorage.user, user.toJson());
      userData(user);
      profile(userData.value.profile);
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('', e.toString());
    }
  }

  @override
  getProfile() async {
    profile(userData.value.profile);
  }

  openPersonalData() async {
    await Get.toNamed(PersonalData.routeName);
    _refreshProfile();
  }

  openHelp() {
    Get.toNamed(HelpScreen.routeName);
  }

  openMySubscriptions() {
    Get.toNamed(MySubscriptions.routeName);
  }

  openAbout() {
    Get.toNamed(AboutScreen.routeName);
  }

  openSecurity() {
    Get.toNamed(SecurityAccount.routeName);
  }

  _getAppVersion() async {
    try {
      isGettingAppInfo(true);
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion(packageInfo.version);
      isGettingAppInfo(false);
    } catch (e) {
      isGettingAppInfo(false);
    }
  }

  openCS() async {
    try {
      String url = GetPlatform.isIOS
          ? 'whatsapp://wa.me/+6281321500904/'
          : 'whatsapp://send?phone=+6281321500904';
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      }
    } catch (e) {
      getSnackbar('Informasi', e.toString());
    }
  }
}
