import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/class_category.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/observables/file_observable.dart';

class ClassCategoryRequest extends NetworkBase {
  Future<Resource<List<ClassCategory>>> gets({
    String? search,
    String sortBy = 'id',
    String orderBy = 'desc',
    int limit = 10,
    int page = 1,
    String? option,
  }) async {
    var response = await network.get('/class_category/get', queryParameters: {
      'sortBy': sortBy,
      'orderBy': orderBy,
      'limit': limit,
      'search': search,
      'page': page,
      'option': option,
    });

    return Resource(
      data: (response?.data['data'] as List)
          .map<ClassCategory>((data) => ClassCategory.fromJson(data))
          .toList(),
      meta: option == 'select'
          ? null
          : Meta(
              total: response?.data['meta']['total'],
              currentPage: response?.data['meta']['current_page'],
              lastPage: response?.data['meta']['last_page'],
            ),
    );
  }

  Future<void> create(
      {String? name, String? description, FileObservable? image}) async {
    await network.post(
      '/class_category',
      body: FormData.fromMap({
        'name': name,
        'description': description,
        'image_icon': image?.path == null
            ? null
            : await MultipartFile.fromFile(image!.path!, filename: image.name),
      }),
    );
  }

  Future<void> update({
    required int categoryClassId,
    String? name,
    String? description,
    FileObservable? image,
  }) async {
    await network.post(
      '/class_category/$categoryClassId/update',
      body: FormData.fromMap({
        'name': name,
        'description': description,
        'image_icon': image?.path == null
            ? null
            : await MultipartFile.fromFile(image!.path!, filename: image.name),
      }),
    );
  }

  Future<void> remove({required int classCategoryId}) async {
    await network.delete('/class_category/$classCategoryId/delete');
  }
}
