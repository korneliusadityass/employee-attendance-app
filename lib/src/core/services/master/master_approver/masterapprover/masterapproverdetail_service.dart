import 'dart:async';

import 'package:dio/dio.dart';
import 'package:project/src/core/model/master/approver/masterapproverdetail_model.dart';

import '../../../dio_clients.dart';
  

class MasterApproverDetailService {
  DioClients dio;
  MasterApproverDetailService(this.dio);

  Future<MasterApproverDetailModel> fetchMasterApproverDetail(int id) async {
    try {
      final queryParameters = {
        'id': id,
      };

      final response = await dio.dio.get(
        'approver/hr/get_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return MasterApproverDetailModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
