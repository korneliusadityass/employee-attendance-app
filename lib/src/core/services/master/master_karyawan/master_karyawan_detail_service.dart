import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../helper/auth_pref_helper.dart';

class DetailMasterKaryawanService {
  final url = 'http://192.168.2.155:8000/user/data';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  FutureOr<Map<String, dynamic>> detailMasterKaryawan(int id) async {
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
        queryParameters: {
          'id': id,
        },
      );

      final Map<String, dynamic> responseMap = response.data;

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Succes!!!');
        print(responseMap);
        return responseMap;
      } else {
        print('Failed!!!');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    throw Exception('Failed to fetch data');
  }
}
