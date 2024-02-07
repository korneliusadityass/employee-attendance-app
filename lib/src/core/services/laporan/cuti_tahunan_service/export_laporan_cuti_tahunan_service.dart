import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/model/laporan/cuti_tahunan/list_laporan_cuti_tahunan_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

class ExportLaporanCutiTahunanService {
  DioClients dio;
  ExportLaporanCutiTahunanService(this.dio);

  Future<Either<Failure, List<ListLaporanCutiTahunanModel>>>
      exportLaporanCutiTahunan(
    int id, {
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'id_perusahaan': id,
        'filter_status': filterStatus,
        if (filterNama != null) 'filter_nama': filterNama,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        '/laporan/cuti_tahunan/export',
        queryParameters: queryParameters,
      );
      List result = response.data;

      return right(
        result
            .map((data) => ListLaporanCutiTahunanModel.fromJson(data))
            .toList(),
      );
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal confirm";
      return Left(ConfirmIzin3JamFailure(errorMessage));
    }
  }
}
