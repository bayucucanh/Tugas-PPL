import 'package:mobile_pssi/base/network.base.dart';
import 'package:mobile_pssi/data/model/rating_class.dart';
import 'package:mobile_pssi/data/model/resource.dart';

class RatingRequest extends NetworkBase {
  Future<Resource<List<RatingClass>>> getAllReviews({required int coachId, int? page}) async {
    var resp = await network.get('/review/all/class', queryParameters: {
      'coach_id': coachId,
      'page': page,
    });

    return Resource(
        data: (resp?.data['data'])
            .map<RatingClass>((data) => RatingClass.fromJson(data))
            .toList(),
        meta: Meta(
          total: resp?.data['meta']['total'],
          currentPage: resp?.data['meta']['current_page'],
        ));
  }

  Future<void> ratingClass({
    double? rating,
    int? classId,
    String? description,
  }) async {
    await network.post('/review/class/rate', body: {
      'rating': rating,
      'class_id': classId,
      'description': description,
    });
  }
}
