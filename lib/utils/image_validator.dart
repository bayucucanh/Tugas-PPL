import 'package:dio/dio.dart';

class ImageValidator {
  Future<bool> getImage(String imageUrl) async {
    try {
      var res = await Dio().get(imageUrl);
      if (res.statusCode != 200) return false;
      Headers data = res.headers;
      return _checkIfImage(data.value('content-type'));
    } catch (_) {
      return false;
    }
  }

  bool _checkIfImage(String? param) {
    if (param == 'image/jpeg' || param == 'image/png' || param == 'image/gif') {
      return true;
    }
    return false;
  }
}
