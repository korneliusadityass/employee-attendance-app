import 'package:get/get.dart';
import 'package:project/src/core/model/cuti_tahunan-model/detail_pengajuan_cuti_tahunan_model.dart';

import '../../../../../core/services/pengajuan/cuti_tahunan_services/data_edit_cuti_tahunan_services.dart';

class DetailCutiTahunanDataController extends GetxController {
  DetailDataCutiTahunanServicess service;
  DetailCutiTahunanDataController(this.service);

  Future<DetailPengajuanCutiTahunanModel> execute(int id) async {
    final result = await service.fetchDataCutiTahunan(id);
    return result;
  }
}
