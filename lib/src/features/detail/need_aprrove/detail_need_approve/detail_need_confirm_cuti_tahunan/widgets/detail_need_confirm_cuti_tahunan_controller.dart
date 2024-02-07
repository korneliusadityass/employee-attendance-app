import 'package:get/get.dart';

import '../../../../../../core/model/approval/cuti_tahunan/cuti_tahunan_attachment_model.dart';
import '../../../../../../core/model/approval/cuti_tahunan/izin_sakit_detail_need_confirm_model.dart';
import '../../../../../../core/services/approval/cuti_tahunan_services/cuti_tahunan_approval_service.dart';

class DetailNeedConfirmCutiTahunanController extends GetxController {
  CutiTahunanApprovalService service;
  DetailNeedConfirmCutiTahunanController(this.service);

  Future<DetailNeedCutiTahunanModel> execute(int id) async {
    final result = await service.fetchDataCutiTahunan(id);

    return result;
  }
}

class GetattachmentApprovalCutiTahunanController extends GetxController
    with StateMixin<List<AttachmentNeedConfirmCutiTahunanModel>> {
  CutiTahunanApprovalService service;
  GetattachmentApprovalCutiTahunanController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentNeedConfirmCutiTahunanModel> attachmentCutiTahunan = <AttachmentNeedConfirmCutiTahunanModel>[].obs;

  Future<List<AttachmentNeedConfirmCutiTahunanModel>> attach(int id) async {
    final result = await service.getattachmentApprovalCutiTahunan(id);

    return result;
  }
}
