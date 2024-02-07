import 'package:dio/dio.dart';

import '../../../model/pengajuan_pembatalan/perjalanan_dinas/perjalanan_dinas_list_model.dart';
import '../../dio_clients.dart';

class PerjalananDinasListService {
  // final url = 'http://192.168.2.155:8000/perjalanan_dinas/list';
  // Dio dio = Dio();
  // final pref = Get.find<AuthStorageHelper>();

  // Future getPerjalananDinasList({
  //   int page = 1,
  //   int size = 10,
  //   String filterStatus = 'All',
  //   required String? tanggalAwal,
  //   required String? tanggalAkhir,
  // }) async {
  //   try {
  // final tokenResponse = '';
  // final tokenJson = jsonDecode(tokenResponse);
  // final token = tokenJson['access_token'];
  // final headers = {
  //   "Authorization": 'Bearer $token',
  // };
  // final queryparameters = {
  //   'page': page,
  //   'size': size,
  //   'filter_status': filterStatus,
  //   if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
  //   if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
  // };
  // final response = await dio.get(
  //   url,
  //   options: Options(
  //     headers: headers,
  //   ),
  //   queryParameters: queryparameters,
  // );
  // debugPrint('${response.statusCode}');
  // if (response.statusCode == 200) {
  //   debugPrint('${response.data}');
  //   return response.data;
  // } else {
  //   debugPrint('failed to fetch data');
  // }
  //   } on DioError catch (e) {
  //     debugPrint('${e.error}');
  //     debugPrint(e.message);
  //     debugPrint('${e.response}');
  //   }
  // }
  DioClients dio;
  PerjalananDinasListService(this.dio);

  Future<List<PerjalananDinasListModel>> fetchPerjalananDinanList({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    try {
      final queryParameters = {
        'page': page,
        'size': size,
        'filter_status': filterStatus,
        if (tanggalAwal != null) 'filter_tanggal_awal': tanggalAwal,
        if (tanggalAkhir != null) 'filter_tanggal_akhir': tanggalAkhir,
      };

      final response = await dio.dio.get(
        'perjalanan_dinas/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result
            .map((data) => PerjalananDinasListModel.fromJson(data))
            .toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
