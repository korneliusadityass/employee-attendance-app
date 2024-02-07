import 'dart:async';

import 'package:dio/dio.dart';
import 'package:project/src/core/model/master/karyawan/masterkaryawandetail_model.dart';

import '../../../dio_clients.dart';
  

class MasterKaryawanDetailService {
  DioClients dio;
  MasterKaryawanDetailService(this.dio);

  Future<MasterKaryawanDetailModel> fetchMasterKaryawanDetail(int id) async {
    try {
      final queryParameters = {
        'id': id,
      };

      final response = await dio.dio.get(
        'user/data',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return MasterKaryawanDetailModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
