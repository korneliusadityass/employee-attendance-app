import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_sakit_model/attachment_izin_sakit_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../helper/auth_pref_helper.dart';

class GetAttachmenIzinSakitServices {
  final url = 'http://192.168.2.155:8000/ijin_sakit/list_attachment';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future getAttachmentIzinSakit(int id) async {
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
      //       'id_ijin': id,
      //     });
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

class GetAttachmentIzinSakitServicess {
  DioClients dio;
  GetAttachmentIzinSakitServicess(this.dio);

  Future getAttachmentIzinSakittt(int id) async {
    try {
      final response = await dio.dio.get(
        '/ijin_sakit/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<AttachmentIzinSakitModel> attachmentss = data
            .map((attachment) => AttachmentIzinSakitModel.fromJson(attachment))
            .toList();
        return attachmentss;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
