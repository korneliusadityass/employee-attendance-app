import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../helper/auth_pref_helper.dart';

class KaryawanListService {
  final url = 'http://192.168.2.155:8000/user/hr/list';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future listkaryawan({
    int page = 1,
    int size = 20,
    String order = 'asc',
    int perusahaanId = 0,
    required int perusahaan_id,
    required String? filterNama,
  }) async {
    try {
      final tokenResponse = '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      final queryparameters = {
        'page': page,
        'size': size,
        'order': order,
        'perusahaan_id': perusahaanId,
        if (filterNama != null) 'filter_nama': filterNama,
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: queryparameters,
      );
      print('STATUS CODE: ${response.statusCode}');
      if (response.statusCode == 200) {
        print(response.data);
        return response.data;
      } else {
        print('failed');
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
      print(e.error);
    }
  }
}
