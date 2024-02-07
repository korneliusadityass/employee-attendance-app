import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../helper/auth_pref_helper.dart';

class ListingApproverService {
  final url = 'http://192.168.2.155:8000/approver/hr/listing';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future listingApprover({
    int page = 1,
    int size = 20,
    int id = 0,
    required String? filterNama,
  }) async {
    try {
      // final tokenResponse = '';

      // print('TOKEN RESPONSE: $tokenResponse');
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };
      // final queryparameters = {
      //   'page': page,
      //   'size': size,
      //   'id': id,
      //   if (filterNama != null) 'filter_nama': filterNama,
      // };

      // final response = await dio.get(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: queryparameters,
      // );

      // print('STATUS CODE: ${response.statusCode}');
      // if (response.statusCode == 200) {
      //   print(response.data);
      //   return response.data;
      // } else {
      //   print('failed to fetch data');
      // }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
      print(e.error);
    }
  }

  Future<List<dynamic>> getApproverList() async {
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
