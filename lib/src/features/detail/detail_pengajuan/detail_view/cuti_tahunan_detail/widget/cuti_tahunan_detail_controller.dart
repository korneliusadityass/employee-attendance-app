import 'package:get/get.dart';
import 'package:project/src/core/model/cuti_tahunan-model/detail_pengajuan_cuti_tahunan_model.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/cuti_tahunan_detail_services.dart';

class DetailCutiTahunanController extends GetxController {
  DetailDataCutiTahunanServices service;
  DetailCutiTahunanController(this.service);

  Future<DetailPengajuanCutiTahunanModel> execute(int id) async {
    final result = await service.fetchDataCutiTahunan(id);

    return result;
  }
}
