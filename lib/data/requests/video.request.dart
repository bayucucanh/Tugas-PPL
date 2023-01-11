import 'package:dio/dio.dart';
import 'package:mobile_pssi/base/network.base.dart';

class VideoRequest extends NetworkBase {
  Future<void> doneWatching({required int id}) async {
    await network.post('/learning/player/create-learning-view/$id');
  }

  Future<bool> logVideo({required int id}) async {
    var resp = await network.get('/learning/log', queryParameters: {
      'learning_id': id,
    });

    if (resp?.statusCode == 400) {
      return false;
    }
    return true;
  }

  Future<void> videoAvailability({required int id}) async {
    await network.get('/learning/player/check-view/$id');
  }

  Future<void> createVideo({required FormData data}) async {
    await network.post('/learning/create-learning', body: data);
  }

  Future<void> editVideo({required int videoId, required FormData data}) async {
    await network.post('/learning/update-learning/$videoId', body: data);
  }
}
