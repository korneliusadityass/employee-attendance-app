import 'package:get/get.dart';

import '../../../../../core/model/hr_pengajuan_pembatalan/izin_sakit/attchment_izin_sakit_model.dart';
import '../../../../../core/model/pengajuan_pembatalan/izin_sakit_model/attachment_izin_sakit_model.dart';
import '../../../../../core/services/pengajuan_hr_services/izin_sakit_services/get_attachment_izin_sakit_hr_services.dart';

class GetAttachmentIzinSakitHrController extends GetxController {
  GetAttachmentIzinSakitHrServices service;
  GetAttachmentIzinSakitHrController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentIzinSakitModel> attachmentizinSakit =
      <AttachmentIzinSakitModel>[].obs;

  Future<List<AttachmentIzinSakitModel>> attach(int id) async {
    final result = await service.getAttchmentizinSakitHr(id);

    return result;
  }
}
