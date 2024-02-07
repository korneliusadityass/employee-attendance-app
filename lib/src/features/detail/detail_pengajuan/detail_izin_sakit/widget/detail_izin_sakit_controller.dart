import 'package:get/get.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_sakit_model/detail_pengajuan_izin_sakit_model.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/data_edit_izin_sakit_services.dart';

class DetailIzinSakitDataController extends GetxController {
  DetailDataIzinSakitServices service;
  DetailIzinSakitDataController(this.service);

  Future<DetailPengajuanIzinSakitModel> execute(int id) async {
    final result = await service.fetchDataIzinSakit(id);

    return result;
  }
}
