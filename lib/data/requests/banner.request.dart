import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/banner_image.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:path/path.dart';

class BannerRequest extends NetworkBase {
  Future<Resource<List<BannerImage>>> getBanners({
    int? limit,
    int? page = 1,
  }) async {
    var resp = await network.get('/banners', queryParameters: {
      'limit': limit,
      'page': page,
    });

    return Resource(
      data: (resp?.data['data'])
          .map<BannerImage>((data) => BannerImage.fromJson(data))
          .toList(),
      meta: Meta(
        total: resp?.data['meta']['total'],
        currentPage: resp?.data['meta']['current_page'],
        lastPage: resp?.data['meta']['last_page'],
      ),
    );
  }

  Future<void> newBanner({
    String? title,
    File? file,
    String? description,
    String? link,
    int? duration,
    String? durationUnit,
  }) async {
    FormData data = FormData.fromMap({
      'title': title,
      'banner_image': await MultipartFile.fromFile(file!.path,
          filename: basename(file.path)),
      'description': description,
      'link': link,
      'duration': duration,
      'duration_unit': durationUnit,
    });
    await network.post('/banners', body: data);
  }

  Future<void> deleteBanner({
    int? bannerId,
  }) async {
    await network.delete('/banners/$bannerId');
  }
}
