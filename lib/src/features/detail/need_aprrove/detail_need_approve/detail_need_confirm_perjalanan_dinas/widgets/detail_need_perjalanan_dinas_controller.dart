import 'package:get/get.dart';

import '../../../../../../core/model/approval/perjalanan_dinas/perjalanan_dinas_attachment_need_confirm_model.dart';
import '../../../../../../core/model/approval/perjalanan_dinas/perjalanan_dinas_detail_need_confirm_model.dart';
import '../../../../../../core/services/approval/perjalanan_dinas_service/perjalanan_dinas_approval_service.dart';

class DetailNeedConfirmPerjalananDinasController extends GetxController {
  PerjalananDinasApprovalService service;
  DetailNeedConfirmPerjalananDinasController(this.service);

  Future<DetailNeedPerjalananDinasModel> execute(int id) async {
    final result = await service.fetchDataPerjalananDinas(id);

    return result;
  }
}

class GetattachmentApprovalPerjalananDinasController extends GetxController
    with StateMixin<List<AttachmentNeedConfirmPerjalananDinasModel>> {
  PerjalananDinasApprovalService service;
  GetattachmentApprovalPerjalananDinasController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentNeedConfirmPerjalananDinasModel> attachmentPerjalananDinas =
      <AttachmentNeedConfirmPerjalananDinasModel>[].obs;

  Future<List<AttachmentNeedConfirmPerjalananDinasModel>> attach(int id) async {
    final result = await service.getattachmentApprovalPerjalananDinas(id);

    return result;
  }
}
