import 'package:get/get.dart';

import '../../../../../core/services/pengajuan_hr_services/cuti_tahunan_servicess/edit_cuti_tahunan_hr_services.dart';

class EditCutiTahunanHrController extends GetxController {
  EditCutiTahunanHrServices service;
  EditCutiTahunanHrController(this.service);

  Future editCutiTahunanHr(
    int id,
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    await service.editIzinSakitt(id, judul, tanggalAwal, tanggalAkhir);
  }
}
