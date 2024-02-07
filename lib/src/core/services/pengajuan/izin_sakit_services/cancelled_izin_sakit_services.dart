import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../error/failure.dart';

class CancelledIzinSakitServices {
  DioClients dio;
  CancelledIzinSakitServices(this.dio);

  Future<Either<Failure, bool>> cancelIzinSakit(int id) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_sakit/cancelled/',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('service status code: ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? " gagal cancel";
      return Left(CancelledIzinSakitFailure(errorMessage));
    }
  }
}
