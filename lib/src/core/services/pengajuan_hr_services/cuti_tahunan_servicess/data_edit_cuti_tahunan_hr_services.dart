import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../model/hr_pengajuan_pembatalan/cuti_tahunan/detail_cuti_tahunan_model_hr.dart';
import '../../dio_clients.dart';

class DetailDataCutiTahunanHrServices {
  DioClients dio;
  DetailDataCutiTahunanHrServices(this.dio);

  Future<DetailPengajuanCutiTahunanHrModel> fetchDataCutiTahunanHr(int id) async {
    try {
      final queryParameters = {
        'id_ijin': id,
      };
      final response = await dio.dio.get(
        '/cuti_tahunan/hr/data_by_id',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return DetailPengajuanCutiTahunanHrModel.fromJson(result);
      } else {
        throw Exception('gagal fetch data');
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
      print(e.error);
      throw Exception(e.message);
    }
  }

  //download attachment

  Future cutiTahunanDownload(
      int idFile, String fileName, Function(int) onProgressUpdate) async {
    try {
      final directory = await getExternalStorageDirectory();
      var savePath = "${directory!.path}/$fileName";
      final status = await Permission.storage.request();

      if (status.isGranted) {
        debugPrint('keterima');
        Directory generalDownloadDir =
            Directory('/storage/emulated/0/Download');
        savePath = '${generalDownloadDir.path}/$fileName';
      } else if (status.isDenied) {
        debugPrint('ketolak');
        return null;
      } else if (status.isPermanentlyDenied) {
        debugPrint('permanent di tolak');
      }
      final response = await dio.dio.download(
        '/cuti_tahunan/get_attachment/$idFile',
        savePath,
        queryParameters: {
          'id_file': idFile,
        },
        options: Options(
          responseType: ResponseType.bytes,
        ),
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            onProgressUpdate((receivedBytes / totalBytes * 100).toInt());
          }
        },
      );
      debugPrint('SERVICE STATUS CODE : ${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint('SUKSES DOWNLOAD');
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
  }
}
