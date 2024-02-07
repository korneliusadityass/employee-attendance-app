import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../helper/auth_pref_helper.dart';
import '../../dio_clients.dart';

class TotalKuotaCutiTahunanService {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/sisa_kuota';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future<int> totalKuotaCutiTahunan(int tahun) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };

      // final response = await dio.get(url,
      //     options: Options(
      //       headers: headers,
      //     ),
      //     queryParameters: {
      //       'tahun': tahun,
      //     });
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('berhasil');
      //   print('TESTTST : ${response.data}');
      //   return response.data;
      // } else {
      //   print('gagal');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
    return 0;
  }
}

class SisaKuotaCutiTahunanServices {
  DioClients dio;
  SisaKuotaCutiTahunanServices(this.dio);

  Future<int?> getSisaCutiTahunan() async {
    final int tahun = DateTime.now().year;
    try {
      final response = await dio.dio.get(
        '/cuti_tahunan/sisa_kuota',
        queryParameters: {'tahun': tahun},
      );
      return response.data;
    } catch (e) {
      throw Exception('failed get data: $e');
    }
  }
}
