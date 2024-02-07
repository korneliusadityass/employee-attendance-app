import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/laporan/cuti_tahunan/list_laporan_cuti_tahunan_model.dart';
import 'package:project/src/core/services/laporan/cuti_tahunan_service/export_laporan_cuti_tahunan_service.dart';
import 'package:project/src/core/services/laporan/cuti_tahunan_service/get_laporan_cuti_tahunan_service.dart';

class LaporanCutiTahunanController extends GetxController
    with StateMixin<List<ListLaporanCutiTahunanModel>> {
  GetLaporanCutiTahunanService service;
  LaporanCutiTahunanController(this.service);

  RxBool isFetchData = true.obs;
  RxInt iniId = 0.obs;
  RxInt pageSize = 10.obs;
  RxString filterStatus2 = 'All'.obs;

  RxList<ListLaporanCutiTahunanModel> dataLaporanCutiTahunan =
      <ListLaporanCutiTahunanModel>[].obs;

  Future<List<ListLaporanCutiTahunanModel>> execute(
    int id, {
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.fetchLaporanCutitahunan(
      id,
      page: page,
      size: pageSize.value,
      filterStatus: filterStatus2.value,
      filterNama: filterNama,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );
    iniId.value = id;
    return result;
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   execute(iniId.value).then((value) {
  //     change(dataLaporanCutiTahunan.value = value, status: RxStatus.success());
  //   }).catchError((e) {
  //     change(null, status: RxStatus.error(e.toString()));
  //   }).whenComplete(() => isFetchData.value = false);
  // }

  @override
  void onReady() {
    super.onReady();
    execute(iniId.value).then((value) {
      change(dataLaporanCutiTahunan.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}

class ExportLaporanCutiTahunanController extends GetxController {
  ExportLaporanCutiTahunanService service;
  ExportLaporanCutiTahunanController(this.service);

  Future<List<ListLaporanCutiTahunanModel>> exportLaporan(
    int id, {
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.exportLaporanCutiTahunan(
      id,
      filterNama: filterNama,
      filterStatus: filterStatus,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );

    return result.fold(
      (failure) {
        const Text('eerorbg');
        return [];
      },
      (success) {
        print('INI SUKSES');
        print('HASIL SUKSES : $success');
        return success;
      },
    );
  }
}
