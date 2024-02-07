import 'package:dio/dio.dart';

import '../../../model/pengajuan_pembatalan/izin_sakit_model/izin_sakit_model.dart';
import '../../dio_clients.dart';

class IzinSakitListServices {
  DioClients dio;
  IzinSakitListServices(this.dio);

  Future<List<IzinSakitModel>> fetchIzinsakit({
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
        'ijin_sakit/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => IzinSakitModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
