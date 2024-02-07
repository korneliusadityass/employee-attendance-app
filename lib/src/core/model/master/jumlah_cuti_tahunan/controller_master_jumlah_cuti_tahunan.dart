import 'package:get/get.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/list_master_jumlah_cuti_tahunan_model.dart';
import 'package:project/src/core/model/master/jumlah_cuti_tahunan/services_master_jumlah_cuti_tahunan.dart';

class MasterJumlahCutiTahunanListController extends GetxController {
  MasterJumlahCutiTahunanListServices service;
  MasterJumlahCutiTahunanListController(this.service);

  RxBool isFetchData = false.obs;

  RxList<MasterJumlahCutiTahunanModel> MasterJumlahCutiTahunanList =
      <MasterJumlahCutiTahunanModel>[].obs;

  Future<List<MasterJumlahCutiTahunanModel>> execute({
    int page = 1,
    int size = 20,
    String order = 'asc',
    String sortBy = 'nama_karyawan',
    int tahun = 0,
    String nama = '',
    bool searchPerusahaan = false,
  }) async {
    isFetchData.value = true;
    print('bool controller : $searchPerusahaan');
    final result = await service.fetchMasterJumlahCutiTahunanListServices(
      page: page,
      size: size,
      order: order,
      sortBy: sortBy,
      tahun: tahun,
      nama: nama,
      searchPerusahaan: searchPerusahaan,
    );

    MasterJumlahCutiTahunanList.value = result;
    isFetchData.value = false;
    return MasterJumlahCutiTahunanList;
  }

  @override
  void onInit() {
    super.onInit();
    execute();
  }
}
