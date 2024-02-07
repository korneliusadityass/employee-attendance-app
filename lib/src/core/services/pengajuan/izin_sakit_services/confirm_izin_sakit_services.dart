import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../helper/auth_pref_helper.dart';

class IzinSakitConfirmServices {
  final url = 'http://192.168.2.155:8000/ijin_sakit/confirm';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future izinsakitconfirm(int id) async {
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
      //   print('sukses');
      // } else {
      //   print('gagal');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class ConfirmIzinSakitServices {
  DioClients dio;
  ConfirmIzinSakitServices(this.dio);

  Future<Either<Failure, bool>> confirmIzinSakit(int id) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_sakit/confirm',
        queryParameters: {
          'id_ijin': id,
        },
      );

      print('status service code ${response.statusCode}');
      return Right(response.data);
      // if (response.statusCode == 200) {
      //   print('Success confirm');
      // } else {
      //   throw Exception('gagal load data');
      // }
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? " gagal confirm";
      return Left(ConfirmIzinSakitFailure(errorMessage));
      // throw Exception(e.message);
    }
  }
}
