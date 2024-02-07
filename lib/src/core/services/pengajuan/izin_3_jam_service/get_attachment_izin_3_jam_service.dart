import 'package:dio/dio.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_3_jam_model/attachment_izin_3_jam_model.dart';

import '../../dio_clients.dart';

class GetAttachmentIzin3JamService2 {
  DioClients dio;
  GetAttachmentIzin3JamService2(this.dio);

  Future getAttachmentIzin3Jam(int id) async {
    try {
      final response = await dio.dio.get(
        '/ijin_3_jam/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );

      if (response.statusCode == 200) {
        final AttachmentListIzin3JamModel data =
            AttachmentListIzin3JamModel.fromJson(response.data);
        final List<AttachmentIzin3JamModel> attachments = data.data;
        return attachments;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
