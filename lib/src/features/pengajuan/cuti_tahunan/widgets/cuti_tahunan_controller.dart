import 'package:get/get.dart';
import 'package:project/src/core/model/cuti_tahunan-model/cuti_tahunan_model.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/cuti_tahunan_list_services.dart';

class CutiTahunanListController extends GetxController {
  CutiTahunanListServices services;
  CutiTahunanListController(this.services);

  RxBool isFetchData = false.obs;

  RxList<CutitahunanModel> cutiTahunanList = <CutitahunanModel>[].obs;

  Future<List<CutitahunanModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    isFetchData.value = true;
    final result = await services.fetchCutiTahunan(
      page: page,
      size: size,
      filterStatus: filterStatus,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );

    cutiTahunanList.value = result;
    isFetchData.value = false;
    return cutiTahunanList;
  }

  @override
  void onInit() {
    super.onInit();
    execute();
  }
}
