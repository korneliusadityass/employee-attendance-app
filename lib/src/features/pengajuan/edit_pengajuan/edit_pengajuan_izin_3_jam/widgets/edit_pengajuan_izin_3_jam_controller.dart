import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/src/core/colors/color.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_3_jam_model/attachment_izin_3_jam_model.dart';
import 'package:project/src/core/model/pengajuan_pembatalan/izin_3_jam_model/data_pengajuan_izin_3_jam_model.dart';
import 'package:project/src/core/routes/routes.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/data_edit_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/delete_attachment_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/edit_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/get_attachment_izin_3_jam_service.dart';
import 'package:project/src/core/services/pengajuan/izin_3_jam_service/input_attachment_izin_3_jam.dart';
import 'package:project/src/features/pengajuan/izin_3_jam/widgets/pengajuan_izin_3_jam_controller.dart';

class EditIzin3JamController extends GetxController {
  EditIzin3JamService service;
  EditIzin3JamController(this.service);

  Future editIzin3Jam(
    int id,
    String judul,
    String tanggal,
    String waktuAwal,
    String waktuAkhir,
  ) async {
    await service.editIzin3Jam(id, judul, tanggal, waktuAwal, waktuAkhir);
  }
}

class DataEditIzin3JamController extends GetxController {
  DataIzin3JamService service;
  DataEditIzin3JamController(this.service);

  Future<DataPengajuanIzin3JamModel> execute(int id) async {
    final result = await service.fetchDataIzin3Jam(id);

    return result;
  }
}

class GetAttachmentEditIzin3JamController extends GetxController
    with StateMixin<List<AttachmentIzin3JamModel>> {
  GetAttachmentIzin3JamService2 service;
  GetAttachmentEditIzin3JamController(this.service);

  RxInt idController = 0.obs;

  RxList<AttachmentIzin3JamModel> attachmentIzin3Jam =
      <AttachmentIzin3JamModel>[].obs;

  Future<List<AttachmentIzin3JamModel>> attach(int id) async {
    final result = await service.getAttachmentIzin3Jam(id);

    return result;
  }
}

class InputAttachmentConfirmedApprovedEditIzin3JamController
    extends GetxController {
  InputAttachmentIzin3JamService2 service;
  InputAttachmentConfirmedApprovedEditIzin3JamController(this.service);

  Future inputAttachmentConfirmedApprovedIzin3Jam(
    int id,
    List<File> files,
  ) async {
    try {
      final result = await service.inputAttachmentIzin3Jam(id, files);
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
                  'Gagal update attachment\nharap coba lagi',
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
        Get.offNamed(Routes.pageIzin3Jam);
        Get.find<Izin3JamListController>().execute();
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
                  'Sukses update attachment',
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

class InputAttachmentEditIzin3JamController extends GetxController {
  InputAttachmentIzin3JamService2 service;
  InputAttachmentEditIzin3JamController(this.service);

  Future inputAttachmentIzin3Jam(
    int id,
    List<File> files,
  ) async {
    await service.inputAttachmentIzin3Jam(id, files);
  }
}

class DeleteAttachmentEditIzin3JamController extends GetxController {
  DeleteAttachmentIzin3JamService2 service;
  DeleteAttachmentEditIzin3JamController(this.service);

  Future deleteAttachmentEdit3Jam(int idIjin, int idAttachment) async {
    try {
      final result =
          await service.deleteAttachmentIzin3Jam(idIjin, idAttachment);
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
                  'Gagal delete attachment\nharap coba lagi',
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
            height: 270,
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
                  'Sukses delete attachment',
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
