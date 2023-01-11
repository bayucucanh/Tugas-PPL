import 'package:dio/dio.dart';
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/utils/storage.dart';

class TokenInteceptor implements InterceptorsWrapper {
  static final noNeedToken = [
    '/player/register',
    '/player/login',
  ];
  // static const tokenExpiredCode = 403;

  static bool isNeedToken(String route) => !noNeedToken.contains(route);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (isNeedToken(options.path)) {
      final token = Storage.get(ProfileStorage.token);

      options.headers = {
        ...options.headers,
        'Authorization': 'Bearer $token',
      };
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
