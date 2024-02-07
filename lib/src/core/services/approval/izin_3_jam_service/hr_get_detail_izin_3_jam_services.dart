import 'dart:async';

import 'package:dio/dio.dart';
import 'package:project/src/core/model/approval/izin_3_jam/data_need_confirm_izin_3_jam_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

class HrDataIzin3JamService {
  DioClients dio;
  HrDataIzin3JamService(this.dio);

  Future<DataNeedConfirmIzin3JamModel> fetchDataIzin3Jam(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        '/ijin_3_jam/hr/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return DataNeedConfirmIzin3JamModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
