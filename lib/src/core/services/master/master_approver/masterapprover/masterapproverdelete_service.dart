import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

class MasterApproverDeleteService {
  DioClients dio;
  MasterApproverDeleteService(this.dio);

  Future masterApproverdelete(int id) async {
    try {
      final response = await dio.dio.delete(
        'approver/hr/delete',
        queryParameters: {
          'id': id,
        },
      );
      print('SERVICE STATUS CODE : ${response.statusCode}');
      if (response.statusCode == 200) {
        print('DELETE SUKSES');
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}