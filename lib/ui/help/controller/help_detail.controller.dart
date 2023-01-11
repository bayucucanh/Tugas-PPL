import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/help.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HelpDetailController extends BaseController {
  final _help = Help().obs;

  HelpDetailController() {
    _help(Help.fromJson(Get.arguments));
  }

  openLink(String s, String? b, String c) async {
    if (b != null) {
      if (await canLaunchUrlString(b)) {
        await launchUrlString(b);
      }
    }
  }

  Help? get help => _help.value;
}
