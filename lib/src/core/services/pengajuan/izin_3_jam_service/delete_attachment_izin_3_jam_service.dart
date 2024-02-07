import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class DeleteAttachmentIzin3JamService2 {
  DioClients dio;
  DeleteAttachmentIzin3JamService2(this.dio);

  Future<Either<Failure, bool>> deleteAttachmentIzin3Jam(
    int idIjin,
    int idAttachment,
  ) async {
    try {
      final response = await dio.dio.delete(
        '/ijin_3_jam/delete_attachment',
        queryParameters: {
          'id_ijin': idIjin,
          'hapus_id': idAttachment,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(DeleteIzin3JamFailure(errorMessage));
    }
  }
}
