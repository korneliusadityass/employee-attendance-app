import 'package:get/get.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanedit_service.dart';

import 'masterkaryawanlist_controller.dart';

class MasterKaryawanEditController extends GetxController {
  MasterKaryawanEditService service;
  MasterKaryawanEditController(this.service);

  Future<void> masterKaryawanEdit({
    required int id,
    required int perusahaanId,
    required String namakaryawan,
    required String tempatlahir,
    required String tanggallahir,
    required String alamat,
    required String nohp,
    required String email,
    required String level,
    required String posisi,
    required String password,
    String? newPassword,
  }) async {
    await service.masterKaryawanEdit(
      alamat: alamat,
      email: email,
      id: id,
      perusahaanId: perusahaanId,
      namakaryawan: namakaryawan,
      tanggallahir: tanggallahir,
      tempatlahir: tempatlahir,
      nohp: nohp,
      level: level,
      posisi: posisi,
      password: password,
      newPassword: newPassword,
    );
    Get.find<MasterKaryawanListController>().execute();
  }
}
