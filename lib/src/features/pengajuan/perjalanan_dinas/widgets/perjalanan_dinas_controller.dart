import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/colors/color.dart';
import 'package:project/src/core/routes/routes.dart';

import '../../../../core/model/pengajuan_pembatalan/perjalanan_dinas/perjalanan_dinas_list_model.dart';
import '../../../../core/services/pengajuan/perjalanan_dinas_service/pengajuan_perjalanan_dinas_service.dart';

class PerjalananDinasController extends GetxController with StateMixin<List<PerjalananDinasListModel>> {
  PengajuanPerjalananDinasService service;
  PerjalananDinasController(this.service);

  //list
  RxBool isFetchData = false.obs;
  RxInt pageNum = 1.obs;
  RxInt pageSize = 10.obs;
  RxString filterStatus2 = 'All'.obs;
  RxList<PerjalananDinasListModel> dataPerjalananDinas = <PerjalananDinasListModel>[].obs;

  Future<List<PerjalananDinasListModel>> execute({
    int page = 1,
    int size = 10,
    String filterStatus = 'All',
    String? tanggalAwal,
    String? tanggalAkhir,
  }) async {
    isFetchData.value = true;
    final result = await service.fetchPerjalananDinanList(
      filterStatus: filterStatus,
      page: page,
      size: size,
      tanggalAkhir: tanggalAkhir,
      tanggalAwal: tanggalAwal,
    );

    dataPerjalananDinas.value = result;
    isFetchData.value = false;
    return dataPerjalananDinas.value;
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   execute().then((value) {
  //     change(dataPerjalananDinas.value = value, status: RxStatus.success());
  //   }).catchError((e) {
  //     change(null, status: RxStatus.error(e.toString()));
  //   }).whenComplete(() => isFetchData.value = false);
  // }

  @override
  void onInit() {
    super.onInit();
    execute();
  }

  //input
  RxInt id = 0.obs;

  Future inputPerjalananDinas(
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final result = await service.inputPerjalananDinas(judul, tanggalAwal, tanggalAkhir);
      print('RESULT ID :$result');
      result.fold((failure) {
        Get.dialog(Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 278,
            height: 270,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
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
        await Get.toNamed(Routes.detailPerjalananDinas, arguments: success);
      });
    } catch (e) {
      Get.snackbar('Terjadi kesalahan', e.toString());
    }
  }

  //cancel
  Future perjalananDinasCancel(int id) async {
    try {
      final result = await service.perjalananDinasCancel(id);
      result.fold((failure) {
        Get.dialog(Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 278,
            height: 270,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
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

   //delete
  Future perjalananDinasdelete(
    int id,
  ) async {
    try {
      print('ID CONTROLLER $id');
      final result = await service.perjalananDinasDelete(id);
      result.fold((failure) {
        Get.dialog(Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 278,
            height: 270,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
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
                  'Gagal delete Perjalanan Dinas\nharap coba lagi',
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
        Get.toNamed(Routes.pagePerjalananDinas);
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
                  'Sukses delete cuti',
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

  //confirm
  Future perjalananDinasConfirm(
    int id,
  ) async {
    try {
      print('ID DARI CONTROLLER : $id');
      final result = await service.perjalananDinasConfirm(id);
      result.fold((failure) {
        Get.dialog(Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 278,
            height: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
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
                  color: kYellowColor,
                  size: 80,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Gagal mengirim konfirmasi\nharap coba lagi',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
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
        Get.offNamed(Routes.pagePerjalananDinas);
        Get.find<PerjalananDinasController>().execute();
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
                  'Pengajuan telah dikirim\nmenunggu konfirmasi Pimpinan dan HR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
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
