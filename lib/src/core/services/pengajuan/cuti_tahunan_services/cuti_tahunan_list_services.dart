import 'package:dio/dio.dart';

import '../../../model/cuti_tahunan-model/cuti_tahunan_model.dart';
import '../../dio_clients.dart';

class CutiTahunanListServices {
  DioClients dio;
  CutiTahunanListServices(this.dio);

  Future<List<CutitahunanModel>> fetchCutiTahunan({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        '/cuti_tahunan/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => CutitahunanModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
