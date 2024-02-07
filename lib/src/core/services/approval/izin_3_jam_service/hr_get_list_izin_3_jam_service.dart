import 'package:dio/dio.dart';
import 'package:project/src/core/model/approval/izin_3_jam/list_approval_izin_3_jam_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

class HrIzin3JamListService2 {
  DioClients dio;
  HrIzin3JamListService2(this.dio);

  Future<List<ListApprovalIzin3JamModel>> fetchIzin3Jam({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (filterNama != null) 'filter_nama': filterNama,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        '/ijin_3_jam/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result
            .map((data) => ListApprovalIzin3JamModel.fromJson(data))
            .toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
