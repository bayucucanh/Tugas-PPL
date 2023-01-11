import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/performance_item.dart';
import 'package:mobile_pssi/data/model/performance_test_verification.dart';
import 'package:mobile_pssi/data/model/recommended.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/scat_question.dart';

class PerformanceTestRequest extends NetworkBase {
  Future<Resource<List<PerformanceTestVerification>>> getPerformanceTests({
    String? option,
    int? page = 1,
  }) async {
    var resp = await network.get('/performance/tests', queryParameters: {
      'option': option,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<PerformanceTestVerification>(
              (data) => PerformanceTestVerification.fromJson(data))
          .toList(),
      meta: option == 'select'
          ? null
          : Meta(
              total: resp?.data['meta']['total'],
              currentPage: resp?.data['meta']['current_page'],
              lastPage: resp?.data['meta']['last_page'],
            ),
    );
  }

  Future<Resource<List<PerformanceItem>>> getPerformanceItemByCategoryId({
    required int categoryId,
    int? positionId,
    String? option,
  }) async {
    var resp =
        await network.get('/performance/$categoryId/items', queryParameters: {
      'option': option,
      'only_for_position_id': positionId,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<PerformanceItem>((data) => PerformanceItem.fromJson(data))
          .toList(),
      meta: option == 'select'
          ? null
          : Meta(
              total: resp?.data['meta']['total'],
              currentPage: resp?.data['meta']['current_page'],
              lastPage: resp?.data['meta']['last_page'],
            ),
    );
  }

  Future<Resource<List<ScatQuestion>>> getScatQuestions({
    String? option,
  }) async {
    var resp =
        await network.get('/performance/scat/questions', queryParameters: {
      'option': option,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<ScatQuestion>((data) => ScatQuestion.fromJson(data))
          .toList(),
      meta: option == 'select'
          ? null
          : Meta(
              total: resp?.data['meta']['total'],
              currentPage: resp?.data['meta']['current_page'],
              lastPage: resp?.data['meta']['last_page'],
            ),
    );
  }

  Future<void> requestVerification({
    FormData? data,
  }) async {
    await network.post('/performance/request', body: data);
  }

  Future<void> available({required int playerId}) async {
    await network.get('/performance/$playerId/available');
  }

  Future<PerformanceTestVerification?> getPerfomance(
      {required int playerId}) async {
    var resp = await network.get('/performance/$playerId/test');
    if (resp?.statusCode == 200) {
      return PerformanceTestVerification.fromJson(resp?.data['data']);
    }
    return null;
  }

  Future<PerformanceTestVerification?> getPerfomanceDetail(
      {required int performanceTestVerificationId}) async {
    var resp =
        await network.get('/performance/$performanceTestVerificationId/detail');
    return PerformanceTestVerification.fromJson(resp?.data['data']);
  }

  Future<Resource<List<Recommended>>> getRecommendations({int? page}) async {
    var resp = await network.get('/recommendeds', queryParameters: {
      'sortBy': 'id',
      'orderBy': 'desc',
      'option': 'select'
    });

    return Resource(
      data: (resp?.data['data'])
          .map<Recommended>((data) => Recommended.fromJson(data))
          .toList(),
    );
  }

  Future<void> verifyPerformance({
    required int performanceVerificationId,
    Map<String, dynamic>? data,
  }) async {
    await network.patch('/performance/$performanceVerificationId/verify',
        body: data);
  }
}
