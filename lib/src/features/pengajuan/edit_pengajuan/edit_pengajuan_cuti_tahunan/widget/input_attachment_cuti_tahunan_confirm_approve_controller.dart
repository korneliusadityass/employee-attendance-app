import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/colors/color.dart';
import 'package:project/src/core/extensions/extension.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/core/services/pengajuan/cuti_tahunan_services/input_attachment_cuti_tahunan_services.dart';

class InputAttachmentConfirmApproveEditCutiTahunanController
    extends GetxController {
  InputAttachmentCutiTahunanServicess service;
  InputAttachmentConfirmApproveEditCutiTahunanController(this.service);

  Future inputAttachmentConfirmApproveCutiTahunan(
    int id,
    List<File> files,
  ) async {
    try {
      final result = await service.inputAttachmentCutiTahunan(id, files);
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ),
                15.height,
                Icon(
                  Icons.warning_amber,
                  color: kRedColor,
                  size: 80,
                ),
                15.height,
                Text(
                  'Gagal update attachment\nharap coba lagi',
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
                    fixedSize: Size(120, 45),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
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
        Get.toNamed(Routes.pageCutiTahunan);
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    color: kDarkGreenColor,
                  ),
                ),
                15.height,
                Icon(
                  Icons.check_circle,
                  color: kGreenColor,
                  size: 80,
                ),
                15.height,
                Text(
                  'Sukses update attachment',
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
                    fixedSize: Size(120, 45),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
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
      Get.snackbar('terjadi kesalahan', e.toString());
    }
  }
}
