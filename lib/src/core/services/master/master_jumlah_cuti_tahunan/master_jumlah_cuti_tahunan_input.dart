import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../colors/color.dart';
import '../../../helper/auth_pref_helper.dart';

class MasterCutiTahunanGenerateService {
  final url = 'http://192.168.2.155:8000/master_cuti_tahunan/input';
  Dio dio = Dio();
  final pref = Get.find<AuthStorageHelper>();

  Future<void> generateMasterJumlahCutiTahunan(
    String tahun,
    int jumlahCuti,
    BuildContext context,
  ) async {
    if (jumlahCuti < 0) {
      throw ArgumentError('Jumlah cuti tidak boleh negatif');
    }

    try {
      final tokenResponse = '';
      final tokenJson = jsonDecode(tokenResponse);
      final token = tokenJson['access_token'];
      final headers = {
        'Authorization': 'Bearer $token',
      };

      print('Ini jumlah cuti service: $jumlahCuti');

      final response = await dio.post(
        url,
        options: Options(
          headers: headers,
        ),
        data: {
          'tahun': tahun,
          'kuota_cuti_tahunan': jumlahCuti,
        },
      );

      print('RESPONSE: ${response.data}');

      if (response.statusCode == 200) {
        print(response.statusCode);
        print('Data berhasil diinput');
        if (context.mounted) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
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
                        'Data Berhasil di Generate',
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
                          backgroundColor: kDarkGreenColor,
                          fixedSize: const Size(120, 45),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
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
              );
            },
          );
        }
      } else {
        print('Terjadi kesalahan saat mengirim data');
        return response.data;
      }
    } on DioError catch (e) {
      print(e.message);
      print(e.response);
      print(e.error);
      print('Data sudah ada!');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 278,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 31,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        color: kYellowColor,
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
                      'Tahun telah di generate',
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
                        backgroundColor: kYellowColor,
                        fixedSize: const Size(120, 45),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
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
            );
          },
        );
      }
    }
  }
}
