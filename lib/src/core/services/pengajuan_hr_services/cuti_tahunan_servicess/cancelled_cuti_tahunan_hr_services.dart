import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class CancelCutiTahunanHrService {
  DioClients dio;
  CancelCutiTahunanHrService(this.dio);

  Future<Either<Failure, bool>> cancelCutiTahunanHr(int id) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_tahunan/hr/cancelled',
        queryParameters: {
          'id_ijin': id,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal cancel";
      return Left(CancelledCutiTahunanHrFailure(errorMessage));
    }
  }
}
