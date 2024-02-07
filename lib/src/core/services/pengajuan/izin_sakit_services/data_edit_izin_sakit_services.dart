import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_sakit_model/detail_pengajuan_izin_sakit_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../helper/auth_pref_helper.dart';

class DataEditIzinSakitService {
  final url = 'http://192.168.2.155:8000/ijin_sakit/data_by_id';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  FutureOr<Map<String, dynamic>> dataEditIzinSakit(int id) async {
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

      // final Map<String, dynamic> responseMap = response.data;

      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('Succes!!!');
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

class DetailDataIzinSakitServices {
  DioClients dio;
  DetailDataIzinSakitServices(this.dio);

  Future<DetailPengajuanIzinSakitModel> fetchDataIzinSakit(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        '/ijin_sakit/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return DetailPengajuanIzinSakitModel.fromJson(result);
      } else {
        throw Exception('gagal fetch data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
