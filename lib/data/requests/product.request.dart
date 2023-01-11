import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/product.dart';
import 'package:mobile_pssi/data/model/resource.dart';
import 'package:mobile_pssi/extensions/case_convetion.extension.dart';

class ProductRequest extends NetworkBase {
  Future<Resource<List<Product>>> gets({
    int? page = 1,
    String? option,
    String? filterBy,
    String? sortBy = 'id',
    String? orderBy = 'desc',
  }) async {
    var resp = await network.get('/product', queryParameters: {
      'option': option,
      'page': page,
      'sortBy': sortBy,
      'orderBy': orderBy,
      'filter_by': filterBy,
    });

    return Resource(
      data: (resp?.data['data'] as List)
          .map<Product>((data) => Product.fromJson(data))
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

  Future<void> create({
    required String productId,
    required String productName,
    String? description,
    required double price,
    required int type,
    String? unit,
    int? value,
  }) async {
    await network.post('/product', body: {
      'product_id': productId.toLowerCase().snakeCase,
      'name': productName,
      'description': description,
      'price': price,
      'type': type,
      'unit': unit,
      'value': value,
      'status': 1,
    });
  }

  Future<void> remove({
    required int id,
  }) async {
    await network.delete('/product/$id/delete');
  }

  Future<void> update({
    required int id,
    required String? name,
    required String? description,
    required double? price,
    required int? duration,
    required String? unit,
  }) async {
    await network.patch('/product/update/$id', body: {
      'name': name,
      'description': description,
      'price': price,
      'value': duration,
      'unit': unit,
    });
  }
}
