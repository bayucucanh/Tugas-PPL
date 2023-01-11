import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_pssi/base/base_controller.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/model/club.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/user.dart';
import 'package:mobile_pssi/data/requests/search.request.dart';
import 'package:mobile_pssi/ui/club/club_detail.dart';
import 'package:mobile_pssi/ui/profile/coach/coach_profile.dart';
import 'package:mobile_pssi/ui/search/search_screen.dart';
import 'package:mobile_pssi/utils/storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum SearchType {
  classData,
  club,
  coach,
}

class SearchController extends BaseController {
  final refreshController = RefreshController();
  final _searchRequest = SearchRequest();
  final query = TextEditingController();
  final queryBlank = false.obs;
  final searchHistory = [].obs;
  final page = 1.obs;
  final searchType = SearchType.classData.obs;
  final searchResult = Resource<List<dynamic>>(data: []).obs;

  @override
  void onInit() {
    _fetchSearchHistory();
    debounce(query.obs, (TextEditingController q) => search(search: q.text));
    super.onInit();
  }

  _fetchSearchHistory() {
    var history = Storage.get(ProfileStorage.searchHistory);
    searchHistory(history);
  }

  search({String? search}) {
    String q = search ?? query.text;
    queryBlank(q.isNotEmpty ? false : true);
    searchResult.update((val) {
      val?.data?.clear();
      val?.meta = null;
    });
    refreshData(search: q);
    addSearchHistory(q);
  }

  _fetchDataSearch({String? search}) async {
    try {
      dynamic response;

      if (searchType.value == SearchType.classData) {
        response =
            await _searchRequest.getClass(search: search!, page: page.value);
      } else if (searchType.value == SearchType.coach) {
        response =
            await _searchRequest.getCoach(search: search!, page: page.value);
      } else if (searchType.value == SearchType.club) {
        response =
            await _searchRequest.getClub(search: search!, page: page.value);
      }

      searchResult.update((val) {
        val?.data?.addAll(response.data!.map((e) => e).toList());
        val?.meta = response.meta;
      });
    } catch (_) {}
  }

  selectSearchType(SearchType? search) {
    searchType(search);
    page(1);
    searchResult.update((val) {
      val?.data?.clear();
      val?.meta = null;
    });
  }

  refreshData({String? search}) {
    try {
      page(1);
      searchResult.update((val) {
        val?.data?.clear();
        val?.meta = null;
      });
      refreshController.resetNoData();
      _fetchDataSearch(search: search ?? query.text);
      refreshController.refreshCompleted();
    } catch (_) {
      refreshController.refreshFailed();
    }
  }

  loadMore() {
    try {
      if (page.value >= searchResult.value.meta!.lastPage!) {
        refreshController.loadNoData();
      } else {
        page((page.value + 1));
        _fetchDataSearch(search: query.text);
        refreshController.loadComplete();
      }
    } catch (_) {
      refreshController.loadFailed();
    }
  }

  addSearchHistory(String query) {
    if (!searchHistory.contains(query)) {
      searchHistory.add(query);
      Storage.save(ProfileStorage.searchHistory, searchHistory);
    }
  }

  resetForm() {
    searchResult.update((val) {
      val?.data?.clear();
      val?.meta = null;
    });
    query.clear();
    queryBlank(true);
  }

  removeSearchHistory() {
    if (Storage.hasData(ProfileStorage.searchHistory)) {
      Storage.remove(ProfileStorage.searchHistory);
      searchHistory.clear();
    }
  }

  tapOnTag(String tag) {
    query.text = tag;
    search(search: tag);
  }

  openCoachDetail(User? user) {
    Get.toNamed(CoachProfile.routeName, arguments: user?.toJson());
  }

  openClubDetail(Club? club) {
    Get.toNamed(ClubDetail.routeName, arguments: club?.toJson());
  }

  showSearchScreen() {
    Get.focusScope?.unfocus();
    Get.toNamed(SearchScreen.routeName);
    search(search: query.text);
  }
}
