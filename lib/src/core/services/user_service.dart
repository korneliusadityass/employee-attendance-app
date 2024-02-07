import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../helper/auth_pref_helper.dart';

class UserNameService {
  final url = 'http://192.168.2.155:8000/user/me';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  FutureOr<Map<String, dynamic>> userName(String namaKaryawan) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };

      // final response = await dio.get(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {
      //     'nama_karyawan': namaKaryawan,
      //   },
      // );

      // final Map<String, dynamic> responseMap = response.data;

      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('Succes!!!');
      //   print(namaKaryawan);
      //   print(responseMap);
      //   return responseMap;
      // } else {
      //   print('Failed!!!');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    throw Exception('Failed to fetch data');
  }
}
