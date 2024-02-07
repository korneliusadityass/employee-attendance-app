import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../../model/master/karyawan/masterkaryawanlist_model.dart';

class MasterKaryawanListService {
  DioClients dio;
  MasterKaryawanListService (this.dio);

  Future<List<MasterKaryawanListModel>> fetchListKaryawan({
    int page = 1,
    int size = 10,
    String order = 'asc',
    int perusahaanId = 0,
    required String? filterNama,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        'order': order,
        'perusahaan_id': perusahaanId,
        if (filterNama != null) 'filter_nama': filterNama,
      };

      final response = await dio.dio.get(
        'user/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => MasterKaryawanListModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
