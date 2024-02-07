import 'package:dio/dio.dart';
import 'package:project/src/core/model/laporan/list_perusahaan_model/list_perusahaan_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

class GetPerusahaanLaporanService {
  DioClients dio;
  GetPerusahaanLaporanService(this.dio);

  Future<List<ListPerusahaanModel>> fetchListPerusahaan({
    int page = 1,
    int size = 25,
    String? filterNama,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        if (filterNama != null) 'filter_nama': filterNama,
      };

      final response = await dio.dio.get(
        '/perusahaan/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result
            .map((data) => ListPerusahaanModel.fromJson(data))
            .toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
