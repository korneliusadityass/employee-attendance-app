import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../error/failure.dart';

class HrCutiTahunanInputServices {
  DioClients dio;
  HrCutiTahunanInputServices(this.dio);

  Future<Either<Failure, int>> hrCutiTahunanServices(
    int id,
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final response = await dio.dio.post(
        '/cuti_tahunan/hr/input',
        queryParameters: {
          'id_karyawan': id,
        },
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal input";
      return Left(PengajuanHRCutiTahunanFailure(errorMessage));
    }
  }
}
