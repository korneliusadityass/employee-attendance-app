import 'package:get/get.dart';

import '../../../../core/enums/sisa_kuota_enum.dart';
import '../../../../core/services/pengajuan/cuti_tahunan_services/total_cuti_tahunan_services.dart';

class SisaKuotaController extends GetxController {
  SisaKuotaCutiTahunanServices service;
  SisaKuotaController(this.service);

  Future<int?> getKuotaCutiTahunan({required SisaKuota kuotaCuti}) async {
    final response = await service.getSisaCutiTahunan();
    return response;
  }
}
