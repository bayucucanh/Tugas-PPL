import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/ui/login/login_screen.dart';
import 'package:mobile_pssi/utils/storage.dart';

class ErrorInterceptors implements Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        throw TimeOutException(err.requestOptions);
      case DioErrorType.response:
        switch (err.response?.statusCode) {
          case 401:
            throw UnauthorizedException(err.requestOptions);
          case 403:
            Storage.remove(ProfileStorage.token);
            Storage.remove(ProfileStorage.user);
            Get.offAllNamed(LoginScreen.routeName);
            throw UnauthorizedException(err.requestOptions);
          case 404:
            throw NotFoundException(err.requestOptions);
          case 409:
            throw ConflictException(err.requestOptions);
          case 429:
            throw TooMuchRequestException(err.requestOptions);
          case 500:
            throw InternalServerErrorException(
                err.response, err.requestOptions);
          case 400:
          case 422:
          default:
            throw UndefinedException(err.response, err.requestOptions);
        }
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}

class BadRequestException extends DioError {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class ConflictException extends DioError {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Terjadi konflik';
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(Response<dynamic>? response, RequestOptions r)
      : super(response: response, requestOptions: r);

  // @override
  // String toString() {
  //   return 'Unknown error occurred, please try again later.';
  // }
  @override
  String toString() {
    Object? message = response?.data != ''
        ? response?.data['message']
        : response?.statusMessage;
    if (message == null) return "Exception";
    return "$message";
  }
}

class NotFoundException extends DioError {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Informasi yang diminta tidak dapat ditemukan';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Tidak mendeteksi koneksi internet, mohon coba kembali.';
  }
}

class TimeOutException extends DioError {
  TimeOutException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Koneksi gagal terhubung, mohon coba kembali.';
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Akses ditolak';
  }
}

class TooMuchRequestException extends DioError {
  TooMuchRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Terlalu banyak permintaan';
  }
}

class UndefinedException extends DioError {
  UndefinedException(Response<dynamic>? response, RequestOptions r)
      : super(response: response, requestOptions: r);

  @override
  String toString() {
    Object? message = response?.data['message'] ?? response?.data;
    if (message == null) return "Exception";
    return "$message";
  }
}
