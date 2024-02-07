import 'package:get/get.dart';

import '../../../../../core/services/pengajuan/izin_sakit_services/edit_izin_sakit_services.dart';

class EditIzinSakitController extends GetxController {
  EditizinSakitServicess service;
  EditIzinSakitController(this.service);

  Future editIzinSakit(
    int id,
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    await service.editIzinSakitt(id, judul, tanggalAwal, tanggalAkhir);
  }
}
