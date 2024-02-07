import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/services/pengajuan/izin_sakit_services/download_attachement_izin_sakit_services.dart';

class DownloadIzinSakitController extends GetxController {
  DownloadAttachmentIzinSakit service;
  DownloadIzinSakitController(this.service);

  //download
  var downloading = false.obs;
  var progress = 0.obs;

  Future IzinSakitDownload(
      int idFile, String fileName, BuildContext context) async {
    try {
      downloading.value = true;
      final result = await service.izinSakitDownload(
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
