import 'package:get/get.dart';
import 'package:project/src/core/model/master/company/mastercompanydetail_model.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanydetail_service.dart';

class MasterCompanyDetailController extends GetxController {
  MasterCompanyDetailService service;
  MasterCompanyDetailController(this.service);

  Future<MasterCompanyDetailModel> execute(int id) async {
    final result = await service.fetchMasterCompanyDetail(id);

    return result;
  }
}
