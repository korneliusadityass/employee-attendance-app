import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../error/failure.dart';
import '../../dio_clients.dart';

class IzinSakitInputServices {
  DioClients dio;
  IzinSakitInputServices(this.dio);

  Future<Either<Failure, int>> izinSakitInputServices(
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final response = await dio.dio.post(
        'ijin_sakit/input',
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );
      final result = response.data;
      return Right(result);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal mengirim";
      return Left(PengajuanIzinSakitFailure(errorMessage));
    }
  }
}
