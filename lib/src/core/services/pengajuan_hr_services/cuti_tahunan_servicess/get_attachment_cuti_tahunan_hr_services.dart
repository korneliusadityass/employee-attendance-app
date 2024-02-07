import 'package:dio/dio.dart';

import '../../../model/hr_pengajuan_pembatalan/cuti_tahunan/attachment_cuti_tahunan_hr_model.dart';
import '../../dio_clients.dart';

class GetAttachmentCutiTahunanHrService {
  DioClients dio;
  GetAttachmentCutiTahunanHrService(this.dio);

  Future getAttachmentCutiTahunanHr(int id) async {
    try {
      final response = await dio.dio.get(
        '/cuti_tahunan/list_attachment',
        queryParameters: {
          'id_ijin': id,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<AttachmentCutiTahunanModelHr> attachmentsss = data
            .map((attachment) =>
                AttachmentCutiTahunanModelHr.fromJson(attachment))
            .toList();
        return attachmentsss;
      } else {
        throw Exception('gagal load data');
      }
    } on DioError catch (e) {
      throw Exception(e.message);
    }
  }
}
