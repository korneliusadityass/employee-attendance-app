import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../colors/color.dart';
import '../../../helper/auth_pref_helper.dart';

class IzinSakitCancelledHRServices {
  final url = 'http://192.168.2.155:8000/ijin_sakit/hr/cancelled';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future izinSakitCancelledHR(int id, BuildContext context) async {
    try {} on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class CancelledIzinSakitHrServices {
  DioClients dio;
  CancelledIzinSakitHrServices(this.dio);

  Future<Either<Failure, bool>> cancelIzinSAkitHr(int id) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_sakit/hr/cancelled',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('service status code: ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal cancel";
      return Left(CancelledIzinSakitHrFailure(errorMessage));
    }
  }
}
