import 'package:dio/dio.dart';

import '../../../model/pengajuan_pembatalan/izin_3_jam_model/list_izin_3_jam_model.dart';
import '../../dio_clients.dart';

class Izin3JamListService {
  DioClients dio;
  Izin3JamListService(this.dio);

  Future<List<ListIzin3JamModel>> fetchIzin3Jam({
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
        'ijin_3_jam/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => ListIzin3JamModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
