import 'dart:io';

import 'package:get/get.dart';

import '../../../../../core/services/pengajuan/cuti_tahunan_services/input_attachment_cuti_tahunan_services.dart';

class InputAttachmentCutiTahunanController extends GetxController {
  InputAttachmentCutiTahunanServicess service;
  InputAttachmentCutiTahunanController(this.service);

  Future inputAttachmentCutiTahunann(
    int id,
    List<File> files,
  ) async {
    await service.inputAttachmentCutiTahunan(id, files);
  }
}
