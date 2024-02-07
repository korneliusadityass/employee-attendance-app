import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project/src/core/services/dio_clients.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/izin_sakit_input_services.dart';

import '../../../error/failure.dart';
import '../../../helper/auth_pref_helper.dart';

class DeleteAttachmentIzinSakit {
  final url = 'http://192.168.2.155:8000/ijin_sakit/delete_attachment';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future deleteAttachmentIzinSakit(int id, int attachmentId) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };

      // final response = await dio.delete(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {
      //     'id_ijin': id,
      //     'hapus_id': attachmentId,
      //   },
      // );
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('sukses hapus');
      // } else {
      //   print('gagal hapus');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class DeleteAttachmentIzinSakitServicess {
  DioClients dio;
  DeleteAttachmentIzinSakitServicess(this.dio);

  Future<Either<Failure, bool>> deleteAttachmentIzinSakitt(
      int idIzin, int idAttachment) async {
    try {
      final response = await dio.dio.delete(
        '/ijin_sakit/delete_attachment',
        queryParameters: {
          'id_ijin': idIzin,
          'hapus_id': idAttachment,
        },
      );
      print('status code delete attach: ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteIzinSakitFailure(errorMessage));
    }
  }
}
