import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../error/failure.dart';

class MasterJumlahCutiTahunanEditServices {
  DioClients dio;
  MasterJumlahCutiTahunanEditServices(this.dio);

  // Future<bool> fetchMasterJumlahCutiTahunanEditServices({
  //   required int id,
  //   required int kuota,
  // }) async {
  //   try {
  //     final queryParameters = {
  //       'id': id,
  //       'kuota': kuota,
  //     };

  //     final response = await dio.dio.post(
  //       '/master_cuti_tahunan/hr/edit',
  //       queryParameters: queryParameters,
  //     );
  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else {
  //       throw Exception('gagal load data');
  //     }
  //   } on DioError catch (e) {
  //     print(e.response);
  //     throw Exception(e.message);
  //   }
  // }
  Future<Either<Failure, bool>> fetchMasterJumlahCutiTahunanEditServices(
      int id, int kuota) async {
    try {
      final response = await dio.dio.patch(
        'master_cuti_tahunan/hr/edit',
        queryParameters: {
          'id': id,
          'kuota': kuota,
        },
      );
      return Right(response.data);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? 'gagal edit';
      return Left(EditCutiTahunanHrFailure(errorMessage));
    }
  }
}
