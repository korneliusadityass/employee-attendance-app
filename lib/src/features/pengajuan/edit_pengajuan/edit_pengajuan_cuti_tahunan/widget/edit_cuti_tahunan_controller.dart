import 'package:get/get.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/edit_cuti_tahunan_services.dart';

class EditCutiTahunanController extends GetxController {
  EditCutiTahunanServicess service;
  EditCutiTahunanController(this.service);

  Future editCutiTahunan(
    int id,
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    await service.editCutiTahunann(id, judul, tanggalAwal, tanggalAkhir);
  }
}
