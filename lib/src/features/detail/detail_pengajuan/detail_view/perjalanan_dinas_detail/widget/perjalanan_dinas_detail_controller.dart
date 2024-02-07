import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/pengajuan_pembatalan/perjalanan_dinas/perjalanan_dinas_attachment_model.dart';
import '../../../../../../core/model/pengajuan_pembatalan/perjalanan_dinas/perjalanan_dinas_detail_model.dart';
import '../../../../../../core/services/pengajuan/perjalanan_dinas_service/pengajuan_perjalanan_dinas_service.dart';

class DetailDataPerjalananDinasController extends GetxController {
  PengajuanPerjalananDinasService service;
  DetailDataPerjalananDinasController(this.service);

  Future<DetailPerjalananDinasModel> execute(int id) async {
    final result = await service.fetchDetailPerjalananDinas(id);

    return result;
  }

  //download
  var downloading = false.obs;
  var progress = 0.obs;

  Future perjalananDinasDownload(int idFile, String fileName, BuildContext context) async {
    try {
      downloading.value = true;
      final result = await service.perjalananDinasDownload(idFile, fileName, context);

      downloading.value = false;
      return result;
    } catch (e) {
      Get.snackbar('Terjadi kesalahan', e.toString());
    }
  }

  // list attachment
  RxInt idController = 0.obs;

  RxList<PerjalananDinasAttachmentModel> attachment = <PerjalananDinasAttachmentModel>[].obs;

  Future<List<PerjalananDinasAttachmentModel>> attach(int id) async {
    final result = await service.perjalananDinasGetAttachment(id);

    return result;
  }
}
