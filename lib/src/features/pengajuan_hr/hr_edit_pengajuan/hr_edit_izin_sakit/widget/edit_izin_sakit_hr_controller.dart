import 'package:get/get.dart';

import '../../../../../core/services/pengajuan_hr_services/izin_sakit_services/edit_izin_sakit_hr_services.dart';

class EditIzinSakitHrController extends GetxController {
  EditizinSakitHrServicess service;
  EditIzinSakitHrController(this.service);

  Future editIzinSakitHr(
    int id,
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    await service.editIzinSakitt(id, judul, tanggalAwal, tanggalAkhir);
  }
}
