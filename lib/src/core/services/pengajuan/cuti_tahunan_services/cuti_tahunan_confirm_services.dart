import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../error/failure.dart';
import '../../../helper/auth_pref_helper.dart';
import '../../dio_clients.dart';

class CutiTahunanConfirmServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/confirm';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future cutiTahunanConfirm(int id) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };
      // final response = await dio.patch(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {'id_ijin': id},
      //   data: {
      //     'id_ijin': id,
      //   },
      // );
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('success');
      // } else {
      //   print('failed');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class ConfirmCutiTahunanServices {
  DioClients dio;
  ConfirmCutiTahunanServices(this.dio);

  Future<Either<Failure, bool>> confirmCutiTahunan(int id) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_tahunan/confirm',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('status service code ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal confirm";
      return Left(ConfirmCutiTahunanFailure(errorMessage));
    }
  }
}
