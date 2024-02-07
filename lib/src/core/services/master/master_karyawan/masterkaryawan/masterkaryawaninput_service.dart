import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/src/core/error/failure.dart';
import 'package:project/src/core/services/dio_clients.dart';

int idKaryawan = 0;

class MasterKaryawanInputService {
  DioClients dio;
  MasterKaryawanInputService(this.dio);

  Future<Either<Failure, bool>> masterKaryawanInput(
    int perusahaanId,
    String namakaryawan,
    String tempatlahir,
    String tanggallahir,
    String alamat,
    String nohp,
    String email,
    String password,
    String level,
    String posisi,
    String tanggalbergabung,
  ) async {
    try {
      final response = await dio.dio.post(
        'user/hr/input',
        data: {
          'perusahaan_id': perusahaanId,
          'nama_karyawan': namakaryawan,
          'tempat_lahir': tempatlahir,
          'tanggal_lahir': tanggallahir,
          'alamat': alamat,
          'no_hp': nohp,
          'email': email,
          'password': password,
          'level': level,
          'posisi': posisi,
          'tanggal_bergabung': tanggalbergabung,
          // 'status': status,
        },
      );
      final result = response.data;
      return Right(result);
    } on DioError catch (e) {
      String errorMessage = e.response?.data['detail'] ?? "gagal mengirim";
      return Left(CutiKhususInputFailure(errorMessage));
    }
  }
}
