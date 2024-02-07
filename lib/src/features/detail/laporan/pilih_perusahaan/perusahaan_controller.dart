import 'dart:developer';

import 'package:get/get.dart';
import 'package:project/src/core/model/laporan/list_perusahaan_model/list_perusahaan_model.dart';
import 'package:project/src/core/services/laporan/pilih_perusahaan/list_perusahaan_service.dart';

class PerusahaanController extends GetxController
    with StateMixin<List<ListPerusahaanModel>> {
  GetPerusahaanLaporanService service;
  PerusahaanController(this.service);

  RxBool isFetchData = true.obs;

  RxList<ListPerusahaanModel> listPerusahaan = <ListPerusahaanModel>[].obs;

  Future<List<ListPerusahaanModel>> execute({
    int page = 1,
    int size = 10,
    String? filterNama,
  }) async {
    final result = await service.fetchListPerusahaan(
      page: page,
      size: size,
      filterNama: filterNama,
    );
    listPerusahaan.value = result;
    update();
    inspect(result);
    inspect(listPerusahaan.value);
    return result;
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   execute().then((value) {
  //     change(listPerusahaan.value = value, status: RxStatus.success());
  //   }).catchError((e) {
  //     change(null, status: RxStatus.error(e.toString()));
  //   }).whenComplete(() => isFetchData.value = false);
  // }
}
