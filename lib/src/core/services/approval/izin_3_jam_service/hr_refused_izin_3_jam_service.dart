import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class HrRefusedIzin3JamService {
  DioClients dio;
  HrRefusedIzin3JamService(this.dio);

  Future<Either<Failure, bool>> hrRefusedIzin3Jam(int id) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_3_jam/approver/refused',
        queryParameters: {
          'id_ijin': id,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal menolak";
      return Left(RefusedIzin3JamFailure(errorMessage));
    }
  }
}
