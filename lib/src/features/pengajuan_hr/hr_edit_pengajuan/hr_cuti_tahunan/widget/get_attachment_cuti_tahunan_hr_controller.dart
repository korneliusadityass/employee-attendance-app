import 'package:get/get.dart';

import '../../../../../core/model/hr_pengajuan_pembatalan/cuti_tahunan/attachment_cuti_tahunan_hr_model.dart';
import '../../../../../core/services/pengajuan_hr_services/cuti_tahunan_servicess/get_attachment_cuti_tahunan_hr_services.dart';

class GetAttachmentCutiTahunanHrController extends GetxController {
  GetAttachmentCutiTahunanHrService service;
  GetAttachmentCutiTahunanHrController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentCutiTahunanModelHr> attachmentizinSakit =
      <AttachmentCutiTahunanModelHr>[].obs;

  Future<List<AttachmentCutiTahunanModelHr>> attach(int id) async {
    final result = await service.getAttachmentCutiTahunanHr(id);

    return result;
  }
}
