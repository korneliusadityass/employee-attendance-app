import 'package:get/get.dart';

import '../../../../../core/model/pengajuan_pembatalan/izin_sakit_model/detail_pengajuan_izin_sakit_model.dart';
import '../../../../../core/services/pengajuan_hr_services/izin_sakit_services/data_edit_izin_sakit_services.dart';

class DataEditIzinSakitHrController extends GetxController {
  DetailDataIzinSakitHrServices service;
  DataEditIzinSakitHrController(this.service);

  Future<DetailPengajuanIzinSakitModel> execute(int id) async {
    final result = await service.fetchDataIzinSakitHr(id);

    return result;
  }
}
