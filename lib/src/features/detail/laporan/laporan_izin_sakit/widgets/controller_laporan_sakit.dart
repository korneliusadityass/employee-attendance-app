import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/laporan/izin_sakit/list_model_izin_sakit.dart';
import 'package:project/src/core/services/laporan/izin_sakit_service/export_laporan_izin_sakit_service.dart';
import 'package:project/src/core/services/laporan/izin_sakit_service/get_laporan_izin_sakit_service.dart';

class LaporanIzinSakitController extends GetxController
    with StateMixin<List<ListLaporanIzinSakitModel>> {
  GetLaporanIzinSakitService service;
  LaporanIzinSakitController(this.service);

  RxBool isFetchData = true.obs;
  RxInt iniId = 0.obs;

  RxList<ListLaporanIzinSakitModel> dataLaporanIzinSakit =
      <ListLaporanIzinSakitModel>[].obs;

  Future<List<ListLaporanIzinSakitModel>> execute(
    int id, {
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.fetchLaporanIzinSakit(
      id,
      page: page,
      size: size,
      filterStatus: filterStatus,
      filterNama: filterNama,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );
    iniId.value = id;
    return result;
  }



  @override
  void onReady() {
    super.onReady();
    execute(iniId.value).then((value) {
      change(dataLaporanIzinSakit.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}

class ExportLaporanIzinSakitController extends GetxController {
  ExportLaporanIzinSakitService service;
  ExportLaporanIzinSakitController(this.service);

  Future<List<ListLaporanIzinSakitModel>> exportLaporan(
    int id, {
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.exportLaporanIzinSakit(
      id,
      filterNama: filterNama,
      filterStatus: filterStatus,
      tanggalAwal: tanggalAwal,
      tanggalAkhir: tanggalAkhir,
    );

    return result.fold(
      (failure) {
        const Text('eror');
        return [];
      },
      (success) {
        print('SUKSES');
        print('HASIL: $success');
        return success;
      },
    );
  }
}
