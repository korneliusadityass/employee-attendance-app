import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:project/src/core/helper/auth_pref_helper.dart';

class DioClients {
//base url
  static const String baseUrl = 'http://54.169.230.234:5930/';

  Dio dio = Dio(BaseOptions(
    baseUrl: baseUrl,
  ))
    ..interceptors.add(AppInterceptor(getx.Get.find()));

  get(String s) {}
}

class AppInterceptor implements Interceptor {
  AuthStorageHelper helper;
  AppInterceptor(this.helper);

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (helper.token != null) {
      debugPrint(helper.token);
      //add options
      options.headers['Authorization'] = 'Bearer ${helper.token}';
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}


