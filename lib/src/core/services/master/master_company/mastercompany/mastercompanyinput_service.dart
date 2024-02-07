
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

int idPerusahaan = 0;

class MasterCompanyInputService{
  DioClients dio;
  MasterCompanyInputService(this.dio);

  Future<Either<Failure, int>> masterCompanyInput(
    String namaperusahaan,
  ) async {
    try {
      final response = await dio.dio.post(
        'perusahaan/input',
        queryParameters: {
          'nama': namaperusahaan,
        },
      );
     final result = response.data;
      return Right(result);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal mengirim";
      return Left(MasterCompanyInputFailure(errorMessage));
    }
  }
}