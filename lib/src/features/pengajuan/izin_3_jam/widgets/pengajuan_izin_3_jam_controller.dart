import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/colors/color.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_3_jam_model/list_izin_3_jam_model.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/cancelled_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/izin_3_jam_list_service.dart';

import '../../../../core/services/pengajuan/izin_3_jam_service/izin_3_jam_service.dart';

class PengajuanIzin3JamController extends GetxController with StateMixin<int> {
  PengajuanIzin3JamService service;
  PengajuanIzin3JamController(this.service);

  RxInt id = 0.obs;

  Future pengajuan(
    String judul,
    String tanggalIjin,
    String waktuAwal,
    String waktuAkhir,
  ) async {
    try {
      final result = await service.pengajuanIzin3Jam(
          judul, tanggalIjin, waktuAwal, waktuAkhir);
      result.fold((failure) {
        Get.dialog(Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 278,
            height: 270,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 31,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    color: kRedColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Icon(
                  Icons.warning_amber,
                  color: kRedColor,
                  size: 80,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Hari yang diinput\ntelah diisi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: kBlackColor,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: kRedColor,
                    fixedSize: const Size(120, 45),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Oke',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      }, (success) async {
        await Get.toNamed(Routes.detailIzin3Jam, arguments: success);
      });
    } catch (e) {
      Get.snackbar('Terjadi kesalahan', e.toString());
    }
  }
}

class Izin3JamListController extends GetxController
    with StateMixin<List<ListIzin3JamModel>> {
  Izin3JamListService service;
  Izin3JamListController(this.service);

  RxBool isFetchData = true.obs;
  RxInt pageNum = 1.obs;
  RxInt pageSize = 10.obs;
  RxString filterStatus2 = 'All'.obs;

  RxList<ListIzin3JamModel> dataIzin3Jam = <ListIzin3JamModel>[].obs;

  Future<List<ListIzin3JamModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    isFetchData.value = true;
    final result = await service.fetchIzin3Jam(
      filterStatus: filterStatus2.value,
      page: pageNum.value,
      size: pageSize.value,
      tanggalAkhir: tanggalAkhir,
      tanggalAwal: tanggalAwal,
    );
    dataIzin3Jam.value = result;
    isFetchData.value = false;
    return result;
  }

  @override
  void onInit() {
    super.onInit();
    // execute().then((value) {
    //   change(dataIzin3Jam.value = value, status: RxStatus.success());
    // }).catchError((e) {
    //   change(null, status: RxStatus.error(e.toString()));
    // }).whenComplete(() => isFetchData.value = false);
    execute();
  }
}

class CancelPengajuanIzin3JamController extends GetxController {
  CancelledIzin3JamService service;
  CancelPengajuanIzin3JamController(this.service);

  Future cancelIzin3Jam(int id) async {
    try {
      final result = await service.cancelledIzin3Jam(id);
      result.fold((failure) {
        Get.dialog(Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 278,
            height: 270,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 31,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    color: kRedColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Icon(
                  Icons.warning_amber,
                  color: kRedColor,
                  size: 80,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Gagal cancel pengajuan\nharap coba lagi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: kBlackColor,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: kRedColor,
                    fixedSize: const Size(120, 45),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Oke',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      }, (success) {
        Get.dialog(Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 278,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 31,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    color: kDarkGreenColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Icon(
                  Icons.check_circle,
                  color: kGreenColor,
                  size: 80,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Sukses cancel pengajuan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: kBlackColor,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: kDarkGreenColor,
                    fixedSize: const Size(120, 45),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Oke',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      });
    } catch (e) {
      Get.snackbar('Terjadi kesalahan', e.toString());
    }
  }
}
