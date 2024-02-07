import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/colors/color.dart';
import 'package:project/src/core/routes/routes.dart';

import '../../../../../core/model/hr_pengajuan_pembatalan/cuti_khusus/hr_cuti_khusus_detail_model.dart';
import '../../../../../core/services/pengajuan_hr_services/cuti_khusus/hr_cuti_khusus_service.dart';
import '../../../../pengajuan_hr/cuti_khusus/widget/hr_cuti_khusus_controller.dart';

class DetailHrCutiKhususController extends GetxController {
  HRCutiKhususService service;
  DetailHrCutiKhususController(this.service);

  //detail
  Future<HrDetailCutiKhususModel> execute(int id) async {
    final result = await service.fetchDetailHrCutiKhusus(id);

    return result;
  }

  // confirm
  Future cutiKhususConfirm(
    int id,
  ) async {
    try {
      print('ID DARI CONTROLLER : $id');
      final result = await service.cutiKhususConfirm(id);
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
        Get.offNamed(Routes.pageHrCutiKhusus);
        Get.find<HrCutiKhususController>().execute();
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

  //delete
  Future cutiKhususdelete(
    int id,
  ) async {
    try {
      print('ID CONTROLLER $id');
      final result = await service.cutiKhususdelete(id);
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
                  'Gagal delete Cuti\nharap coba lagi',
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
        Get.toNamed(Routes.pageHrCutiKhusus);
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
}
