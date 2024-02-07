import 'package:get/get.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/get_attachement_izin_sakit_services.dart';

import '../../../../../core/model/pengajuan_pembatalan/izin_sakit_model/attachment_izin_sakit_model.dart';

class GetAttachmentIzinSakitController extends GetxController with StateMixin<List<AttachmentIzinSakitModel>> {
  GetAttachmentIzinSakitServicess service;
  GetAttachmentIzinSakitController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentIzinSakitModel> attachmentizinSakit = <AttachmentIzinSakitModel>[].obs;

  Future<List<AttachmentIzinSakitModel>> attach(int id) async {
    final result = await service.getAttachmentIzinSakittt(id);

    return result;
  }
}
