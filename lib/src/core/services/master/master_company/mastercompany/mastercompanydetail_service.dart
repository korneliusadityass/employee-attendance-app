import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../model/master/company/mastercompanydetail_model.dart';
import '../../../dio_clients.dart';
  

class MasterCompanyDetailService {
  DioClients dio;
  MasterCompanyDetailService(this.dio);

  Future<MasterCompanyDetailModel> fetchMasterCompanyDetail(int id) async {
    try {
      final queryParameters = {
        'id': id,
      };

      final response = await dio.dio.get(
        'perusahaan/data',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return MasterCompanyDetailModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
