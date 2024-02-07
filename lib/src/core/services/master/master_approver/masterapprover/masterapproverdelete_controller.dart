import 'package:get/get.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverdelete_service.dart';

class MasterApproverDeleteController extends GetxController {
  MasterApproverDeleteService service;
  MasterApproverDeleteController(this.service);

  Future masterApproverdelete(int id) async {
    await service.masterApproverdelete(id);
  }
}
