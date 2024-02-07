import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class DeleteIzin3JamService {
  DioClients dio;
  DeleteIzin3JamService(this.dio);

  Future<Either<Failure, bool>> deleteIzin3Jam(int id) async {
    try {
      final response = await dio.dio.delete(
        '/ijin_3_jam/delete',
        queryParameters: {
          'id_ijin': id,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteIzin3JamFailure(errorMessage));
    }
  }
}
