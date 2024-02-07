import 'package:get/get.dart';

import '../../../../../../core/model/approval/cuti_khusus/cuti_khusus_attachment_need_confirm_model.dart';
import '../../../../../../core/model/approval/cuti_khusus/cuti_khusus_detail_need_confirm_model.dart';
import '../../../../../../core/services/approval/cuti_khusus_service/cuti_khusus_approval_service.dart';

class DetailNeedConfirmCutiKhususController extends GetxController {
  CutiKhususApprovalService service;
  DetailNeedConfirmCutiKhususController(this.service);

  Future<DetailNeedCutiKhususModel> execute(int id) async {
    final result = await service.fetchDataCutiKhusus(id);

    return result;
  }
}

class GetattachmentApprovalCutiKhususController extends GetxController
    with StateMixin<List<AttachmentNeedConfirmCutiKhususModel>> {
  CutiKhususApprovalService service;
  GetattachmentApprovalCutiKhususController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentNeedConfirmCutiKhususModel> attachmentCutiKhusus = <AttachmentNeedConfirmCutiKhususModel>[].obs;

  Future<List<AttachmentNeedConfirmCutiKhususModel>> attach(int id) async {
    final result = await service.getattachmentApprovalCutiKhusus(id);

    return result;
  }
}
