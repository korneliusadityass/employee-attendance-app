import 'package:get/get.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanydelete_service.dart';

class MasterCompanyDeleteController extends GetxController {
  MasterCompanyDeleteService service;
  MasterCompanyDeleteController(this.service);

  Future masterCompanydelete(int id) async {
    await service.masterCompanydelete(id);
  }
}
