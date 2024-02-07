import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../helper/auth_pref_helper.dart';

class PerusahaanListService {
  final url = 'http://192.168.2.155:8000/perusahaan/list';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future perusahaanList({
    int page = 1,
    int size = 20,
    required String? filterNama,
    String order = 'asc',
  }) async {
    try {
      final tokenResponse = '';

      print('TOKEN RESPONSE: $tokenResponse');
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        "Authorization": 'Bearer $token',
      };
      final queryparameters = {
        'page': page,
        'size': size,
        if (filterNama != null) 'filter_nama': filterNama,
        'order': order,
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
        print('failed to fetch data');
      }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }

  Future<List<dynamic>> getPerusahaanList() async {
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
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }
}
