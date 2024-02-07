import 'dart:io';

import 'package:get/get.dart';

import '../../../../../core/services/pengajuan/izin_sakit_services/input_attachment_izin_sakit.dart';

class InputAttachmentIzinSakitControllerr extends GetxController {
  InputAttachmentIzinSakitServicess service;
  InputAttachmentIzinSakitControllerr(this.service);

  Future inputAttachmentIzinSakitttt(
    int id,
    List<File> files,
  ) async {
    await service.inputAttachmentizinsakitt(id, files);
  }
}
