import 'dart:io';

import 'package:get/get.dart';

import '../../../../../core/services/pengajuan_hr_services/cuti_tahunan_servicess/input_attachment_cuti_tahunan_services.dart';

class InputAttachmentCutiTahunanHrController extends GetxController {
  InputAttachmentCutiTahunanHrServices service;
  InputAttachmentCutiTahunanHrController(this.service);

  Future inputAttachmentCutiTahunanHrr(
    int id,
    List<File> files,
  ) async {
    await service.inputAttachmentCutiTahunantHr(id, files);
  }
}
