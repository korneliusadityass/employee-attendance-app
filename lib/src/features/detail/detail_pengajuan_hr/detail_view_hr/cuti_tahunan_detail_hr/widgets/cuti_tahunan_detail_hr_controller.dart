import 'package:get/get.dart';

import '../../../../../../core/model/hr_pengajuan_pembatalan/cuti_tahunan/detail_cuti_tahunan_model_hr.dart';
import '../../../../../../core/services/pengajuan_hr_services/cuti_tahunan_servicess/data_edit_cuti_tahunan_hr_services.dart';

class DetailViewCutiTahunanHrController extends GetxController {
  DetailDataCutiTahunanHrServices service;
  DetailViewCutiTahunanHrController(this.service);

  Future<DetailPengajuanCutiTahunanHrModel> execute(int id) async {
    final result = await service.fetchDataCutiTahunanHr(id);

    return result;
  }
}
