import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../error/failure.dart';
import '../../dio_clients.dart';

class DeleteCutiTahunanHrService {
  DioClients dio;
  DeleteCutiTahunanHrService(this.dio);

  Future<Either<Failure, bool>> deleteCutiTahunanHr(int id) async {
    try {
      final response = await dio.dio.delete(
        '/cuti_tahunan/hr/delete',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('ini service status code: ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? " gagal delete";
      return Left(DeleteCutiTahunanHrFailure(errorMessage));
    }
  }
}
