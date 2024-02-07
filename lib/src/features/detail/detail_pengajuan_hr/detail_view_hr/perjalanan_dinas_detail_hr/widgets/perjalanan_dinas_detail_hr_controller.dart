import 'package:get/get.dart';

import '../../../../../../core/model/hr_pengajuan_pembatalan/perjalanan_dinas/hr_perjalanan_dinas_detail_model.dart';
import '../../../../../../core/services/pengajuan_hr_services/perjalanan_dinas/hr_perjalanan_dinas_service.dart';

class DetailDataHrPerjalananDinasController extends GetxController {
  HRPerjalananDinasService service;
  DetailDataHrPerjalananDinasController(this.service);

  //detail
  Future<HrDetailPerjalananDinasModel> execute(int id) async {
    final result = await service.fetchDetailHrPerjalananDinas(id);

    return result;
  }

  // //download
  // var downloading = false.obs;
  // var progress = 0.obs;

  // Future PerjalananDinasDownload(int idFile, String fileName) async {
  //   try {
  //     downloading.value = true;
  //     final result = await service.PerjalananDinasDownload(idFile, fileName, (progressValue) {
  //       progress.value = progressValue;
  //     });

  //     downloading.value = false;
  //     return result;
  //   } catch (e) {
  //     Get.snackbar('Terjadi kesalahan', e.toString());
  //   }
  // }

//   //list attachment
//   RxInt idController = 0.obs;

//   RxList<PerjalananDinasAttachmentModel> attachment =
//       <PerjalananDinasAttachmentModel>[].obs;

//   Future<List<PerjalananDinasAttachmentModel>> attach(int id) async {
//     final result = await service.PerjalananDinasGetAttachment(id);

//     return result;
//   }
}
