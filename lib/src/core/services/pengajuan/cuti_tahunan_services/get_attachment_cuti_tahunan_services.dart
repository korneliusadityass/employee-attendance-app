import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../helper/auth_pref_helper.dart';
import '../../../model/hr_pengajuan_pembatalan/cuti_tahunan/attachment_cuti_tahunan_hr_model.dart';

class GetAttachmenCutiTahunanServices {
  final url = 'http://192.168.2.155:8000/cuti_tahunan/list_attachment';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future getAttachmentCutiTahunan(int id) async {
    try {
      // final tokenResponse = '';
      // final tokenJson = jsonDecode(tokenResponse);
      // final token = tokenJson['access_token'];
      // final headers = {"Authorization": 'Bearer $token'};
      // final response = await dio.get(
      //   url,
      //   options: Options(
      //     headers: headers,
      //   ),
      //   queryParameters: {
      //     'id_ijin': id,
      //   },
      // );
      // print(response.statusCode);
      // if (response.statusCode == 200) {
      //   print('dapat');
      //   return response.data;
      // } else {
      //   print('gagal');
      // }
    } on DioError catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }
}

class GetAttachmentCutiTahunanServicess {
  DioClients dio;
  GetAttachmentCutiTahunanServicess(this.dio);

  Future getAttachmentCutiTahunann(int id) async {
    try {
      final response = await dio.dio.get(
        '/cuti_tahunan/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<AttachmentCutiTahunanModelHr> attachmentsss =
            data.map((attachment) => AttachmentCutiTahunanModelHr.fromJson(attachment)).toList();
        return attachmentsss;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.toString());
    }
  }
}
