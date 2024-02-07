import 'dart:async';

import 'package:dio/dio.dart';

import '../../../model/pengajuan_pembatalan/izin_3_jam_model/data_pengajuan_izin_3_jam_model.dart';
import '../../dio_clients.dart';

class DataIzin3JamService {
  DioClients dio;
  DataIzin3JamService(this.dio);

  Future<DataPengajuanIzin3JamModel> fetchDataIzin3Jam(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };

      final response = await dio.dio.get(
        '/ijin_3_jam/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return DataPengajuanIzin3JamModel.fromJson(result);
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
