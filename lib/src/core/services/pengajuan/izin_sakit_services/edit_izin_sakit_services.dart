import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../helper/auth_pref_helper.dart';

class EditizinSakitServices {
  final url = 'http://192.168.2.155:8000/ijin_sakit/update';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future editIzinSakit(int id, String judul, String tanggalAwal,
      String tanggalAkhir, BuildContext context) async {
    try {
      // final tokenRespons = await AuthStorageHelper().getToken() ?? '';
      // final tokenJson = jsonDecode(tokenRespons);
      // final token = tokenJson['access_token'];
      // final headerss = {
      //   "Authorization": 'Bearer $token',
      // };
      // final response = await dio.post(
      //   url,
      //   options: Options(
      //     headers: headerss,
      //   ),
      //   data: {
      //     'judul': judul,
      //     'tanggal_awal': tanggalAwal,
      //     'tanggal_akhir': tanggalAkhir,
      //   },
      // );

      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('Sukses');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class EditizinSakitServicess {
  DioClients dio;
  EditizinSakitServicess(this.dio);

  Future<Either<Failure, bool>> editIzinSakitt(
      int id, String judul, String tanggalAwal, String tanggalAkhir) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_sakit/update',
        queryParameters: {
          'id_ijin': id,
        },
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );
      print('Edit status code : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal edit";
      return Left(EditIzinSakitFailure(errorMessage));
    }
  }
}
