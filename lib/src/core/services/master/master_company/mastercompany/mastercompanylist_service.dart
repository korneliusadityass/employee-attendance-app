
import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../../model/master/company/mastercompanylist_model.dart';

class MasterCompanyListService {
  DioClients dio;
  MasterCompanyListService (this.dio);

  Future<List<MasterCompanyListModel>> fetchListPerusahaanModel({
    int page = 1,
    int size = 10,
    required String? filterNama,
    String order = 'asc',
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        if (filterNama != null) 'filter_nama': filterNama,
        'order': order,
      };

      final response = await dio.dio.get(
        'perusahaan/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => MasterCompanyListModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }


}
