import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../error/failure.dart';
import '../../../helper/auth_pref_helper.dart';
import '../../dio_clients.dart';

class DeleteAttachmentCutiTahunanServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/delete_attachment';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future deleteAttachmentCutiTahunan(int id, int attachmentId) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {"Authorization": 'Bearer $token'};
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

class DeleteAttachmentCutiTahunanServicess {
  DioClients dio;
  DeleteAttachmentCutiTahunanServicess(this.dio);

  Future<Either<Failure, bool>> deleteAttachmentCutiTahunan(
      int idCuti, int idAttachment) async {
    try {
      final response = await dio.dio.delete(
        '/cuti_tahunan/delete_attachment',
        queryParameters: {
          'id_ijin': idCuti,
          'hapus_id': idAttachment,
        },
      );
      print('statuss code delete attach : ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteCutiTahunanFailure(errorMessage));
    }
  }
}
