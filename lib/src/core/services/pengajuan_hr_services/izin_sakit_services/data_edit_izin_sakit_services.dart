import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../helper/auth_pref_helper.dart';
import '../../../model/pengajuan_pembatalan/izin_sakit_model/detail_pengajuan_izin_sakit_model.dart';

class DataEditIzinSakitHRService {
  final url = 'http://192.168.2.155:8000/ijin_sakit/hr/data_by_id';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  FutureOr<Map<String, dynamic>> dataEditIzinSakitHR(int id) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headerss = {"Authorization": 'Bearer $token'};
      // final response = await dio.get(url,
      //     options: Options(
      //       headers: headerss,
      //     ),
      //     queryParameters: {
      //       'id_ijin': id,
      //     });
      // final Map<String, dynamic> responseMap = response.data;

      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('sukseesss');
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
    throw Exception('Failed to fetch data');
  }
}

class DetailDataIzinSakitHrServices {
  DioClients dio;
  DetailDataIzinSakitHrServices(this.dio);

  Future<DetailPengajuanIzinSakitModel> fetchDataIzinSakitHr(int id) async {
    try {
      final response = await dio.dio.get(
        '/ijin_sakit/hr/data_by_id',
        queryParameters: {
          'id_ijin': id,
        },
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
