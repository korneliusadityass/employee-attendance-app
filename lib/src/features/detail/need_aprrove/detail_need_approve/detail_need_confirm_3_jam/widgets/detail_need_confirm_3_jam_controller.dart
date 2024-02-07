import 'package:get/get.dart';
import 'package:project/src/core/model/approval/izin_3_jam/attachment_need_confirm_izin_jam_model.dart';
import 'package:project/src/core/model/approval/izin_3_jam/data_need_confirm_izin_3_jam_model.dart';
import 'package:project/src/core/services/approval/izin_3_jam_service/hr_get_detail_izin_3_jam_services.dart';
import 'package:project/src/core/services/approval/izin_3_jam_service/hr_list_attachment_izin_3_jam_service.dart';

class DetailNeedConfirm3JamController extends GetxController {
  HrDataIzin3JamService service;
  DetailNeedConfirm3JamController(this.service);

  Future<DataNeedConfirmIzin3JamModel> execute(int id) async {
    final result = await service.fetchDataIzin3Jam(id);

    return result;
  }
}

class HrGetAttachmentEditIzin3JamController extends GetxController
    with StateMixin<List<AttachmentNeedConfirmIzin3JamModel>> {
  HrGetAttachmentIzin3JamService service;
  HrGetAttachmentEditIzin3JamController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentNeedConfirmIzin3JamModel> attachmentIzin3Jam =
      <AttachmentNeedConfirmIzin3JamModel>[].obs;

  Future<List<AttachmentNeedConfirmIzin3JamModel>> attach(int id) async {
    final result = await service.hrGetAttachmentIzin3Jam(id);

    return result;
  }
}
