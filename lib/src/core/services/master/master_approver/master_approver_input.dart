import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../helper/auth_pref_helper.dart';

class MasterInputApprover {
  final url = 'http://192.168.2.155:8000/approver/hr/input';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future inputMasterApprover(
    int namaapprover,
    String namakaryawan,
  ) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };
      // final response = await dio.post(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   data: {
      //     'approver_id': namaapprover,
      //     'karyawan_id': namakaryawan,
      //   },
      // );
      // if (response.statusCode == 200) {
      //   print(response.statusCode);
      //   print('Data berhasil diinput');
      // } else {
      //   print('Terjadi kesalahan saat mengirim data');
      // }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
      print(e.error);
    }
  }
}
