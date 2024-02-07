import 'package:get/get.dart';

import '../../../../../core/model/hr_pengajuan_pembatalan/cuti_tahunan/detail_cuti_tahunan_model_hr.dart';
import '../../../../../core/services/pengajuan_hr_services/cuti_tahunan_servicess/data_edit_cuti_tahunan_hr_services.dart';

class DetailCutiTahunanHrController extends GetxController {
  DetailDataCutiTahunanHrServices service;
  DetailCutiTahunanHrController(this.service);

  Future<DetailPengajuanCutiTahunanHrModel> execute(int id)async{
    final result = await service.fetchDataCutiTahunanHr(id);
    return result;
  }

  
  var downloading = false.obs;
  var progres = 0.obs;

  Future cutitahunanDownload(int idFile, String fileName) async{
    try{
      downloading.value = true;
      final result = await service.cutiTahunanDownload(idFile, fileName,(progressValue){
        progres.value = progressValue;
      });

      downloading.value = false;
      return result;
    } catch (e){
      Get.snackbar('Terjadi kesalahan', e.toString());
    }
  }
}
