import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:mobile_pssi/constant/profile_storage.dart';
import 'package:mobile_pssi/data/remote/interceptors/delayed.interceptor.dart';
import 'package:mobile_pssi/data/remote/interceptors/error.interceptor.dart';
import 'package:mobile_pssi/data/remote/interceptors/logging.interceptor.dart';
import 'package:mobile_pssi/data/remote/interceptors/token.interceptor.dart';
import 'package:mobile_pssi/data/remote/sse_model.dart';
import 'package:mobile_pssi/flavors.dart';
import 'package:mobile_pssi/utils/custom_exception.dart';
import 'package:mobile_pssi/utils/storage.dart';

enum RequestType {
  get,
  post,
  put,
  patch,
  delete,
}

class Network {
  static http.Client _client = http.Client();
  final _dio = createDio();

  final Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'package-name': GetPlatform.isAndroid
        ? 'com.kunci.mobile_pssi'
        : 'com.kunci.mobilePssi',
    'platform': GetPlatform.isAndroid ? 'android' : 'ios',
    'Authorization': "access_token"
  };

  // Network._internal();

  // static final _instance = Network._internal();

  // factory Network() => _instance;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: F.urlApi,
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
      receiveTimeout: 60000, // 20 seconds
      connectTimeout: 60000,
      sendTimeout: 60000,
    ));

    dio.interceptors.addAll([
      TokenInteceptor(),
      LoggingInterceptor(),
      DelayedInterceptor(),
      ErrorInterceptors(),
    ]);

    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    return dio;
  }

  // Future<NetworkResponse?> call(
  //   RequestType requestType,
  //   String url, {
  //   Map<String, dynamic>? queryParameters,
  //   Map<String, dynamic>? body,
  //   void Function(int, int)? onSendProgress,
  //   void Function(int, int)? onReceiveProgress,
  // }) async {
  //   late Response result;
  //   try {
  //     switch (requestType) {
  //       case RequestType.get:
  //         {
  //           Options options = Options(headers: header);
  //           result = await _dio.get(url,
  //               queryParameters: queryParameters, options: options);
  //           break;
  //         }
  //       case RequestType.post:
  //         {
  //           Options options = Options(headers: header);
  //           result = await _dio.post(
  //             url,
  //             data: body,
  //             options: options,
  //             onSendProgress: onSendProgress,
  //             onReceiveProgress: onReceiveProgress,
  //           );
  //           break;
  //         }
  //       case RequestType.patch:
  //         {
  //           Options options = Options(headers: header);
  //           result = await _dio.patch(
  //             url,
  //             data: body,
  //             options: options,
  //             onReceiveProgress: onReceiveProgress,
  //             onSendProgress: onSendProgress,
  //             queryParameters: queryParameters,
  //           );
  //           break;
  //         }
  //       case RequestType.put:
  //         {
  //           Options options = Options(headers: header);
  //           result = await _dio.put(
  //             url,
  //             data: body,
  //             options: options,
  //             onReceiveProgress: onReceiveProgress,
  //             onSendProgress: onSendProgress,
  //             queryParameters: queryParameters,
  //           );
  //           break;
  //         }
  //       case RequestType.delete:
  //         {
  //           Options options = Options(headers: header);
  //           result = await _dio.delete(url,
  //               data: body, options: options, queryParameters: queryParameters);
  //           break;
  //         }
  //     }
  //     // ignore: unnecessary_null_comparison
  //     if (result != null) {
  //       return NetworkResponse.success(result.data);
  //     } else {
  //       return const NetworkResponse.error("Data is null");
  //     }
  //   } on DioError catch (error) {
  //     return NetworkResponse.error(error.message);
  //   } catch (error) {
  //     return NetworkResponse.error(error.toString());
  //   }
  // }

  Future<Response?> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    int cacheDays = 7,
    bool forceRefresh = true,
  }) async {
    Response? response;
    try {
      response = await _dio.get(url, queryParameters: queryParameters);
      return response;
    } on DioError catch (e) {
      throw CustomException(e);
    }
  }

  Future<Response?> post(String url,
      {Map<String, dynamic>? headers,
      Function(int, int)? onSendProgress,
      body,
      int cacheDays = 7,
      bool forceRefresh = true,
      ResponseType? responseType}) async {
    Response? response;
    try {
      response = await _dio.post(
        url,
        data: body,
        onSendProgress: onSendProgress,
      );
      return response;
    } on DioError catch (e) {
      throw CustomException(e);
    }
  }

  Future<Response?> patch(
    String url, {
    Map<String, dynamic>? headers,
    Function(int, int)? onSendProgress,
    Map<String, dynamic>? queryParameters,
    body,
    int cacheDays = 7,
    bool forceRefresh = true,
    ResponseType? responseType,
  }) async {
    Response? response;
    try {
      response = await _dio.patch(
        url,
        data: body,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
      );
      return response;
    } on DioError catch (e) {
      throw CustomException(e);
    }
  }

  Future<Response?> put(
    String url, {
    Map<String, dynamic>? headers,
    Function(int, int)? onSendProgress,
    Map<String, dynamic>? queryParameters,
    body,
    int cacheDays = 7,
    bool forceRefresh = true,
    ResponseType? responseType,
  }) async {
    Response? response;
    try {
      response = await _dio.put(
        url,
        data: body,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
      );
      return response;
    } on DioError catch (e) {
      throw CustomException(e);
    }
  }

  Future<Response?> delete(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    Response? response;
    try {
      response =
          await _dio.delete(url, data: body, queryParameters: queryParameters);
      return response;
    } on DioError catch (e) {
      throw CustomException(e);
    }
  }

  Future<Response?> download(
    String url, {
    required String filename,
    required String folderPath,
    Map<String, dynamic>? queryParams,
    void Function(int?, int?)? onReceive,
  }) async {
    Response? response;
    try {
      String downloadPath = '$folderPath/$filename';
      response = await _dio.download(
        url,
        downloadPath,
        queryParameters: queryParams,
        onReceiveProgress: onReceive,
        deleteOnError: true,
      );
      return response;
    } on DioError catch (e) {
      throw CustomException(e);
    }
  }

  Stream<SSEModel> subscribeToStream({
    required String endpoint,
    bool? useAuthentication = false,
  }) {
    RegExp lineRegex = RegExp(r'^([^:]*)(?::)?(?: )?(.*)?$');
    SSEModel currentSSEModel = SSEModel(data: '', id: '', event: '');

    StreamController<SSEModel> streamController = StreamController();
    while (true) {
      try {
        _client = http.Client();
        String url = '${F.urlApi}$endpoint';
        var request = http.Request('GET', Uri.parse(url));

        ///Adding headers to the request
        if (useAuthentication == true) {
          final token = Storage.get(ProfileStorage.token);
          request.headers['Authorization'] = 'Bearer $token';
          request.headers['Accept'] = 'text/event-stream';
          request.headers['Cache-Control'] = 'no-cache';
        }

        Future<http.StreamedResponse> response = _client.send(request);

        ///Listening to the response as a stream
        response.asStream().listen((data) {
          ///Applying transforms and listening to it
          data.stream
              .transform(const Utf8Decoder())
              .transform(const LineSplitter())
              .listen(
            (dataLine) {
              if (dataLine.isEmpty) {
                ///This means that the complete event set has been read.
                ///We then add the event to the stream
                streamController.add(currentSSEModel);
                currentSSEModel = SSEModel(data: '', id: '', event: '');
                return;
              }

              ///Get the match of each line through the regex
              Match match = lineRegex.firstMatch(dataLine)!;
              var field = match.group(1);
              if (field!.isEmpty) {
                return;
              }
              var value = '';
              if (field == 'data') {
                //If the field is data, we get the data through the substring
                value = dataLine.substring(5);
              } else {
                value = match.group(2) ?? '';
              }
              switch (field) {
                case 'event':
                  currentSSEModel.event = value;
                  break;
                case 'data':
                  currentSSEModel.data =
                      '${currentSSEModel.data ?? ''}$value\n';
                  break;
                case 'id':
                  currentSSEModel.id = value;
                  break;
                case 'retry':
                  break;
              }
            },
            onError: (e, s) {
              debugPrint('---ERROR---');
              debugPrint(e);
              streamController.addError(e, s);
            },
          );
        }, onError: (e, s) {
          debugPrint('---ERROR---');
          debugPrint(e.toString());
          streamController.addError(e, s);
        });
      } catch (e, s) {
        debugPrint('---ERROR---');
        debugPrint(e.toString());
        streamController.addError(e, s);
      }

      Future.delayed(const Duration(seconds: 1), () {});
      return streamController.stream;
    }
  }

  unsubscribeFromSSE() {
    _client.close();
  }
}
