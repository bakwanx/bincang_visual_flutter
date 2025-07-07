import 'dart:io';

import 'package:bincang_visual_flutter/utils/log/print_debug_log.dart';
import 'package:dio/dio.dart';


class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final httpMethod = options.method.toUpperCase();
    final url = options.baseUrl + options.path;

    printDebugLog(message:'--> $httpMethod $url');

    printDebugLog(message:'\tHeaders:');
    options.headers.forEach((k, Object? v) => printDebugLog(message:'\t\t$k: $v'));

    if (options.queryParameters.isNotEmpty) {
      printDebugLog(message:'\tqueryParams:');
      options.queryParameters.forEach(
            (k, Object? v) => printDebugLog(message:'\t\t$k: $v'),
      );
    }

    if (options.data != null) {
      printDebugLog(message:'\tBody: ${options.data}');
    }

    printDebugLog(message:'--> END $httpMethod');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printDebugLog(message:'<-- RESPONSE');

    printDebugLog(message:'\tStatus code: ${response.statusCode}');

    if (response.statusCode == 304) {
      printDebugLog(message:'\tSource: Cache');
    } else {
      printDebugLog(message:'\tSource: Network');
    }

    printDebugLog(message:'\tResponse: ${response.data}');

    printDebugLog(message:'<-- END HTTP');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    printDebugLog(message:'--> ERROR');
    final httpMethod = err.requestOptions.method.toUpperCase();
    final url = err.requestOptions.baseUrl + err.requestOptions.path;

    printDebugLog(message:'\tMETHOD: $httpMethod');
    printDebugLog(message:'\tURL: $url');
    if (err.response != null) {
      printDebugLog(message:'\tStatus code: ${err.response!.statusCode}');
      printDebugLog(message:'\tData: ${err.response!.data}');
    } else if (err.error is SocketException) {
      const message = 'No internet connectivity';
      printDebugLog(message:'\tException: FetchDataException');
      printDebugLog(message:'\tMessage: $message');
    } else {
      printDebugLog(message:'\tUnknown Error');
    }

    printDebugLog(message:'<-- END ERROR');
    super.onError(err, handler);
  }
}