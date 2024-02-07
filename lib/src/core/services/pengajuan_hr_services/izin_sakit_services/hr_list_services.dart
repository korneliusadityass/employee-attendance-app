import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../helper/auth_pref_helper.dart';
import '../../../model/hr_pengajuan_pembatalan/izin_sakit/list_izin_sakit_hr_model.dart';
import '../../dio_clients.dart';

class IzinSakitListHRServices {
  final url = 'http://192.168.2.155:8000/ijin_sakit/hr/list';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future izinsakitHRlist({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    required String? tanggalAwal,
    required String? tanggalAkhir,
  }) async {
    try {
      // final tokenRespons = await AuthStorageHelper().getToken() ?? '';
      // final tokenJson = jsonDecode(tokenRespons);
      // final token = tokenJson['access_token'];
      // final headerss = {
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
      //     headers: headerss,
      //   ),
      //   queryParameters: queryparameters,
      // );
      // if (response.statusCode == 200) {
      //   print(response.statusCode);
      //   print(response.data);
      //   return response.data;
      // } else {
      //   print('failed to fetch data');
      // }
    } on DioError catch (e) {
      print(e);
    }
  }
}

class HRIzinSakitListServicess {
  DioClients dio;
  HRIzinSakitListServicess(this.dio);

  Future<List<HrListIzinSakitModel>> fetchIzinsakitHr({
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
        '/ijin_sakit/hr/list',
        queryParameters: queryParameters,
      );
      if (response.statusCode == 200) {
        List result = response.data;
        return result
            .map((data) => HrListIzinSakitModel.fromJson(data))
            .toList();
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
