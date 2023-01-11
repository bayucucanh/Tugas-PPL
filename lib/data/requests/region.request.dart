import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/city.dart';
import 'package:mobile_pssi/data/model/district.dart';
import 'package:mobile_pssi/data/model/province.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/data/model/village.dart';

class RegionRequest extends NetworkBase {
  Future<Resource<List<Province>>> getProvince({
    String option = 'select',
  }) async {
    var response = await network.get('/village/province', queryParameters: {
      'option': option,
      'sortBy': 'id',
      'orderBy': 'desc',
    });

    return Resource(
      data: (response?.data['data'])
          .map<Province>((data) => Province.fromJson(data))
          .toList(),
    );
  }

  Future<List<Province>> getListProvince({
    String? search,
  }) async {
    var response = await network.get('/village/province', queryParameters: {
      'sortBy': 'id',
      'orderBy': 'desc',
      'search': search,
    });

    return (response?.data['data'])
        .map<Province>((data) => Province.fromJson(data))
        .toList();
  }

  Future<Resource<List<City>>> getCity(
      {required int? provinceId, String option = 'select'}) async {
    var response = await network.get('/village/city', queryParameters: {
      'option': option,
      'province_id': provinceId,
    });

    return Resource(
      data: (response?.data['data'])
          .map<City>((data) => City.fromJson(data))
          .toList(),
    );
  }

  Future<List<City>> getListCity(
      {required int? provinceId, String? search}) async {
    var response = await network.get('/village/city', queryParameters: {
      'search': search,
      'province_id': provinceId,
    });

    return (response?.data['data'])
        .map<City>((data) => City.fromJson(data))
        .toList();
  }

  Future<Resource<List<District>>> getDistrict(
      {required int? cityId, String option = 'select'}) async {
    var response = await network.get('/village/district', queryParameters: {
      'option': option,
      'city_id': cityId,
    });

    return Resource(
      data: (response?.data['data'])
          .map<District>((data) => District.fromJson(data))
          .toList(),
    );
  }

  Future<List<District>> getListDistrict(
      {required int? cityId, String? search}) async {
    var response = await network.get('/village/district', queryParameters: {
      'search': search,
      'city_id': cityId,
    });

    return (response?.data['data'])
        .map<District>((data) => District.fromJson(data))
        .toList();
  }

  Future<Resource<List<Village>>> getVillage(
      {required int? districtId, String option = 'select'}) async {
    var response = await network.get('/village/village', queryParameters: {
      'option': option,
      'district_id': districtId,
    });

    return Resource(
      data: (response?.data['data'])
          .map<Village>((data) => Village.fromJson(data))
          .toList(),
    );
  }

  Future<List<Village>> getListVillage(
      {required int? districtId, String? search}) async {
    var response = await network.get('/village/village', queryParameters: {
      'search': search,
      'district_id': districtId,
    });

    return (response?.data['data'])
        .map<Village>((data) => Village.fromJson(data))
        .toList();
  }
}
