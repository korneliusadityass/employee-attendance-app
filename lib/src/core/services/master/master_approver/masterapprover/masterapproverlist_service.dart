import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../../model/master/approver/masterapproverlist_model.dart';

class MasterApproverListService {
  DioClients dio;
  MasterApproverListService(this.dio);

  Future<List<MasterApproverListModel>> fetchApproverHRList({
    int page = 1,
    int size = 10,
    int id = 0,
    required String? filterNama,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        'id': id,
        if (filterNama != null) 'filter_nama': filterNama,
      };

      final response = await dio.dio.get(
        'approver/hr/listing',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => MasterApproverListModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
