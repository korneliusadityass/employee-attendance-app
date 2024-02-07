import 'package:dio/dio.dart';
import 'package:project/src/core/enums/duration_enum.dart';
import 'package:project/src/core/services/dio_clients.dart';

class DashboardHrService {
  DioClients dio;

  DashboardHrService(this.dio);

  Future<Response> getTotalKaryawanHr({int? perusahaanId}) async {
    try {
      final response = await dio.dio.get(
        'user/hr/jumlah_karyawan',
        queryParameters: {
          if (perusahaanId != null) 'perusahaan_id': perusahaanId,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<Response> getTotalCutiTahunan({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      try {
        return await dio.dio.get('cuti_tahunan/hr/jumlah_ijin_tahun');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    } else {
      try {
        return await dio.dio.get('cuti_tahunan/hr/jumlah_ijin_bulan');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    }
  }

  Future<Response> getTotalCutiKhusus({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      try {
        return await dio.dio.get('cuti_khusus/hr/jumlah_ijin_tahun');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    } else {
      try {
        return await dio.dio.get('cuti_khusus/hr/jumlah_ijin_bulan');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    }
  }

  Future<Response> getTotalIzinSakit({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      try {
        return await dio.dio.get('ijin_sakit/hr/jumlah_ijin_tahun');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    } else {
      try {
        return await dio.dio.get('ijin_sakit/hr/jumlah_ijin_bulan');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    }
  }

  Future<Response> getTotalIzin3Jam({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      try {
        return await dio.dio.get('ijin_3_jam/hr/jumlah_ijin_tahun');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    } else {
      try {
        return await dio.dio.get('ijin_3_jam/hr/jumlah_ijin_bulan');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    }
  }

  Future<Response> getTotalDinas({required HRDuration duration}) async {
    if (duration == HRDuration.yearly) {
      try {
        return await dio.dio.get('perjalanan_dinas/hr/jumlah_ijin_tahun');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    } else {
      try {
        return await dio.dio.get('perjalanan_dinas/hr/jumlah_ijin_bulan');
      } catch (e) {
        throw Exception('Failed to get data: $e');
      }
    }
  }
}
