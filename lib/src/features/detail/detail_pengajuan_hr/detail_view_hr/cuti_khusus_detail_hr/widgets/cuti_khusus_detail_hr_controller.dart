import 'package:get/get.dart';

import '../../../../../../core/model/hr_pengajuan_pembatalan/cuti_khusus/hr_cuti_khusus_detail_model.dart';
import '../../../../../../core/services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_service.dart';

class DetailDataHrCutiKhususController extends GetxController {
  HRCutiKhususService service;
  DetailDataHrCutiKhususController(this.service);

  //detail
  Future<HrDetailCutiKhususModel> execute(int id) async {
    final result = await service.fetchDetailHrCutiKhusus(id);

    return result;
  }

  // //download
  // var downloading = false.obs;
  // var progress = 0.obs;

  // Future cutiKhususDownload(int idFile, String fileName) async {
  //   try {
  //     downloading.value = true;
  //     final result = await service.cutiKhususDownload(idFile, fileName, (progressValue) {
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

//   RxList<CutiKhususAttachmentModel> attachment =
//       <CutiKhususAttachmentModel>[].obs;

//   Future<List<CutiKhususAttachmentModel>> attach(int id) async {
//     final result = await service.cutiKhususGetAttachment(id);

//     return result;
//   }
}
