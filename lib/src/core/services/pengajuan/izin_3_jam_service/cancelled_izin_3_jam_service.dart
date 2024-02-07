import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class CancelledIzin3JamService {
  DioClients dio;
  CancelledIzin3JamService(this.dio);

  Future<Either<Failure, bool>> cancelledIzin3Jam(int id) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_3_jam/cancelled',
        queryParameters: {
          'id_ijin': id,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal cancel";
      return Left(CancelIzin3JamFailure(errorMessage));
    }
  }
}
