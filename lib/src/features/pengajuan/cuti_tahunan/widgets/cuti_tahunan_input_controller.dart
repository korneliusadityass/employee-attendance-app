import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/colors/color.dart';
import 'package:project/src/core/extensions/extension.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/services/pengajuan/cuti_tahunan_services/cuti_tahunan_input_services.dart';

class InputCutitahunanController extends GetxController {
  InputCutiTahunanServices services;
  InputCutitahunanController(this.services);

  RxInt id = 0.obs;

  Future inputCutiTahuanPengajuan(
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final result = await services.inputCutitahuananServices(
          judul, tanggalAwal, tanggalAkhir);
      print('result id:$result');
      result.fold((failure) {
        Get.dialog(Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            width: 278,
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 31,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(6),
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
                  'Hari yang diinput\nsudah diisi',
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
                      borderRadius: BorderRadius.circular(6),
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
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      }, (success) async {
        await Get.toNamed(Routes.detailCutiTahunan, arguments: success);
      });
    } catch (e) {
      Get.snackbar('terjadi kesalahan', e.toString());
    }
  }
}
