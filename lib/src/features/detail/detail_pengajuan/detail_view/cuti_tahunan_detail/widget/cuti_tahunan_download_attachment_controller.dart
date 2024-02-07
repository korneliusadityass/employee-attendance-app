import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/services/pengajuan/cuti_tahunan_services/download_attachment_cuti_tahunan_services.dart';

class DownloadCutiTahunanController extends GetxController {
  DownloadAttachmentCutiTahunanServices service;
  DownloadCutiTahunanController(this.service);

  //download
  var downloading = false.obs;
  var progress = 0.obs;

  Future cutiTahunanDownload(
      int idFile, String fileName, BuildContext context) async {
    try {
      downloading.value = true;
      final result = await service.cutiTahunanDownload(
        idFile,
        fileName,
        context,
      );

      downloading.value = false;
      return result;
    } catch (e) {
      Get.snackbar('Terjadi kesalahan', e.toString());
    }
  }
}
