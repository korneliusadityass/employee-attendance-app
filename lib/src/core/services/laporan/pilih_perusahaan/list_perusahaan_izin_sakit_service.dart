import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../helper/auth_pref_helper.dart';

class GetPerusahaanIzinSakitService {
  final url = 'http://192.168.2.155:8000/perusahaan/list';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future getPerusahaanIzinSakit() async {
    try {
      final tokenResponse = '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.get(
        url,
        options: Options(
          headers: headers,
        ),
      );

      print('STATUS CUTI KHUSUS : ${response.statusCode}');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('failed to fetch data');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
