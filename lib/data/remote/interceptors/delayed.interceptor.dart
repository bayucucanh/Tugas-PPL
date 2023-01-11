import 'package:dio/dio.dart';

class DelayedInterceptor extends QueuedInterceptorsWrapper {
  static final needQueues = [
    '/learning/log',
    '/auth/forgot-password',
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (needQueues.contains(options.path)) {
      Future.delayed(const Duration(seconds: 1), () {
        return handler.next(options);
      });
    } else {
      return handler.next(options);
    }
  }
}
