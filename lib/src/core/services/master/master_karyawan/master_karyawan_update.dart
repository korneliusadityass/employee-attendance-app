import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../helper/auth_pref_helper.dart';

class EditKaryawanService {
  final url = 'http://192.168.2.155:8000/user/hr/update_karyawan';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future editKaryawan(
    int id,
    int perusahaanId,
    String namakaryawan,
    String tempatlahir,
    String tanggallahir,
    String alamat,
    String nohp,
    String email,
    String password,
    String level,
    String posisi,
  ) async {
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
          'id_karyawan': id,
          'password': password,
        },
        data: {
          'perusahaan_id': perusahaanId,
          'nama_karyawan': namakaryawan,
          'tempat_lahir': tempatlahir,
          'tanggal_lahir': tanggallahir,
          'alamat': alamat,
          'no_hp': nohp,
          'email': email,
          'level': level,
          'posisi': posisi,
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
