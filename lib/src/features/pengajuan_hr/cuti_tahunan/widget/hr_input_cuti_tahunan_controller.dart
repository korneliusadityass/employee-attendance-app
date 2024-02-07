import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';

import '../../../../core/colors/color.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/pengajuan_hr_services/cuti_tahunan_servicess/input_cuti_tahunan_hr_services.dart';

class HrInputCutiTahunanController extends GetxController {
  HrCutiTahunanInputServices service;
  HrInputCutiTahunanController(this.service);

  RxInt id = 0.obs;

  Future hrInputCutiTahunan(
    int id,
    String judul,
    String tanggalAwal,
    String tanggalAkhir,
  ) async {
    try {
      final result = await service.hrCutiTahunanServices(
        id,
        judul,
        tanggalAwal,
        tanggalAkhir,
      );
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
        await Get.toNamed(Routes.hrDetailCutiTahunan, arguments: success);
      });
    } catch (e) {
      Get.snackbar('terjadi kesalahan', e.toString());
    }
  }
}


