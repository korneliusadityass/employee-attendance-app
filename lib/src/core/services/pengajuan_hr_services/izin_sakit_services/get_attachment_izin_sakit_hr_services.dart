import 'package:dio/dio.dart';
import 'package:project/src/core/services/dio_clients.dart';

import '../../../model/pengajuan_pembatalan/izin_sakit_model/attachment_izin_sakit_model.dart';

class GetAttachmentIzinSakitHrServices {
  DioClients dio;
  GetAttachmentIzinSakitHrServices(this.dio);

  Future getAttchmentizinSakitHr(int id) async {
    try {
      final response = await dio.dio.get(
        '/ijin_sakit/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );

      if (response.statusCode == 200) {
        final IzinSakitListAttachmentModel data =
            IzinSakitListAttachmentModel.fromJson(response.data);
        final List<AttachmentIzinSakitModel> attachments = data.data;
        return attachments;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
