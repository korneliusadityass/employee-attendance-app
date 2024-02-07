import 'package:dio/dio.dart';
import 'package:project/src/core/enums/duration_karyawan_enum.dart';
import 'package:project/src/core/services/dio_clients.dart';

class DashboardSayaService {
  DioClients dio;

  DashboardSayaService(this.dio);

  Future<Response> getSisaCutiTahunan() async {
    final int tahun = DateTime.now().year;
    try {
      final response = await dio.dio.get(
        'cuti_tahunan/sisa_kuota',
        queryParameters: {'tahun': tahun},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> getlIzin3Jam(
      {required KaryawanDuration duration}) async {
    if (duration == KaryawanDuration.yearly) {
      try {
        return await dio.dio.get('ijin_3_jam/jumlah_ijin_tahun');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    } else {
      try {
        return await dio.dio.get('ijin_3_jam/jumlah_ijin_bulan');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    }
  }

  Future<int?> getCutiTahunan({required KaryawanDuration duration}) async {
  try {
    final response = await dio.dio.get('cuti_tahunan/jumlah_ijin_tahun');
    return response.data;
  } catch (e) {
    throw Exception('Failed to get data: $e');
  }
}

  Future<int?> getCutiKhusus({required KaryawanDuration duration}) async {
  try {
    final response = await dio.dio.get('cuti_khusus/jumlah_ijin_tahun');
    return response.data;
  } catch (e) {
    throw Exception('Failed to get data: $e');
  }
}

  Future<int?> getIzinSakit({required KaryawanDuration duration}) async {
  try {
    final response = await dio.dio.get('ijin_sakit/jumlah_ijin_tahun');
    return response.data;
  } catch (e) {
    throw Exception('Failed to get data: $e');
  }
}

  Future<int?> getPerjalananDinas({required KaryawanDuration duration}) async {
  try {
    final response = await dio.dio.get('perjalanan_dinas/jumlah_ijin_tahun');
    return response.data;
  } catch (e) {
    throw Exception('Failed to get data: $e');
  }
}

}
