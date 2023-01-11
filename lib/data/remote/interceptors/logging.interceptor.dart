import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:mobile_pssi/utils/logger.dart';

class LoggingInterceptor implements Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Fimber.i('Option path ${options.path}');
    Logger.logRequest(options);
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.logResponse(response);

    return handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Logger.logError(err);

    return handler.next(err);
  }
}
