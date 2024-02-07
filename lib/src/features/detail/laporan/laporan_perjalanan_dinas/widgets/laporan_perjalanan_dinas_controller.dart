import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/laporan/perjalanan_dinas/list_laporan_perjalanan_dinas_model.dart';
import 'package:project/src/core/services/laporan/perjalanan_dinas_service/export_laporan_perjalanan_dinas_service.dart';
import 'package:project/src/core/services/laporan/perjalanan_dinas_service/get_laporan_perjalanan_dinas_service.dart';

class LaporanPerjalananDinasController extends GetxController
    with StateMixin<List<ListLaporanPerjalananDinasModel>> {
  GetLaporanPerjalananDinasService service;
  LaporanPerjalananDinasController(this.service);

  RxBool isFetchData = true.obs;
  RxInt iniId = 0.obs;
  RxInt pageSize = 10.obs;
  RxString filterStatus2 = 'All'.obs;

  RxList<ListLaporanPerjalananDinasModel> dataLaporanPerjalananDinas =
      <ListLaporanPerjalananDinasModel>[].obs;

  Future<List<ListLaporanPerjalananDinasModel>> execute(
    int id, {
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.fetchLaporanPerjalananDinas(
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
      change(dataLaporanPerjalananDinas.value = value,
          status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}

class ExportLaporanPerjalananDinasController extends GetxController {
  ExportLaporanPerjalananDinasService service;
  ExportLaporanPerjalananDinasController(this.service);

  Future<List<ListLaporanPerjalananDinasModel>> exportLaporan(
    int id, {
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.exportLaporanPerjalananDinas(
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
