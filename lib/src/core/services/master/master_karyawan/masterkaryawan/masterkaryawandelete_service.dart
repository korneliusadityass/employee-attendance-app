import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

class MasterKaryawanDeleteService {
  DioClients dio;
  MasterKaryawanDeleteService(this.dio);

  Future masterKaryawandelete(int id) async {
    try {
      final response = await dio.dio.delete(
        '/user/hr/delete_karyawan',
        queryParameters: {
          'id_karyawan': id,
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