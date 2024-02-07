import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../helper/auth_pref_helper.dart';

class ListKaryawanService {
  final url = 'http://192.168.2.155:8000/user/hr/list';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future listKaryawan({
    required String? filterNama,
  }) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };

      // final queryparameters = {
      //   if (filterNama != null) 'filter_nama': filterNama,
      // };

      // final response = await dio.get(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: queryparameters,
      // );

      // debugPrint('${response.statusCode}');
      // if (response.statusCode == 200) {
      //   return response.data;
      // } else {
      //   debugPrint('failed to fetch data');
      //   return [];
      // }
    } on DioError catch (e) {
      debugPrint('${e.error}');
      debugPrint(e.message);
      debugPrint('${e.response}');
      return [];
    }
  }
}
