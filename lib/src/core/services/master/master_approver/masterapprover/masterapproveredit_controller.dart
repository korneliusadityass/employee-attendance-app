import 'package:get/get.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproveredit_service.dart';

import 'masterapproverlist_controller.dart';

class MasterApproverEditController extends GetxController {
  MasterApproverEditService service;
  MasterApproverEditController(this.service);

  Future<void> masterApproverEdit({required int id, required int approverid, required int karyawanid}) async {
    await service.masterApproverEdit(id: id, approverid: approverid, karyawanid: karyawanid);
    Get.find<MasterApproverListController>().execute();
  }
}
