import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../helper/auth_pref_helper.dart';

class ApproverDeleteService {
  final url = 'http://192.168.2.155:8000/approver/hr/delete';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  // CompanyDeleteService(companyDelete);

  Future approverDelete(int id) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {
      //   "Authorization": 'Bearer $token',
      // };
      // final response = await dio.delete(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {'id': id},
      //   data: {
      //     'id': id,
      //   },
      // );
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('berhasil di hapus');
      // } else {
      //   print('gagal dihapus');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}
