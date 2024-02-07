import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/pengajuan_pembatalan/cuti_khusus/cuti_khusus_attachment_model.dart';
import '../../../../../../core/model/pengajuan_pembatalan/cuti_khusus/cuti_khusus_detail_model.dart';
import '../../../../../../core/services/pengajuan/cuti_khusus_service/pengajuan_cuti_khusus_service.dart';

class DetailDataCutiKhususController extends GetxController {
  PengajuanCutiKhususService service;
  DetailDataCutiKhususController(this.service);

  //detail
  Future<DetailCutiKhususModel> execute(int id) async {
    final result = await service.fetchDetailCutiKhusus(id);

    return result;
  }

  //download
  var downloading = false.obs;
  var progress = 0.obs;

  Future cutiKhususDownload(
      int idFile, String fileName, BuildContext context) async {
    try {
      downloading.value = true;
      final result =
          await service.cutiKhususDownload(idFile, fileName, context);

      downloading.value = false;
      return result;
    } catch (e) {
      Get.snackbar('Terjadi kesalahan', e.toString());
    }
  }

  //list attachment
  RxInt idController = 0.obs;

  RxList<CutiKhususAttachmentModel> attachment =
      <CutiKhususAttachmentModel>[].obs;

  Future<List<CutiKhususAttachmentModel>> attach(int id) async {
    final result = await service.cutiKhususGetAttachment(id);

    return result;
  }
}
