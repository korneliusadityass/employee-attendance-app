import 'dart:io';

import 'package:get/get.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_sakit_services/input_attachment_izin_sakit_hr_services.dart';

class InputAttachmentIzinSakitHrController extends GetxController {
  InputAttachmentIzinSakitHrServices service;
  InputAttachmentIzinSakitHrController(this.service);

  Future inputAttachmentizinsakitHr(
    int id,
    List<File> files,
  ) async {
    await service.inputAttachmentIzinSakitHr(id, files);
  }
}
