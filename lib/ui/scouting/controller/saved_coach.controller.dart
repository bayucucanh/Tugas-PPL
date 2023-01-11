import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/ui/scouting/coach_scouting.dart';
import 'package:mobile_pssi/utils/storage.dart';

class SavedCoachController extends BaseController {
  final coaches = <User>[].obs;

  @override
  void onInit() {
    _fetchCoaches();
    super.onInit();
  }

  _fetchCoaches() {
    if (Storage.hasData(ProfileStorage.savedCoach)) {
      coaches.clear();
      List<dynamic> savedCoaches = Storage.get(ProfileStorage.savedCoach);
      savedCoaches
          .map((savedCoach) => coaches.add(User.fromJson(savedCoach)))
          .toList();
    }
  }

  deleteSavedCoach(User? coach) {
    if (Storage.hasData(ProfileStorage.savedCoach)) {
      List<dynamic> savedCoaches = Storage.get(ProfileStorage.savedCoach);
      savedCoaches.removeWhere((savedCoach) => savedCoach['id'] == coach?.id);

      _fetchCoaches();
    }
  }

  getDetail(User? coach) {
    Get.toNamed(CoachProfile.routeName, arguments: coach?.toJson());
  }

  goScoutingCoach() async {
    await Get.toNamed(CoachScouting.routeName);
    _fetchCoaches();
  }
}
