import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../error/failure.dart';

class MasterJumlahCutiTahunanGenerateServices {
  DioClients dio;
  MasterJumlahCutiTahunanGenerateServices(this.dio);

  Future<Either<Failure, bool>> fetchMasterJumlahCutiTahunanGenerateServices({
    required int kuota_cuti_tahunan,
    required int tahun,
  }) async {
    try {
      final queryParameters = {
        'kuota_cuti_tahunan': kuota_cuti_tahunan,
        'tahun': tahun,
      };

      final response = await dio.dio.post(
        'master_cuti_tahunan/input',
        data: queryParameters,
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? 'gagal edit';
      return Left(EditCutiTahunanHrFailure(errorMessage));
    }
  }
}
