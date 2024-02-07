import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../error/failure.dart';
import '../../dio_clients.dart';

class HrIzinSakitInputServices {
  DioClients dio;
  HrIzinSakitInputServices(this.dio);

  Future<Either<Failure, int>> hrIzinSakitInputServices(
    int id,
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final response = await dio.dio.post(
        '/ijin_sakit/hr/input',
        queryParameters: {
          'id_karyawan': id,
        },
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );
      final result = response.data;
      return Right(result);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal input";
      return Left(PengajuanHRIzinSakitFailure(errorMessage));
    }
  }
}
