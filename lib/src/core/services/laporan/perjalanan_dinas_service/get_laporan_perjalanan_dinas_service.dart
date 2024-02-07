import 'package:dio/dio.dart';
import 'package:project/src/core/model/laporan/perjalanan_dinas/list_laporan_perjalanan_dinas_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

class GetLaporanPerjalananDinasService {
  DioClients dio;
  GetLaporanPerjalananDinasService(this.dio);

  Future<List<ListLaporanPerjalananDinasModel>> fetchLaporanPerjalananDinas(
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
        '/laporan/perjalanan_dinas',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result
            .map((data) => ListLaporanPerjalananDinasModel.fromJson(data))
            .toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
