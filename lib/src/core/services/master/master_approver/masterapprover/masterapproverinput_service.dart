import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

class MasterApproverInputService {
  DioClients dio;
  MasterApproverInputService(this.dio);

  Future masterApproverInput(
    int approverid,
    String karyawanid,
  ) async {
    try {
      final response = await dio.dio.post(
        'approver/hr/input',
        // queryParameters: {
        //   'approver_id': approverid,
        //   'karyawan_id': karyawanid
        // },

        data: {'approver_id': approverid, 'karyawan_id': karyawanid},
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
