import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';

class Logger {
  static logResponse(dynamic response) {
    // Fimber.i(
    //     "<-- ${response.statusCode} ${(response.request.baseUrl + response.request.path ?? 'URL')}");
    // Fimber.i("Headers:");
    // response.headers?.forEach((k, v) => Fimber.i('$k: $v'));
    Fimber.i("Response: ${response.data}");
    Fimber.i("<-- END HTTP");
  }

  static logError(DioError dioError) {
    Fimber.i("<-- ${dioError.message} ${((dioError.requestOptions.path))}");
    Fimber.i(
        "${dioError.response != null ? dioError.response?.data : 'Unknown Error'}");
    Fimber.i("<-- End error");
  }

  static logRequest(RequestOptions options) {
    Fimber.i(
        "--> ${options.method.toUpperCase()} ${"${options.baseUrl}${options.path}"}");
    Fimber.i("Headers:");
    Fimber.i("URL : ${options.uri}");
    options.headers.forEach((k, v) => Fimber.i('$k: $v'));
    Fimber.i("queryParameters:");
    options.queryParameters.forEach((k, v) => Fimber.i('$k: $v'));
    if (options.data != null) {
      Fimber.i("Body: ${options.data}");
    }
    Fimber.i("--> END ${options.method.toUpperCase()}");
  }
}
