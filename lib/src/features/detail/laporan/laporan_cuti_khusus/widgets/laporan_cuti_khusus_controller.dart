import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/laporan/cuti_khusus/list_laporan_cuti_khusus_model.dart';
import 'package:project/src/core/services/laporan/cuti_khusus_service/export_laporan_cuti_khusus_service.dart';
import 'package:project/src/core/services/laporan/cuti_khusus_service/get_laporan_cuti_khusus_service.dart';

class LaporanCutiKhususController extends GetxController
    with StateMixin<List<ListLaporanCutiKhususModel>> {
  GetLaporanCutiKhususService service;
  LaporanCutiKhususController(this.service);

  RxBool isFetchData = true.obs;
  RxInt iniId = 0.obs;
  RxInt pageSize = 10.obs;
  RxString filterStatus2 = 'All'.obs;

  RxList<ListLaporanCutiKhususModel> dataLaporanCutiKhusus =
      <ListLaporanCutiKhususModel>[].obs;

  Future<List<ListLaporanCutiKhususModel>> execute(
    int id, {
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.fetchLaporanCutiKhusus(
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
      change(dataLaporanCutiKhusus.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}

class ExportLaporanCutiKhususController extends GetxController {
  ExportLaporanCutiKhususService service;
  ExportLaporanCutiKhususController(this.service);

  Future<List<ListLaporanCutiKhususModel>> exportLaporan(
    int id, {
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.exportLaporanCutiKhusus(
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
