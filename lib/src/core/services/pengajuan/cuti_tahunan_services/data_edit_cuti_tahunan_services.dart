import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../helper/auth_pref_helper.dart';
import '../../../model/cuti_tahunan-model/detail_pengajuan_cuti_tahunan_model.dart';
import '../../dio_clients.dart';

class DataEditCutiTahunanServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/data_by_id';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future<Map<String, dynamic>> dataEditCutiTahunan(int id) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {"Authorization": 'Bearer $token'};
      // final response = await dio.get(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {
      //     'id_ijin': id,
      //   },
      // );
      // final Map<String, dynamic> responseMap = response.data;
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('sukses');
      //   print(responseMap);
      //   return responseMap;
      // } else {
      //   print('failed');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    throw Exception('failed to fetch data');
  }
}

class DetailDataCutiTahunanServicess {
  DioClients dio;
  DetailDataCutiTahunanServicess(this.dio);

  Future<DetailPengajuanCutiTahunanModel> fetchDataCutiTahunan(int id) async {
    try {
      final response = await dio.dio.get(
        '/cuti_tahunan/data_by_id',
        queryParameters: {
          'id_ijin': id,
        },
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return DetailPengajuanCutiTahunanModel.fromJson(result);
      } else {
        throw Exception('gagal fetch data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  } 
}
