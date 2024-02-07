import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class HrApprovedIzin3JamService {
  DioClients dio;
  HrApprovedIzin3JamService(this.dio);

  Future<Either<Failure, bool>> hrApprovedIzin3Jam(int id) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_3_jam/approver/approved',
        queryParameters: {
          'id_ijin': id,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal menerima";
      return Left(ApprovedIzin3JamFailure(errorMessage));
    }
  }
}
