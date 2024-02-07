import 'package:dio/dio.dart';
import 'package:project/src/core/model/laporan/izin_3jam/list_model_ijin3_jam.dart';
import 'package:project/src/core/services/dio_clients.dart';

// class GetLaporanIzin3JamService {
//   final url = 'http://192.168.2.155:8000/laporan/ijin_3_jam';
//   Dio dio = Dio();
//   final pref = Get.find<AuthStorageHelper>();

//   Future getLaporanIzin3Jam(
//     int id, {
//     int page = 1,
//     int size = 10,
//     String filterStatus = 'All',
//     required String? filterNama,
//     required String? tanggalAwal,
//     required String? tanggalAkhir,
//   }) async {
//     try {
//       final tokenResponse = '';
//       final tokenJson = jsonDecode(tokenResponse);
//       final token = tokenJson['access_token'];
//       final headers = {
//         "Authorization": 'Bearer $token',
//       };

//       final queryparameters = {
//         'id_perusahaan': id,
//         'page': page,
//         'size': size,
//         'filter_status': filterStatus,
//         if (filterNama != null) 'filter_nama': filterNama,
//         if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
//         if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
//       };

//       final response = await dio.get(
//         url,
//         options: Options(
//           headers: headers,
//         ),
//         queryParameters: queryparameters,
//       );

//       print('LIST IZIN 3 JAM : ${response.statusCode}');
//       if (response.statusCode == 200) {
//         return response.data;
//       } else {
//         print('failed to fetch data');
//       }
//     } on DioError catch (e) {
//       print(e.error);
//       print(e.message);
//       print(e.response);
//     }
//   }
// }

class GetLaporanIzin3JamService {
  DioClients dio;
  GetLaporanIzin3JamService(this.dio);

  Future<List<ListLaporanIzin3JamModel>> fetchLaporanIzin3Jam(
    int id, {
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'id_perusahaan': id,
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (filterNama != null) 'filter_nama': filterNama,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        'laporan/ijin_3_jam',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result.map((data) => ListLaporanIzin3JamModel.fromJson(data)).toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      print(e.response);
      throw Exception(e.message);
    }
  }
}
