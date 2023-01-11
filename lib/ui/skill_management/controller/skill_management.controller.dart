import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/skill.dart';
import 'package:mobile_pssi/data/requests/skill.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/skill_management/add_skill.dart';
import 'package:mobile_pssi/ui/skill_management/edit_skill.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SkillManagementController extends BaseController {
  final refreshController = RefreshController();
  final _skillRequest = SkillRequest();
  final _skills = Resource<List<Skill>>(data: []).obs;
  final _page = 1.obs;

  @override
  void onInit() {
    _fetchSkills();
    super.onInit();
  }

  refreshData() {
    try {
      _page(1);
      _skills.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchSkills();
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchSkills() async {
    try {
      EasyLoading.show();
      var resp = await _skillRequest.getSkills(page: _page.value, option: null);
      _skills.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e));
        val?.meta = resp.meta;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() {
    try {
      if (_page.value >= _skills.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        _page(_page.value + 1);
        _fetchSkills();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  addSkill() async {
    var data = await Get.toNamed(AddSkill.routeName);
    if (data != null) {
      refreshController.requestRefresh();
    }
  }

  editSkill(Skill? skill) {
    Get.toNamed(EditSkill.routeName, arguments: skill?.toJson());
  }

  confirmDelete(Skill? skill) {
    Get.dialog(ConfirmationDefaultDialog(
      title: 'Hapus Topik Keahlian',
      content: 'Hapus topik keahlian ${skill?.name ?? '-'}?',
      onConfirm: () => _removeSkill(skill),
    ));
  }

  _removeSkill(Skill? skill) async {
    try {
      EasyLoading.show();
      await _skillRequest.remove(skillId: skill!.id!);
      EasyLoading.dismiss();
      if (Get.isDialogOpen!) {
        Get.back();
      }
      _skills.update((val) {
        val?.data?.remove(skill);
      });
    } catch (e) {
      EasyLoading.dismiss();
      getSnackbar('Informasi', e.toString());
    }
  }

  List<Skill>? get skills => _skills.value.data;
}
