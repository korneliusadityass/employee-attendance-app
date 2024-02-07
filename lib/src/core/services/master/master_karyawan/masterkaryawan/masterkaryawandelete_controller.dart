import 'package:get/get.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawandelete_service.dart';

class MasterKaryawanDeleteController extends GetxController {
  MasterKaryawanDeleteService service;
  MasterKaryawanDeleteController(this.service);

  Future masterKaryawandelete(
    int id,
  ) async {
    await service.masterKaryawandelete(id);
  }
}
