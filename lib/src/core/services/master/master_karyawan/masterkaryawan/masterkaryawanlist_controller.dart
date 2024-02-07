import 'package:get/get.dart';
import 'package:project/src/core/services/master/master_karyawan/masterkaryawan/masterkaryawanlist_service.dart';

import '../../../../model/master/karyawan/masterkaryawanlist_model.dart';


class MasterKaryawanListController extends GetxController
    with StateMixin<List<MasterKaryawanListModel>> {
  MasterKaryawanListService masterkaryawanlistService;
  MasterKaryawanListController(this.masterkaryawanlistService);

  RxBool isFetchData = true.obs;

  RxList<MasterKaryawanListModel> dataKaryawan =
      <MasterKaryawanListModel>[].obs;

  Future<List<MasterKaryawanListModel>> execute({
   int page = 1,
    int size = 10,
    String order = 'asc',
    int perusahaanId = 0,
    String? filterNama,
  }) async {
    return await masterkaryawanlistService.fetchListKaryawan(
        page: page,
        size: size,
        order: order,
        perusahaanId: perusahaanId,
        filterNama: filterNama);
  }

   @override
    void onInit() {
    super.onInit();
    execute().then((value) {
      change(dataKaryawan.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}
