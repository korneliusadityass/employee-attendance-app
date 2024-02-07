import 'package:dio/dio.dart';

import '../../../dio_clients.dart';

class MasterKaryawanEditService {
  DioClients dio;
  MasterKaryawanEditService(this.dio);

  Future masterKaryawanEdit(
  { required  int id,
    required  int perusahaanId,
    required  String namakaryawan,
    required  String tempatlahir,
    required  String tanggallahir,
    required  String alamat,
    required  String nohp,
    required  String email,
    required  String level,
    required  String posisi,
    required String password,
    String? newPassword,}
  ) async {
    try {
      final response = await dio.dio.patch(
        'user/hr/update_karyawan',
        queryParameters: {
         'id_karyawan': id,
         'password': password,
        },
        data: {
          'perusahaan_id': perusahaanId,
          'nama_karyawan': namakaryawan,
          'tempat_lahir': tempatlahir,
          'tanggal_lahir': tanggallahir,
          'alamat': alamat,
          'no_hp': nohp,
          'email': email,
          'level': level,
          'posisi': posisi,
          'status' : 'aktif',
          'password': password,
          'new_password': newPassword,
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
