import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/error/failure.dart';

import '../../../helper/auth_pref_helper.dart';
import '../../dio_clients.dart';

class DeleteIzinSakitServicesHR {
  final url = 'http://192.168.2.155:8000/ijin_sakit/hr/delete';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future deleteIzinSakitHR(int id, BuildContext context) async {
    try {} on DioError catch (e) {
      print('Data gagal dihapus');
      print(e.response);
      print(e.error);
      print(e.message);
    }
  }
}

class DeleteIzinSakitHrServices {
  DioClients dio;
  DeleteIzinSakitHrServices(this.dio);

  Future<Either<Failure, bool>> deleteIzinSakitHr(int id) async {
    try {
      final response = await dio.dio.delete(
        '/ijin_sakit/hr/delete',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('service status code: ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteIzinSakitHrFailure(errorMessage));
    }
  }
}
