import 'package:dio/dio.dart';
import 'package:project/src/core/enums/duration_karyawan_enum.dart';
import 'package:project/src/core/services/dio_clients.dart';

class DashboardKaryawanService {
  DioClients dio;

  DashboardKaryawanService(this.dio);

  Future<Response> getSisaCutiTahunanKaryawan() async {
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

  Future<Response> getlIzin3JamKaryawan(
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

  Future<int?> getCutiTahunanKaryawanTahun(
      {required KaryawanDuration duration}) async {
    try {
      final response = await dio.dio.get('cuti_tahunan/jumlah_ijin_tahun');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<int?> getCutiKhususKaryawan(
      {required KaryawanDuration duration}) async {
    try {
      final response = await dio.dio.get('cuti_khusus/jumlah_ijin_tahun');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<int?> getIzinSakitKaryawan(
      {required KaryawanDuration duration}) async {
    try {
      final response = await dio.dio.get('ijin_sakit/jumlah_ijin_tahun');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<int?> getPerjalananDinasKaryawan(
      {required KaryawanDuration duration}) async {
    try {
      final response = await dio.dio.get('perjalanan_dinas/jumlah_ijin_tahun');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }
}
