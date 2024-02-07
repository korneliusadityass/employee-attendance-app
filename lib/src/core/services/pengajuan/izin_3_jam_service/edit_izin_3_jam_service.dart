import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class EditIzin3JamService {
  DioClients dio;
  EditIzin3JamService(this.dio);
  Future<Either<Failure, bool>> editIzin3Jam(int id, String judul,
      String tanggal, String waktuAwal, String waktuAkhir) async {
    try {
      final response = await dio.dio.patch(
        '/ijin_3_jam/update',
        queryParameters: {
          'id_ijin': id,
        },
        data: {
          'judul': judul,
          'tanggal_ijin': tanggal,
          'waktu_awal': waktuAwal,
          'waktu_akhir': waktuAkhir,
        },
      );
      return right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(EditIzin3JamFailure(errorMessage));
    }
  }
}
