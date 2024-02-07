import 'package:get/get.dart';
import 'package:project/src/core/model/hr_pengajuan_pembatalan/izin_sakit/list_izin_sakit_hr_model.dart';

import '../../../../core/services/pengajuan_hr_services/izin_sakit_services/hr_list_services.dart';

class HrIzinSakitListController extends GetxController {
  HRIzinSakitListServicess service;
  HrIzinSakitListController(this.service);

  RxBool isFetchData = false.obs;
  RxInt pageSize = 10.obs;
  RxString filterStatus2 = 'All'.obs;

  RxList<HrListIzinSakitModel> hrIzinSakitList = <HrListIzinSakitModel>[].obs;

  Future<List<HrListIzinSakitModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    isFetchData.value = true;
    final result = await service.fetchIzinsakitHr(
      page: page,
      size: pageSize.value,
      filterStatus: filterStatus2.value,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );

    hrIzinSakitList.value = result;
    isFetchData.value = false;
    return hrIzinSakitList;
  }

  @override
  void onInit() {
    super.onInit();
    execute();
  }
}
