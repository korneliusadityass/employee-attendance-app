import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

class MasterCompanyDeleteService {
  DioClients dio;
  MasterCompanyDeleteService(this.dio);

Future<Either<Failure, bool>> masterCompanydelete(int id) async {
    try {
      final response =
          await dio.dio.delete('perusahaan/delete', queryParameters: {
        'id_perusahaan': id,
      });
      print('Service status code: ${response.statusCode}');
      return Right(response.data);
      // if (response.statusCode == 200) {
      //   print('delete success');
      // } else {
      //   throw Exception('gagal load data');
      // }
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal delete";
      return Left(MasterCompanyDeleteFailure(errorMessage));
      // throw Exception(e.message);
    }
  }
}