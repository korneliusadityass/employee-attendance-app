import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/hr_pengajuan_pembatalan/izin_3_jam/data_hr_detail_izin_3_jam_model.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_3_jam_model/attachment_izin_3_jam_model.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/download_attachment_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/get_attachment_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan_hr_services/izin_3_jam_services/hr_data_edit_izin_3_jam_service.dart';

class HrDataDetailIzin3JamController extends GetxController {
  HrDataDetailIzin3JamService service;
  HrDataDetailIzin3JamController(this.service);

  Future<HrDataDetailIzin3JamModel> execute(int id) async {
    final result = await service.fetchDataIzin3Jam(id);

    return result;
  }
}

class HrGetAttachmentIzin3JamDetailController extends GetxController
    with StateMixin<List<AttachmentIzin3JamModel>> {
  GetAttachmentIzin3JamService2 service;
  HrGetAttachmentIzin3JamDetailController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentIzin3JamModel> attachmentIzin3Jam =
      <AttachmentIzin3JamModel>[].obs;

  Future<List<AttachmentIzin3JamModel>> attach(int id) async {
    final result = await service.getAttachmentIzin3Jam(id);

    return result;
  }
}

class HrDownloadAttachmentIzin3JamController extends GetxController {
  DownloadAttachmentIzin3JamService2 service;
  var downloading = false.obs;
  var progress = 0.obs;
  HrDownloadAttachmentIzin3JamController(this.service);

  Future downloadAttachment(
      int idFile, String fileName, BuildContext context) async {
    try {
      downloading.value = true;
      final result = await service.downloadAttachmentIzin3Jam(
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
