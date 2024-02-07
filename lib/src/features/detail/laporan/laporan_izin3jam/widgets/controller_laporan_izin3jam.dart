import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/model/laporan/izin_3jam/list_model_ijin3_jam.dart';
import 'package:project/src/core/services/laporan/izin_3jam_service/export_laporan_izin_3jam_service.dart';
import 'package:project/src/core/services/laporan/izin_3jam_service/get_laporan_izin_3jam_service.dart';

class LaporanIzin3JamController extends GetxController
    with StateMixin<List<ListLaporanIzin3JamModel>> {
  GetLaporanIzin3JamService service;
  LaporanIzin3JamController(this.service);

  RxBool isFetchData = true.obs;
  RxInt iniId = 0.obs;

  RxList<ListLaporanIzin3JamModel> dataLaporanIzin3Jam =
      <ListLaporanIzin3JamModel>[].obs;

  Future<List<ListLaporanIzin3JamModel>> execute(
    int id, {
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.fetchLaporanIzin3Jam(
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
      change(dataLaporanIzin3Jam.value = value, status: RxStatus.success());
    }).catchError((e) {
      change(null, status: RxStatus.error(e.toString()));
    }).whenComplete(() => isFetchData.value = false);
  }
}

class ExportLaporanIzin3JamController extends GetxController {
  ExportLaporanIzin3JamService service;
  ExportLaporanIzin3JamController(this.service);

  Future<List<ListLaporanIzin3JamModel>> exportLaporan(
    int id, {
    String filterStatus = 'All',
    String? filterNama,
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    final result = await service.exportLaporanIzin3Jam(
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
        print('Berhasil');
        print('Hasil : $success');
        return success;
      },
    );
  }
}
