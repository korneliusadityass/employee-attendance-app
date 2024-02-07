import 'package:get/get.dart';
import 'package:project/src/core/services/master/master_company/mastercompany/mastercompanyedit_service.dart';

class MasterCompanyEditController extends GetxController {
  MasterCompanyEditService service;
  MasterCompanyEditController(this.service);

  Future<void> masterCompanyEdit(
    int id,
    String nama,
  ) async {
    await service.masterCompanyEdit(id, nama);
  }
}
