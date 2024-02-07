import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../error/failure.dart';
import '../../../helper/auth_pref_helper.dart';
import '../../dio_clients.dart';

int idCutiTahunan = 0;

class CutiTahunanInputServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/input';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future cutiTahunanInput(String judul, String tanggalAwal, String tanggalAkhir,
      BuildContext context) async {
    try {} on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class InputCutiTahunanServices {
  DioClients dio;
  InputCutiTahunanServices(this.dio);

  Future<Either<Failure, int>> inputCutitahuananServices(
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final response = await dio.dio.post(
        '/cuti_tahunan/input',
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );
      final result = response.data;
      return Right(result);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal mengirim";
      return Left(PengajuanCutiTahunanFailure(errorMessage));
    }
  }
}
