import 'package:get/get.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/get_attachment_cuti_tahunan_services.dart';

import '../../../../../core/model/hr_pengajuan_pembatalan/cuti_tahunan/attachment_cuti_tahunan_hr_model.dart';

class GetAttachmentCutiTahunanController extends GetxController {
  GetAttachmentCutiTahunanServicess service;
  GetAttachmentCutiTahunanController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentCutiTahunanModelHr> attachmentCutiTahunannnn = <AttachmentCutiTahunanModelHr>[].obs;

  Future<List<AttachmentCutiTahunanModelHr>> attach(int id) async {
    final result = await service.getAttachmentCutiTahunann(id);
    return result;
  }
}
