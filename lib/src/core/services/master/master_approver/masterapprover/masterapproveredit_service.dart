import 'package:dio/dio.dart';

import '../../../dio_clients.dart';

class MasterApproverEditService {
  DioClients dio;
  MasterApproverEditService(this.dio);
  Future masterApproverEdit({required int id, required int approverid, required int karyawanid}) async {
    try {
      final response = await dio.dio.patch(
        'approver/hr/update',
        queryParameters: {
          'id': id,
        },
        data: {
          'approver_id': approverid,
          'karyawan_id': karyawanid,
        },
      );
      print('EDIT STATUS CODE : ${response.statusCode}');
      if (response.statusCode == 200) {
        print('sukses edit');
      } else {
        throw Exception('gagal ngedit');
      }
    } on DioError catch (e) {
      print(e.response?.data);
      print(e.response?.statusCode);
      print(e.response?.statusMessage);
      print(e.response);
      throw Exception(e.message);
    }
  }
}
