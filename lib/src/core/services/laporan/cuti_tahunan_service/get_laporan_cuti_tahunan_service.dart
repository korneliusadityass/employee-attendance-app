import 'package:dio/dio.dart';
import 'package:project/src/core/model/laporan/cuti_tahunan/list_laporan_cuti_tahunan_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

class GetLaporanCutiTahunanService {
  DioClients dio;
  GetLaporanCutiTahunanService(this.dio);

  Future<List<ListLaporanCutiTahunanModel>> fetchLaporanCutitahunan(
    int id, {
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'id_perusahaan': id,
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (filterNama != null) 'filter_nama': filterNama,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        '/laporan/cuti_tahunan',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result
            .map((data) => ListLaporanCutiTahunanModel.fromJson(data))
            .toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
