import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/colors.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/player.dart';
import 'package:mobile_pssi/data/model/player_position.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/requests/player.request.dart';
import 'package:mobile_pssi/data/requests/position.request.dart';
import 'package:mobile_pssi/data/requests/region.request.dart';
import 'package:mobile_pssi/shared_ui/confirmation.dialog.dart';
import 'package:mobile_pssi/ui/scouting/scouting_club_player_history.dart';
import 'package:mobile_pssi/ui/scouting/scouting_player_detail.dart';
import 'package:mobile_pssi/ui/scouting/scouting_player_history.dart';
import 'package:mobile_pssi/utils/dialog_custom.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:velocity_x/velocity_x.dart';

class PlayerScoutingController extends BaseController {
  final refreshController = RefreshController();
  final _positionRequest = PositionRequest();
  final _playerRequest = PlayerRequest();
  final _regionRequest = RegionRequest();
  final positions = Resource<List<PlayerPosition>>(data: []).obs;
  final _provinces = Resource<List<Province>>(data: []).obs;
  final _cities = Resource<List<City>>(data: []).obs;
  final players = Resource<List<Player>>(data: []).obs;
  final loadingPlayers = false.obs;
  final positionFilter = const PlayerPosition().obs;
  final _province = const Province().obs;
  final domicileFilter = const City().obs;
  final heightFilter = TextEditingController();
  final weightFilter = TextEditingController();
  final page = 1.obs;
  final search = TextEditingController();

  @override
  void onInit() {
    _fetchPositions();
    _fetchProvince();
    _fetchPlayers();
    super.onInit();
  }

  _fetchPositions() async {
    try {
      var resp = await _positionRequest.getPlayerPositions();
      positions.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
    } catch (_) {}
  }

  _fetchProvince() async {
    try {
      var resp = await _regionRequest.getProvince();
      _provinces.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
    } catch (_) {}
  }

  _fetchCity() async {
    try {
      _cities(await _regionRequest.getCity(provinceId: _province.value.id));
    } catch (_) {}
  }

  refreshData() {
    try {
      page(1);
      players.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchPlayers();
      refreshController.refreshCompleted();
      Get.focusScope?.unfocus();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  _fetchPlayers() async {
    try {
      var resp = await _playerRequest.getPlayers(
        page: page.value,
        positionId: positionFilter.value.id,
        search: search.text,
        cityId: domicileFilter.value.id,
        height: heightFilter.text,
        weight: weightFilter.text,
      );
      players.update((val) {
        val?.data?.addAll(resp.data!.map((e) => e).toList());
        val?.meta = resp.meta;
      });
    } catch (e) {
      loadingPlayers(false);
      getSnackbar('Informasi', e.toString());
    }
  }

  loadMore() {
    try {
      if (page.value >= players.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page(page.value + 1);
        _fetchPlayers();
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  openFilterPositionDialog() {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Pilih Penyaringan Posisi',
        contentWidget: ListView.builder(
          itemBuilder: (context, index) {
            final position = positions.value.data?[index];
            return ListTile(
              onTap: () => changeFilter(position),
              title: (position?.name ?? '-')
                  .text
                  .color(positionFilter.value.id == position?.id
                      ? primaryColor
                      : Colors.black)
                  .make(),
            );
          },
          itemCount: positions.value.data?.length ?? 0,
        ).h(240),
        showCancel: false,
        showConfirm: false,
      ),
    );
  }

  openFilterDomicileDialog() {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Pilih Penyaringan Domisili',
        contentWidget: ListView.builder(
          itemBuilder: (context, index) {
            final province = _provinces.value.data?[index];
            return ListTile(
              onTap: () => _changeProvince(province),
              title: (province?.name ?? '-')
                  .text
                  .color(_province.value.id == province?.id
                      ? primaryColor
                      : Colors.black)
                  .make(),
            );
          },
          itemCount: _provinces.value.data?.length ?? 0,
        ).h(240),
        showCancel: false,
        showConfirm: false,
      ),
    );
  }

  _changeProvince(Province? province) async {
    _province(province);
    if (Get.isDialogOpen!) {
      Get.back();
    }
    await _fetchCity();
    openFilterCityDialog();
  }

  openFilterCityDialog() {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Pilih Penyaringan Domisili',
        contentWidget: ListView.builder(
          itemBuilder: (context, index) {
            final city = _cities.value.data?[index];
            return ListTile(
              onTap: () => _changeCity(city),
              title: (city?.name ?? '-')
                  .text
                  .color(domicileFilter.value.id == city?.id
                      ? primaryColor
                      : Colors.black)
                  .make(),
            );
          },
          itemCount: _cities.value.data?.length ?? 0,
        ).h(240),
        showCancel: false,
        showConfirm: false,
      ),
    );
  }

  openFilterHeightDialog() {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Masukan Penyaringan Tinggi Badan',
        contentWidget: TextFormField(
          controller: heightFilter,
          decoration: const InputDecoration(
            hintText: 'Tinggi Badan',
            labelText: 'Tinggi Badan',
            suffixText: 'cm',
          ),
        ),
        showCancel: false,
        showConfirm: true,
        confirmText: 'Set',
        onConfirm: () {
          if (Get.isDialogOpen!) {
            Get.back();
          }
          refreshController.requestRefresh();
        },
      ),
    );
  }

  openFilterWeightDialog() {
    Get.dialog(
      ConfirmationDefaultDialog(
        title: 'Masukan Penyaringan Berat Badan',
        contentWidget: TextFormField(
          controller: weightFilter,
          decoration: const InputDecoration(
            hintText: 'Berat Badan',
            labelText: 'Berat Badan',
            suffixText: 'Kg',
          ),
        ),
        showCancel: false,
        showConfirm: true,
        confirmText: 'Set',
        onConfirm: () {
          if (Get.isDialogOpen!) {
            Get.back();
          }
          refreshController.requestRefresh();
        },
      ),
    );
  }

  _changeCity(City? city) {
    domicileFilter(city);
    if (Get.isDialogOpen!) {
      Get.back();
    }
    refreshController.requestRefresh();
  }

  resetFilter() {
    positionFilter(const PlayerPosition());
    _province(const Province());
    domicileFilter(const City());
    heightFilter.clear();
    weightFilter.clear();
    refreshController.requestRefresh();
  }

  changeFilter(PlayerPosition? position) {
    if (positionFilter.value.id == position?.id) {
      positionFilter(const PlayerPosition());
    } else {
      positionFilter(position);
    }
    if (Get.isDialogOpen!) {
      Get.back();
    }
    refreshController.requestRefresh();
  }

  getDetail(Player? player) {
    Get.toNamed(ScoutingPlayerDetail.routeName, arguments: player?.toJson());
  }

  getHistory() {
    Get.toNamed(ScoutingPlayerHistory.routeName);
  }

  getClubPlayerHistory() {
    Get.toNamed(ScoutingClubPlayerHistory.routeName);
  }
}
