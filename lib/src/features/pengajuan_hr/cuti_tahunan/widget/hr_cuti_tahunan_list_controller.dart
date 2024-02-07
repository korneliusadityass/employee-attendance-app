import 'package:get/get.dart';

import '../../../../core/model/hr_pengajuan_pembatalan/cuti_tahunan/cuti_tahunan_model_hr.dart';
import '../../../../core/services/pengajuan_hr_services/cuti_tahunan_servicess/list_cuti_tahunan_hr_services.dart';

class CutiTahunanHrListController extends GetxController {
  CutiTahunanHrListServices service;
  CutiTahunanHrListController(this.service);

  RxBool isFetchData = false.obs;

  RxList<CutiTahunanHrModel> cutiTahunanHrList = <CutiTahunanHrModel>[].obs;

  Future<List<CutiTahunanHrModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    isFetchData.value = true;
    final result = await service.fetchCutiTahunan(
      page: page,
      size: size,
      filterStatus: filterStatus,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );

    cutiTahunanHrList.value = result;
    isFetchData.value = false;
    return cutiTahunanHrList;
  }

  @override
  void onInit() {
    super.onInit();
    execute();
  }
}
