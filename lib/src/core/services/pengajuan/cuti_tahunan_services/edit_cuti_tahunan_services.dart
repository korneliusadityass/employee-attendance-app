import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../error/failure.dart';
import '../../../helper/auth_pref_helper.dart';

class CutiTahunanEditServices {
  final url = 'http://192.168.2.155:8000/ijin_sakit/update';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future cutiTahunanEdit(int id, String judul, String tanggalAwal,
      String tanggalAkhir, BuildContext context) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {"Authorization": 'Bearer $token'};
      // final response = await dio.patch(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {
      //     'id_ijin': id,
      //   },
      //   data: {
      //     'judul': judul,
      //     'tanggal_awal': tanggalAwal,
      //     'tanggal_akhir': tanggalAkhir,
      //   },
      // );

      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('success');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class EditCutiTahunanServicess {
  DioClients dio;
  EditCutiTahunanServicess(this.dio);

  Future<Either<Failure, bool>> editCutiTahunann(
    int id,
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_tahunan/update',
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
      return Left(EditCutiTahunanFailure(errorMessage));
    }
  }
}
