import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../error/failure.dart';

class EditCutiTahunanHrServices {
  DioClients dio;
  EditCutiTahunanHrServices(this.dio);

  Future<Either<Failure, bool>> editIzinSakitt(
      int id, String judul, String tanggalAwal, String tanggalAkhir) async {
    try {
      final response = await dio.dio.patch(
        '/cuti_tahunan/hr/update',
        queryParameters: {
          'id_ijin': id,
        },
        data: {
          'judul': judul,
          'tanggal_awal': tanggalAwal,
          'tanggal_akhir': tanggalAkhir,
        },
      );
      print('Edit status code : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal edit";
      return Left(EditCutiTahunanHrFailure(errorMessage));
    }
  }
}
