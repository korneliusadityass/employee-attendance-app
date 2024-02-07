import 'package:dio/dio.dart';

import '../../../model/hr_pengajuan_pembatalan/cuti_tahunan/cuti_tahunan_model_hr.dart';
import '../../dio_clients.dart';

class CutiTahunanHrListServices {
  DioClients dio;
  CutiTahunanHrListServices(this.dio);

  Future<List<CutiTahunanHrModel>> fetchCutiTahunan({
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
        '/cuti_tahunan/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => CutiTahunanHrModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
