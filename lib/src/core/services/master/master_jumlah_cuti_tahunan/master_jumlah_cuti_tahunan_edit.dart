import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../helper/auth_pref_helper.dart';

class EditCutiTahunanService {
  final url = 'http://192.168.2.155:8000/master_cuti_tahunan/hr/edit';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future editCutiTahunan(int id, int kuota) async {
    try {
      final tokenResponse = '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };

      final response = await dio.patch(
        url,
        options: Options(
          headers: headers,
        ),
        queryParameters: {
          'id': id,
          'kuota': kuota,
        },
        data: {
          'kuota': kuota,
        },
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('Succes!!!');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
