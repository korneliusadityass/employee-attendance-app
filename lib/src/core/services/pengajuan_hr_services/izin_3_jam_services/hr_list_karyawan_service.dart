import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/hr_pengajuan_pembatalan/cuti_khusus/hr_list_karyawan_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../helper/auth_pref_helper.dart';

class ListKaryawanService {
  final url = 'http://192.168.2.155:8000/user/hr/list';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future listKaryawan({
    required String? filterNama,
  }) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };

      // final queryparameters = {
      //   if (filterNama != null) 'filter_nama': filterNama,
      // };

      // final response = await dio.get(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: queryparameters,
      // );

      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   return response.data;
      // } else {
      //   print('failed to fetch data');
      //   return [];
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
      return [];
    }
  }
}

class HrListKaryawanService {
  DioClients dio;
  HrListKaryawanService(this.dio);

  Future<List<HrListKaryawanModel>> listKaryawan({
    required String? filterNama,
  }) async {
    try {
      final response = await dio.dio.get(
        '/user/hr/list',
        queryParameters: {
          'filter_nama': filterNama,
        },
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result
            .map((data) => HrListKaryawanModel.fromJson(data))
            .toList();
      } else {
        throw Exception('error');
      }
    } catch (e) {
      return [];
    }
  }
}
