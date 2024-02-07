import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/list_master_jumlah_cuti_tahunan_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

class MasterJumlahCutiTahunanListServices {
  DioClients dio;
  MasterJumlahCutiTahunanListServices(this.dio);

  Future<List<MasterJumlahCutiTahunanModel>>
      fetchMasterJumlahCutiTahunanListServices({
    int page = 1,
    int size = 20,
    String order = '',
    String sortBy = '',
    int tahun = 0,
    String nama = '',
    bool searchPerusahaan = false,
  }) async {
    try {
      debugPrint('service search : $searchPerusahaan');
      final queryParameters = {
        'page': page,
        'size': size,
        'order': order,
        'tahun': tahun,
        'sort_by': sortBy,
        'nama': nama,
        'search_perusahaan': searchPerusahaan,
      };

      final response = await dio.dio.get(
        'master_cuti_tahunan/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        inspect(response.data);
        List result = response.data;
        return result
            .map((data) => MasterJumlahCutiTahunanModel.fromJson(data))
            .toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
