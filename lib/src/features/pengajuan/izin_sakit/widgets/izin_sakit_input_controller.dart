import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/core/services/pengajuan/izin_sakit_services/izin_sakit_input_services.dart';

import '../../../../core/colors/color.dart';
import '../../../../core/routes/routes.dart';

class InputIzinSakitController extends GetxController {
  IzinSakitInputServices services;
  InputIzinSakitController(this.services);

  RxInt id = 0.obs;

  Future inputPengajuan(
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final result = await services.izinSakitInputServices(
        judul,
        tanggalAwal,
        tanggalAkhir,
      );
      print('RESULT ID :$result');
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
                15.height,
                const Icon(
                  Icons.warning_amber,
                  color: kRedColor,
                  size: 80,
                ),
                15.height,
                const Text(
                  'Hari yang diinput\ntelah diisi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: kBlackColor,
                  ),
                ),
                24.height,
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
        await Get.toNamed(Routes.detailIzinSakitt, arguments: success);
      });
    } catch (e) {
      Get.snackbar('Terjadi Kesalahan', e.toString());
    }
  }
}
