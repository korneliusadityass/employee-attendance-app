import 'package:dio/dio.dart';
import 'package:project/src/core/model/approval/izin_3_jam/attachment_need_confirm_izin_jam_model.dart';
import 'package:project/src/core/services/dio_clients.dart';

class HrGetAttachmentIzin3JamService {
  DioClients dio;
  HrGetAttachmentIzin3JamService(this.dio);

  Future hrGetAttachmentIzin3Jam(int id) async {
    try {
      final response = await dio.dio.get(
        '/ijin_3_jam/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<AttachmentNeedConfirmIzin3JamModel> attachments = data
            .map((attachment) =>
                AttachmentNeedConfirmIzin3JamModel.fromJson(attachment))
            .toList();
        return attachments;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
