import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../dio_clients.dart';

class MasterCompanyEditService {
  DioClients dio;
  MasterCompanyEditService(this.dio);

  Future<void> masterCompanyEdit(int id, String nama) async {
    try {
      final response = await dio.dio.patch(
        'perusahaan/ubah_nama',
        queryParameters: {
          'id_perusahaan': id,
          'nama': nama,
        },
      );

      debugPrint(response.statusMessage);
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
