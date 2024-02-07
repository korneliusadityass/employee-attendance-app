import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class InputAttachmentIzinSakitHrServices {
  DioClients dio;
  InputAttachmentIzinSakitHrServices(this.dio);

  Future inputAttachmentIzinSakitHr(int id, List<File> files) async {
    try {
      List<MultipartFile> multipartFiles = [];
      for (int i = 0; i < files.length; i++) {
        String fileName = files[i].path.split('/').last;
        multipartFiles.add(
          await MultipartFile.fromFile(files[i].path, filename: fileName),
        );
      }

      FormData formData = FormData.fromMap({
        'id_ijin': id,
        "input_baru": multipartFiles,
      });

      final response = await dio.dio.post(
        '/ijin_sakit/input_attachment',
        queryParameters: {
          'id_ijin': id,
        },
        data: formData,
      );

      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal input";
      return Left(InputAttachmentizinSakitHrFailure(errorMessage));
    }
  }
}
