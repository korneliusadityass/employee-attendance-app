import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/hr_pengajuan_pembatalan/izin_3_jam/data_hr_detail_izin_3_jam_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../helper/auth_pref_helper.dart';

class DataEditIzin3JamHRService {
  final url = 'http://192.168.2.155:8000/ijin_3_jam/hr/data_by_id';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  FutureOr<Map<String, dynamic>> dataEditIzin3JamHR(
      int id, BuildContext context) async {
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
      //     'id_ijin': id,
      //   },
      // );

      // print('status code EDIT : ${response.statusCode}');
      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> responseMap = response.data;
      //   print('sukses ngab');
      //   return responseMap;
      // } else {
      //   print('gagal ngab');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    throw Exception('Failed to fetch data');
  }
}

class HrDataDetailIzin3JamService {
  DioClients dio;
  HrDataDetailIzin3JamService(this.dio);

  Future<HrDataDetailIzin3JamModel> fetchDataIzin3Jam(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        '/ijin_3_jam/hr/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return HrDataDetailIzin3JamModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
