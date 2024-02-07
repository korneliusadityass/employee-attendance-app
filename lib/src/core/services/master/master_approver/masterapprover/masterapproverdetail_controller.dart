import 'package:get/get.dart';
import 'package:project/src/core/model/master/approver/masterapproverdetail_model.dart';
import 'package:project/src/core/services/master/master_approver/masterapprover/masterapproverdetail_service.dart';

class MasterApproverDetailController extends GetxController {
  MasterApproverDetailService service;
  MasterApproverDetailController(this.service);

  Future<MasterApproverDetailModel> execute(int id) async {
    final result = await service.fetchMasterApproverDetail(id);

    return result;
  }
}
