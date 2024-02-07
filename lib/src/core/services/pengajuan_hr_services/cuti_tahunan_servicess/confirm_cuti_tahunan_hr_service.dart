import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../error/failure.dart';
import '../../dio_clients.dart';

class ConfirmCutiTahunanHrService {
  DioClients dio;
  ConfirmCutiTahunanHrService(this.dio);
  Future<Either<Failure, bool>> confirmCutiTahunanHr(int id) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_tahunan/hr/confirm',
        queryParameters: {
          'id_ijin': id,
        },
      );
      print('status code ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal confirm";
      return Left(ConfirmCutiTahunanHrFailure(errorMessage));
    }
  }
}
