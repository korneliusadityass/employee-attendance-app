import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../error/failure.dart';
import '../../dio_clients.dart';

class DeleteAttachmentCutiTahunanHrServicess {
  DioClients dio;
  DeleteAttachmentCutiTahunanHrServicess(this.dio);

  Future<Either<Failure, bool>> deleteAttachmentCutiTahunanHr(
    int idIzin,
    int idAttachment,
  ) async {
    try {
      final response = await dio.dio.delete(
        '/cuti_tahunan/hr/delete_attachment',
        queryParameters: {
          'id_ijin': idIzin,
          'hapus_id': idAttachment,
        },
      );
      print('status code delete attach: ${response.statusCode}');
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteattachmentCutiTahunanHrFailure(errorMessage));
    }
  }
}