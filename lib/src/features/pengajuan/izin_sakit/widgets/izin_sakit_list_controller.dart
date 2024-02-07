import 'package:get/get.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_sakit_model/izin_sakit_model.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/izin_sakit_list_services.dart';

class IzinSakitListController extends GetxController {
  IzinSakitListServices service;
  IzinSakitListController(this.service);

  RxBool isFetchData = false.obs;

  RxList<IzinSakitModel> izinSakitList = <IzinSakitModel>[].obs;

  Future<List<IzinSakitModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    isFetchData.value = true;
    final result = await service.fetchIzinsakit(
      page: page,
      size: size,
      filterStatus: filterStatus,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );

    izinSakitList.value = result;
    isFetchData.value = false;
    return izinSakitList;
  }

  @override
  void onInit() {
    super.onInit();
    execute();
  }
}
