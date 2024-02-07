import 'package:get/get.dart';

import '../../../../../../core/model/approval/izin_sakit/izin_sakit_attachment_model.dart';
import '../../../../../../core/model/approval/izin_sakit/izin_sakit_detail_need_confirm_model.dart';
import '../../../../../../core/services/approval/izin_sakit_services/izin_sakit_approval_service.dart';

class DetailNeedConfirmIzinSakitController extends GetxController {
  IzinSakitApprovalService service;
  DetailNeedConfirmIzinSakitController(this.service);

  Future<DetailNeedIzinSakitModel> execute(int id) async {
    final result = await service.fetchDataIzinSakit(id);

    return result;
  }
}

class GetattachmentApprovalIzinSakitController extends GetxController
    with StateMixin<List<AttachmentNeedConfirmIzinSakitModel>> {
  IzinSakitApprovalService service;
  GetattachmentApprovalIzinSakitController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentNeedConfirmIzinSakitModel> attachmentIzinSakit = <AttachmentNeedConfirmIzinSakitModel>[].obs;

  Future<List<AttachmentNeedConfirmIzinSakitModel>> attach(int id) async {
    final result = await service.getattachmentApprovalIzinSakit(id);

    return result;
  }
}
