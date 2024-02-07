import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/extensions/extension.dart';

import '../../../../../core/colors/color.dart';
import '../../../../../core/services/pengajuan_hr_services/cuti_tahunan_servicess/delete_attachment_cutitahunan_hr_services.dart';

class DeleteAttachmentCutiTahunanHrController extends GetxController {
  DeleteAttachmentCutiTahunanHrServicess service;
  DeleteAttachmentCutiTahunanHrController(this.service);

  Future deleteattachmentCutiTahunanHr(int idIzin, int idAttachment) async{
     try {
      final result =
          await service.deleteAttachmentCutiTahunanHr(idIzin, idAttachment);
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
                  'gagal delete attachment\nharap coba lagi',
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
      }, (success) {
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
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(6)),
                    color: kDarkGreenColor,
                  ),
                ),
                15.height,
                const Icon(
                  Icons.check_circle,
                  color: kGreenColor,
                  size: 80,
                ),
                15.height,
                const Text(
                  'Sukses delete attachment',
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
                    backgroundColor: kDarkGreenColor,
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
      });
    } catch (e) {
      Get.snackbar('terjadi kesalahan', e.toString());
    }
  }
}
