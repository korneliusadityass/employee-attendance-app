import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../error/failure.dart';
import '../../dio_clients.dart';

class PengajuanIzin3JamService {
  DioClients dio;
  PengajuanIzin3JamService(this.dio);

  Future<Either<Failure, int>> pengajuanIzin3Jam(
    String judul,
    String tanggalIjin,
    String waktuAwal,
    String waktuAkhir,
  ) async {
    try {
      final response = await dio.dio.post(
        '/ijin_3_jam/input',
        data: {
          'judul': judul,
          'tanggal_ijin': tanggalIjin,
          'waktu_awal': waktuAwal,
          'waktu_akhir': waktuAkhir,
        },
      );
      final result = response.data;
      return Right(result);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal mengirim";
      return Left(PengajuanIzin3JamFailure(errorMessage));
    }
  }
}
